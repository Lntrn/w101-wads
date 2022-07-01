function main()
	CompleteAllQuests();
end

function CompleteAllQuests()
----------------------------------------Wizard City--------------------------------------------
-------------------------------------------Main-------------------------------------------------
	CompleteQuestChain("WC-MAIN-C01", 10);
	
---------------------------------------Unicorn Way-------------------------------------------
--Celen Nightshade
	CompleteQuestChain("WC-ST01-C01", 6);

--Lady under tree -- Olivia Dawnwillow
	Server("AddRegistry", "WC-ST01-C02-001_Complete", 1);

--Private Connelly
	CompleteQuestChain("WC-ST01-C03", 2);

--Lady Oriel
	CompleteQuestChain("WC-ST01-C04", 4);

-----------------------------------------Triton--------------------------------------------------
-- Complete Breadcrumb
	Server("AddRegistry", "WC-MISC-C01-002b_Complete", 1);

-- Run the quest chain WC-ST04-C01
	CompleteQuestChain("WC-ST04-C01", 5);

	Server("AddRegistry", "WC-ST04-C02-001_Complete", 1);
-- Run the quest chain WC-ST04-C03
	CompleteQuestChain("WC-ST04-C03", 2);

-- Run the quest chain WC-ST04-C04
	CompleteQuestChain("WC-ST04-C04", 3);
	
--Susie Gryphonbane
	CompleteQuestChain("WC-ST04-C05", 4);

---------------------------------------Cyclops Alley----------------------------------------------
-- Complete Breadcrumb
	Server("AddRegistry", "WC-MISC-C01-002a_Complete", 1);

-- Run the quest chain WC-ST03-C01
	CompleteQuestChain("WC-ST03-C01", 6);

-- Run the quest chain WC-ST03-C02
	CompleteQuestChain("WC-ST03-C02", 3);

	Server("AddRegistry", "WC-ST03-C03-001_Complete", 1);
	
	Server("AddRegistry", "WC-ST03-C05-001_Complete", 1);
	
---------------------------------------Firecat Alley-----------------------------------------
-- Complete Breadcrumb
	Server("AddRegistry", "WC-MISC-C01-002c_Complete", 1);

-- Run the quest chain WC-ST05-C01
	CompleteQuestChain("WC-ST05-C01", 6);

-- Run the quest chain WC-ST05-C02
	CompleteQuestChain("WC-ST05-C02", 3);
	
--Shelus Gruffheart
	Server("Addregistry", "WC-ST05-C06-001_Complete", 1);
	
--Gretta Darkkettle
	CompleteQuestChain("WC-ST05-C07", 3);

-----------------------------------------Colossus------------------------------------------
-- Run the quest chain WC-ST06-C01
	CompleteQuestChain("WC-ST06-C01", 7);

--Kazul Ironhelm
	Server("AddRegistry", "WC-ST06-C02_Complete", 1);

-- Run the quest chain WC-ST06-C03
	CompleteQuestChain("WC-ST06-C03", 3);

-- Run the quest chain WC-ST06-C04
	CompleteQuestChain("WC-ST06-C04", 6);
	Server("AddRegistry", "WC-ST06-C04-007F_Complete", 1);
	Server("AddRegistry", "WC-ST06-C04-007I_Complete", 1);
	Server("AddRegistry", "WC-ST06-C04-007L_Complete", 1);
	Server("AddRegistry", "WC-ST06-C04-007M_Complete", 1);
	Server("AddRegistry", "WC-ST06-C04-007S_Complete", 1);

-----------------------------------------Miscellaneous-------------------------------------------
--MISC
    Server("AddRegistry", "WC-MISC-C01-001_Complete", 1);
  	CompleteQuestChain("WC-MISC-C02", 4);
  	CompleteQuestChain("WC-MISC-C03", 4);
    Server("AddRegistry", "WC-MISC-C04-001_Complete", 1);
  	CompleteQuestChain("WC-MISC-C05", 2);

--Optionals
  	CompleteQuestChain("Opt-BigGame", 10);
    Server("AddRegistry", "Opt-Explorer-001_Complete", 1);
	Server("AddRegistry", "Explore-001-1_Complete", 1);

----------------------------------------------Ravenwood--------------------------------------------
--Storm
	CompleteQuestChain("WC-RAV-C01", 1);
--Ice
	CompleteQuestChain("WC-RAV-C02", 1);
--Fire
	CompleteQuestChain("WC-RAV-C03", 1);
--Life
	CompleteQuestChain("WC-RAV-C04", 1);
--Myth
	CompleteQuestChain("WC-RAV-C05", 1);

--------------------------------------------Nightside-----------------------------------------------
--Marla Singer
	CompleteQuestChain("WC-ST07-C01", 2);
	
-----------------------------------------End Wizard City--------------------------------------------


---------------------------------------Krokotopia------------------------------------------------
--------------------------------Main----------------------------------
	CompleteQuestChain("KT-MAIN-C01", 4);

-----------------------------Pyramid---------------------------------
	CompleteQuestChain("KT-PYMHub-C01", 6);

	--Royal Hall
	CompleteQuestChain("KT-PYM1-C01", 3);
	CompleteQuestChain("KT-PYM1-C02", 2);

	--Chamber of Fire
	CompleteQuestChain("KT-PYM3-C01", 4);
	CompleteQuestChain("KT-PYM3-C02", 3);
	
	--Palace of Fire
	CompleteQuestChain("KT-PYM2-C01", 3);
	
	--Map Room
	CompleteQuestChain("KT-PYM4-C01", 4);
	
---------------------------------Sphinx------------------------------------
	--Sphinx Hub
	CompleteQuestChain("KT-SPHUB-C02-001", 5);
	CompleteQuestChain("KT-SPHub-C01", 4);

	-- Hall of Champions
	CompleteQuestChain("KT-SPH2-C01", 3);
	CompleteQuestChain("KT-SPH2-C02", 4);
	
	--Grand Arena
	CompleteQuestChain("KT-SPH3-C01", 2);
	CompleteQuestChain("KT-SPH3-C02", 5);
	Server("AddRegistry", "KT-SPH3-C03-001_Complete", 1);
	
	--Vault of Ice
	CompleteQuestChain("KT-SPH4-C01", 2);

	--Emperors Retreat
	CompleteQuestChain("KT-SPH5-C01", 1);
	CompleteQuestChain("KT-SPH5-C02", 3);

----------------------------------Crypt----------------------------------
	--Crypt Hub
	CompleteQuestChain("KT-CRYHub-C01", 5);

	--Ahnic Family
	CompleteQuestChain("KT-CRY1-C01", 4);
	CompleteQuestChain("KT-CRY1-C02", 4);

	--Djeserit Family
	CompleteQuestChain("KT-CRY2-C01", 4);
	Server("AddRegistry", "KT-CRY2-C02-001_Complete", 1);
	CompleteQuestChain("KT-CRY2-C03", 2);

	--Barracks
	CompleteQuestChain("KT-CRY3-C01", 4);

	--Temple of Storms
	CompleteQuestChain("KT-CRY5-C01", 2);

----------------------------Miscellaneous------------------------------
	CompleteQuestChain("KT-BigGame", 10);
    Server("AddRegistry", "Explorer-001-1_Complete", 1);

---------------------------Balance School----------------------------
    Server("AddRegistry", "KT-BAL-C01-001_Complete", 1);
	Server("AddRegistry", "KT-BAL-C02-001_Complete", 1);

-------------------------------------End Krokotopia---------------------------------------------

---------------------------------------Marleybone------------------------------------------------
--------------------------------Museum----------------------------------
	CompleteQuestChain("MB-MUSEHub-C01", 1);
	CompleteQuestChain("MB-MUSEHub-C02", 2);
	CompleteQuestChain("MB-MUSEHub-C03", 2);

-----------------------------Digmoore Station---------------------------------
	Server("AddRegistry", "MB-AIRHub-C01-001_Complete", 1);
	CompleteQuestChain("MB-AIRHub-C02", 5);
	Server("AddRegistry", "MB-AIRHub-C03-001_Complete", 1);
	Server("AddRegistry", "MB-AIRHub-C04-001_Complete", 1);
	Server("AddRegistry", "MB-AIRHub-C05-001_Complete", 1);
	Server("AddRegistry", "MB-AIRHub-C06-001_Complete", 1);
	Server("AddRegistry", "MB-AIRHub-C07-001_Complete", 1);

	--Hyde Park
	CompleteQuestChain("MB-AIR1-C01", 5);
	CompleteQuestChain("MB-AIR1-C02", 2);
	CompleteQuestChain("MB-AIR1-C03", 3);
	Server("AddRegistry", "MB-AIR1-C04-001_Complete", 1);
	CompleteQuestChain("MB-AIR1-C05", 2);
	
	--Chelsea Court
	Server("AddRegistry", "MB-AIR2-C01-001_Complete", 1);
	CompleteQuestChain("MB-AIR2-C02", 4);
	CompleteQuestChain("MB-AIR2-C03", 3);
	CompleteQuestChain("MB-AIR2-C04", 2);
	
	--The Ironworks
	CompleteQuestChain("MB-AIR3-C01", 2);
	CompleteQuestChain("MB-AIR3-C02", 3);
	
-----------------------------Scotland Yard---------------------------------
	CompleteQuestChain("MB-YARDHub-C01", 4);
	
	--Newgate Prison
	CompleteQuestChain("MB-YARD1-C01", 1);
	Server("AddRegistry", "MB-YARD1-C02-001_Complete", 1);
	Server("AddRegistry", "MB-YARD1-C03-001_Complete", 1);
	Server("AddRegistry", "MB-YARD1-C04-001_Complete", 1);
	Server("AddRegistry", "MB-YARD1-C05-001_Complete", 1);
	Server("AddRegistry", "MB-YARD1-C06-001_Complete", 1);
	CompleteQuestChain("MB-YARD1-C07", 2);
	CompleteQuestChain("MB-YARD1-C08", 4);
	
	--Newgate Prison
	CompleteQuestChain("MB-YARD2-C01", 8);
	CompleteQuestChain("MB-YARD2-C02", 2);
	Server("AddRegistry", "MB-YARD2-C03-001_Complete", 1);
	CompleteQuestChain("MB-YARD2-C04", 4);
	
	--Katzenstien's Lab
	CompleteQuestChain("MB-YARD3-C01", 2);
	CompleteQuestChain("MB-YARD3-C02", 2);
	
----------------------------Miscellaneous------------------------------
	CompleteQuestChain("MB-BigGame", 10);
    Server("AddRegistry", "Explorer-001-2_Complete", 1);
	
-------------------------------------End Marleybone---------------------------------------------
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
