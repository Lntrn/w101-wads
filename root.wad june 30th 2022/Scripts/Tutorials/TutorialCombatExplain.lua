-- TutorialCombatExplain.lua
Include("Tutorials/API/Debug.lua");
Include("Tutorials/API/TutorialDialog.lua")
Include("API/ControlClasses.lua");

function TutorialCombatExplain()

   -- Reconfigure the tutorial dialog
   tutorialDialog = ResetTutorialDialog(tutorialDialog);
   tutorialDialog:SetTitle("Tutorial_Title3");
   tutorialDialog:SetProfessorImage("GUI/NpcPortraits/Art_Portrait_Gamma.dds");
	tutorialDialog:SetMessage("Tutorial_Tutorial_FictionCombatExpl1");
   tutorialDialog:MoveToBottom();
   
	--Adding this event so that other scripts (like an automated Tutorial Test) can know exactly
	--where we are in the tutorial
	SendEvent("Tutorial_LectureText");
	
   tutorialDialog:WaitForNextButton();

	summonPic = CreateSpriteClass("Backgrounds/Background_Tutorial_Summon.dds",MakeRectString(0,0,618,404),false,nil);
	summonPic.SetLocation( 0, 0 );
	summonPic.m_Style = "HAS_NO_BORDER|DO_NOT_CAPTURE_MOUSE";
   summonPic.m_Flags = "HCENTER";
	summonPic.ShowWindow(true);

   tutorialDialog:SetMessage("Tutorial_Tutorial_FictionCombatExpl2");
   tutorialDialog:ShowWindow(true);
	
	--Adding this event so that other scripts (like an automated Tutorial Test) can know exactly
	--where we are in the tutorial
	SendEvent("Tutorial_LectureText");
	
   tutorialDialog:WaitForNextButton();

   tutorialDialog:SetMessage("Tutorial_Tutorial_FictionCombatExpl3");
   tutorialDialog:ShowWindow(true);
 	
	--Adding this event so that other scripts (like an automated Tutorial Test) can know exactly
	--where we are in the tutorial
	SendEvent("Tutorial_LectureText");
	
   tutorialDialog:WaitForNextButton();

   tutorialDialog:SetMessage("Tutorial_Tutorial_FictionCombatExpl4");
   tutorialDialog:ShowWindow(true);
 	
	--Adding this event so that other scripts (like an automated Tutorial Test) can know exactly
	--where we are in the tutorial
	SendEvent("Tutorial_LectureText");
	
   tutorialDialog:WaitForNextButton();

   --tutorialDialog:DetachSelf();
   summonPic.DetachSelf();

end

