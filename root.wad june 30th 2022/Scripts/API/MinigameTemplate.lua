--[[

   MinigameTemplate.lua

	MinigameTemplate

	Author: Jeff Everett
	KingsIsle Entertainment
	Date: Nov 8 06
]]

-- Include classes that are needed for various UIs
Include( "API/BitManip.lua" );
Include( "API/Debug.lua" );
Include( "API/Classes/class.lua" );
Include( "API/ControlClasses.lua" );
Include( "API/Utilities.lua" );

Include( "API/Classes/Timer.lua" );

Include("API/Globals.lua");


RegisteredEvents = {};	-- Handles events that must first be registered.
Events = {};			-- Handles messages from the server.



---------------------------------------------------------------------------------------------------------
-- REGISTERED EVENTS
---------------------------------------------------------------------------------------------------------


MinigameTemplate = class(function( a, window, override, noButtons )
  if (noButtons == nil) then
    a.quitButton = nil;
    a.normalButton = nil;
    a.minimizeButton = nil;
    a.helpButton = nil;
    a.baseWindow = {};
    a.gameWindow = nil;
    a.helpWindow = nil;
    a.helpTitleText = nil;
    a.helpText = nil;
    a.messageText = nil;
    a.onExit = nil;
    a.onEnterHelp = nil;
    a.onExitHelp = nil;
    a.onMin = nil;
    a.onMax = nil;
    
    if (window and override) then
      a.baseWindow.window = window;
    else
      a.baseWindow.window = CreateGUIClass("MiniGame_Template.gui", true);
      a.gameWindow = a.baseWindow.window.FindNamedWindow( "GameWindow" );
      if (window) then
        window.DetachSelf();
        a.gameWindow.AttachWindow( window );
      end
    end
    
    local baseWindow = a.baseWindow.window;
    a.quitButton = baseWindow.FindNamedWindow( "CloseButton" );
    a.normalButton = baseWindow.FindNamedWindow("MaxButton");
    a.minimizeButton = baseWindow.FindNamedWindow("MinButton");
    a.helpButton = baseWindow.FindNamedWindow("HelpButton");
    a.titleText = baseWindow.FindNamedWindow("TitleText");
    a.helpWindow = baseWindow.FindNamedWindow("HelpWindow");
    if override and a.helpWindow == nil then
      local template = CreateGUIClass("MiniGame_Template.gui", false);
      a.helpWindow = template.FindNamedWindow("HelpWindow");
      a.helpWindow.DetachSelf();
      baseWindow.AttachWindow( a.helpWindow );
      DebugLog( "HelpWindow was not found, using default help window" );
    end
    a.helpWindow.ShowWindow( false );
    a.messageText = baseWindow.FindNamedWindow("MessageText");
    a.helpTitleText = baseWindow.FindNamedWindow("HelpTitle");
    a.helpText = baseWindow.FindNamedWindow("HelpText");
    a.baseWindow.xSize = baseWindow.GetRight()-baseWindow.GetLeft()+1;
    a.baseWindow.ySize = baseWindow.GetBottom()-baseWindow.GetTop()+1;
    a.baseWidth = a.baseWindow.xSize;
    a.baseHeight = a.baseWindow.ySize;
    a.HelpCallback = nil;
  end

  
  RegisterEvent("WB_BUTTONUP");
  for eventName, _ in pairs( RegisteredEvents ) do
   	RegisterEvent( eventName );
  end

end);


function MinigameTemplate:LoadTitleMenu()
	DebugLog( "LoadTitleMenu doesn't do anything now, remove the call to it" );
end

function MinigameTemplate:ProcessMessage(event)
	DebugBeginCriticalSection();
	DoDebugLog( event );
	if(event.EventName == "WB_BUTTONUP") then
		if(event.Name == "CloseButton") then
			Log("Clicking QuitButton");
			EndGame();
			--local pid = GetProcessID();
			--Kill(pid);
		elseif(event.Name == "MinButton") then
			DebugLog("Clicking Minimize Button [NYI]");
			if self.onMin then
				self.onMin();
			end
		elseif(event.Name == "MaxButton") then
			DebugLog("Clicking TitleMenuRestore Button [NYI]");
			if self.onMax then
				self.onMax();
			end
		elseif(event.Name == "HelpButton" or event.Name == "HelpBackButton") then
			local isVisible = self.helpWindow.IsVisible();
			local func = nil;
			if isVisible then
				func = self.onExitHelp;
			else
				func = self.onEnterHelp;
			end
			if func then
				func();
			end
			local parent = self.helpWindow.Parent();
			self.helpWindow.DetachSelf();
			parent.AttachWindow( self.helpWindow );
			self.helpWindow.ShowWindow( not isVisible );
		end
	end
	
	local continue = true;
	local func = RegisteredEvents[event.EventName];
	if func then
		func( event );
		continue = false;
	end
	
	if continue == true then
		local func = Events[event.EventName];
		if func then
			func( event );
		end
	end
	DebugEndCriticalSection();
end

function MinigameTemplate:SetOnExitFunc( func )
	self.onExit = func;
end

function MinigameTemplate:SetOnEnterHelpFunc( func )
	self.onEnterHelp = func;
end

function MinigameTemplate:SetOnExitHelpFunc( func )
	self.onExitHelp = func;
end

function MinigameTemplate:SetOnMinFunc( func )
	self.onMin = func;
end

function MinigameTemplate:SetOnMaxFunc( func )
	self.onMax = func;
end

function MinigameTemplate:SetTitleText(text)
   self.titleText.SetText(text);
end

function MinigameTemplate:SetHelpTitleText(text)
	self.helpTitleText.SetText(text);
end

function MinigameTemplate:SetHelpText(text)
	self.helpText.SetText(text);
end

function MinigameTemplate:SetMessageText(text)
	self.messageText.SetText(text);
end

function MinigameTemplate:SetQuitButton(window)
	self.quitButton = window;
end

function MinigameTemplate:SetNormalButton(window)
	self.normalButton = window;
end

function MinigameTemplate:SetMinimizeButton(window)
	self.minimizeButton = window;
end

function MinigameTemplate:CenterWindow()

	-- first we have to determine the screen resolution
	local rootWindow = OpenWindowClass("Root");
--	local rootWindow = OpenClass(FindNamedWindow("Root"));

	local mx = MinigameTemplate_DefaultMaximizedX;
	local my = MinigameTemplate_DefaultMaximizedY;
	
	if(not rootWindow) then
		DebugLog("Unable to get the Root window, assuming 1024,768");
	else
		mx = rootWindow.GetRight();
		my = rootWindow.GetBottom();
	end

	local MinigameTemplate_MaximizedX = mx -348;
	local MinigameTemplate_MaximizedY = my -75;
	local posX = ((MinigameTemplate_MaximizedX/2) - (self.baseWidth/2));
	local posY = ((MinigameTemplate_MaximizedY/2) - (self.baseHeight/2));
	
	self.baseWindow.window.SetLocation(posX,posY);

end

function MinigameTemplate:SetWindow(window)
	window.DetachSelf();
	self.gameWindow.DetachAllWindows();
	self.gameWindow.AttachWindow( window );
end

function MinigameTemplate:Show()
	self.baseWindow.window.ShowWindow(true);
end

function MinigameTemplate:Hide()
	self.baseWindow.window.ShowWindow(false);
end

function MinigameTemplate:Run()
	while true do
		event = GetEvent();
		Minigame:ProcessMessage( event );
	end
end

-- Helper functions 

function DoDebugLog(event)
	--Log incoming server messages
	if DEBUG == true then
		for i, j in pairs( event ) do
			Log( i .. " " .. j );
		end
		Log( "-------" );
	end
end
