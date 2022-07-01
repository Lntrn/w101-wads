-----------------------------------------------------------------------------
-- CompleteWC.lua
-- This file completes all the quests in Wizard City
-----------------------------------------------------------------------------

function OpenKrok( args )

  local PlayerID = args.CharacterID;

	--Completes the Main Quests
	ScriptCompleteQuest(PlayerID, "WC-MAIN-C01-001");
	ScriptCompleteQuest(PlayerID, "WC-MAIN-C01-003");
	ScriptCompleteQuest(PlayerID, "WC-MAIN-C01-004");
	ScriptCompleteQuest(PlayerID, "WC-MAIN-C01-006");
	ScriptCompleteQuest(PlayerID, "WC-MAIN-C01-007");
	ScriptCompleteQuest(PlayerID, "WC-MAIN-C01-009");
	ScriptCompleteQuest(PlayerID, "WC-MAIN-C01-010");
	CompleteQuestChain(PlayerID, "WC-MAIN-C02");

	--Completes the Find the Smiths Quest
	ScriptCompleteQuest(PlayerID, "Opt-Explorer-001");

	--Completes the Unicorn Way Quests
	CompleteQuestChain(PlayerID, "WC-ST01-C01");
	CompleteQuestChain(PlayerID, "WC-ST01-C02");
	CompleteQuestChain(PlayerID, "WC-ST01-C03");
	CompleteQuestChain(PlayerID, "WC-ST01-C04");
	ScriptCompleteQuest(PlayerID, "WC-ST01-C05-001");

	--Completes the Cyclops Lane Quests
	CompleteQuestChain(PlayerID, "WC-ST03-C01");
	CompleteQuestChain(PlayerID, "WC-ST03-C02");
	ScriptCompleteQuest(PlayerID, "WC-ST03-C03-001");
	CompleteQuestChain(PlayerID, "WC-ST03-C04");
	ScriptCompleteQuest(PlayerID, "WC-ST03-C05-001");

	--Completes the Triton Avenue Quests
	CompleteQuestChain(PlayerID, "WC-ST04-C01");
	CompleteQuestChain(PlayerID, "WC-ST04-C02");
	CompleteQuestChain(PlayerID, "WC-ST04-C03");
	ScriptCompleteQuest(PlayerID, "WC-ST04-C03-002");
	CompleteQuestChain(PlayerID, "WC-ST04-C04");
	CompleteQuestChain(PlayerID, "WC-ST04-C05");
	CompleteQuestChain(PlayerID, "WC-ST04-C06");

	--Completes the Firecat Alley Quests
	CompleteQuestChain(PlayerID, "WC-ST05-C01");
	CompleteQuestChain(PlayerID, "WC-ST05-C02");
	ScriptCompleteQuest(PlayerID, "WC-ST05-C06-001");
	CompleteQuestChain(PlayerID, "WC-ST05-C07");
	CompleteQuestChain(PlayerID, "WC-ST05-C08");

	--Completes the Colossus Boulevard Quests
	CompleteQuestChain(PlayerID, "WC-ST06-C01");
	ScriptCompleteQuest(PlayerID, "WC-ST06-C02-001");
	CompleteQuestChain(PlayerID, "WC-ST06-C03");
	CompleteQuestChain(PlayerID, "WC-ST06-C04");
	
	--Completes the Sunken City prep Quests
	CompleteQuestChain(PlayerID, "WC-ST07-C01");
	
	--Completes the Miscellaneous Quests
	ScriptCompleteQuest(PlayerID, "WC-MISC-C01-001");
	ScriptCompleteQuest(PlayerID, "WC-MISC-C01-002a");
	ScriptCompleteQuest(PlayerID, "WC-MISC-C01-002b");
	ScriptCompleteQuest(PlayerID, "WC-MISC-C01-002c");
	ScriptCompleteQuest(PlayerID, "WC-MISC-C02-001");
	CompleteQuestChain(PlayerID, "WC-MISC-C03");
	ScriptCompleteQuest(PlayerID, "WC-MISC-C04-001");
	CompleteQuestChain(PlayerID, "WC-MISC-C05");
	ScriptCompleteQuest(PlayerID, "WC-MISC-C06-001");
	
	--Grants the player some Bonus Experience
	GrantXP(PlayerID, 50);

end
