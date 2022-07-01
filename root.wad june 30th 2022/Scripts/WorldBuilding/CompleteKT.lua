-----------------------------------------------------------------------------
-- CompleteKT.lua
-- This file completes all the quests in Krokotopia
-----------------------------------------------------------------------------

function OpenMarleybone( args )

  local PlayerID = args.CharacterID;

	--Completes the Main and Hub Quests
	ScriptCompleteQuest(PlayerID, "KT-BAL-C02-001");
	ScriptCompleteQuest(PlayerID, "KT-HUB-C01-001");
	CompleteQuestChain(PlayerID, "KT-HUB-C02");
	CompleteQuestChain(PlayerID, "KT-HUB-C03");
	CompleteQuestChain(PlayerID, "KT-HUB-C04");
	CompleteQuestChain(PlayerID, "KT-HUB-C05");
	CompleteQuestChain(PlayerID, "KT-HUB-C06");
	CompleteQuestChain(PlayerID, "KT-HUB-C07");
	CompleteQuestChain(PlayerID, "KT-HUB-C08");
	CompleteQuestChain(PlayerID, "KT-HUB-C09");
	CompleteQuestChain(PlayerID, "KT-HUB-C10");
	CompleteQuestChain(PlayerID, "KT-HUB-C11");
	ScriptCompleteQuest(PlayerID, "KT-HUB-C12-001");
	CompleteQuestChain(PlayerID, "KT-HUB-C13");
	ScriptCompleteQuest(PlayerID, "KT-HUB-C14-001");
	ScriptCompleteQuest(PlayerID, "KT-HUB-C15-001");
	CompleteQuestChain(PlayerID, "KT-HUB-C16");
	CompleteQuestChain(PlayerID, "KT-HUB-C17");
	ScriptCompleteQuest(PlayerID, "KT-HUB-C18-001");
	CompleteQuestChain(PlayerID, "KT-MAIN-C01");
	
	--Completes the Find the Beetles Quest
	ScriptCompleteQuest(PlayerID, "Explore-001-1");

	--Completes the Crypt Quests
	CompleteQuestChain(PlayerID, "KT-CRY1-C01");
	CompleteQuestChain(PlayerID, "KT-CRY1-C02");
	CompleteQuestChain(PlayerID, "KT-CRY2-C01");
	ScriptCompleteQuest(PlayerID, "KT-CRY2-C02-001");
	CompleteQuestChain(PlayerID, "KT-CRY2-C03");
	CompleteQuestChain(PlayerID, "KT-CRY3-C01");
	ScriptCompleteQuest(PlayerID, "KT-CRY4-C01-001");
	CompleteQuestChain(PlayerID, "KT-CRY6-C01");
	--ScriptCompleteQuest(PlayerID, "KT-CRY7-C01-001");
	CompleteQuestChain(PlayerID, "KT-CRYHub-C01");
	
	--Completes the Pyramid Quests
	CompleteQuestChain(PlayerID, "KT-PYM1-C01");
	CompleteQuestChain(PlayerID, "KT-PYM1-C02");
	CompleteQuestChain(PlayerID, "KT-PYM1-C03");
	CompleteQuestChain(PlayerID, "KT-PYM2-C01");
	CompleteQuestChain(PlayerID, "KT-PYM3-C01");
	CompleteQuestChain(PlayerID, "KT-PYM3-C02");
	ScriptCompleteQuest(PlayerID, "KT-PYM3-C03-001");
	ScriptCompleteQuest(PlayerID, "KT-PYM3-C04-001");
	ScriptCompleteQuest(PlayerID, "KT-PYM4-C01-004");
	CompleteQuestChain(PlayerID, "KT-PYMHub-C01");
	
	--Completes the Sphinx Quests
	CompleteQuestChain(PlayerID, "KT-SPH2-C01");
	CompleteQuestChain(PlayerID, "KT-SPH2-C02");
	CompleteQuestChain(PlayerID, "KT-SPH3-C01");
	CompleteQuestChain(PlayerID, "KT-SPH3-C02");
	ScriptCompleteQuest(PlayerID, "KT-SPH3-C03-001");
	CompleteQuestChain(PlayerID, "KT-SPH3-C04");
	ScriptCompleteQuest(PlayerID, "KT-SPH4-C02-001");
	CompleteQuestChain(PlayerID, "KT-SPHUB-C02-001");
	CompleteQuestChain(PlayerID, "KT-SPHub-C02");
	
	--Grants the player some Bonus Experience
	GrantXP(PlayerID, 3000);

end
