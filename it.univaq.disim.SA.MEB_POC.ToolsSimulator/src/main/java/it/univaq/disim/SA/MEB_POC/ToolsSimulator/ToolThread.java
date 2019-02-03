package it.univaq.disim.SA.MEB_POC.ToolsSimulator;

import java.util.Random;

import it.univaq.disim.SA.MEB_POC.ToolsSimulator.Models.InhibitEvent;

public class ToolThread extends Thread {

	private String equipOID;
	private String recipeOID;
	private int noEquipProbability;
	private Counter holdONCounter;
	private Counter holdOFFCounter;

	public ToolThread(String equipOID, String recipeOID, Counter holdONCounter, Counter holdOFFCounter) {
		this.equipOID = equipOID;
		this.recipeOID = recipeOID;
		this.holdONCounter = holdONCounter;
		this.holdOFFCounter = holdOFFCounter;

	}

	@Override
	public void run() {
		
		noEquipProbability = 100;

		while (true) {
			
			try {
				Thread.sleep(4000);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}

			InhibitEvent holdON = Utilities.Generate_Inhibit_Event(equipOID, recipeOID, noEquipProbability);

			String messageON = Utilities.Inhibit_to_XML(holdON);
			holdONCounter.increment();
			Utilities.broadcast(messageON);
			

			try {
				Thread.sleep(new Random().nextInt(30000));
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			InhibitEvent holdOFF = Utilities.Generate_Inverted_Inhibit(holdON);

			String messageOFF = Utilities.Inhibit_to_XML(holdOFF);
			holdOFFCounter.increment();
			Utilities.broadcast(messageOFF);
			
		}

	}
}
