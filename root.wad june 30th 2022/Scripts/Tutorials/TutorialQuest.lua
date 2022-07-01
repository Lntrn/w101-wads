-- TutorialQuest.lua
Include("Tutorials/API/Debug.lua");
Include("Tutorials/API/TutorialDialog.lua")
Include("Tutorials/API/TutorialUtility.lua")
Include("API/ControlClasses.lua");

function TutorialQuest()
	-- Retrieve a reference to our client tutorial object.
	local clientTutorial = OpenClass(GetTutorial());
	clientTutorial.RequestRemoveQuest("WC-TUT-C03-001");
	clientTutorial.RequestRemoveQuest("WC-TUT_C03-002");

   -- Reconfigure the tutorial dialog
   tutorialDialog = ResetTutorialDialog(tutorialDialog);
   tutorialDialog:SetTitle("Tutorial_Title5");
   tutorialDialog:SetProfessorImage("GUI/NpcPortraits/Art_Portrait_Registrar.dds");
   tutorialDialog:SetMessage("Tutorial_Tutorial_Quest1");
   tutorialDialog:MoveToBottom();

   --Add quest to player	
	-- Request that our special tutorial equipment quest is added to the player.
	clientTutorial.RequestAddQuest("WC-TUT-C03-001");

	-- having this quest turns on the golem tower quest light
	clientTutorial.RequestAddQuest("WC-TUT-C03-002");	
	
	tutorialDialog:SetMessage("Tutorial_Tutorial_Quest3");	
	
	--Adding this event so that other scripts (like an automated Tutorial Test) can know exactly
	--where we are in the tutorial
	SendEvent("Tutorial_LectureText");
	
	tutorialDialog:WaitForNextButton();

	-- Display the Quest Preview HUD
	-- display pic of arrow keys
	QuestOfferImage = CreateSpriteClass("Backgrounds/Background_Tutorial_Quest.dds",MakeRectString(0,0,618,404),false,nil);
	QuestOfferImage.SetLocation( (GetScreenWidth()/2) - (618/2), 25 );
	QuestOfferImage.m_Style = "HAS_NO_BORDER|DO_NOT_CAPTURE_MOUSE";
	QuestOfferImage.ShowWindow(true);
	
	tutorialDialog:SetMessage("Tutorial_Tutorial_Quest4");	
	
	--Adding this event so that other scripts (like an automated Tutorial Test) can know exactly
	--where we are in the tutorial
	SendEvent("Tutorial_LectureText");
	
	tutorialDialog:WaitForNextButton();

	QuestOfferImage.DetachSelf();

	tutorialDialog:SetMessage("Tutorial_Tutorial_Quest5");	
	
	--Adding this event so that other scripts (like an automated Tutorial Test) can know exactly
	--where we are in the tutorial
	SendEvent("Tutorial_LectureText");
	
	tutorialDialog:WaitForNextButton();
	
	--Dialogue portrait should be a spell deck
	tutorialDialog:SetMessage("Tutorial_Tutorial_Quest6");
	tutorialDialog:SetProfessorImage("GUI/QuestButtons/Quest_Deck.dds");
	
	--Adding this event so that other scripts (like an automated Tutorial Test) can know exactly
	--where we are in the tutorial
	SendEvent("Tutorial_LectureText");
	
	tutorialDialog:WaitForNextButton();
	
	--Show pic of a few spell cards fanned out in a hand
	PlaySoundOnce(string.format("GUI/ui_carddeck_shuffle.wav"));
	local spellbookImage = CreateSpriteClass("Backgrounds/Background_Tutorial_Spell_Cards.dds",MakeRectString(0,0,618,404),false,nil);
	spellbookImage.SetLocation( (GetScreenWidth()/2) - (618/2), 25 );
	spellbookImage.m_Style = "HAS_NO_BORDER|DO_NOT_CAPTURE_MOUSE";
	spellbookImage.ShowWindow(true);	
	
	--Dialogue portrait back to Registrar
	tutorialDialog:SetProfessorImage("GUI/NpcPortraits/Art_Portrait_Registrar.dds");
	tutorialDialog:SetMessage("Tutorial_Tutorial_Quest7");	
	
	--Adding this event so that other scripts (like an automated Tutorial Test) can know exactly
	--where we are in the tutorial
	SendEvent("Tutorial_LectureText");
	
	tutorialDialog:WaitForNextButton();
	spellbookImage.ShowWindow(false);
	
	--Remove spell card pic
	spellbookImage.DetachSelf();
	
	tutorialDialog:SetMessage("Tutorial_Tutorial_Quest8");
	
	--Adding this event so that other scripts (like an automated Tutorial Test) can know exactly
	--where we are in the tutorial
	SendEvent("Tutorial_LectureText");
	
	tutorialDialog:WaitForNextButton();
end

