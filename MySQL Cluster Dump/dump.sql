-- MySQL dump 10.13  Distrib 5.7.24-ndb-7.6.8, for Win64 (x86_64)
--
-- Host: localhost    Database: analytics_database
-- ------------------------------------------------------
-- Server version	5.7.24-ndb-7.6.8-cluster-gpl

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `analytics_database`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `analytics_database` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `analytics_database`;

--
-- Table structure for table `aggregateddata`
--

DROP TABLE IF EXISTS `aggregateddata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `aggregateddata` (
  `EquipName` varchar(50) NOT NULL,
  `RecipeName` varchar(50) NOT NULL,
  `HoldType` varchar(50) NOT NULL,
  `HoldStartDateTime` varchar(50) DEFAULT NULL,
  `HoldEndDateTime` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `aggregateddata`
--

LOCK TABLES `aggregateddata` WRITE;
/*!40000 ALTER TABLE `aggregateddata` DISABLE KEYS */;
/*!40000 ALTER TABLE `aggregateddata` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Current Database: `raw_data`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `raw_data` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `raw_data`;

--
-- Table structure for table `recipes`
--

DROP TABLE IF EXISTS `recipes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `recipes` (
  `OID` varchar(20) NOT NULL,
  `Name` varchar(20) NOT NULL,
  PRIMARY KEY (`OID`)
) ENGINE=ndbcluster DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recipes`
--

LOCK TABLES `recipes` WRITE;
/*!40000 ALTER TABLE `recipes` DISABLE KEYS */;
INSERT INTO `recipes` VALUES ('0x3K303068E8418821','ABVN49173'),('0x5Z446945P1394870','FTTT83916'),('0x2Z698615R7771287','NZZP41460'),('0x4X851919M8245655','OTZC17425'),('0x4A100710A0399303','FLTG68433'),('0x8D746237X0419398','DCAO90420'),('0x7W423997R6925772','PLSQ23727'),('0x3B868876E1062155','VNPF51195'),('0x2I022930H5642577','PMEG47218'),('0x8H570586H0233157','FONL82252'),('0x4Z892411S7087639','SAUT65225'),('0x4I096905N8402194','NIND50292'),('0x2F858439K1246404','QTSV61336'),('0x1N396584U8513685','ITBQ96573'),('0x8X282576L1634586','DRSU38589'),('0x0Y550090P2457408','LCSM08968'),('0x2P417963Y4493245','VCDP67437'),('0x1R401133G4560915','PNRP82668'),('0x7V343857Q8253979','LOSA41500'),('0x7F627983L2179627','FLQH11687'),('0x4H630245L0013517','EBCD16504'),('0x7I608884H5831912','HEND66422'),('0x0Y224904O9016402','ERAH83705'),('0x5P781610P1939076','BHUT49591'),('0x3P781538C6750949','VDVB37274'),('0x7Y366078I9013851','MMEB96242'),('0x9V132724E5010155','HCBA45710'),('0x3E111005R4286275','HIET14331'),('0x0L024982Y5938103','VDTD77273'),('0x5S368519A1897740','SVTV58188'),('0x7X875153V9017291','FGVS31035'),('0x9Z920704T7905634','NMTR14951'),('0x5R632008A4490944','VQTH12946'),('0x2G181635F7819422','VEIN38873'),('0x9Q007777C6812935','DALP62531'),('0x9F401204B2027071','CQVU86672'),('0x9G216801W6257352','QGUC82760'),('0x9Y764393X2268758','LSZS94354'),('0x2E939569Q5629550','HNQV41012'),('0x8V986812H2758070','LSVT40910'),('0x5J329342K4393400','CIEN75390'),('0x8Y969339X9815355','FOSE05625'),('0x4O692564C0932550','HTEE35116'),('0x4A000869W7617972','IFQP35008'),('0x9E627243H3295985','GBOI40179'),('0x8X651082I1123519','TDGG06745'),('0x5I023113E6973603','IMUM23800'),('0x7Q215053X5870739','PVTP11747'),('0x9Z580007Z8608827','PIAE14842'),('0x9Y668551X4186094','NDNR47413'),('0x5O533889Z7999372','NVND03478'),('0x6C125287A7243294','MPCQ95424'),('0x9K627817I2178163','DGGR33870'),('0x0B843481X3801404','CHMI45570'),('0x1E449901M3606607','SIGF52762'),('0x4P160214D5607428','SHGN44658'),('0x7O561779S4087229','TGCN80740'),('0x9R876972Q0849990','SUTU27892'),('0x3N317853I4176619','HSLC36885'),('0x7Z440283A9834918','IDSQ31113'),('0x2A388883U2443847','HDVH40864'),('0x5K018569T6257698','IMHN81408'),('0x7G699978Q6020826','IUNQ12244'),('0x4B288195N0949588','OPGU77108'),('0x1G664889G8974546','ESMA32306'),('0x9L209488F4396529','CLGQ40094'),('0x9F583678X5066251','CZUC39237'),('0x8C779470D4620492','POVZ02220'),('0x1P141473P2906528','EPSU90370'),('0x7D966759D5260621','GGNR83052'),('0x4Q844478R6571773','GIBT30217'),('0x6K743103K2484410','LDZU26893'),('0x3R954358R1260740','PRNR00853'),('0x3M140319P3502565','ZDUS93274'),('0x0E647053F2248982','ICNU35231'),('0x1G551911K9563346','FOCU80349'),('0x4V610856O0924236','ZHNN76374'),('0x4C742082W0012802','GGLP25861'),('0x7D237070N3679248','NFQR91323'),('0x9D773318P8810667','MRGD67012'),('0x4H917284P5121009','ZNPN26322'),('0x1P070803Z1332425','OSVN02392'),('0x9D451154H2723579','MOPH76745'),('0x0S742821W6775963','HQLL99560'),('0x0Z187713S0720764','MLSF79333'),('0x4O899829A8437145','OLDT35422'),('0x9I678324O5817453','FFPD75276'),('0x4B672389K3410741','ECBC49953'),('0x2A105034L6898440','ODGP87429'),('0x7Z827021C6161314','SBCA40000'),('0x5J587823G4679671','CZPI31312'),('0x2U773688J7618599','RNAI56195'),('0x3L100799H8640834','MFDO95818'),('0x5M361974D3485495','VTAG05242'),('0x8G109893W0047704','NONC29812'),('0x8U792766K6190773','IBEE35065'),('0x7E628854E5036115','MDQG42453'),('0x8O298787T0041036','DPDG06441'),('0x8G446917S8698147','VUZG53356'),('0x1G972863P4886445','MCMZ99587');
/*!40000 ALTER TABLE `recipes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tools`
--

DROP TABLE IF EXISTS `tools`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tools` (
  `OID` varchar(20) NOT NULL,
  `Name` varchar(20) NOT NULL,
  PRIMARY KEY (`OID`)
) ENGINE=ndbcluster DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tools`
--

LOCK TABLES `tools` WRITE;
/*!40000 ALTER TABLE `tools` DISABLE KEYS */;
INSERT INTO `tools` VALUES ('0x8J565962W1160826','MRFU20461'),('0x9Z362179R5143400','UQFI40387'),('0x7O791447I0728070','ZVQQ02249'),('0x3U842399U5138758','GBCA85164'),('0x5K950897I5433685','PCQR38445'),('0x8V040439D4593400','LAON16487'),('0x9K058707W4633245','GGIS85748'),('0x5J712257B7382577','BLBQ39970'),('0x5F825586X6246404','VZEH39205'),('0x5G055097V9222565','TZRM84547'),('0x3H443644O0822194','UHRU71872'),('0x6J185480I6422425','GGIS85748'),('0x8S042907D8570740','SAVH31001'),('0x9F011490E7641314','GVDS17204'),('0x5C786275U0923603','LUPS72914'),('0x7G826434D9806115','OTQH59057'),('0x9B683823L9365355','BLBQ39970'),('0x8P156695I9734586','CZAD17033'),('0x0C837000V6357698','ZSUO24480'),('0x8E174554M3526115','VZEH39205'),('0x8Q745360O2907972','QTBO50087'),('0x9I819945W1412802','LIFQ16787'),('0x7G964440M7267352','MGZR22113'),('0x4U056040T2818821','AEOB36663'),('0x9X578279A7552550','ZISL62637'),('0x1U594054V7135655','QARL09086'),('0x9W231971D5423346','QDDZ41004'),('0x4Q501377U8248982','IALD58121'),('0x1T181278K7807145','SHZL20089'),('0x5V639968H4183294','LOTQ28739'),('0x8V576292F3172565','LBTQ62031'),('0x4X168124T1337453','FSNC43923'),('0x2G651031S3565655','NSUT78064'),('0x5K969494I1331773','NSUT78064'),('0x4H008539C3722550','TONI20090'),('0x2A693663W1159422','EDSM49276'),('0x6A974764G2178147','USBG64166'),('0x3S816068H6002565','NSUT78064'),('0x3F292267J3750492','TSHR32593'),('0x8V156110C7652935','VHCE13704'),('0x8W138081P1386607','QARL09086'),('0x6Q500647I3860155','GANH80934'),('0x7V720364M7965495','SGCB98947'),('0x3D919023M7190621','EDSM49276'),('0x4Q670464C0675985','QUBT90900'),('0x3S447665P9020667','UCLO04754'),('0x6U685156L4542935','VDGQ98362'),('0x6T049115B9163851','MTVO07721'),('0x9M396273Q2459398','LAON16487'),('0x3D086545G1586528','ZIGA68883'),('0x8P949672J0119990','LIIQ93679'),('0x6B298800H9716445','HSZF10432'),('0x3G255854P9098827','AEOB36663'),('0x9A188552G1601287','DZDN90653'),('0x2N614670D2345355','OTBG97995'),('0x5R094645Y9808440','PTQF37197'),('0x8Q255495N2996094','EHUC33578'),('0x4W555936Y8687972','ODVN34166'),('0x5R018736G1842577','MTVO07721'),('0x3U236177G2828147','MHVT57705'),('0x0S438857U4454870','DZDN90653'),('0x1H023011H0982550','NETM21010'),('0x3Z543000V2420739','MHVT57705'),('0x1T854018G5908599','NZZV04153'),('0x4F190014V6529550','SPFE37908'),('0x4R554667I7713517','CLFE98661'),('0x9J275673A6931287','VSPP82865'),('0x8B435655X5762550','GVDS17204'),('0x0F021074Q3870944','ZISL62637'),('0x6E898002I3453245','RZLD16581'),('0x4C625338Y9320492','MGZR22113'),('0x9F004691D8945963','ZISL62637'),('0x1V565264E4063157','ZVQQ02249'),('0x4W923473G0364870','SACM19085'),('0x6S918182U5534918','UHRU71872'),('0x7A599672M4447453','LONR67784'),('0x4D716124G6456528','LHBA35137'),('0x6X203621U5264236','HEQG07690'),('0x7M601329H2863685','NZZV04153'),('0x3J029911F9489372','BZGD11021'),('0x8I168784F0079372','QDDZ41004'),('0x3F445517R4653519','TDRP80584'),('0x1X673264B4325495','UCVE28935'),('0x5C426335R2713979','VAMR23352'),('0x4I872059U9669550','ABZL75797'),('0x7O197521K8920915','CLFE98661'),('0x4P478826Z1165355','MTVO07721'),('0x5U525019S8099076','TPZQ80173'),('0x2P079231D9587229','VDGQ98362'),('0x8Z970591Q6749588','QTBO50087'),('0x8H496062N2189588','ODVN34166'),('0x3J779947X0226404','LIIQ93679'),('0x9I300564Q4376115','LIIQ93679'),('0x6H425083M3082935','EHUC33578'),('0x1Z018879C6860826','HLAD31562'),('0x2V898138N9412155','AEOB36663'),('0x5E893256V5416619','UMMB89209'),('0x9G352032N8508070','COOC32772'),('0x8Z695912W3855634','LUPS72914'),('0x3H662693G2760739','LHBA35137'),('0x7P320362N5089422','ONDZ13076'),('0x3T016649E4151009','LONR67784'),('0x0Y831144K4583294','SPFE37908'),('0x0L201775J1508821','HLAD31562'),('0x5T997657E1077428','HSZF10432'),('0x3E486508J2662802','UHRU71872'),('0x2J446566P3189627','QUUH15933'),('0x4X863282S5255985','ADQN60313'),('0x3V226822H8733517','PTQF37197'),('0x4X462846Z5557408','VZEH39205'),('0x9W165001J9766404','OTQH59057'),('0x1N334028K5520949','BHPP71331'),('0x5Z758782S2608070','VEVR95452'),('0x7U321657B6000944','TONI20090'),('0x7S735823L1774546','BSFB06569'),('0x9I660262C2109076','GBCA85164'),('0x8F278568X0727408','TDUL22279'),('0x3F068714Z6390621','LCAZ97519'),('0x6D437752W2400773','ONTS82263'),('0x6J009679X3242577','COZL21566'),('0x9E549137A7727291','EHRS85386'),('0x3N777115M6276251','ONTS82263'),('0x4V182733W6909990','VZEH39205'),('0x5C947710Q8517639','ARZE57593'),('0x1V429215E8003519','EHRS85386'),('0x5I239993W7273519','CBTS16760'),('0x6F082257P2923346','BZGD11021'),('0x3X595104L0803245','LONR67784'),('0x3C317047R9796619','HRPQ13658'),('0x8B207691S6908821','RQTB95081'),('0x9E786667Q2473157','COOC32772'),('0x3D996453L9799303','UHRU71872'),('0x9P578032U4768103','NZOL42441'),('0x9B447869B5525772','ARDS88625'),('0x1B998012T7910764','ABZL75797'),('0x1H724967U1052155','MRFU20461'),('0x2B014478S0199671','OTCC59647'),('0x0R161708Z7977740','QZSZ50019'),('0x1M926793H9113979','EHRS85386'),('0x6I908513V0005655','TZRM84547'),('0x0S047253X0072155','RQTB95081'),('0x6V568378C2380773','DILC18633'),('0x7V828006B9879671','LCAZ97519'),('0x4S319000A8996094','IALD58121'),('0x0K638266O9249588','ARZE57593'),('0x3Z280704W9238103','LOTQ28739'),('0x8D611793S7455985','RDHQ23806'),('0x6J348515D7043603','ADQN60313'),('0x4R678252K2972565','QARL09086'),('0x8F096590U6097229','EHUC33578'),('0x7A162812T6790915','AIIO81747'),('0x8L628237I8854870','VSPP82865'),('0x5L498742K7150764','LOTQ28739'),('0x8Z661306W5631912','ZVQQ02249'),('0x9P182393N5481009','RZLD16581'),('0x7H084505E2075495','MGZR22113'),('0x5D880832X7906529','OTCC59647'),('0x3S460832F9697408','LIIQ93679'),('0x5Z635368Z6793157','CZAD17033'),('0x9Q880945R8385772','HRPQ13658'),('0x0O431542E4435963','GVDS17204'),('0x2F846024X0661036','USBG64166'),('0x8T407694B0285963','NETM21010'),('0x7E844000G7623979','CBTS16760'),('0x9I152143N6531036','ZIGA68883'),('0x7V436201M2474918','OFIG32299'),('0x6D774775H2406607','LBTQ62031'),('0x2O266574W2819588','TMQF70607'),('0x1V671083L0350667','GBCA85164'),('0x1P935281J0090741','SHZL20089'),('0x1L955241W5256275','ZSUO24480'),('0x8E990823A9889990','OTQH59057'),('0x5I656089F7187704','PTQF37197'),('0x9S997317G5515655','LBTQ62031'),('0x2B946682B3273517','AIIO81747'),('0x2B088525W2918982','VHCE13704'),('0x8W805995P9390949','DILC18633'),('0x2N587730X9662802','OFIG32299'),('0x1J375810W9301773','LBTQ62031'),('0x6D540494G5697352','UCVE28935'),('0x6T873125P3977071','UQFI40387'),('0x6S540252M6486402','RDHQ23806'),('0x2P028059C4358827','MRFU20461'),('0x9P648215W9043400','QUUH15933'),('0x3N741597I3236275','ZCGV58469'),('0x7C075537P9637704','AIIO81747'),('0x5V752675E7269372','SAVH31001'),('0x6Z993773Z6562425','FSNC43923'),('0x2W656465F8843851','OTBG97995'),('0x3X885751J1714586','VEVR95452'),('0x2Q948806F5897291','TDRP80584'),('0x7O959289B3223294','ABZL75797'),('0x1S221000W4023400','GECN49165'),('0x1O033771C4178440','CLFE98661'),('0x7V892776K9415495','TSHR32593'),('0x4E412099T4806251','BSFB06569'),('0x1Y787794H0720739','ZIGA68883'),('0x2L842198R8469422','OTCC59647'),('0x1Y382975K8090944','NETM21010'),('0x2P549586Q3185963','TONI20090'),('0x4G058801B6470741','PCQR38445'),('0x6C323052Y8087428','UMMB89209'),('0x4M583689J2196607','TZRM84547'),('0x9H855082I2744546','ONTS82263'),('0x4L865627O3995634','ADQN60313'),('0x4D547505G3077698','GANH80934'),('0x5U581347M0723851','BLBQ39970'),('0x2J518507L1240773','BSFB06569'),('0x6Y959823G7030834','VSPP82865'),('0x8M314997J7550949','BSFB06569'),('0x9W435219P9656529','LCAZ97519'),('0x9Q496521G3264918','FOCI48029'),('0x0L370842R8678103','ABZL75797'),('0x9A026143P7591036','LHBA35137'),('0x5L818896V4838163','VSPP82865'),('0x5V724150Q6410492','UCVE28935'),('0x0H556589O4659627','UQFI40387'),('0x8Y837508E3033851','COZL21566'),('0x1S604532G6294236','UCLO04754'),('0x6J117984V7514236','GBCA85164'),('0x4B048056Z4404586','ZVQQ02249'),('0x7S678092L1277145','PCQR38445'),('0x7J737143Q8492194','OFIG32299'),('0x3E626371S6857071','GECN49165'),('0x6C025743F7679550','LOTQ28739'),('0x6M753160S3813579','VAMR23352'),('0x9I428657D7893847','COZL21566'),('0x0Q834241Z7316275','QZSZ50019'),('0x0I293810F2711912','CZAD17033'),('0x9I716684D9344586','COOC32772'),('0x4X628580N1287740','GANH80934'),('0x7W903589Z0016402','LUPS72914'),('0x7Q549392Z7279550','NZOL42441'),('0x3H007688B1405772','HSZF10432'),('0x7C618738A1982194','LIFQ16787'),('0x4O804349V5543847','OTBG97995'),('0x4O292456N2973685','TDHL16768'),('0x4L592302O8093517','GTPN65574'),('0x4E237584B9330155','ZSUO24480'),('0x7O815531T7919671','ONDZ13076'),('0x9Q532081Z4834546','DILC18633'),('0x6V510128Z0347145','NZZV04153'),('0x2F282632N5357428','ARDS88625'),('0x3H582886U2693245','FSNC43923'),('0x7M686902H8006619','ARDS88625'),('0x1R429114K5951404','ODVN34166'),('0x3O491880O5316445','HRPQ13658'),('0x5T418772D1756402','ADQN60313'),('0x0O558917J8258599','TDHL16768'),('0x0C812725T4638982','EHUC33578'),('0x9W920456U9279372','GAAS13522'),('0x8O697345G2739076','HEQG07690'),('0x1H465251U8246607','NSUT78064'),('0x6Z570008A8748758','HEQG07690'),('0x4L892686X3247698','ZCGV58469'),('0x7B846662Q9803294','NZOL42441'),('0x4B782789T6318827','RQTB95081'),('0x2U829027B5676529','EDSM49276'),('0x7E924732H5447229','VHCE13704'),('0x2W850902D4280667','HEQG07690'),('0x0X851060L3437453','RZLD16581'),('0x5M598948B6799248','UCVE28935'),('0x1C403390E0743579','EHRS85386'),('0x9L187084Z3910834','VBMC50853'),('0x1K967643I7908758','TPZQ80173'),('0x2B020600D3107352','TSHR32593'),('0x6J252717Y7529398','GECN49165'),('0x8T361238N8886251','DILC18633'),('0x2U936128X2170834','DZDN90653'),('0x6I564380O7521404','TMQF70607'),('0x5D634661O7160764','SPFE37908'),('0x4G478096A3488163','VBMC50853'),('0x5B158511U5654236','TPZQ80173'),('0x5Z965022V8021009','GGIS85748'),('0x9P971220L0924410','SAVH31001'),('0x1J103593T8652194','FOCI48029'),('0x6W319779J9022425','RZLD16581'),('0x7X689873J3808070','CZAD17033'),('0x2G083590I2529248','SGCB98947'),('0x9X964262Q0768827','HLAD31562'),('0x3R133724L9120155','ZCGV58469'),('0x0Z243482B4073603','QUBT90900'),('0x3Q883550U1701404','QTBO50087'),('0x8V768961S7739671','EDSM49276'),('0x1R180768S5541009','FSNC43923'),('0x8X281427U2893157','VEVR95452'),('0x5B062105X0463847','BLBQ39970'),('0x3Q276456P9165634','QUBT90900'),('0x1U139365R7283685','SHZL20089'),('0x6Y154608Y0982935','IALD58121'),('0x1H349616W5579076','UCLO04754'),('0x1O240584I0677698','QZSZ50019'),('0x9E521134Q2156115','TDUL22279'),('0x9N538775N8550826','RQTB95081'),('0x8I763398Z5440621','ONDZ13076'),('0x3R939077X7470740','BZGD11021'),('0x1J900144T6850492','SGCB98947'),('0x2C611192I6161773','QARL09086'),('0x5Z954694H0211773','TZRM84547'),('0x0X738413V0055355','COZL21566'),('0x1U063678E5621912','VEVR95452'),('0x3S045129Q8227408','OTQH59057'),('0x0W742060Q1868163','DZDN90653'),('0x2M060646I5639422','LCAZ97519'),('0x2H739046P8598758','UCLO04754'),('0x8A851332G8042155','HLAD31562'),('0x3I300293Y3965772','UMMB89209'),('0x0V647043Q3650621','OTCC59647'),('0x8Z287724E3767704','CLFE98661'),('0x4G629233C0983579','TDRP80584'),('0x2K613966C8350667','TPZQ80173'),('0x0K224486C6317428','HRPQ13658'),('0x1O995636W1656445','UMMB89209'),('0x2B350400W3566251','BHPP71331'),('0x1E342422P4407704','GTPN65574'),('0x8E561792I3078440','AIIO81747'),('0x4B168129M0826402','QUBT90900'),('0x6Q563474O2334546','BHPP71331'),('0x9P024371U6956529','ONDZ13076'),('0x1O400462I1990826','AEOB36663'),('0x4F336713X5679303','FOCI48029'),('0x5Q631715Y8949398','QUUH15933'),('0x4A024901U8190915','PTQF37197'),('0x0L796730Y6521404','ARZE57593'),('0x8L952088V2807352','SGCB98947'),('0x9I806902Q0642425','LONR67784'),('0x6W449813L2489248','TSHR32593'),('0x1I709153H9929303','OFIG32299'),('0x4B893475P0726619','HSZF10432'),('0x0Y729671K8647639','QTBO50087'),('0x2L851466W0130741','NZZV04153'),('0x8G499457U4593346','SAVH31001'),('0x9C960644B9580739','USBG64166'),('0x6H221264X6456404','TDUL22279'),('0x3Y547585O0945985','LUPS72914'),('0x9I834956O5740741','TDHL16768'),('0x2H906423F7568599','SHZL20089'),('0x6N171410G3157740','ZCGV58469'),('0x2J247805Y8417071','QUUH15933'),('0x1J490353Z0457639','TMQF70607'),('0x1D005445G2758147','LHBA35137'),('0x3G956195R7740949','ONTS82263'),('0x8X123630I7077071','LAON16487'),('0x7H295416G5390740','GAAS13522'),('0x5S146899H4977229','IALD58121'),('0x6C831305E6207291','VAMR23352'),('0x5V243058Q6744870','VBMC50853'),('0x4U697016D4660764','NZOL42441'),('0x4E010419S3404410','GAAS13522'),('0x2R624839T9133847','MTVO07721'),('0x1D602971M0104410','QDDZ41004'),('0x7I400133W6495634','RDHQ23806'),('0x8X551442X1303979','TDRP80584'),('0x5E296880Z8521314','NETM21010'),('0x4T279055S4107453','GGIS85748'),('0x9J003818B4340773','BHPP71331'),('0x7E033440L7570944','GVDS17204'),('0x6A643440D6849627','LAON16487'),('0x4Q293550B9317145','TDHL16768'),('0x6T133315X4719248','MGZR22113'),('0x0F327455O6679398','UQFI40387'),('0x4F008057U1221287','VBMC50853'),('0x2Y390550I0152577','OTBG97995'),('0x5M798001P1531036','MHVT57705'),('0x5X203822Y7866275','GANH80934'),('0x0S145272S2020834','SACM19085'),('0x4D728749I9443519','VAMR23352'),('0x3O732105G5561314','ZISL62637'),('0x5Q108796L8693603','RDHQ23806'),('0x4T549205P9907291','CBTS16760'),('0x1O141749B6959627','GECN49165'),('0x7E186349E2201314','TONI20090'),('0x7H898690P8799303','LIFQ16787'),('0x3H201197O5947740','ZSUO24480'),('0x7D850249M2548440','GTPN65574'),('0x6T965895W7408821','MRFU20461'),('0x4S391437Q1566445','ARDS88625'),('0x1Y622887O7810740','QDDZ41004'),('0x7U132965D6426528','USBG64166'),('0x6W982672K0796094','VDGQ98362'),('0x4R230434F2633579','CBTS16760'),('0x7V543937O0048147','ZIGA68883'),('0x9P254831A4554918','LIFQ16787'),('0x5N361318Z5867972','ARZE57593'),('0x9Y170768W7177639','ODVN34166'),('0x2Q237107Q8908163','SACM19085'),('0x7U949035A5250915','GTPN65574'),('0x6I224517V4191287','SACM19085'),('0x0E718603N4203346','GAAS13522'),('0x8R883362Y2671912','COOC32772'),('0x9R339300E2360155','QZSZ50019'),('0x1E925331G3937972','TMQF70607'),('0x8Z948274C6838103','SPFE37908'),('0x1M461829S7552802','FOCI48029'),('0x8N406414L3004410','BZGD11021'),('0x2L285594Z6226528','MHVT57705'),('0x8R752984J7776094','VHCE13704'),('0x7B769331W1268599','PCQR38445'),('0x5U469354A4999990','TDUL22279'),('0x1S623368T0958982','VDGQ98362');
/*!40000 ALTER TABLE `tools` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-02-02 18:23:41
