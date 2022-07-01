--This script takes the following arguments:
--	arg0	A new name for the log file.  Will override the default name.  A file is always output.
--	arg1	Whether or not to output to std out (in addition to other forms of output).  1 to use
--		it, 0 to not use it.  Defaults to 0.
--	arg2	Whether or not to output to a database (in addition to other forms of output).  1 to
--		use it, 0 to not use it.  Defaults to 0.  If this is 0, then the rest of the remaining
--		arguments are ignored.
--	arg3	The host name for the database.
--	arg4	The database name to connect to.
--	arg5	The table name to write to within the specified database.
--	arg6	The user name to log into the database.
--	arg7	The password to log into the database.

Include("API/Utilities.lua");
Include("HelperScripts/GetXmlValueFromFile.lua");
Include("HelperScripts/GetArguments.lua");
Include("HelperScripts/GetXmlFileList.lua");

SchoolNames = { "Fire", "Ice", "Storm", "Life", "Myth", "Death", "Balance" };

--This is a configuration constant that sets how long (in seconds) we will wait once we have given
--an equip or unequip command before we consider that it is not going to happen.
SECONDS_BEFORE_EQUIP_TIMEOUT = 1;

function main()
	--Get any arguments the user passed to this script.
	local args = GetArguments();
	local newFileName = nil;
	if(args["arg0"] ~= nil) then
		--The user passed in a different log file name.  We need to make sure that the slash
		--directions for the path are standardized to support Linux.
		newFileName = string.gsub(args["arg0"], "\\", "/");
		
		--When specifying a new log file, the user can either specify a path, or they can just
		--specify a file name.  If they don't specify a path, then use the default path.
		if(string.find(newFileName, "/") == nil) then
			--The user did not specify a path
			newFileName = string.gsub(LogFileName, "AutomatedEquipmentTestResults.log", newFileName);
		end
	end
	local useStdOut = false;
	if(args["arg1"] ~= nil) then
		--The user specified whether or not to output to std out
		if(args["arg1"] == "1") then
			useStdOut = true;
		end
	end
	local writeToDb = false;
	local dbHost = "";
	local dbName = "";
	local dbUser = "";
	local dbPassword = "";
	local dbTableName = "";
	if(args["arg2"] ~= nil) then
		--The user specified whether or not to output to std out
		if(args["arg2"] == "1") then
			writeToDb = true;
			
			--Get all of the connection information to connect to the database
			if(args["arg3"] ~= nil) then
				dbHost = args["arg3"];
			end
			if(args["arg4"] ~= nil) then
				dbName = args["arg4"];
			end
			if(args["arg5"] ~= nil) then
				dbTableName = args["arg5"];
			end
			if(args["arg6"] ~= nil) then
				dbUser = args["arg6"];
			end
			if(args["arg7"] ~= nil) then
				dbPassword = args["arg7"];
			end
		end
	end
	
	--Run a progression test on this player
	TestEquipment(newFileName, useStdOut, writeToDb, dbHost, dbName, dbUser, dbPassword, dbTableName);
end

function TestEquipment(newFileName, useStdOut, writeToDb, dbHost, dbName, dbUser, dbPassword, dbTableName)
	--Declare a flag variable that will say whether or not any of the tests failed.
	TestFailed = false;

	--If the user passed in a new file name, then use it instead of the default file name
	if(newFileName ~= nil) then
		LogFileName = newFileName;
	end

	--Set the flags for whether or not to write to std out or a Database
	UseStdOut = useStdOut;
	WriteToDb = writeToDb;
	DbTableName = dbTableName;

	--If we are going to write to a database, then initiate the connection
	if(WriteToDb == true) then
		ConnectToDb(dbHost, dbName, dbUser, dbPassword);

		--Create the table.  If the table already exists, we will just append the new data
		local query = "CREATE TABLE `"..dbName.."`.`"..DbTableName.."`(";
		query = query.."`id` int(10) unsigned NOT NULL auto_increment,";
		query = query.."`Result` varchar(45) NOT NULL,";
		query = query.."`Test_Name` varchar(45) NOT NULL,";
		query = query.."`Template_Id` varchar(45) NOT NULL,";
		query = query.."`Item_File_Name` varchar(45) NOT NULL,";
		query = query.."`Expected_Results` varchar(512) NOT NULL,";
		query = query.."`TimeStamp` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,";
		query = query.."PRIMARY KEY  (`id`));";
		CreateTable(DbTableName, query);
	end

	Log("Starting Equipment Test");
		
	--Go through the player's inventory and trash everything.  That way we start with a fresh inventory.
	ClearPlayerInventory();
	Sleep(1);
	
	--Initialize Global variables that will be used in the Timer Handler
	CalledServer = false;
	WaitingOnServer = false;
	TierLvl = 1;
	MaxTierLvl = 3;
	TierFolder = "";
	EquipType = {"Athames", "Hats", "Rings", "Robes", "Shoes"};
	MaxEquipIndex = table.getn(EquipType);
	Files = {};
	EndTime = GetTime();
	CurrentState = 1;
	SchoolCnt = 1;
	EquipmentTestStateTable = {	"GettingTierFolder",
								"GettingEquipmentFileList",
								"GettingItemEffects",
								"WaitingForInventoryAdd",
								"SettingCorrectPrimarySchool",
								"SettingToJustUnderCorrectLevel",
								"WaitingForRequiredLevelEquip",
								"TestRequiredLevel",
								"SetUpFocusRequirementTest",
								"StartFocusRequirementTest",
								"WaitForFocusEquip",
								"TestFocusRequirement",
								"WaitingForEquip",
								"TestEquipEffects",
								"WaitingForUnequip",
								"TestingUnequip"};
	if(GetRunMode() == "Release") then
		GameDataDir = "../Data/GameData/";
		LogFileName = "../Data/GameData/Scripts/AutomatedEquipmentTestResults.log";
		TempFileName = "../Data/GameData/Scripts/TmpFileListing.txt";
	else
		GameDataDir = "../../Data/GameData/";
		LogFileName = "../../Data/GameData/Scripts/AutomatedEquipmentTestResults.log";
		TempFileName = "../../Data/GameData/Scripts/TmpFileListing.txt";
	end
	ObjectDataDir = GameDataDir.."ObjectData/";

	--Open a log file to store the results of all of the tests we run.
	LogFile = io.open(LogFileName, "w+");
	if(LogFile == nil) then
		Log("Could not open Log File:  "..LogFileName);
		return;
	end
	LogFile:write(os.date().."\n");
	LogFile:write("TEST_RESULT\tTEST_NAME\tTEMPLATE_ID\tITEM_FILE_NAME\tEXPECTED_RESULTS\n");
	LogFile:flush();

	--Set up a timer to trigger 4 times per second
	RegisterEventCallback("TestTimer", OnTimer);
	StartTimer("TestTimer", 0.25, false);	--Have the timer trigger every 1/4 second

	--Add the event that will respond when an item is equipped.
	RegisterEventCallback("ItemEquipped", OnItemEquipped);
	
	--Add the event that will respond when an item is un-equipped
	RegisterEventCallback("ItemUnequipped", OnItemUnequipped);
	
	--Add the event that will respond when an item is added to inventory
	RegisterEventCallback("OnItemAddedToInventory", OnItemAddedToInventory);
	
	--Add the event that will respond when the player's level changes
	RegisterEventCallback("CharacterChangedLevel", OnServerCmdExecuted);
	
	--Add the event that will respond when the player's school of focus changes
	RegisterEventCallback("SchoolFocusChanged", OnServerCmdExecuted);
	
	-- using this to make sure timer calls are smooth in case we get timer pulses in a not so exact time
	Timer = GetTime() + 1;

	StillTestingEquipment = true;
	while( StillTestingEquipment == true ) do 
		-- GetEvent called with no parameters = get any event and no timeout
		local event = GetEvent();
		if( event ) then
			-- since all of our registered events have a callback, 
			-- we will not have to handle event parsing within our main()
			if ( event.LUA_CallBack ) then
				event.LUA_CallBack( event );
			end
		end
	end

	--Close the log file
	LogFile:close();

	--We're done testing, so disconnect from the database if we are alredy connected
	if(WriteToDb == true) then
		DisconnectFromDb();
	end

	Log("Done Testing Equipment");
	
	--Send an event to notify any other scripts that care that this script is done running
	local doneEventArgs = {["ScriptName"] = "TestEquipment.lua"};
	if(TestFailed) then
		doneEventArgs["ExitCode"] = 1;
	else
		doneEventArgs["ExitCode"] = 0;
	end
	SendEvent("DoneRunningScript", doneEventArgs);
end

function OnTimer()
	if(GetTime() > Timer) then
		Timer = GetTime() + 1;
		
		if(EquipmentTestStateTable[CurrentState] == "GettingTierFolder") then
			if(TierLvl > MaxTierLvl) then
				StillTestingEquipment = false;
				return;
			end
		
			--Determine the name of the tier folder that we will search for all equipment types that
			--affect buffs
			TierFolder = string.format("%sTier%d/", ObjectDataDir, TierLvl);
			
			--Start with the first equipment type in this new tier
			EquipIndex = 1;
			ChangeState();
		end
		
		if(EquipmentTestStateTable[CurrentState] == "GettingEquipmentFileList") then
			if(EquipIndex > MaxEquipIndex) then
				SetState("GettingTierFolder");
				return;
			end
			
			--Get all of the xml Files for this type of equipment
			Files = GetXmlFileList(TierFolder..EquipType[EquipIndex].."/", TempFileName);
			if(Files == nil) then
				--We couldn't get the file list, so we can't really do anything else
				return;
			end
			FileIndex = 1;
			MaxFileIndex = table.getn(Files);
			ChangeState();
		end
		
		if(EquipmentTestStateTable[CurrentState] == "GettingItemEffects") then
			if(FileIndex > MaxFileIndex) then
				--We have gone through all of the equipment files for this equipment type
				SetState("GettingEquipmentFileList");
				return;
			end
		
			--Get the item information
			ItemName, ItemTemplateId, ItemReqLvl, ItemEffects, ItemSchoolFocus = GetItemEffects(Files[FileIndex]);
			
			--Add this item to the player's inventory
			if(Server("AddInventory", ItemTemplateId) == 0) then
				--This item could not be added to inventory, so go on to the next item in inventory
				FileIndex = FileIndex + 1;
				return;
			end
			EndTime = GetTime() + SECONDS_BEFORE_EQUIP_TIMEOUT * 1000;
			ChangeState();
		end
		
		if(EquipmentTestStateTable[CurrentState] == "WaitingForInventoryAdd") then
			--The only way we should progress to the next states is if this item was added to inventory.
			if(EndTime <= GetTime()) then
				--The item could not be added to inventory
				SetState("GettingItemEffects");
				return;
			else
				--Still waiting
				return;
			end
		end
		
		if(EquipmentTestStateTable[CurrentState] == "SettingCorrectPrimarySchool") then
			--If there is a required school focus, then set the player's primary school to it
			if(CalledServer == false) then
				OrigMaxHp, OrigMaxMana, OrigPwrPips, OrigAcc, OrigDmgFlat, OrigDmgPercent, OrigDmgReduce, OrigLvl, OrigFocus = GetCurrentStats();
				if(ItemSchoolFocus ~= nil) then
					if(OrigFocus <= table.getn(SchoolNames) and ItemSchoolFocus ~= SchoolNames[OrigFocus]) then
						Server("SetPrimarySchool", ItemSchoolFocus);
						WaitingOnServer = true;
						CalledServer = true;
					end
				end
			end

			if(WaitingOnServer == true) then
				return;
			end
			CalledServer = false;
			
			ChangeState();
		end
			
		if(EquipmentTestStateTable[CurrentState] == "SettingToJustUnderCorrectLevel") then
			if(CalledServer == false) then
				--Get the equipment slot that we're going to equip this item into
				if(EquipType[EquipIndex] == "Shoes") then
					--All of the inventory tabs have the same name as the equipment type minus the "S",
					--except Shoes, which includes the "S"
					EquipmentSlot = EquipType[EquipIndex];
				else
					EquipmentSlot = string.sub(EquipType[EquipIndex], 1, -2);
				end
				
				--Set the level to one less than is required to equip this item (if there is a
				--requirement).  This will let us verify that the correct player level is required to
				--equip an item
				if(tonumber(ItemReqLvl) > 1) then
					if(OrigLvl ~= tonumber(ItemReqLvl) - 1) then
						--Only need to set the level if our character is not already at the desired level
						Server("SetLevel", tonumber(ItemReqLvl) - 1);
						WaitingOnServer = true;
						CalledServer = true;
					end
				end
			end
			
			if(WaitingOnServer == true) then
				return;
			end
			CalledServer = false;
				
			if(tonumber(ItemReqLvl) > 1) then
				if(OrigLvl ~= tonumber(ItemReqLvl) - 1) then
					--Only need to get the stats again if the level wasn't correct in the first place
					OrigMaxHp, OrigMaxMana, OrigPwrPips, OrigAcc, OrigDmgFlat, OrigDmgPercent, OrigDmgReduce = GetCurrentStats();
				end
				EquipItem(ItemTemplateId, EquipmentSlot);
				EndTime = GetTime() + SECONDS_BEFORE_EQUIP_TIMEOUT * 1000;
			end
			
			ChangeState();
		end
		
		if(EquipmentTestStateTable[CurrentState] == "WaitingForRequiredLevelEquip") then
			if(tonumber(ItemReqLvl) <= 1) then
				ChangeState();
			elseif(EndTime <= GetTime()) then
				--This item is not going to be equipped
				ChangeState();
			else
				--Still waiting
				return;
			end
		end
		
		if(EquipmentTestStateTable[CurrentState] == "TestRequiredLevel") then
			if(CalledServer == false) then
				if(tonumber(ItemReqLvl) > 1) then
					--Verify that the correct player level is required to equip an item
					if(CheckStatsEqual(OrigMaxHp, OrigMaxMana, OrigPwrPips, OrigAcc, OrigDmgFlat, OrigDmgPercent, OrigDmgReduce) == true) then
						--We could not equip the item with a player level one below what is required
						OutputResults("PASS", "EquipLevel", "Level "..ItemReqLvl.."+ Required to Equip");
					else
						--Set the flag signifying that a test failed.
						TestFailed = true;
							
						--We were able to equip the item when the player did not have the
						--pre-requisite level.
						OutputResults("FAIL", "EquipLevel", "Level "..ItemReqLvl.."+ Required to Equip");
					end
					
					--Ensure that the player is set to the correct level so we can equip this item
					Server("SetLevel", tonumber(ItemReqLvl));
					WaitingOnServer = true;
					CalledServer = true;
				end
			end
			if(WaitingOnServer == true) then
				return;
			end
			CalledServer = false;
			
			ChangeState();
		end
		
		if(EquipmentTestStateTable[CurrentState] == "SetUpFocusRequirementTest") then
			--Set up the variables for the next state
			if(ItemSchoolFocus ~= nil) then
				SchoolCnt = 1;
				PassSchoolFocusTest = true;
			end
			
			ChangeState();
		end
		
		if(EquipmentTestStateTable[CurrentState] == "StartFocusRequirementTest") then
			if(SchoolCnt > table.getn(SchoolNames)) then
				SetState("TestFocusRequirement");
			else
				if(CalledServer == false) then
					if(ItemSchoolFocus ~= nil) then
						if(SchoolNames[SchoolCnt] ~= ItemSchoolFocus) then
							Server("SetPrimarySchool", SchoolNames[SchoolCnt]);
							WaitingOnServer = true;
							CalledServer = true;
						end
					end
				end
				if(WaitingOnServer == true) then
					return;
				end
				CalledServer = false;
				
				if(ItemSchoolFocus ~= nil) then
					if(SchoolNames[SchoolCnt] ~= ItemSchoolFocus) then
						OrigMaxHp, OrigMaxMana, OrigPwrPips, OrigAcc, OrigDmgFlat, OrigDmgPercent, OrigDmgReduce = GetCurrentStats();
						EquipItem(ItemTemplateId, EquipmentSlot);
						EndTime = GetTime() + SECONDS_BEFORE_EQUIP_TIMEOUT * 1000;
					else
						--We want to test that we cannot equip this item for every school other than
						--the required one, so go on to the next school.
						SchoolCnt = SchoolCnt + 1;
						return;
					end
				end
				
				ChangeState();
			end
		end
		
		if(EquipmentTestStateTable[CurrentState] == "WaitForFocusEquip") then
			if(ItemSchoolFocus == nil) then
				ChangeState();
			elseif(EndTime <= GetTime()) then
				--This item is not going to be equipped
				ChangeState();
			else
				--Still waiting
				return;
			end
		end
		
		if(EquipmentTestStateTable[CurrentState] == "TestFocusRequirement") then
			if(CalledServer == false) then
				if(ItemSchoolFocus ~= nil) then
					--Make sure not to index past the SchoolNames table
					if(SchoolCnt <= table.getn(SchoolNames)) then
						--If this is the school of focus or we could not equip this item, then go on to the next school
						if(SchoolNames[SchoolCnt] ~= ItemSchoolFocus) then
							if(CheckStatsEqual(OrigMaxHp, OrigMaxMana, OrigPwrPips, OrigAcc, OrigDmgFlat, OrigDmgPercent, OrigDmgReduce) == true) then
								--We couldn't equip this item
								SetState("StartFocusRequirementTest");
								return;
							else
								PassSchoolFocusTest = false;
							end
						end
					end
					
					--We only get here when we are done going through the schools or we have found a
					--school that we could equip the item with that was not the focus school
					if(PassSchoolFocusTest == true) then
						OutputResults("PASS", "EquipPrimarySchool", "Required Focus of "..ItemSchoolFocus.." to Equip");
					else
						--Set the flag signifying that a test failed.
						TestFailed = true;
							
						OutputResults("FAIL", "EquipPrimarySchool", "Required Focus of "..ItemSchoolFocus.." to Equip");
					end
					
					--Set the primary school to the correct school of focus
					Server("SetPrimarySchool", ItemSchoolFocus);
					WaitingOnServer = true;
					CalledServer = true;
				end
			end
			
			if(WaitingOnServer == true) then
				return;
			end
			CalledServer = false;

			--Get the player stats before equipping any items.
			OrigMaxHp, OrigMaxMana, OrigPwrPips, OrigAcc, OrigDmgFlat, OrigDmgPercent, OrigDmgReduce = GetCurrentStats();

			--Equip this item
			EquipItem(ItemTemplateId, EquipmentSlot);
			EndTime = GetTime() + SECONDS_BEFORE_EQUIP_TIMEOUT * 1000;

			ChangeState();
		end
		
		if(EquipmentTestStateTable[CurrentState] == "WaitingForEquip") then
			if(EndTime <= GetTime()) then
				--This item is not going to be equipped
				ChangeState();
			else
				--Still waiting
				return;
			end
		end
		
		if(EquipmentTestStateTable[CurrentState] == "TestEquipEffects") then
			--Verify that the correct buffs are applied to the player when this item is equipped.
			for effectCnt = 1, table.getn(ItemEffects) do
				local valueAsNumber = tonumber(ItemEffects[effectCnt].Value);
				local expectedValueStr;
				if(valueAsNumber < 1) then
					--The value for this effect is a percentage, but it is only stored in decimal form, so
					--we need to convert it to a percentage.
					expectedValueStr = string.format("%+d%%", valueAsNumber * 100);
				else
					--The value is a whole number, so we can deal with it as is; no conversion.
					expectedValueStr = string.format("%+d", valueAsNumber);
				end
				if(VerifyCorrectBuff(OrigMaxHp, OrigMaxMana, OrigPwrPips, OrigAcc, OrigDmgFlat, OrigDmgPercent, OrigDmgReduce, ItemEffects[effectCnt]) == false) then
					--Set the flag signifying that a test failed.
					TestFailed = true;
							
					OutputResults("FAIL", "EquipBuff", expectedValueStr.." "..ItemEffects[effectCnt].Name);
				else
					OutputResults("PASS", "EquipBuff", expectedValueStr.." "..ItemEffects[effectCnt].Name);
				end
			end

			--Remove this item from the player's inventory
			UnequipItem(ItemTemplateId);
			EndTime = GetTime() + SECONDS_BEFORE_EQUIP_TIMEOUT * 1000;
			
			ChangeState();
		end

		if(EquipmentTestStateTable[CurrentState] == "WaitingForUnequip") then
			if(EndTime <= GetTime()) then
				--This item is not going to be equipped
				ChangeState();
			else
				--Still waiting
				return;
			end
		end

		if(EquipmentTestStateTable[CurrentState] == "TestingUnequip") then
			--When you delete an item from inventory, you also un-equip it.  So, check to see if
			--the buffs for this item have been removed.
			for effectCnt = 1, table.getn(ItemEffects) do
				--Record the expected value in a string before we go changing it.
				local valueAsNumber = tonumber(ItemEffects[effectCnt].Value);
				local expectedValueStr;
				if(valueAsNumber < 1) then
					--The value for this effect is a percentage, but it is only stored in decimal form, so
					--we need to convert it to a percentage.
					expectedValueStr = string.format("%+d%%", valueAsNumber * 100);
				else
					--The value is a whole number, so we can deal with it as is; no conversion.
					expectedValueStr = string.format("%+d", valueAsNumber);
				end

				--For each effect, set it's value to zero, so we can make sure that it's effect has been removed.
				ItemEffects[effectCnt].Value = 0;
				if(VerifyCorrectBuff(OrigMaxHp, OrigMaxMana, OrigPwrPips, OrigAcc, OrigDmgFlat, OrigDmgPercent, OrigDmgReduce, ItemEffects[effectCnt]) == false) then
					--Set the flag signifying that a test failed.
					TestFailed = true;
							
					OutputResults("FAIL", "UnEquipBuff", "Removed "..expectedValueStr.." "..ItemEffects[effectCnt].Name);
				else
					OutputResults("PASS", "UnEquipBuff", "Removed "..expectedValueStr.." "..ItemEffects[effectCnt].Name);
				end
			end
			
			ClearPlayerInventory();
			SetState("GettingItemEffects");
		end
		
	end
end

function ChangeState()
	if(CurrentState == table.getn(EquipmentTestStateTable)) then
		SetState("GettingTierFolder");
	else
		CurrentState = CurrentState + 1;
	end
end

--Set the current state to the correct number based on the name of the state passed in
function SetState(stateName)
	--Increment counters based on which state we're moving to
	if( stateName == "GettingTierFolder") then
		TierLvl = TierLvl + 1;
	elseif(stateName == "GettingEquipmentFileList") then
		EquipIndex = EquipIndex + 1;
	elseif(stateName == "GettingItemEffects") then
		FileIndex = FileIndex + 1;
	elseif(stateName == "StartFocusRequirementTest") then
		SchoolCnt = SchoolCnt + 1;
	end
	
	for i = 1, table.getn(EquipmentTestStateTable) do
		if(EquipmentTestStateTable[i] == stateName) then
			CurrentState = i;
			return;
		end
	end
end

function OnItemEquipped(event)
	ChangeState();
end

function OnItemUnequipped(event)
	ChangeState();
end

function OnItemAddedToInventory(event)
	if(EquipmentTestStateTable[CurrentState] == "WaitingForInventoryAdd") then
		ChangeState();
	end
end

function OnServerCmdExecuted(event)
	WaitingOnServer = false;
end

function GetItemEffects(itemFileName)
	--Get the object name.  This will be used strictly for the log Files.
	local objectName = GetXmlValueFromFile(itemFileName, "m_objectName");
	if(objectName == nil) then
		--If we couldn't find the object name, then we should just stop looking through the file.
		--Cuz, even if we can get the rest of the data, we couldn't OutputResults it to the log in any way that would be readable.
		return nil;
	end
	
	--Get the template ID
	local templateId = GetXmlValueFromFile(itemFileName, "m_templateID");
	
	--Get the level required to equip this item
	local containedTxt, endTag, startTag = GetXmlValueFromFile(itemFileName, "Class", 1, -1, 'Name="class ReqMagicLevel"');
	local reqLvl;
	if(containedTxt ~= nil) then
		reqLvl = GetXmlValueFromFile(itemFileName, "m_numericValue", startTag, endTag);
	end
	if(reqLvl == nil) then
		--There was no required level, so set it equal to 0
		reqLvl = "0";
	end
	
	--Get the effect names
	local effectTable = {};
	local lookupTable = {};
	local effectName;
	local lookupIndex;
	local filePos = 1;
	while(true) do
		effectName, filePos = GetXmlValueFromFile(itemFileName, "m_effectName", filePos);
		lookupIndex, filePos = GetXmlValueFromFile(itemFileName, "m_lookupIndex", filePos);
		if(effectName == nil or lookupIndex == nil) then
			break;
		else
			table.insert(effectTable, effectName);
			table.insert(lookupTable, lookupIndex);
		end
	end
	
	--Get the required school of focus
	local schoolFocus = GetXmlValueFromFile(itemFileName, "m_requiredSchoolOfFocus");
	
	--Go through each effect
	local effectValueTable = {};
	for effectIndex = 1, table.getn(effectTable) do
		--Open the CanonicalStatEffects.xml file.  This file only serves to point us to the correct
		--stats table.
		local canonicalFileName = GameDataDir.."GameEffectData/CanonicalStatEffects.xml";
		
		--Find the section of the canonical effects file that corresponds to this effect
		local xmlValue;
		filePos = 1;
		repeat
		do
			--Go to the next effect section.
			xmlValue, filePos = GetXmlValueFromFile(canonicalFileName, "m_effectName", filePos);
		end
		until( xmlValue == effectTable[effectIndex] or xmlValue == nil)
		
		--Now, get the name of the table that we need to open
		local statsTableName;
		statsTableName, filePos = GetXmlValueFromFile(canonicalFileName, "m_statTableName", filePos);
		local statsTableFileName = GameDataDir.."GameEffectRuleData/"..statsTableName..".xml";
		
		--Open the stats table for this effect.
		local statsTableFile = io.open(statsTableFileName);
		
		--Go through the file 'til we find the stats vector
		for line in statsTableFile:lines() do
			local skip, statKeyBegin = string.find(line, "m_statVector key=\"");
			if(skip ~= nil) then
				statKeyBegin = statKeyBegin + 1;
				local statKeyEnd = string.find(line, "\"", statKeyBegin);
				if(statKeyEnd ~= nil) then
					--We know the start and end position of the key in this line, so get it
					statKeyEnd = statKeyEnd - 1;
					local statKey = string.sub(line, statKeyBegin, statKeyEnd);
					if(statKey == lookupTable[effectIndex]) then
						--If this is the correct lookup index, then get the value
						local statValueBegin = string.find(line, ">", statKeyEnd);
						if(statValueBegin ~= nil) then
							statValueBegin = statValueBegin + 1;
							local statValueEnd = string.find(line, "<", statValueBegin);
							if(statValueEnd ~= nil) then
								--At this point we have found the correct value for the effect, so store it and go on to the next effect
								statValueEnd = statValueEnd - 1;
								local effect = {};
								effect.Name = effectTable[effectIndex];
								effect.Value = string.sub(line, statValueBegin, statValueEnd);
								table.insert(effectValueTable, effect);
								
								--Go on to the next effect
								break;
							end
						end
					end
				end
			end
		end
	end
	
	--We have ammassed the effects for this item, so return them
	return objectName, templateId, reqLvl, effectValueTable, schoolFocus;
end

function VerifyCorrectEffectInfo(effect, displayedInfo)
	--Separate the different parts of this effect
	local effectSchool, effectType, effectModifier = ParseEffectName(effect.Name);
	if(effectType == "Healing") then
		--We change the effect typ from healing to heal, because that's how the display text stores
		--it.
		effectType = "Heal";
	end
	
	--See if we can find this effect in the displayed text
	local foundSchool = false;
	local foundType = false;
	local foundModifier = false;
	local foundValue = false;
	local nextEffect = 1;
	while(true)
	do
		--Find the beginning of the displayed effect text
		local skip, startEffect = string.find(displayedInfo, "<center>", nextEffect);
		if(skip == nil) then
			--We don't know how to parse this effect string, so stop trying.
			break;
		end
		startEffect = startEffect + 1;
		
		--Find the end of the displayed effect text
		local endEffect;
		endEffect, nextEffect = string.find(displayedInfo, "</center>", nextEffect);
		if(endEffect == nil) then
			--We do not know how to parse this string, so stop trying.
			break;
		end
		endEffect = endEffect - 1;
		nextEffect = nextEffect + 1;
		
		--Isolate this effect from the rest of the displayed effects.
		local oneDisplayedEffect = string.sub(displayedInfo, startEffect, endEffect);
		
		--Try to find the effect in the displayed text
		if(effectSchool ~= "All" and effectSchool ~= "Power" and effectSchool ~= "Max") then
			--If there is school information attached to this effect, then make sure it exists in
			--the displayed information
			if(string.find(oneDisplayedEffect, effectSchool) ~= nil) then
				--Found the school within this effect
				foundSchool = true;
			end
		else
			--There is no school information to find, so we can indicate that we have found it.
			foundSchool = true;
		end
		if(string.find(oneDisplayedEffect, effectType) ~= nil) then
			--The correct effect information is present
			foundType = true;
		end
		if(effectModifier == "Reduce") then
			--If this is a resist effect, then make sure the text "Resist" is present in the
			--displayed text.
			if(string.find(oneDisplayedEffect, "Resist") ~= nil) then
				--Found the correct text
				foundModifier = true;
			end
		else
			--There was not special modifier, so we can simply indicate that we have found it
			foundModifier = true;
		end
		local valueAsNumber = tonumber(effect.Value);
		if(valueAsNumber < 1) then
			--The value for this effect is a percentage, but it is only stored in decimal form, so
			--we need to convert it to a percentage.
			if(string.find(oneDisplayedEffect, string.format("%+d%%", valueAsNumber * 100), 1, true) ~= nil) then
				--We found the correct value for this effect in the displayed info
				foundValue = true;
			end
		else
			--The value is a whole number, so we can deal with it as is; no conversion.
			if(string.find(oneDisplayedEffect, string.format("%+d", valueAsNumber)) ~= nil) then
				--We found the correct value for this effect in the displayed info
				foundValue = true;
			end
		end
		
		if(foundSchool == true and foundType == true and foundModifier == true and foundValue == true) then
			--We found all of the correct effect information for this effect in the displayed text,
			--so we can stop searching the displayed text
			break;
		end
	end
	
	if(foundSchool == false or foundType == false or foundModifier == false or foundValue == false) then
		--If we could not find the correct effect information in the displayed text, then indicate 
		--a failure.
		return false;
	end
	
	--Every part of this effect was successfully found within the displayed text
	return true;
end

function ParseEffectName(name)
	--All effect names should have a prefix of "Canonical".  So, remove it.
	local skip, endCanonical = string.find(name, "Canonical");
	if(skip == nil) then
		--If the effect name does not have Canonical in it, then this isn't a name we know how to
		--parse.
		return nil;
	end
	name = string.sub(name, endCanonical+1);
	
	--Get the separate words.  Each new word starts with a capital.
	local strEnd = 1;
	local words = {};
	repeat
	do
		strEnd = string.find(name, "%u", 2);
		if(strEnd ~= nil) then
			strEnd = strEnd - 1;
			
			--Add the word to a list
			table.insert(words, string.sub(name, 1, strEnd));
			
			--Remove the word form the name
			name = string.sub(name, strEnd + 1);
		else
			--We couldn't find any more capital letters, so this must be the last word
			table.insert(words, name);
		end
	end
	until (strEnd == nil);
	
	--If there were 2 words, then we don't want to try and return 3
	if(table.getn(words) == 2) then
		--Only return the first and last words in the name
		return words[1], words[2];
	elseif (table.getn(words) == 3) then
		--Return the first, last, and middle words
		return words[1], words[3], words[2];
	end
	
	--If we get there, then we didn't have even 2 words, so we should not return anything
	return nil;
end

function GetCurrentStats()
	--Get all of the current player stats
	local stats = {GetPlayerStats()};

	--Pull out the stats that interest us right now.
	local curLvl = stats[1];
	local curHp = stats[8];
	local curMana = stats[10];
	local curPwrPips = stats[13];
	local curDmgPercent = {};
	local curDmgFlat = {};
	local curAccuracy = {};
	local curDmgReduce = {};
	local argCnt = 14;
	for schoolIndex = 1, table.getn(SchoolNames) do
		curDmgPercent[schoolIndex] = stats[argCnt];
		argCnt = argCnt + 1;
		curDmgFlat[schoolIndex] = stats[argCnt];
		argCnt = argCnt + 1;
		curAccuracy[schoolIndex] = stats[argCnt];
		argCnt = argCnt + 1;
		curDmgReduce[schoolIndex] = stats[argCnt];
		argCnt = argCnt + 1;
	end
	local curFocus = stats[argCnt];
	
	return curHp, curMana, curPwrPips, curAccuracy, curDmgFlat, curDmgPercent, curDmgReduce, curLvl, curFocus;
end

function CheckStatsEqual(oldHp, oldMana, oldPwrPips, oldAcc, oldDmgFlat, oldDmgPercent, oldDmgReduce)
	local newHp, newMana, newPwrPips, newAcc, newDmgFlat, newDmgPercent, newDmgReduce = GetCurrentStats();
	if(newHp ~= oldHp) then
		return false;
	end
	if(newMana ~= oldMana) then
		return false;
	end
	if(newPwrPips ~= oldPwrPips) then
		return false;
	end
	for schoolIndex = 1, table.getn(SchoolNames) do
		if(newAcc[schoolIndex] ~= oldAcc[schoolIndex]) then
			return false;
		end
		if(newDmgFlat[schoolIndex] ~= oldDmgFlat[schoolIndex]) then
			return false;
		end
		if(newDmgPercent[schoolIndex] ~= oldDmgPercent[schoolIndex]) then
			return false;
		end
		if(newDmgReduce[schoolIndex] ~= oldDmgReduce[schoolIndex]) then
			return false;
		end
	end
	return true;
end

function VerifyCorrectBuff(oldMaxHp, oldMaxMana, oldPwrPips, oldAcc, oldDmgFlat, oldDmgPercent, oldDmgReduce, effect)
	local effectSchool, effectType, effectModifier = ParseEffectName(effect.Name);
	local effectSchoolIndex = GetSchoolIndex(effectSchool);
	local newHp, newMana, newPips, newAcc, newDmgFlat, newDmgPercent, newDmgReduce = GetCurrentStats();
	local value = tonumber(effect.Value);
	if(effectModifier == "Reduce") then
		if(effectSchool == "All") then
			--This is a Damage Reduce effect for all schools
			for schoolIndex = 1, table.getn(SchoolNames) do
				--Check the damage reduction for each school
				if(oldDmgReduce[schoolIndex] + value - newDmgReduce[schoolIndex] > 0.001) then
					--This effect is not correctly reflected in the buffs
					return false;
				end
			end
		else
			--This is a Damage Reduce effect for an individual school
			if(oldDmgReduce[effectSchoolIndex] + value - newDmgReduce[effectSchoolIndex] > 0.001) then
				--This effect is not correctly reflected in the buffs
				return false;
			end
		end
	elseif(effectType == "Damage") then
		if(effectSchool == "All") then
			--This is a damage effect for all schools
			for schoolIndex = 1, table.getn(SchoolNames) do
				--Check the damage for each school
				if(value < 1) then
					--If this is a percentage value, convert it to a whole number for comparison
					--with what is displayed.
					if(oldDmgPercent[schoolIndex] + value - newDmgPercent[schoolIndex] > 0.001) then
						--This effect is not correctly reflected in the buffs
						return false;
					end
				else
					if(oldDmgFlat[schoolIndex] + value ~= newDmgFlat[schoolIndex]) then
						--This effect is not correctly reflected in the buffs
						return false;
					end
				end
			end
		else
			--This is a damage effect for an individual school
			if(value < 1) then
				--If this is a percentage value, convert it to a whole number for comparison
				--with what is displayed.
				if(oldDmgPercent[effectSchoolIndex] + value - newDmgPercent[effectSchoolIndex] > 0.001) then
					--This effect is not correctly reflected in the buffs
					return false;
				end
			else
				if(oldDmgFlat[effectSchoolIndex] + value ~= newDmgFlat[effectSchoolIndex]) then
					--This effect is not correctly reflected in the buffs
					return false;
				end
			end
		end
	elseif(effectType == "Accuracy") then
		if(effectSchool == "All") then
			--This is an accuracy effect for all schools
			for schoolIndex = 1, table.getn(SchoolNames) do
				--Check the accuracy for each school
				if(oldAcc[schoolIndex] + value - newAcc[schoolIndex] > 0.001) then
					--This effect is not correctly reflected in the buffs
					return false;
				end
			end
		elseif(effectSchool == "Incoming") then
			--We can't check this, so just return true for now
			return true;
		else
			--This is a damage effect for an individual school
			if(oldAcc[effectSchoolIndex] + value - newAcc[effectSchoolIndex] > 0.001) then
				--This effect is not correctly reflected in the buffs
				return false;
			end
		end
	elseif(effectType == "Pip") then
		--This is a Power Pip effect
		if(oldPwrPips + value - newPips > 0.001) then
			--This effect is not correctly reflected in the buffs
			return false;
		end
	elseif(effectType == "Mana") then
		--This is a Max Mana effect
		if(oldMaxMana + value ~= newMana) then
			--This effect is not correctly reflected in the buffs
			return false;
		end
	elseif(effectType == "Health") then
		--This is a Max Health effect
		if(oldMaxHp + value ~= newHp) then
			--This effect is not correctly reflected in the buffs
			return false;
		end
	end
	
	return true;
end

function GetSchoolIndex(name)
	for schoolIndex = 1, table.getn(SchoolNames) do
		if(SchoolNames[schoolIndex] == name) then
			return schoolIndex;
		end
	end
	
	return nil;
end

function OutputResults(resultStr, testName, expectedResultStr)
	local opStr = resultStr.."\t"..testName.."\t"..ItemTemplateId.."\t"..ItemName.."\t"..expectedResultStr.."\n";
	LogFile:write(opStr);
	LogFile:flush();
	
	--Write out to std out, if the user specified to do so
	if(UseStdOut) then
		io.stdout:write(opStr);
		io.stdout:flush();
	end
	
	--Write to a database, if the suer specified to do so
	if(WriteToDb) then
		local recordInfo = {["TableName"] = DbTableName,
							["Result"] = resultStr,
							["Test_Name"] = testName,
							["Template_Id"] = ItemTemplateId,
							["Item_File_Name"] = ItemName,
							["Expected_Results"] = expectedResultStr};
		UpdateRecord(recordInfo);
	end
end
