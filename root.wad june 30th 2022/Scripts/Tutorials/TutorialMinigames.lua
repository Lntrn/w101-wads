-- TutorialMinigames.lua

Include("Tutorials/API/TutorialCommon.lua");


---------------------------------------------------------------------------------------------------------
function TutorialMinigames()
	DebugLog("TutorialMinigames");
   
   RegisterEvent("OnCompassToggled");
	
	HideCompass();
	
   -- Reconfigure the tutorial dialog
	tutorialDialog = ResetTutorialDialog(tutorialDialog);	
   tutorialDialog:SetTitle("Tutorial_Title13");	
	tutorialDialog:SetProfessorImage("Art/Art_Quest_Mana_Ball.dds");	 		   		
	tutorialDialog:SetMessage("Tutorial_Tutorial_Mana1"); --You can play mini-games in the Fairground to replenish your mana!
	tutorialDialog:MoveToBottom();
   
	--Adding this event so that other scripts (like an automated Tutorial Test) can know exactly
	--where we are in the tutorial
	SendEvent("Tutorial_LectureText");

	tutorialDialog:WaitForNextButton();	
	
	--------------------------------------------------------------------------
	-- Set Message 'Minigames are accessed via Sigils - glowing symbols on the ground...'
	tutorialDialog:SetProfessorImage("Art/Art_Quest_Minigame_Sigil.dds");
	--If you want to play a mini-game, step into the magic circle on the ground!  You can do that later.
	tutorialDialog:SetMessage("Tutorial_Tutorial_Mana2");

	--Adding this event so that other scripts (like an automated Tutorial Test) can know exactly
	--where we are in the tutorial
	SendEvent("Tutorial_LectureText");

	-- Show the Quest Log with a new quest
	tutorialDialog:WaitForNextButton();	
	
	tutorialDialog:SetProfessorImage("GUI/NpcPortraits/Art_Portrait_Girl_Life.dds");
	
	--Professor Ambrose and Gamma are waiting for you in the Tower behind me!
	tutorialDialog:SetMessage("Tutorial_Tutorial_Mana3");

	--Adding this event so that other scripts (like an automated Tutorial Test) can know exactly
	--where we are in the tutorial
	SendEvent("Tutorial_LectureText");

	tutorialDialog:WaitForNextButton();
	
	--Look for the door with the lit window. Buildings you can enter will always have their lights on.
	tutorialDialog:SetMessage("Tutorial_Tutorial_Mana4");

	--Adding this event so that other scripts (like an automated Tutorial Test) can know exactly
	--where we are in the tutorial
	SendEvent("Tutorial_LectureText");

	tutorialDialog:WaitForNextButton();
   
	local compassButton = OpenClass(FindNamedWindow("btnCompass"));		
   compassButton.SetLocation( (GetScreenWidth()/2) - 40, (GetScreenHeight()/2) - 40 );
	compassButton.m_Style = "HAS_NO_BORDER|DO_NOT_CAPTURE_MOUSE";
	compassButton.ShowWindow(true);
	
	tutorialDialog:SetTitle("Tutorial_Title18");
	--If you get lost, you can use the Compass to show you the way!
	tutorialDialog:SetMessage("Tutorial_Tutorial_Mana5");
	tutorialDialog:MoveToTop();
	tutorialDialog:HideNextButton();		

	PlaySoundOnce(string.format("GUI/ui_woosh_fast.wav"));
		
	anim = MakeScaleAnimation( 2.0, 1.0 );
	compassButton.PushAnimation( anim );
	WaitForAnimationsToFinish( compassButton );
	anim = MakeScaleAnimation( 1.0, 0.1 );
	compassButton.PushAnimation( anim );
	anim = MakeMoveAnimation( GetScreenWidth() - 188, GetScreenHeight() - (128), 1.0 );
	compassButton.PushAnimation( anim );
	WaitForAnimationsToFinish( compassButton );
	
   -- temporarily ignore mouse clicks on the compass
   compassButton.SetEnable(false);
   
	--Adding this event so that other scripts (like an automated Tutorial Test) can know exactly
	--where we are in the tutorial
	SendEvent("Tutorial_LectureText");

	tutorialDialog:WaitForNextButton();
	tutorialDialog:HideNextButton();
   
   FreezePlayer();

	PlaySoundOnce(string.format("GUI/ui_arrowyellow_point.wav"));
   local newArrow = TutorialArrow(compassButton,"Top",64,0.5,0.5,true);
   newArrow:ShowWindow(true);
   
   -- allow mouse clicks on the compass
   compassButton.m_Style = "HAS_NO_BORDER";
   compassButton.SetEnable(true);
   
   -- Click the compass now.
	tutorialDialog:SetMessage("Tutorial_Tutorial_Mana6");
	
	--Adding this event so that other scripts (like an automated Tutorial Test) can know exactly
	--where we are in the tutorial
	SendEvent("Tutorial_WaitingToClickOnCompass");
	   
	GetEvent("OnCompassToggled");
   newArrow:ShowWindow(false);
   
   UnregisterEvent("OnCompassToggled");   
end

function main()
	TutorialMinigames();
end
