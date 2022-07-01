function main()
	CompleteAllQuests();
end

function CompleteAllQuests()
----------------------------------------Wizard City--------------------------------------------
--Main
	CompleteQuestChain("WC-MAIN-C01", 12);
	
--Unicorn Way
	CompleteQuestChain("WC-ST01-C01", 6);
	Server("AddRegistry", "WC-ST01-C02-001_Complete", 1);
	Server("AddRegistry", "WC-ST01-C03", 1);
	CompleteQuestChain("WC-ST01-C04", 4);

--Triton
	Server("AddRegistry", "WC-MISC-C01-002b_Complete", 1);
	CompleteQuestChain("WC-ST04-C01", 5);
	CompleteQuestChain("WC-ST04-C02", 3);
	CompleteQuestChain("WC-ST04-C03", 3);
	CompleteQuestChain("WC-ST04-C04", 3);


--Cyclops Lane
	Server("AddRegistry", "WC-MISC-C01-002a_Complete", 1);
	CompleteQuestChain("WC-ST03-C01", 6);
	CompleteQuestChain("WC-ST03-C02", 3);
	Server("AddRegistry", "WC-ST03-C03-001_Complete", 1);
	Server("AddRegistry", "WC-ST03-C03-003_Complete", 1);
	
--Firecat Alley
	Server("AddRegistry", "WC-MISC-C01-002c_Complete", 1);
	CompleteQuestChain("WC-ST05-C01", 6);

-----------------------------------------End Wizard City--------------------------------------------


---------------------------------------Krokotopia------------------------------------------------
--Main
	CompleteQuestChain("KT-MAIN-C01", 4);

--Pyramid
	CompleteQuestChain("KT-PYMHub-C01", 7);
	CompleteQuestChain("KT-PYM3-C01", 4);
	CompleteQuestChain("KT-PYM2-C01", 4);
	CompleteQuestChain("KT-PYM4-C01", 4);
	
--Sphinx
 	Server("AddRegistry", "KT-SPHUB-C01-005_Complete", 1);	
	CompleteQuestChain("KT-SPHub-C01", 4);
	CompleteQuestChain("KT-SPH2-C01", 3);
	CompleteQuestChain("KT-SPH2-C02", 9);
	CompleteQuestChain("KT-SPH3-C01", 2);
	CompleteQuestChain("KT-SPH3-C02", 5);
	Server("AddRegistry", "KT-SPH3-C03-001_Complete", 1);
	CompleteQuestChain("KT-SPH4-C01", 2);
	CompleteQuestChain("KT-SPH5-C01", 1);
	CompleteQuestChain("KT-SPH5-C02", 3);

--Crypt
	CompleteQuestChain("KT-CRYHub-C01", 5);

--Balance School    
	Server("AddRegistry", "KT-BAL-C02-001_Complete", 1);

-------------------------------------End Krokotopia---------------------------------------------

---------------------------------------Marleybone------------------------------------------------
--Museum
	CompleteQuestChain("MB-MUSEHub-C01", 1);
	CompleteQuestChain("MB-MUSEHub-C02", 2);
	CompleteQuestChain("MB-MUSEHub-C03", 2);

--Digmoore Station
	Server("AddRegistry", "MB-AIRHub-C01-001_Complete", 1);
	CompleteQuestChain("MB-AIRHub-C02", 5);
	Server("AddRegistry", "MB-AIRHub-C03-001_Complete", 1);
	Server("AddRegistry", "MB-AIRHub-C04-001_Complete", 1);
	
--Hyde Park
	CompleteQuestChain("MB-AIR1-C01", 5);
			
--Chelsea Court
	CompleteQuestChain("MB-AIR2-C02", 4);
	Server("AddRegistry", "MB-AIR2-C03", 1);
	Server("AddRegistry", "MB-AIR2-C04", 1);
	
	
--Scotland Yard--
	CompleteQuestChain("MB-YARDHub-C01", 4);
	Server("AddRegistry", "MB-YARD1-C01-001_Complete", 1);
	CompleteQuestChain("MB-YARD2-C01", 3);
		
--Katzenstien's Lab
	CompleteQuestChain("MB-YARD3-C01", 2);
	CompleteQuestChain("MB-YARD3-C02", 2);
	
--Miscellaneous
	Server("AddRegistry", "MB-MAIN-C01-001_Complete", 1);
    	Server("AddRegistry", "Explorer-001-2_Complete", 1);
	
-------------------------------------End Marleybone------------------------


-------------------------------------MooShu--------------------------------

--Main	
	Server("AddRegistry", "MS-MAIN-C01-001_Complete", 1);
	CompleteQuestChain("MS-MAIN-C02", 3);
	Server("AddRegistry", "MS-MAIN-C03-001_Complete", 1);
	Server("AddRegistry", "MS-MAIN-C04-001_Complete", 1);
	Server("AddRegistry", "MS-MAIN-C05-001_Complete", 1);
	CompleteQuestChain("MS-MAIN-C06", 4);


--Death
	CompleteQuestChain("MS-DTHHub-C01", 3);
	CompleteQuestChain("MS-DTH1-C01", 7);
	CompleteQuestChain("MS-DTH2-C01", 6);
	CompleteQuestChain("MS-DTH2-C02", 2);

--Plague
	CompleteQuestChain("MS-PLAGHub-C01", 4);
	CompleteQuestChain("MS-PLAG1-C01", 5);
	CompleteQuestChain("MS-PLAG2-C01", 6);
	CompleteQuestChain("MS-PLAG2-C02", 3);
	CompleteQuestChain("MS-PLAG2-C03", 2);
	CompleteQuestChain("MS-PLAG2-C04", 5);

--War
	CompleteQuestChain("MS-WAR1-C01", 8);
	CompleteQuestChain("MS-WAR2-C01", 6);
	CompleteQuestChain("MS-WAR2-C02", 4);


-------------------------------------End MooShu------------------------

end

function CompleteQuestChain(questName, numStages)
	for stageCnt = 1, numStages do
		local questStage;
		if(stageCnt / 10 < 1) then
			--The stage number is less than 10, so fill with 2 zeros
			questStage = "00"..stageCnt;
		elseif(stageCnt / 100 < 1) then
			--The stage number is less than 100, but greater than or equal to 10, so fill with 1 zero
			questStage = "0"..stageCnt;
		end
		Server("AddRegistry", questName.."-"..questStage.."_Complete", 1);
	end
end
