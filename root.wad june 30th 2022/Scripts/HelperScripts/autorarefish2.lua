Include("API/Utilities.lua")
Include("API/ControlClasses.lua")
Include("HelperScripts/PushButton.lua")
Include("HelperScripts/GetArguments.lua")

local CharacterPlaying = GetLocalCharacterName();

function main()

	--Give the player the current fishing spells
	Server("addspell", "SummonFish");
	Server("addspell", "CSRRevealFishNames");	
	Sleep(2);
	
	--Get information on the HUD
	local RootWnd = OpenClass(GetRootWindow())
	if(RootWnd == nil) then
		Log("Couldn't find Root window. Exiting")
		Kill(GetProcessID())
	end

	--Get the rest of the information on the HUD
	local HudWnd = RootWnd.FindNamedWindow("windowHUD")
	if(HudWnd == nil) then
		Log("Couldn't find HUD window. Exiting")
		Kill(GetProcessID())
	end
	
	--Open the fishing menu
	local fishMenu = HudWnd.FindNamedWindow("OpenFishingButton")
	if (fishMenu == nil) then
		Log("There is no fishing UI button");
	end
	PushButton(fishMenu);

	--Get more information on the HUD
	local FishWnd = RootWnd.FindNamedWindow("FishingSubWindow")
	if(FishWnd == nil) then
		Log("Couldn't find fishing HUD sub-window. Exiting")
		Kill(GetProcessID())
	end	

	--Get still more information on the HUD
	local BotFrm = FishWnd.FindNamedWindow("BottomFrame")
	if(BotFrm == nil) then
		Log("Couldn't find fishing HUD sub-window's bottom frame. Exiting")
		Kill(GetProcessID())
	end	
	
	--Navigate to the page in the fishing menu with Summon Fish
	local pageRight = BotFrm.FindNamedWindow("btnItemPageRight")
	if (pageRight == nil) then
		Log("there is no page right button");
	end
	for i = 1, 3, 1 do
		PushButton(pageRight);
	end

	--Run the autorarefish loop
	rare();
end
	


function rare()

	--This tracks the number of the picture, and is appended to the file name, incrementing each loop
	local pictureNumber = 0
	
	--If the player uses the mousewheel, quit the loop
	Quit = false
	RegisterEventCallback("GM_MOUSEWHEEL", QuitProgram)

	
	--Until the player quits the loop, do the following
	while (Quit == false) do
		--Take screenshots after using the CSR reveal fish names spell, and repeat
		pictureNumber = pictureNumber + 1;
		
		--Get refreshed info on the HUD
			local RootWnd = OpenClass(GetRootWindow())
			if(RootWnd == nil) then
				Log("Couldn't find Root window. Exiting")
				Kill(GetProcessID())
			end
	
		--Get more information on the HUD
			local FishWnd = RootWnd.FindNamedWindow("FishingSubWindow")
			if(FishWnd == nil) then
			Log("Couldn't find fishing HUD sub-window. Exiting")
			Kill(GetProcessID())
			end	

		--Get still more information on the HUD
			local BotFrm = FishWnd.FindNamedWindow("BottomFrame")
			if(BotFrm == nil) then
			Log("Couldn't find fishing HUD sub-window's bottom frame. Exiting")
			Kill(GetProcessID())
			end	
	
			--Find the Summon fish spell and use it to refresh the pond
			local summonFish = BotFrm.FindNamedWindow("Icon1")
				if (summonFish == nil) then
				Log("there is no Summon fish button");
			end
			Sleep(1.5);
			PushButton(summonFish);
			Sleep(5);
			
		--Get refreshed info on the HUD
			local RootWnd = OpenClass(GetRootWindow())
			if(RootWnd == nil) then
				Log("Couldn't find Root window. Exiting")
				Kill(GetProcessID())
			end
	
		--Get more information on the HUD
			local FishWnd = RootWnd.FindNamedWindow("FishingSubWindow")
			if(FishWnd == nil) then
			Log("Couldn't find fishing HUD sub-window. Exiting")
			Kill(GetProcessID())
			end	

		--Get still more information on the HUD
			local BotFrm = FishWnd.FindNamedWindow("BottomFrame")
			if(BotFrm == nil) then
			Log("Couldn't find fishing HUD sub-window's bottom frame. Exiting")
			Kill(GetProcessID())
			end
			
			--Find the CSR reveal fish names spell and use to show the names of the fish in the pond
			local CSRRevealFishNames = BotFrm.FindNamedWindow("Icon2")
				if (CSRRevealFishNames == nil) then
				Log("there is no Fish Names Button right now");
			end
			Sleep(1.5);			
			PushButton(CSRRevealFishNames);
			Sleep(15);
			
			--Take a screenshot to keep a record for further review
			Screenshot(1,"rarefish_"..pictureNumber)
		
		--Set the player's energy to max, to allow the loop to continue indefinitely
		Server("setmaxenergy");
		
		--Check to see if we've got a mousewheel event, and quit the program if so
		
		--Get a list of events
		local event = GetEvent("", false);
		
		--If the event is valid, check for the associate callback function and call it
		--In this case, we're looking for mousewheel movement and then setting quit to false if so
		if (event) then
			Log("Event registered")
			
			--If the event is registered, run the associated callback function
			if (event.LUA_CallBack) then
				Log("LUA Callback triggered")
				event.LUA_CallBack(event);
			end
		end
	end
end

--When the mousewheel is used, sets quit to false, ending the loop
function QuitProgram()
	Quit = true
end