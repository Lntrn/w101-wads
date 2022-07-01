-- TutorialChat.lua
Include("Tutorials/API/TutorialCommon.lua")


function CreateDockedArrow(window)
   local myArrow = TutorialArrow(window,"Bottom",64,0.5,0.5,true);
   myArrow:ShowWindow(true);
   return myArrow;
end

function TutorialChat()
   RegisterEvent("OnNPCInteractionShown"); 
   RegisterEvent("OnInteractWithNPC");
   RegisterEvent("QuickChatClicked"); 
   
   gQuickChatButton = quickChatButton or OpenClass(FindNamedWindow("btnRadialQuickChat"));
   gQuickChatButton.SetVisible(false);
   
   FreezePlayer();
	
   gTutorialDialog:SetTitle("Tutorial_Title12"); -- "Chatting"
   gTutorialDialog:SetProfessorImage("GUI/NpcPortraits/Art_Portrait_Ambrose.dds");   
	gTutorialDialog:HideNextButton();
   gTutorialDialog:MoveToBottom();
   
   local ambroseId = GetClientID(39394);
   
   ---gTutorialDialog:DoDialog("Now, do you have any questions, young Wizard?", true);   
   gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro046", 3.0, "Dialogue_Tutorial/TUT_Ambrose_046.mp3", false, ambroseId, 3.0);
   
   ---gTutorialDialog:DoDialog("What’s that? You don’t know how to speak? My pardon!", true);   
   gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro047", 6.0, "Dialogue_Tutorial/TUT_Ambrose_047.mp3", false, ambroseId, 6.0);   
   
   ---gTutorialDialog:DoDialog("Well then... let me teach you how to use Menu Chat, and we’ll see what you have to say for yourself.", true);
   gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro048", 6.0, "Dialogue_Tutorial/TUT_Ambrose_048.mp3", false, ambroseId, 6.0);

   local chatImage = CreateSpriteClass("HUD/Button_Chat_Normal.dds", MakeRectString(0, 0, 144, 144), false, nil);
	chatImage.SetLocation( (GetScreenWidth()/2) - 72, (GetScreenHeight()/2) - 72 );
	chatImage.m_Style = "HAS_NO_BORDER|DO_NOT_CAPTURE_MOUSE";
	chatImage.SetVisible(true);
   
   FreezePlayer();
   
   ---gTutorialDialog:DoDialog("This is the Menu Chat button. Click on it to say something.", false);    -- This is the Easy Chat button.
   gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro049", -1, "Dialogue_Tutorial/TUT_Ambrose_049.mp3", false, ambroseId, 4.0);    -- This is the Easy Chat button.
   
   FreezePlayer();
   
    -- Show animated easy chat graphic
    local destX = gQuickChatButton.GetLeft();
    local destY = gQuickChatButton.GetTop();
	scaleAnim = MakeScaleAnimation( 0.5, 0.5 );	    -- size, duration
	--moveAnim = MakeMoveAnimation( 0, 0, 1.0);
	moveAnim = MakeMoveAnimation( destX, destY, 1.0);
	chatImage.PushAnimation( scaleAnim );
	chatImage.PushAnimation( moveAnim );
	WaitForAnimationsToFinish( chatImage );
	chatImage.SetVisible(false);
   gQuickChatButton.SetVisible(true);
   
   FreezePlayer();

	PlaySoundOnce(string.format("GUI/ui_arrowyellow_point.wav"));
   local newArrow = TutorialArrow(gQuickChatButton,"Right",64,0.5,0.5,true);
   newArrow:ShowWindow(true);
	
   FreezePlayer();
   
	-- Hide the health, mana, exp bar
	gExpBar = gExpBar or OpenClass(FindNamedWindow("XPBar"));

	gHealthGlobe = gHealthGlobe or OpenClass(OpenWindow( "spriteHealthBkg" ));	
	gManaGlobe = gManaGlobe or OpenClass(OpenWindow( "spriteManaBkg" ));
	
	gExpBar.SetVisible(false);
	gHealthGlobe.SetVisible(false);
	gManaGlobe.SetVisible(false);

   FreezePlayer();
   
   -- wait for the easy chat button click
   GetEvent("QuickChatClicked");
   newArrow:ShowWindow(false);
	   
	gExpBar.SetVisible(true);
	gHealthGlobe.SetVisible(true);
	gManaGlobe.SetVisible(true);
   
   --SetOverrideCameraByName("Cam_Staff", 1.5);
   
	gTutorialDialog:SetProfessorImage("GUI/NpcPortraits/Art_Portrait_Ambrose.dds");
   ---gTutorialDialog:DoDialog("You have the way of it! Now you can chat with anyone you meet, and make lots of friends here.", true);
   gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro050", 7.0, "Dialogue_Tutorial/TUT_Ambrose_050.mp3", false, ambroseId, 7.0);
   
   gTutorialDialog:ShowWindow(false);
   ---gTutorialDialog:DoDialog("You can also hit Enter and type your own messages using Text Chat, but players under 13 will first need their parent’s permission.", true);
   gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro051", 10.0, "Dialogue_Tutorial/TUT_Ambrose_051.mp3", false, ambroseId, 10.0);
	
   --SetCanShowInteraction(true);
   
   --UnfreezePlayer();
   
   UnregisterEvent("OnNPCInteractionShown"); 
   UnregisterEvent("OnInteractWithNPC");
   UnregisterEvent("QuickChatClicked");
end

function main()
	TutorialChat();
end
