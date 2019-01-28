using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Net;
using System.Net.Sockets;
using System.Threading;
using System.Windows.Forms;
namespace a
{
    public abstract class Receiver{
        public static IPAddress receiveAddress = IPAddress.Any; // IPAddress.Parse("192.168.1.255");
        internal UdpClient udpClient;
        internal IPEndPoint endpoint;
        internal Thread myThread;
        internal volatile int myindex = 0;

        public static StartupArgJson args { get { return Program.args; } }

        /// <summary>
        /// Avvia la ricezione di questo ricevitore.
        /// </summary>
        public abstract void start();

        /// <summary>
        /// Interrompe la ricezione di questo ricevitore.
        /// </summary>
        public abstract void stop(object stopReason);
        public virtual void receiveBroadcast(object unused){
            receiveBroadcast0(unused);
            //try { receiveBroadcast0(unused); } catch (Exception e) { MessageBox.Show(e.ToString()); }
        }
        public virtual void receiveBroadcast0(object unused) {
            //Receiver r = (Receiver)arg;
            double averageMessageSize = this is ReceiverTool ? ReceiverTool.averageMessageSize : SlaveReceiver.averageMessageSize;
            myMessage msg;
            byte[] data = null;
            try {
                //con 2500 robot nel simulatore sono arrivato a 78 messaggi al secondo processati, con numeri superiori lo reggo svuotando la coda ma solo 15 al secondo, perchè?
                Program.p(Thread.CurrentThread.Name+ " ready");
                bool warningEmitted = false;
                bool debugBinary = false;
                int rcv = 0;
                string uselessdebug = Program.pes;
                string uselessdeb2 = Program.ps;
                int ciclo = 1000;
                List<myMessage> debugAllProduced = new List<myMessage>();
                while (true) {
                    //if (ciclo-- == 0) { ciclo = 1000; Thread.Sleep(1000000); throw new Exception("work done"); }
                    //data = Program.fakereceive();
                    try { data = this.udpClient.Receive(ref this.endpoint); } catch (SocketException ex) {/*likely thread aborted*/; }
                    if (hash(data) != args.myPartitionNumber) { continue; }
                    msg = new myMessage(data);
                    if (0.90 <= this.udpClient.Available / (ushort.MaxValue - averageMessageSize)) Program.pe("Questo ricevente è sovraccarico al " + ((int)(10000 * (this.udpClient.Available / (ushort.MaxValue - averageMessageSize)))) / 100 + "%, la perdita pacchetti è imminente e il programma non può funzionare correttamente in queste condizioni." + Environment.NewLine + "Si prega di ridurre il carico su questo ricevente inserendone altri nella rete e ripartizionando."+Environment.NewLine+"byte pending:" + udpClient.Available + "; pacchetti:" + udpClient.Available / averageMessageSize);
                    //todo: ripartizionamento dinamico: se i listener non bastano devo poterne inserire altri senza riavviare tutto.
                    if (!warningEmitted && this.udpClient.Available >= (ushort.MaxValue - averageMessageSize * 2) / 10) {
                        warningEmitted = true; Program.p("warning sovraccarico al "+ ((int)(10000 * (this.udpClient.Available / (ushort.MaxValue - averageMessageSize)))) / 100 + "%. byte pending:" + udpClient.Available + "; pacchetti:" + udpClient.Available / averageMessageSize); }
                    //$? if (null == (msg = RobotMessage.ProcessaMessaggio(data))) { MessageBox.Show("Discarded: " + System.Text.Encoding.UTF8.GetString(data) + ";"); return; }
                    if (rcv++ % 20 == 0) {
                        Program.p(Thread.CurrentThread.Name+") receive pending message:" + (this.udpClient.Available / averageMessageSize) 
                            + "; pending byte:" + this.udpClient.Available 
                            + "; load:" + ((int)(10000*(this.udpClient.Available / (ushort.MaxValue - averageMessageSize))))/100+"%"); }
                    
                    debugAllProduced.Add(msg);
                    if (msg.type == MessageType.xml) {
                        ReceiverTool.messageQueue.Add(msg);
                        //if (ReceiverTool.messageQueue.Count == 0) throw new Exception();
                        Master.canPublish.Release(1);}
                    else {
                        SlaveReceiver.SlaveMessageQueue.Add(msg);
                        //if (SlaveReceiver.SlaveMessageQueue.Count == 0) throw new Exception();
                        SlaveMsgConsumer.canConsume.Release(1);}
                    //todo: manca completamente il consumer della slave-queue

                    Thread me = Thread.CurrentThread;
                    StartupArgJson debug = Program.args;
                    EndPoint ee = this.endpoint;
                    if (msg.type == MessageType.xml && (me.Name == null || me.Name[0] == 'I')) { Program.pe("Got xml data on the slave receiver (msg was sent on wrong broadacast port)"); continue; }
                    if (msg.type != MessageType.xml && (me.Name == null || me.Name[0] == 'T')) { Program.pe("Got non-xml data on the tool receiver (msg was sent on wrong broadacast port)"); continue; }
                    string raw;
                    if (debugBinary) {
                        raw = "| ";
                        foreach (byte b in data) { raw += b + " "; }
                        raw += "|"; }
                    else raw = Encoding.UTF8.GetString(data);
                    if (Program.args.logToolMsgOnReceive == true){ Program.LogToolMsg("Rcv: "+raw); }
                    /*
                    myMessage message = new myMessage(raw);
                    message.consume(raw);
                    Master.canPublish.Release();
                    if (Master.iAmTheMaster){
                        Master.canSendMessage.Release();
                        Master.emptyMessageBuffer();
                        //send from buffer attivando un altro thread
                    }*/
                }
            }
            catch (ThreadAbortException e) {
                Program.p("Thread receiver ("+this.GetType()+") aborted; Last data handled:"+ (data == null ? "none" : data.arrayToString()), e);
                return; }
        }

        public static int hash(byte[] msg){ return hashSafe(msg); }

        public static int hashSafe(byte[] msg){
            int skip = 50, lengthMax = 100;
            int length = Math.Min(msg.Length, lengthMax);
            //nb: message length is always about 970 byte
            byte b = (byte)(msg.Length % 255);
            while (length-- > skip) { b ^= msg[length]; }
            return b % args.partitionNumbers_Total; }
        public static int hashUnsafe(byte[] msg){//test if faster
            int skip = 50, lengthMax = 100;
            int length = (Math.Min(msg.Length, lengthMax) - skip*0) / sizeof(ulong);
            ulong val=0;
            unsafe {
                ulong* arr, limit;
                fixed (byte* tmp = msg) {
                    arr = ((ulong*)tmp) + skip;
                    limit = ((ulong*)tmp) + length;
                    //nb: message length is always about 970 byte
                    byte b = (byte)(msg.Length % 255);
                    while (arr < limit) { val^= *arr++; }//todo:System.AccessViolationException: 'Tentativo di lettura o scrittura della memoria protetta. Spesso questa condizione indica che altre parti della memoria sono danneggiate.'
                }
            }
            return (int)(val % (ulong) args.partitionNumbers_Total); }
    }
}
