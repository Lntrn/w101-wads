--This function's sole purpose is to get past character creation in the text client, then to run
--another script.  It waits for the client to log in, then it will create a fresh character called
--"TestChar[#]", select that character, wait for the character to be teleported into the game, skips
--the tutorial, then runs the desired script.  It allows you to specify a number to append to the
--character's name, so you can differentiate between characters in the game.  It also quits the game
--when the script is done running, as long as the script that is run sends the "DoneRunningScript"
--event with the event.ScriptName member equal to the name of the script.
--
-- @param[in]	[#<number>]	An optional argument that consists of a '#' character followed by a
--					number.  That number will be appended to the end of the character's name.
-- @param[in]	ScriptName	The name of the script that you want run once the character is loaded
--					into the zone.
-- @param[in]	[ScriptArgs]	The arguments you want passed to the script that's going to be run.

Include("HelperScripts/GetArguments.lua");
Include("HelperScripts/GetEventByName.lua");
Include("HelperScripts/EquipLevelOneSpells.lua");

function main()
	--Register events we're going to be waiting for before they could possibly happen, so we don't
	--miss them when they do.
	RegisterEvent("CharacterSelectState");
	RegisterEvent("DeleteCharacterResponse");
	RegisterEvent("OnTeleported");
	RegisterEvent("DoneRunningScript");
	
	Log("Starting RunScriptAfterLogin.lua");
	
	--First, get the arguments that were passed into this script.  The first argument will be the
	--script to be run.  Any remaining args will be passed on to the script.
	local args = GetArguments();
	local scriptName;
	if(args["arg0"] == nil) then
		--We didn't get a script to run, so we can't really do anything
		Log("Usage:  RunScriptAfterLogin <ScriptName> [ScriptArg...]");
		return;
	end

	--Get the script name.
	local charIndex = "";
	local argNum = 1;
	if(string.sub(args.arg0, 1, 1) == "#") then
		--The first argument is not the script name, but is the number the caller wants appended to
		--the character's name, so make sure that there is a digit following the "#" and get it.
		if(string.len(args.arg0) >= 2) then
			charIndex = string.sub(args.arg0, 2, -1);
		end
		scriptName = args.arg1;
		argNum = argNum + 1;
	else
		scriptName = args["arg0"];
	end
	
	--Construct the Run command's string.  It will have the format:
	--	"<Lua File Name>, [args...]"
	local argTbl = {};
	while(args["arg"..argNum] ~= nil) do
		if(string.sub(args["arg"..argNum], 1, 1) == "#") then
			--This argument is not a script argument, but is the number that the caller wanted
			--appended to the end of the character's name.  So, make sure there is a number
			--following the "#" and get it.
			if(string.len(args["arg"..argNum]) >= 2) then
				charIndex = string.sub(args["arg"..argNum], 2, -1);
			end
		else
			argTbl["arg"..argNum+2] = args["arg"..argNum];
		end
		argNum = argNum + 1;
	end

	--Wait for the client to log in before I try to run any scripts.
	Log("Waiting for login");
	GetEvent("CharacterSelectState");

	--Make sure that there are no previous test characters that were created
	local numChars = DeleteAllCharacters();
	for charCnt = 1, numChars do
		Log("Waiting for Character Deletion");
		GetEvent("DeleteCharacterResponse");
	end

	--Create a new character to test on
	-- local charName = "TestChar"..charIndex;
	-- WizCreateCharacter(charName, 1);
	local charName = WizCreateCharacter(1);

	--Wait for the client to log in before I try to select the character
	Log("Waiting for Character Creation");
	GetEvent("CharacterSelectState");
	
	--For some odd reason, trying to select a character too soon after getting the
	--CharacterSelectState event doesn't work.  So, I'm waiting a bit.
	Sleep(0.5);
	
	--Select the character
	WizSelectCharacter(charName);
	-- SelectFirstCharacter();
	
	--Wait for the character to be teleported into the tutorial
	Log("Waiting to go into tutorial");
	GetEvent("OnTeleported");
	
	--Wait a bit once the character has been loaded into the zone
	Sleep(1);

	--Because it's a new character, the tutorial will automatically launch, so skip it.
	local clientTutorial = OpenClass(GetTutorial());
	if(clientTutorial ~= nil) then
		clientTutorial.RequestAddQuest("WC-TUT-C08-001");
      clientTutorial.RequestGoalCompletion("WC-TUT-C08-001","Teleport");
		clientTutorial.RequestGoalCompletion("Tutorial_Intro","OnlyGoal");
	else
		Server("Teleport", "WC_Hub");
	end
	
	--Wait to be teleported out of the tutorial area
	Log("Waiting to be teleported out of tutorial");
	GetEvent("OnTeleported");
	Log("Got into game, should be no problems now");
	
	--Wait a bit once the character has been loaded into the zone
	Sleep(1);

	local runRes = Run(scriptName, argTbl);
	if(runRes ~= "0") then
		Log("Waiting for "..scriptName.." to finish running");
		--Wait for the script to finish running and quit the game.
		local event = GetEvent("DoneRunningScript");
		while(string.find(scriptName, event["ScriptName"], 1, true) == nil) do
			event = GetEvent("DoneRunningScript");
		end
		if(event["ExitCode"] ~= nil) then
			--We're done with the character we created, so remove it
			Logout();
			Log("Waiting For Logout");
			GetEvent("CharacterSelectState");
			WizDeleteCharacter(charName);
			Log("Waiting for Character Deletion");
			GetEvent("CharacterSelectState");

			--We're done running the script and it provided us with an exit code, so exit with that
			--code.
			Exit(tonumber(event["ExitCode"]));
		end
	end
	
	--We're done with the character we created, so remove it
	Logout();
	Log("Waiting For Logout");
	GetEvent("CharacterSelectState");
	WizDeleteCharacter(charName);
	Log("Waiting for Character Deletion");
	GetEvent("CharacterSelectState");

	--We're done running our script, so exit the game.
	Quit();
end


