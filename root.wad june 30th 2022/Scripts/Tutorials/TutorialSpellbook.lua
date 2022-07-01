-- TutorialSpellbook.lua

Include("Tutorials/API/Debug.lua");
Include("Tutorials/API/TutorialDialog.lua")
Include("Tutorials/API/TutorialUtility.lua")
Include("API/ControlClasses.lua");



function TutorialSpellbook()
   
   RegisterEvent("OnSpellbookOpened");

	local spellbookButton = OpenClass(FindNamedWindow("btnSpellbook"));
	if(spellbookButton == nil) then
		Log("Could not find spellbook button to hide!");
	else
		-- Spellbook is supposed to be hidden at this point, so make sure it's hidden.
		spellbookButton.ShowWindow(false);
	end	
	
	-- Now display a large sprite of the spellbook.
	local spellbookImage = CreateSpriteClass("HUD/Button_Spellbook.dds",MakeRectString(0,0,128,128),false,nil);
	spellbookImage.SetLocation( (GetScreenWidth()/2) - 64, (GetScreenHeight()/2) - 64 );
	spellbookImage.m_Style = "HAS_NO_BORDER|DO_NOT_CAPTURE_MOUSE";
	spellbookImage.ShowWindow(true);
		
	anim = MakeScaleAnimation( 2.0, 0.2 );	
	spellbookImage.PushAnimation( anim );
	WaitForAnimationsToFinish( spellbookImage );

   -- Reconfigure the tutorial dialog
	tutorialDialog = ResetTutorialDialog(tutorialDialog);	
   tutorialDialog:SetTitle("Tutorial_Title8");
	tutorialDialog:SetProfessorImage("GUI/NpcPortraits/Art_Portrait_Registrar.dds");
	tutorialDialog:SetMessage("Tutorial_Tutorial_Spellbook1");
	tutorialDialog:MoveToTop();
   
	--Adding this event so that other scripts (like an automated Tutorial Test) can know exactly
	--where we are in the tutorial
	SendEvent("Tutorial_LectureText");

	tutorialDialog:WaitForNextButton();
	
	anim = MakeScaleAnimation( 1.0, 0.3 );	
	spellbookImage.PushAnimation( anim );
	--WaitForAnimationsToFinish( spellbookImage );
	
	-- Animate the spellbook to the bottom corner of the screen
	anim = MakeMoveAnimation( GetScreenWidth() - (128), GetScreenHeight() - (128), 0.3 );
	spellbookImage.PushAnimation( anim );
	WaitForAnimationsToFinish( spellbookImage );
	
	--When the last spell book page the user looked at was the preferences and the user clicks on
	--the spellbook button during the tutorial, a "Quit Game" dialog appears briefly before the
	--spellbook appears.  This could happen very easily if the user goes through the tutorial, gets
	--into the main game, then presses escape and Quit to log out, then creates a new character and
	--goes through the tutorial.  This happenes because of how we are intercepting the "escape"
	--key-press, which is done in the HandleDisplayPreferences() function.
	--The answer to this is to make sure the "last page opened" is not the preferences page.
	GetSpellBookPage("Maps", false);
	
	-- Display the actual spellbook button
	SendClientEvent("ShowSpellbookButton");
      
   while(true) do -- loop here until we get a handle on the button
      local spellbookButton = OpenClass(FindNamedWindow("btnSpellbook"));
      if(spellbookButton) then break; end
      Sleep(100);
      
   end
   
	local spellbookArrow = TutorialArrow(spellbookButton, "Top", 64, 0.5, 0.5, false);
	spellbookArrow:ShowWindow(true);
	PlaySoundOnce(string.format("GUI/ui_arrowyellow_point.wav"));

	tutorialDialog:SetMessage("Tutorial_Tutorial_Spellbook2");	
	tutorialDialog:ShowWindow(true);
	tutorialDialog:HideNextButton();
	spellbookImage.DetachSelf();

	--Adding this event so that other scripts (like an automated Tutorial Test) can know exactly
	--where we are in the tutorial
	SendEvent("Tutorial_WaitingForOpenSpellBook");

	GetEvent("OnSpellbookOpened");
	
	spellbookArrow:ShowWindow(false);
	
   UnregisterEvent("OnSpellbookOpened");
   
	--tutorialDialog:DetachSelf();
end

