package it.univaq.disim.SA.MEB_POC.ToolsSimulator;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

import org.apache.commons.lang3.time.StopWatch;

public class Main {

	public static void main(String[] args) {
		
		/*List<String> recipes = Utilities.Generate_Recipe(100, "C:\\Users\\Stefano\\Desktop\\kafka_2.12-2.1.0\\", "RecipeList.txt");
		Utilities.Generate_Equip(recipes, 4, "C:\\Users\\Stefano\\Desktop\\kafka_2.12-2.1.0\\", "EquipList.txt");*/

		List<String> equipOIDs = Utilities.import_Equips_From_File();
		List<String> recipeOIDs = Utilities.import_Recipes_From_File();

		Counter holdONCounter = new Counter();
		Counter holdOFFCounter = new Counter();
		
		List<ToolThread> tools = new ArrayList<ToolThread>();
		StopWatch sw = new StopWatch();
		
		int dummyCounter = 0;
		
		for (int i = 0; i < equipOIDs.size(); i++) {
			String equipOID = equipOIDs.get(i);
			String category = equipOID.substring(equipOID.length() - 4);

			List<String> compatibleRecipes = recipeOIDs.stream()
					.filter(recipeOID -> category.equalsIgnoreCase(recipeOID.substring(recipeOID.length() - 4)))
					.collect(Collectors.toList());

			String recipeOID = compatibleRecipes.get(new Random().nextInt(compatibleRecipes.size()));

			ToolThread tool = new ToolThread(equipOID, recipeOID, holdONCounter, holdOFFCounter);
			tools.add(tool);
			
		}
		
		for (ToolThread tool : tools) {
			tool.start();
		}
		sw.start();
		System.out.println(equipOIDs.size() + " tools started sending messages...");

		while (true) {
			
			if ( dummyCounter == 12) {
				System.out.println("After " + (sw.getTime(TimeUnit.SECONDS) / 60) + " minutes");
				dummyCounter = 0;
			}
			System.out.println("messages sent: HoldON  " + holdONCounter.getValue());
			System.out.println("messages sent: HoldOFF " + holdOFFCounter.getValue());
			System.out.println("messages sent: Total   " + (holdONCounter.getValue() + holdOFFCounter.getValue()));
			System.out.println("");
			dummyCounter++;

			try {
				Thread.sleep(5000);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
		}
	}

}
