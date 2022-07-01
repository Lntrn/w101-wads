
Include("API/Classes/class.lua");
Include("Tutorials/API/Debug.lua");

WindowSlideTime = 0.35; -- time it takes for window to slide to top or bottom of screen

---------------------------------------------------------------------------------------------------------
-- Declaration - This class manages the TutorialDialog gui, which is used in the tutorials
---------------------------------------------------------------------------------------------------------
TutorialDialog = class( function( self, a_attachToWindow )
		--BreakNative();
		-- added btnQuickChat here so that we will insert the dialog window before btnQuickChat so that 
		-- the chat window will always be on top of dialog windows
		if (a_attachToWindow) then
		   self.m_BaseWindow		= OpenClass( LoadGUI( "Tutorial.gui", 0, OpenClass( a_attachToWindow ), "btnQuickChat" ) );
		else
		   self.m_BaseWindow		= OpenClass( LoadGUI( "Tutorial.gui", 0, OpenClass( GetRootWindow() ) ) );
		end
		self.m_Dialog 			= self.m_BaseWindow.FindNamedWindow( "DialogWindow" );
		self.m_Title			= self.m_BaseWindow.FindNamedWindow( "TitleText" );
		self.m_Message			= self.m_BaseWindow.FindNamedWindow( "MessageText" );
		self.m_NextButton		= self.m_BaseWindow.FindNamedWindow( "NextButton" );
		self.m_SkipButton		= self.m_BaseWindow.FindNamedWindow( "SkipButton" );
		self.m_ProfessorSprite	= self.m_BaseWindow.FindNamedWindow( "ProfessorSprite" );
	
	    self.m_ConfirmationWindow     = OpenClass( LoadGUI( "MessageBoxWindow.gui", 0 ) );
	    self.m_ConfirmationTitle       = self.m_ConfirmationWindow.FindNamedWindow( "TitleText" );
        self.m_ConfirmationText       = self.m_ConfirmationWindow.FindNamedWindow( "CaptionText" );
        self.m_YesButton  = self.m_ConfirmationWindow.FindNamedWindow( "leftButton" );
        self.m_NoButton   = self.m_ConfirmationWindow.FindNamedWindow( "rightButton" );
        self.m_MaybeButton   = self.m_ConfirmationWindow.FindNamedWindow( "centerButton" );

        local myLeft = self.m_BaseWindow.GetLeft();   
        local myHeight = self.m_BaseWindow.GetWindowHeight();
        local parentBottom = self.m_BaseWindow.Parent().GetBottom();
        self.m_BaseWindow.SetLocation(myLeft, parentBottom - myHeight);
        self.m_BaseWindow.m_Flags = "VISIBLE|HCENTER";
      
		self.m_MaybeButton.ShowWindow(false);
		self.m_ConfirmationWindow.ShowWindow(false);
		self.m_SkipButton.ShowWindow(false);
	end );

---------------------------------------------------------------------------------------------------------
-- Show or Hide the dialog window
---------------------------------------------------------------------------------------------------------
function TutorialDialog:ShowWindow( a_bShowDialog )
	self.m_BaseWindow.ShowWindow( a_bShowDialog );
end

---------------------------------------------------------------------------------------------------------
-- Show or Hide the confirmation window
---------------------------------------------------------------------------------------------------------
function TutorialDialog:ShowConfirmationWindow( a_bShowDialog )
	self.m_ConfirmationWindow.ShowWindow( a_bShowDialog );
end

---------------------------------------------------------------------------------------------------------
-- Set the title text. Takes in a string. 
---------------------------------------------------------------------------------------------------------
function TutorialDialog:SetTitle( a_TitleText )
	self.m_Title.SetText( "<string;"..a_TitleText.."></string>" );
end

---------------------------------------------------------------------------------------------------------
-- Set the message text. Takes in a string key.
---------------------------------------------------------------------------------------------------------
function TutorialDialog:SetMessage( a_Text )
	local clientTutorial = OpenClass(GetTutorial());
	if(clientTutorial ~= nil) then
      clientTutorial.SetTutorialDialogText(self.m_Message, a_Text);
   end
end

---------------------------------------------------------------------------------------------------------
-- Set the confirmation text. Takes in a string key.
---------------------------------------------------------------------------------------------------------
function TutorialDialog:SetConfirmationMessage( a_MessageText )
	self.m_ConfirmationText.SetText( "<center>".."<string;"..a_MessageText.."></string>".."</center>" );
end

---------------------------------------------------------------------------------------------------------
-- Set the confirmation Title. Takes in a string key.
---------------------------------------------------------------------------------------------------------
function TutorialDialog:SetConfirmationTitle( a_MessageText )
	self.m_ConfirmationTitle.SetText( "<center>".."<string;"..a_MessageText.."></string>".."</center>" );
end

---------------------------------------------------------------------------------------------------------
-- Set the confirmation Yes Button text. Takes in a string key.
---------------------------------------------------------------------------------------------------------
function TutorialDialog:SetConfirmationYesLabel( a_MessageText )
	self.m_YesButton.SetLabel( "<center>".."<string;"..a_MessageText.."></string>".."</center>" );
end

---------------------------------------------------------------------------------------------------------
-- Set the confirmation No Button text. Takes in a string key.
---------------------------------------------------------------------------------------------------------
function TutorialDialog:SetConfirmationNoLabel( a_MessageText )
	self.m_NoButton.SetLabel( "<center>".."<string;"..a_MessageText.."></string>".."</center>" );
end

---------------------------------------------------------------------------------------------------------
-- Wait for the player to press the 'Next' button.
---------------------------------------------------------------------------------------------------------
function TutorialDialog:WaitForNextButton(aPlayAnimationID)
	local skipTutorial = false;
	FreezePlayer();
	self:ShowNextButton();
	RegisterEvent("WB_BUTTONUP");
	RegisterEvent("SkipTutorialButton");
	while ( true ) do
		---[[--Check for CSR command
		local event = GetEvent("", false);
		if (event) then
		    Log("WaitFornextButton Event received: "..event.EventName.." "..event.Name); 
			--Only show with CSR keyboard shortcut, with the first dialog box, and with the first character
			--because subsequent characters already have the skip button available
			if (event.EventName == "SkipTutorialButton" and gFirstScreen == true and gFirstCharacterCreation) then
				gTutorialDialog:ShowSkipTutorialButton();
				gFirstScreen = false;
			elseif (event.EventName == "WB_BUTTONUP" and event.Name == "NextButton") then
				break;
			elseif (event.EventName == "WB_BUTTONUP" and event.Name == "SkipButton") then
				skipTutorial = true;
				break;
			end
		end
	end
	
	UnregisterEvent("WB_BUTTONUP");
	UnregisterEvent("SkipTutorialButton");
	UnfreezePlayer();
	
   -- Cut off any playing dialog sounds
   StopDialogSound();
        
   if (aPlayAnimationID) then          
   	   PlayAnimation(aPlayAnimationID, "Idle");
   end
   
   return skipTutorial;
end

---------------------------------------------------------------------------------------------------------
-- Wait for the player to Confirm (or retract) Tutorial Cancellation
---------------------------------------------------------------------------------------------------------
function TutorialDialog:GetConfirmation()
	local retVal = false;
	FreezePlayer();
	self:ShowConfirmationWindow(true);
	RegisterEvent("WB_BUTTONUP");
	while ( true ) do
		local event = GetEvent("WB_BUTTONUP");
		Log("GetConfirmation Event received: "..event.EventName.." "..event.Name); 		
		if ( event.EventName == "WB_BUTTONUP" and event.Name == "rightButton" ) then
			break;
		end
		if ( event.EventName == "WB_BUTTONUP" and event.Name == "leftButton" ) then
			retVal = true;
			break;
		end
	end
	UnregisterEvent("WB_BUTTONUP");
	
	self:ShowConfirmationWindow(false);
	UnfreezePlayer();
	
	return retVal;
end

function TutorialDialog:ShowSkipTutorialButton()	
	self.m_SkipButton.ShowWindow(true);
end
function TutorialDialog:HideSkipTutorialButton()	
	self.m_SkipButton.ShowWindow(false);
end

---------------------------------------------------------------------------------------------------------
-- Force the Next button to be hidden
---------------------------------------------------------------------------------------------------------
function TutorialDialog:HideNextButton()
	self.m_NextButton.ShowWindow(0);
end

---------------------------------------------------------------------------------------------------------
-- Force the Next button to be shown
---------------------------------------------------------------------------------------------------------
function TutorialDialog:ShowNextButton()
	self.m_NextButton.ShowWindow(1);
end

---------------------------------------------------------------------------------------------------------
-- Move our dialog window to the top of the screen
---------------------------------------------------------------------------------------------------------
function TutorialDialog:MoveToTop()
  local myLeft = self.m_BaseWindow.GetLeft();
  local parentTop = self.m_BaseWindow.Parent().GetTop();
  self.m_BaseWindow.SetLocation(myLeft, parentTop);  
end

---------------------------------------------------------------------------------------------------------
-- Move our dialog window to the bottom of the screen (default)
---------------------------------------------------------------------------------------------------------
function TutorialDialog:MoveToBottom()
  local myLeft = self.m_BaseWindow.GetLeft();
  local myHeight = self.m_BaseWindow.GetWindowHeight();
  local parentBottom = self.m_BaseWindow.Parent().GetBottom();
  self.m_BaseWindow.SetLocation(myLeft, parentBottom - myHeight);  
end

---------------------------------------------------------------------------------------------------------
-- Make sure our dialog is visible by setting focus to it
---------------------------------------------------------------------------------------------------------
function TutorialDialog:SetFocus()
  WindowSetFocus(self.m_BaseWindow);
  WindowSetFocus(self.m_Dialog);  
  WindowSetFocus(self.m_Title);
  WindowSetFocus(self.m_Message);
  WindowSetFocus(self.m_NextButton);
  WindowSetFocus(self.m_ProfessorSprite);
end
---------------------------------------------------------------------------------------------------------
-- Detach the TutorialDialog from the root window (essentially remove it)
---------------------------------------------------------------------------------------------------------
function TutorialDialog:DetachSelf()
	self.m_BaseWindow.DetachSelf();
end

---------------------------------------------------------------------------------------------------------
-- Change the professor image to the given filename
---------------------------------------------------------------------------------------------------------
function TutorialDialog:SetProfessorImage( a_sProfImageFilename )
	self.m_ProfessorSprite.SetMaterialByName(a_sProfImageFilename);
end


function TutorialDialog:Display(aText, aShowNext)
   self:SetMessage(aText);
   self:ShowWindow(true);
   if(aShowNext == true) then
      self:WaitForNextButton();  
   else
      self:HideNextButton();  
   end
end

-- Params:
--    aText: Display text from string table using this key; pass an empty string if you don't want to show the dialog window
--    aNextDelay: Delay for this many seconds before making the Next button available; pass in a neative number to never show NextButton
--    aVoiceOver: Play this audio file as the voiceover for this dialog
--    aDontFreeze: don't call FreezePlayer
--    aPlayAnimationID: ID of dialog animation to play (Basically, gammaID, AmbroseID or MalistaireID)
function TutorialDialog:DoDialog(aText, aNextDelay, aVoiceOver, aDontFreeze, aPlayAnimationID, aDefaultAnimationLength)  
   local freezeThem = true;
   if(aDontFreeze and aDontFreeze == true) then
      freezeThem = false;
   end
   
   if(freezeThem) then
      -- make sure the player is frozen except when we explicitely allow them to move
      FreezePlayer();
   end

   local showDialogWindow = true;
   if(aText == "") then
      showDialogWindow = false;
   end

   self:HideNextButton();  
   self:SetMessage(aText);
   self:ShowWindow(showDialogWindow); 
   
   local soundID = 0;
   if(aVoiceOver) then
      soundID = PlayDialogSound(aVoiceOver);
   end      
   
   if (aPlayAnimationID) then        
     local animationLength = aDefaultAnimationLength;
     if (soundID > 0) then
        local soundPlayTimeSec = GetSoundPlayTimeSec(soundID);	
		
	    -- Set animationLength based on soundPlayTimeSec (This settings seem to give good adjustment)
	    if (soundPlayTimeSec > 7) then
	       animationLength = soundPlayTimeSec-2.5;
	    else
	       animationLength = soundPlayTimeSec-1.5;
	    end
	  
	    if (animationLength > 0 and animationLength <= 1) then
	       animationLength = 2;
	    elseif (animationLength <= 0) then
	       animationLength = 1;
	    end
     end
    
     if (animationLength and animationLength > 0) then
   	     PlayAnimation(aPlayAnimationID, "Gen_Dial_01", animationLength);
	 else
	     PlayAnimation(aPlayAnimationID, "Gen_Dial_01");
	 end	 
   end
     
   -- Allow the player to hit next immediately as long as SkipOk is true
   local noSkip = true;
   if(gSkipOK and gSkipOK == true) then
      noSkip = false;      
   end   
   
   if(noSkip == true and aNextDelay and aNextDelay > 0) then
      --convert aNextDelay to milliseconds	  	  	  
      aNextDelay = aNextDelay * 1000;
      local sleepAmt = 250; -- in milliseconds
      local elapsedTime = 0;
      while(elapsedTime < aNextDelay) do
   		local event = GetEvent("SkipAhead", false);
         if(event) then
            -- Implement a way to skip ahead using a keystroke
         end
         Sleep(sleepAmt);
         elapsedTime = elapsedTime + sleepAmt;
      end
   end
   
   if(showDialogWindow and (aNextDelay == nil or aNextDelay >= 0)) then            
      self:ShowNextButton();
      self:WaitForNextButton(aPlayAnimationID);      	 	
   end
   
   return soundID;
end

