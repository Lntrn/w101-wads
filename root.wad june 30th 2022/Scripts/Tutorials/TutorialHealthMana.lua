-- TutorialHealthMana.lua

Include("Tutorials/API/TutorialCommon.lua");

---------------------------------------------------------------------------------------------------------
function CreateWinAnimStatGlobeScaleTime( a_scale, a_time )
   local scaleTime = CreateClass("WinAnimStatGlobeScaleTime");   
   scaleTime.SetScale(a_scale);
   scaleTime.SetTime(a_time);
   return scaleTime;
end

---------------------------------------------------------------------------------------------------------
function CreateMoveFillAnimation( a_posX, a_posY, a_amount, a_endTutorialOnFinish, a_timeToPerform )
	local animAnim 		= CreateClass("WinAnimConcurrent");	
	animAnim.AddAnimation( CreateWinAnimMoveToLocationTime(a_posX, a_posY, a_timeToPerform) );
	animAnim.AddAnimation( CreateWinAnimFillGlobeTime( a_amount, a_timeToPerform, a_endTutorialOnFinish ) );
	
	return animAnim; 
end

---------------------------------------------------------------------------------------------------------
function GetGlobeValues( a_globe )
	local initVals = {};
	initVals.X, initVals.Y 		= GetPointFromString(a_globe.GetLocation());
	initVals.Amount 			= a_globe.GetCurrentAmount();
	initVals.Max 				= a_globe.GetMaxAmount();
	return initVals;
end

---------------------------------------------------------------------------------------------------------
function GetScreenCenter()
	gRootWindow = gRootWindow or OpenClass(GetRootWindow());
	gRootWindowSize = { 	width = ( gRootWindow.GetRight() - gRootWindow.GetLeft() ),
						height = ( gRootWindow.GetBottom() - gRootWindow.GetTop() ) };

	return gRootWindowSize.width * 0.5, gRootWindowSize.height * 0.5;
end

---------------------------------------------------------------------------------------------------------
function TutorialHealthMana()
	--------------------------------------------------------------------------
	-- Open the Health/Mana globes
	gHealthGlobe = gHealthGlobe or OpenClass(OpenWindow( "spriteHealthBkg" ));	
	gManaGlobe = gManaGlobe or OpenClass(OpenWindow( "spriteManaBkg" ));
	gEnergyGlobe = gEnergyGlobe or OpenClass(OpenWindow( "spriteEnergyBkg" ));	
	gHealthGlobe.SetTutorialMode(true);
	gManaGlobe.SetTutorialMode(true);
	gEnergyGlobe.SetTutorialMode(true);
	
	local healthInit 	=  GetGlobeValues(gHealthGlobe);
	local manaInit 		=  GetGlobeValues(gManaGlobe);
    gHealthGlobe.SetVisible(true);
    gManaGlobe.SetVisible(true);
	
	local ambroseId = GetClientID(39394);
	   
   -- Reconfigure the tutorial dialog
   gTutorialDialog:SetTitle("Tutorial_Title4"); -- "Health and Mana"
   gTutorialDialog:SetProfessorImage("GUI/NpcPortraits/Art_Portrait_Ambrose.dds");	
   gTutorialDialog:MoveToBottom();
   ---gTutorialDialog:DoDialog("Oh my! You’re hurt! You’ll need to pay attention to your current Health.", false);
   gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro022", -1, "Dialogue_Tutorial/TUT_Ambrose_022.mp3", false, ambroseId, 5.0);
	
	-- Move the health/mana globes to the center of the screen
	local offsetX 		= manaInit.X - healthInit.X;
	local offsetY 		= manaInit.Y - healthInit.Y;
	local locX, locY 	= GetScreenCenter();
	
	gHealthGlobe.PushAnimation( CreateWinAnimMoveToLocationTimeEaseApprox( locX - 200, locY - 100, 1.0, 0.1, 5 ) );
	gManaGlobe.PushAnimation( CreateWinAnimMoveToLocationTimeEaseApprox( locX + offsetX + 50, locY - 100 + offsetY, 1.0, 0.1, 5 ) );
	PlaySoundOnce(string.format("GUI/ui_woosh_slow.wav"));
   
   FreezePlayer();
	
	WaitForAnimationsToFinish(gHealthGlobe);	
	WaitForAnimationsToFinish(gManaGlobe);
		
	-- Point arrow at the health globe
    PlaySoundOnce(string.format("GUI/ui_arrowyellow_point.wav"));	
	gHealthGlobe.PushAnimation(CreateWinAnimStatGlobeScaleTime( 1.5, 1.0 ));
    FreezePlayer();
	WaitForAnimationsToFinish(gHealthGlobe);
	gTutorialDialog:WaitForNextButton(ambroseId);
	
	--------------------------------------------------------------------------
   ---gTutorialDialog:DoDialog("This red crystal ball shows your Health. If you run out of Health in a Wizard duel, you’ll be defeated.", false);
   gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro023", -1, "Dialogue_Tutorial/TUT_Ambrose_023.mp3", false, ambroseId, 8.0);
   
   local healthArrow = TutorialArrow(gHealthGlobe, "Top", 64, 0.5, 0.5, true);
	
	-- Show health globe draining
	gHealthGlobe.PushAnimation(CreateWinAnimFillGlobeTime( 0, 1.0, false ));
    FreezePlayer();
	WaitForAnimationsToFinish(gHealthGlobe);
	gTutorialDialog:WaitForNextButton(ambroseId);	
	
	--------------------------------------------------------------------------
   ---gTutorialDialog:DoDialog("The blue crystal ball shows how much Mana you have left.", false);
   gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro024", -1, "Dialogue_Tutorial/TUT_Ambrose_024.mp3", false, ambroseId, 5.0);
	
   healthArrow:ShowWindow(false);	
	
	-- Scale the mana globe large, scale the health globe small again
	gHealthGlobe.PushAnimation(CreateWinAnimStatGlobeScaleTime( 1, 1.0 ));
	gManaGlobe.PushAnimation(CreateWinAnimStatGlobeScaleTime( 2, 1.0 ));
   FreezePlayer();
	WaitForAnimationsToFinish(gHealthGlobe);
	WaitForAnimationsToFinish(gManaGlobe);
	gTutorialDialog:WaitForNextButton(ambroseId);
   
   -- Point arrow at the mana globe	
	PlaySoundOnce(string.format("GUI/ui_arrowyellow_point.wav"));
	local manaArrow = TutorialArrow(gManaGlobe, "Top", 64, 0.5, 2.0, true);	
	
	--------------------------------------------------------------------------	
	---gTutorialDialog:DoDialog("Mana is magical energy. If you run out of Mana, you won’t be able to cast any more spells.", false);
   gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro025", -1, "Dialogue_Tutorial/TUT_Ambrose_025.mp3", false, ambroseId, 7.0);
	-- Show mana globe draining
	gManaGlobe.PushAnimation( CreateWinAnimFillGlobeTime( 0, 1.0, false ));
   FreezePlayer();
	WaitForAnimationsToFinish(gManaGlobe);
	gTutorialDialog:WaitForNextButton(ambroseId);	  
   manaArrow:ShowWindow(false);
   
   ---gTutorialDialog:DoDialog("When you’re out of Mana, you’ll be at the mercy...", true);
   gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro026", 3.0, "Dialogue_Tutorial/TUT_Ambrose_026.mp3", false, ambroseId, 3.0);
   
   ---gTutorialDialog:DoDialog("Why so distracted? We’re under attack? Oh my! Call me a fool... I had all but forgotten! ", true);
   gTutorialDialog:DoDialog("Tutorial_Tutorial_Intro027", 9.0, "Dialogue_Tutorial/TUT_Ambrose_027.mp3", false, ambroseId, 9.0);
   gTutorialDialog:ShowWindow(false);
   
	--------------------------------------------------------------------------
	-- Add the mana and health elements to the Main HUD, refill them also
	PlaySoundOnce(string.format("GUI/ui_woosh_slow.wav"));
	gManaGlobe.PushAnimation(CreateWinAnimStatGlobeScaleTime( 1, 1.0 ));
   FreezePlayer();	
	
	gHealthGlobe.PushAnimation( CreateMoveFillAnimation( healthInit.X, healthInit.Y, healthInit.Amount, true, 1.0  ) );
	gManaGlobe.PushAnimation( CreateMoveFillAnimation( manaInit.X, manaInit.Y, manaInit.Amount, true, 1.0  ) );
	FreezePlayer();
	WaitForAnimationsToFinish(gHealthGlobe);	
	WaitForAnimationsToFinish(gManaGlobe);
   UnfreezePlayer();
end

