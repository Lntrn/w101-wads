--This script can take arguments.  No arguments are required.  If an argument is not passed in, the
--default value is used.
--
-- @param[in]	"-L"			Indicates that we want to log the performance metrics.
--
-- @param[in]	"-C <min> [max]"	Sets the range of time in which the chat messages will be
--						refreshed.  The range is inclusive, so [min, max].  If only one value (min)
--						is specified, the range will be fixed with no range; the chat message will
--						always be refreshed in <min> miliseconds.  Defaults to [5000, 240000].
--
-- @param[in]	"-E <min> [max]"	Determines the range of time for equipment changes:  [min, max].
--						Same explanation as for chat (-C).  Defaults to [1000, 20000].
--
-- @param[in]	"-T <frequency>"	The frequency (in seconds) at which to query and record the zone
--						server tick count.  Defaults to 10.
-- @param[in]	"-F <frequency>"	The frequency (in seconds) at which to query and record the FPS.
--						Defaults to 10.
-- @param[in]	"-S <frequency>"	The frequency (in seconds) at which to query and record the Zone
--						Server's system statistics, including % CPU and memory usage.
--						Defaults to 10.
--
-- @param[in]	"-N <frequency>"	The frequency (in seconds) at which to query and record the
--						number of players on the zone server.  Defaults to 75.
--
-- @param[in]	"-P <min> [max]"	The frequency (in seconds) at which players will pause their
--						movements.  Defaults to [5, 60]
--
-- @param[in]	"-D <min> [max]"	The duration for which players will remain paused.
--						Defaults to [5, 60]

Include("API/Utilities.lua");
Include("HelperScripts/GetPath.lua");
-- Include("HelperScripts/GetTeleportData.lua");
Include("HelperScripts/GetArguments.lua");
Include("HelperScripts/GetDictionary.lua");
Include("HelperScripts/GetXmlFileList.lua");
Include("HelperScripts/GetXmlValueFromFile.lua");
Include("HelperScripts/EquipLevelOneSpells.lua");
Include("HelperScripts/PushButton.lua");


--This variable regulates how much time we wait for an action to be completed before we assume that
--that action is not going to be completed successfully.  It is in units of miliseconds
TIME_OUT = 5000;		--Wait 5 seconds before timing out.

-- helper function to setup callbacks and register the event
function WaitForEvent(eventName)
	RegisterEvent(eventName);
	GetEvent(eventName);
	UnregisterEvent(eventName);
end

function OnStartingPhase()
	Log("Starting Combat");
	InCombat = true;
end

function OnPlanningPhase(randFlg)
	Log("--- RECEIVED PLANNING PHASE ---");

	if(randFlg == true) then
		local spell = math.random(0, 6);
		local target = math.random(1, 8);
		Server("SelectSpell", string.format("%d", spell), string.format("%d", target));
	else
		for spell = 0, 6 do
			--The calling function has deemed it necessary to try anything and everything,
			--presumably because a random selection did not result in any valid combinations of
			--spell and target.  So, now we try all combos and see what happens.
			for target = 1, 8 do
				--In case there isn't a target in the randomly chosen position, try try again.
				Server("SelectSpell", string.format("%d", spell), string.format("%d", target));
			end
		end
	end
end

function OnVictoryPhase()
	SendVictoryMessage();
	Server("SetHealth","100000");
	Server("SetMana","100000");
end

function OnEndedPhase()
	InCombat = false;
end

function OnCombatPhase(event)
	Log("OnCombatPhase "..event.Phase);
	InPlanningPhase = false;
	if(event.Phase == 1) then
		OnStartingPhase();
	end
	if(event.Phase == 2) then
		NumSpellAttempts = 1;
		OnPlanningPhase();
		InPlanningPhase = true;
	end
	if(event.Phase == 5) then
		OnVictoryPhase();
	end
	if(event.Phase == 6) then
		OnEndedPhase();
	end
end

function TeleportToCorrectZone()
	if(pathTable[pathIndex].zone ~= GetZoneName()) then
		WaitingForTeleport = true;
		Server("Teleport", pathTable[pathIndex].zone);
	end
end

function OnTeleported(event)
	if(pathTable[pathIndex].zone ~= GetZoneName()) then
		--InCombat is not always true when we lose a battle and are teleported back to WC_Hub.  So,
		--we're going to try this.
		--If we are teleported away from the correct zone for whatever reason, then wait a second
		--for the game to process the new zone, then teleport back to the correct one.
		Sleep(1);
		TeleportToCorrectZone();
		InCombat = false;
		Server("SetHealth","100000");
		Server("SetMana","100000");
	else
		--We lost the combat and got teleported back to the hub, so we need to wait for a second to
		--let the game catch up and figure out exactly what zone we're in, then we can try to
		--teleport back to the correct zone and continue along our path.
		-- Sleep(1);
		-- TeleportToCorrectZone();
		-- InCombat = false;
		-- Server("SetHealth","100000");
		-- Server("SetMana","100000");
	-- else
		WaitingForTeleport = false;
	end
	currentZoneName = GetZoneName();
	InPlanningPhase = false;
end

function main()
	--Set up all of the variables to default to nil unless they have a value passed in for them.
	local logState = nil; 
	local chatMin = nil;
	local chatMax = nil;
	local equipMin = nil;
	local equipMax = nil;
	local tickFreq = nil;
	local fpsFreq = nil;
	local sysFreq = nil;
	local numFreq = nil;
	local pauseFreq = nil;
	local pauseDuration = nil;
	--Go through the arguments, see if the user specified anything, and if so, what.
	local args = GetArguments();
	local argCnt = 0;
	while(args["arg"..argCnt] ~= nil) do
		local arg = string.upper(args["arg"..argCnt]);
		if(arg == "-L") then
			--The user specified that they want to Log the system performance.
			logState = true;

		elseif(arg == "-C") then
			--The user specified the chat range option.  See if they passed the corresponding range
			if(args["arg"..(argCnt+1)] == nil or string.sub(args["arg"..(argCnt+1)], 1, 1) == "-") then
				--The user did not specify a range, after the option flag.
				Log("Could not find Chat Frequency range.");
				Log("Usage:  -C [min] [max], where min and max are in miliseconds");
			else
				--The user specified at least the Min value, so see if it's a legit number
				argCnt = argCnt + 1;
				local tmpMin = tonumber(args["arg"..argCnt]);
				if(tmpMin ~= nil) then
					--The Min value is a legit number
					chatMin = tmpMin;
					
					--Also set the Max number to this, cuz if the Max number isn't set, it means
					--there won't be a range, but rather a constant frequency.
					chatMax = tmpMin;
					
					--See if the user also specified a max value
					if(args["arg"..(argCnt+1)] ~= nil and string.sub(args["arg"..(argCnt+1)], 1, 1) ~= "-") then
						--The user specified a Max value, too.  See if it's a valid number
						argCnt = argCnt + 1;
						local tmpMax = tonumber(args["arg"..argCnt]);
						if(tmpMax ~= nil) then
							--The Max value is a legit number
							chatMax = tmpMax;
						else
							Log(args["arg"..argCnt].." is not a valid number.  Chat Frequency ranges must be specified as a number.");
							Log("Using "..chatMax.." instead.");
						end
					end
				else
					Log(args["arg"..argCnt].." is not a valid number.  Chat Frequency ranges must be specified as a number.");
				end
			end
		elseif(arg == "-E") then
			--The user specified the equip frequency range option.  See if they passed the
			--corresponding range.
			if(args["arg"..(argCnt+1)] == nil or string.sub(args["arg"..(argCnt+1)], 1, 1) == "-") then
				--The user did not specify a range, after the option flag.
				Log("Could not find Equip Frequency range.");
				Log("Usage:  -E [min] [max], where min and max are in miliseconds");
			else
				--The user specified at least the min value.  See if it's a valid value.
				argCnt = argCnt + 1;
				local tmpMin = tonumber(args["arg"..argCnt]);
				if(tmpMin ~= nil) then
					--This is a legit value.
					equipMin = tmpMin;
					
					--Also set the Max to this value in case there is no Max value set, in which
					--case we want to default to a fixed value, rather than a range of values.
					equipMax = tmpMin;
					
					--Check to see if the Max value was specified.
					if(args["arg"..(argCnt+1)] ~= nil and string.sub(args["arg"..(argCnt+1)], 1, 1) ~= "-") then
						--The user specified a Max value, too.  See if it's a valid number
						argCnt = argCnt + 1;
						local tmpMax = tonumber(args["arg"..argCnt]);
						if(tmpMax ~= nil) then
							--The value is a valid number
							equipMax = tmpMax;
						else
							Log(args["arg"..argCnt].." is not a valid number.  Chat Frequency ranges must be specified as a number.");
							Log("Using "..equipMax.." instead.");
						end
					end
				else
					Log(args["arg"..argCnt].." is not a valid number.  Chat Frequency ranges must be specified as a number.");
				end
			end
		elseif(arg == "-T") then
			--The user provided the Tick Count frequency option.  Let's check to see if they
			--actually provided a correct argument.
			if(args["arg"..(argCnt+1)] == nil or string.sub(args["arg"..(argCnt+1)], 1, 1) == "-") then
				--The user did not provide an argument to accompany the Tick Count flag.
				Log("Could not find the Tick Count update frequency");
				Log("Usage:  -T [frequency], where frequency is in seconds");
			else
				--The user provided a value for the Tick Count update frequency.  Make sure it's a
				--valid value.
				argCnt = argCnt + 1;
				local tmpFreq = tonumber(args["arg"..argCnt]);
				if(tmpFreq == nil) then
					--The value provided for the frequency is not a number
					Log("The Tick Count update frequency must be a number.  Using default value.");
				else
					tickFreq = tmpFreq * 1000;
				end
			end
		elseif(arg == "-F") then
			--The user provided the FPS update frequency option.  Let's check to see if they
			--actually provided a correct argument.
			if(args["arg"..(argCnt+1)] == nil or string.sub(args["arg"..(argCnt+1)], 1, 1) == "-") then
				--The user did not provide an argumnet to  accompany the FPS flag.
				Log("Could not find the FPS update frequency");
				Log("Usage:  -F [frequency], where frequency is in seconds");
			else
				--The user provided a value for the FPS update frequency.  Make sure it's a valid
				--number.
				argCnt = argCnt + 1;
				local tmpFreq = tonumber(args["arg"..argCnt]);
				if(tmpFreq == nil) then
					--The value provided for the frequency is not a number
					Log("The FPS update frequency must be a number.  Using default value.");
				else
					--The value provided for the frequency is a number
					fpsFreq = tmpFreq * 1000;
				end
			end
		elseif(arg == "-S") then
			--The user provided the System Stats update frequency option.  Let's check to see if
			--they actually provided a correct argument.
			if(args["arg"..(argCnt+1)] == nil or string.sub(args["arg"..(argCnt+1)], 1, 1) == "-") then
				--The user did not provide an argumnet to accompany the System Stats update
				--flag.
				Log("Could not find the System Stats update frequency");
				Log("Usage:  -S [frequency], where frequency is in seconds");
			else
				--The user provided a value for the System Stats update frequency.  Make sure it's
				--a valid number.
				argCnt = argCnt + 1;
				local tmpFreq = tonumber(args["arg"..argCnt]);
				if(tmpFreq == nil) then
					--The value provided for the frequency is not a number
					Log("The System Stats update frequency must be a number.  Using default value.");
				else
					--The value provided for the frequency is a number
					sysFreq = tmpFreq * 1000;
				end
			end
		elseif(arg == "-N") then
			--The user provided the option to query the number of players on the server.  Let's
			--check to see if they actually provided the frequency at which to query for this.
			if(args["arg"..(argCnt+1)] == nil or string.sub(args["arg"..(argCnt+1)], 1, 1) == "-") then
				--The user did not provide the frequency at which we should queyr for this number
				Log("Could not find the frequency at which to query for the Number of Users on the server");
				Log("Usage:  -N [frequency], where frequency is in seconds");
			else
				--The user provided a value for the System Stats update frequency.  Make sure it's
				--a valid number.
				argCnt = argCnt + 1;
				local tmpFreq = tonumber(args["arg"..argCnt]);
				if(tmpFreq == nil) then
					--The value provided for the frequency is not a number
					Log("The frequency at which we query for the number of users on the zone server must be a number.  Using default value.");
				else
					--The value provided for the frequency is a number
					numFreq = numFreq * 1000;
				end
			end
		elseif(arg == "-P") then
			--The user specified the range of frequencies at which they wanted to have their
			--character pause movement.  Let's check to see if they actually provided the frequency
			--at which to query for this.
			if(args["arg"..(argCnt+1)] == nil or string.sub(args["arg"..(argCnt+1)], 1, 1) == "-") then
				--The user did not provide the frequency at which we should pause the player's movement
				Log("Could not find the frequency at which to pause your character's movement.");
				Log("Usage:  -P [min] [max], where where min and max are in seconds");
			else
				--The user provided a value for the movement pause frequency.  Make sure it's a
				--valid number.
				argCnt = argCnt + 1;
				local tmpMin = tonumber(args["arg"..argCnt]);
				if(tmpMin ~= nil) then
					--This is a legit value.
					pauseFreq.min = tmpMin * 1000;
					
					--Also set the Max to this value in case there is no Max value set, in which
					--case we want to default to a fixed value, rather than a range of values.
					pauseFreq.max = pauseFreq.min;
					
					--Check to see if the Max value was specified.
					if(args["arg"..(argCnt+1)] ~= nil and string.sub(args["arg"..(argCnt+1)], 1, 1) ~= "-") then
						--The user specified a Max value, too.  See if it's a valid number
						argCnt = argCnt + 1;
						local tmpMax = tonumber(args["arg"..argCnt]);
						if(tmpMax ~= nil) then
							--The value is a valid number
							pauseFreq.max = tmpMax * 1000;
						else
							Log(args["arg"..argCnt].." is not a valid number.  Movement Pause Frequency ranges must be specified as a number.");
							Log("Using "..pauseFreq.max.." instead.");
						end
					end
				else
					Log(args["arg"..argCnt].." is not a valid number.  Movement Pause Frequency ranges must be specified as a number.");
				end
			end
		elseif(arg == "-D") then
			--The user specified the range of durations for which they wanted to have their
			--character pause movement.  Let's check to see if they actually provided the duration.
			if(args["arg"..(argCnt+1)] == nil or string.sub(args["arg"..(argCnt+1)], 1, 1) == "-") then
				--The user did not provide the duration for which we want to pause the character's
				--movement.
				Log("Could not find the duration to pause your character's movement for.");
				Log("Usage:  -D [min] [max], where where min and max are in seconds");
			else
				--The user provided a value for the movement pause duration.  Make sure it's a
				--valid number.
				argCnt = argCnt + 1;
				local tmpMin = tonumber(args["arg"..argCnt]);
				if(tmpMin ~= nil) then
					--This is a legit value.
					pauseDuration.min = tmpMin * 1000;
					
					--Also set the Max to this value in case there is no Max value set, in which
					--case we want to default to a fixed value, rather than a range of values.
					pauseDuration.max = pauseDuration.min;
					
					--Check to see if the Max value was specified.
					if(args["arg"..(argCnt+1)] ~= nil and string.sub(args["arg"..(argCnt+1)], 1, 1) ~= "-") then
						--The user specified a Max value, too.  See if it's a valid number
						argCnt = argCnt + 1;
						local tmpMax = tonumber(args["arg"..argCnt]);
						if(tmpMax ~= nil) then
							--The value is a valid number
							pauseDuration.max = tmpMax * 1000;
						else
							Log(args["arg"..argCnt].." is not a valid number.  Movement Pause Duration ranges must be specified as a number.");
							Log("Using "..pauseFreq.max.." instead.");
						end
					end
				else
					Log(args["arg"..argCnt].." is not a valid number.  Movement Pause Duration ranges must be specified as a number.");
				end
			end
		end
		
		argCnt = argCnt + 1;
	end
	
	ZoneLoadTest(logState, chatMin, chatMax, equipMin, equipMax, tickFreq, fpsFreq, sysFreq, numFreq, pauseFreq, pauseDuration);
end

function ZoneLoadTest(logState, chatMin, chatMax, equipMin, equipMax, tickFreq, fpsFreq, sysFreq, numFreq, pauseFreq, pauseDuration)
	--Initialize the character to starting with level 50 fire.  Level 50 makes the player capable
	--of equipping anything.
	Server("SetLevel", 50);
	Server("SetPrimarySchool", "Fire");
	CurSchoolFocus = "Fire"
	
	--Set the flag that determines if we log the performance metrics or not.
	LogMetrics = false;
	if(logState ~= nil) then
		LogMetrics = logState;
	end
	
	--Provide a range of time between chat message updates.
	ChatTimeRange = {["min"] = 5000, ["max"] = 240000};
	ChatWordCntRange = {["min"] = 1, ["max"] = 5};
	if(chatMin ~= nil) then
		ChatTimeRange.min = chatMin;
		if(chatMax ~= nil) then
			ChatTimeRange.max = chatMax;
		else
			ChatTimeRange.max = chatMin;
		end
	end

	--Provide a range of time between Equipment changes
	EquipTimeRange = {["min"] = 1000, ["max"] = 20000};
	if(equipMin ~= nil) then
		EquipTimeRange.min = equipMin;
		if(equipMax ~= nil) then
			EquipTimeRange.max = equipMax;
		else
			EquipTimeRange.max = equipMin;
		end
	end
	
	--Set up the state table that will make sure we add items to inventoyr, equip, unequip, and
	--remove items from inventory at the proper times
	EquipState = 	{
					"AddToInventory",
					"WaitForAddToInventory",
					"SetReqLevel", 
					"WaitForReqLevel", 
					"SetSchoolFocus", 
					"WaitForSchoolFocus", 
					"Equip", 
					"WaitForEquip", 
					"Unequip",
					"WaitForUnequip"
					};
	CurEquipState = 1;
	
	--Set up the variables that will store which items are being added to inventory and which items
	--we already have equipped.
	EquipTypes = {"Athames", "Hats", "Rings", "Robes", "Shoes"};
	CurEquipment = nil;
	NewTemplateId = nil;
	NewEquipSlot = nil;

	--Keep track of the latency times for the various equip events
	StartTime = {["AddToInventory"] = 0, ["Equip"] = 0, ["Unequip"] = 0};
	
	--The number of miliseconds to wait between queries for the Zone Server Tick count
	TickCountInterval = 10000;
	if(tickFreq ~= nil) then
		TickCountInterval = tickFreq;
	end

	--Miliseconds between FPS updates
	FpsInterval = 10000;
	if(fpsFreq ~= nil) then
		FpsInterval = fpsFreq;
	end

	--Miliseconds between Zone Server CPU and Memory usage stats updates
	SysStatsInterval = 10000;
	if(sysFreq ~= nil) then
		SysStatsInterval = sysFreq;
	end
	
	--Miliseconds between queries for the number of players on the server
	NumPlayersInterval = 75000;		--Default to once every 75 seconds because the server search query times out after 60 seconds
	if(numFreq ~= nil) then
		NumPlayersInterval = numFreq;
	end
	
	--Miliseconds between movement pauses
	MovementPauseRange = {["min"] = 5000, ["max"] = 60000};
	if(pauseFreq ~= nil) then
		MovementPauseRange.min = pauseFreq.min;
		MovementPauseRange.max = pauseFreq.max;
	end
	
	--Miliseconds to pause the movement for.
	PauseDurationRange = {["min"] = 5000, ["max"] = 60000};
	if(pauseDuration ~= nil) then
		PauseDurationRange.min = pauseDuration.min;
		PauseDurationRange.max = pauseDuration.max;
	end

	Log("RetracePath Script Starting");
	
	-- seed random and pop a few randoms off (docs say this ensures a "more" random first number...dont ask me	
	math.randomseed(GetTime());
	math.random();
	math.random();
	math.random();
	math.random();
	
	--Initialize the Global varialbes that depend on whether we're running in release or debug mode.
	GameDataDir = "../Data/GameData/";
	
	--Initialize other Global variables
	ObjectDataDir = GameDataDir.."ObjectData/";
	WaitingForAdd = false;
	WaitingForLevel = false;
	WaitingForSchoolFocus = false;
	WaitingForEquip = false;
	WaitingForUnequip = false;
	if(GetOS() == "Linux") then
		Dictionary = GetDictionary();
	end
	LastTickCnt = 0;
	LastTickCntTime = GetTime();
	FirstSysStats = true;
	
	--We will output the stats for each metric on a periodic basis, which is going to be when we
	--query for the number of players in the game.  Once we get a response to our query, we'll
	--output the number of players followed by stats summarizing the metrics we are measuring.
	Metrics = {	["AddToInventory_RTT"] = {},
				["FPS"] = {},
				["CpuUsage"] = {},
				["VirtualMem_KB"] = {},
				["ResidentMem_KB"] = {},
				["ZoneTick_Cnt"] = {},
				["AvgNetwork_RTT"] = {},
				["Equip_RTT"] = {},
				["Unequip_RTT"] = {} };
	
	--Initialize a variable that will store the number of players in each zone.
	NumPlayersPerZone = nil;
	
	--Initialize the log file if the user wants us to
	if(LogMetrics == true) then
		--Open the log file.  If it already exists, then wipe all info.  If it doesn't exist, then create it.
		PerformanceLogName = GameDataDir.."Scripts/ZonePerformanceLog"..os.date("_%Y%m%d_%H%M%S")..".log"
		PerformanceLog = io.open(PerformanceLogName, "w+");
		if(PerformanceLog == nil) then
			Log("Could not open "..ZonePerformanceLogName.." for output");
			return;
		end
		
		--Output a summary of what we are doing at the top of the file.
		PerformanceLog:write(os.date("%c").."\n");
		PerformanceLog:write("Chat Time Range:  ["..ChatTimeRange.min..", "..ChatTimeRange.max.."] ms\n");
		PerformanceLog:write("Equip Time Range:  ["..EquipTimeRange.min..", "..EquipTimeRange.max.."] ms\n");
		PerformanceLog:write("Zone Tick Query Interval:  "..(TickCountInterval/1000).." seconds\n");
		if(GetOS() ~= "Linux") then
			PerformanceLog:write("FPS Query Interval:  "..(FpsInterval/1000).." seconds\n");
		end
		PerformanceLog:write("Zone Server System Stats Query Interval:  "..(SysStatsInterval/1000).." seconds\n");
		PerformanceLog:write("Number of Players Query Interval:  "..(NumPlayersInterval/1000).." seconds\n");
		PerformanceLog:write("Pause Frequency Range:  ["..MovementPauseRange.min..", "..MovementPauseRange.max.."] ms\n");
		PerformanceLog:write("Pause Duration Range:  ["..PauseDurationRange.min..", "..PauseDurationRange.max.."] ms\n");
		PerformanceLog:write("\n");
		
		--Output a header for the results, so we know what each column represents
		PerformanceLog:write("METRIC\tNUM_SAMPLES\tMEDIAN\tAVERAGE\tSTDEV\tMAX\tMIN\tTIME\n");
		PerformanceLog:flush();
	end
	
	--Get a list of all equipment by type and store it so that we can choose from it at random when
	--equipping items.
	--This variable will have the form EquipmentList[Equipment_Type]
	EquipmentList = GetEquipmentList();

	--Get the first item to be equipped
	EquipIndex, NewTemplateId, NewSchoolFocus, NewEquipSlot = GetNextItemInfo();
	
	--Reset all of the semaphores and state variables
	WaitingForTeleport = false;
	Retrace_Done = 0;
	InCombat = false;
	
	--Get the zone name and path that the user recorded last time.
	samplesPerSecond, pathTable = GetPath();
	-- samplesPerSecond, pathTable = GetTeleportData();
	pathIndex = 1;
	
	--Make sure all settings are set to enable combat
	Server("Aggro");
	Server("SetHealth","100000");
	Server("SetMana","100000");
	
	-- setup the MoveTimer event;
	RegisterEventCallback("MoveTimer", OnMoveTimer);
	StartTimer("MoveTimer", (1/samplesPerSecond), false);

	--Add the event that will handle all of the combat sequences
	RegisterEventCallback("CombatPhase",OnCombatPhase);

	--Add the event that will respond when your player is teleported.
	RegisterEventCallback("OnTeleported", OnTeleported);
	
	--Add the event that will respond when an item is equipped.
	RegisterEventCallback("ItemEquipped", OnItemEquipped);
	
	--Add the event that will respond when an item is un-equipped
	RegisterEventCallback("ItemUnequipped", OnItemUnequipped);
	
	--Add the event that will respond when an item is added to inventory
	RegisterEventCallback("OnItemAddedToInventory", OnItemAddedToInventory);
	
	--Add the event that will respond when the player's school of focus has changed.
	RegisterEventCallback("SchoolFocusChanged", OnSchoolFocusChanged);
	
	--Register a callback for the event that will give us updated network stats every now and then
	RegisterEventCallback("NetworkStatsEvent", OnNetworkStatsEvent);
	
	--Register a callback for the event when we get an updated Zone Tick count
	RegisterEventCallback("NewTickCntAvailable", OnNewTickCntAvailable);
	
	--Register a callback for the event that contains updated Zone Server usage stats.
	RegisterEventCallback("NewSysStatsAvailable", OnNewSysStatsAvailable);

	--Register a callback for the event that contains the results for a Player Search
	RegisterEventCallback("NewCsrSearchResults", OnNewCsrSearchResults);
	
	--Register a callback for when the server sends plain text messages.
	RegisterEventCallback("MSG_RawText", OnMsgRawText);
	
	--Search for all users that I can see anywhere.  I will use the results of this query to tell
	--how many players are currently on the zone server.  But we only need to do this if we are
	--logging the metrics.
	if(LogMetrics == true) then
		Server("Search", "UserName", "=", "*");
	end
	
	--Initialize all the timer thresholds
	MoveTimer = GetTime() + 1;
	ChatTimer = GetTime() + math.random(ChatTimeRange["min"], ChatTimeRange["max"]);
	EquipTimer = GetTime() + math.random(EquipTimeRange["min"], EquipTimeRange["max"]);
	TickTimer = GetTime() + TickCountInterval;
	FpsTimer = GetTime() + FpsInterval;
	SysStatsTimer = GetTime() + SysStatsInterval;
	NumPlayersTimer = GetTime() + NumPlayersInterval;
	FailTime = GetTime();
	MovementPauseTimer = GetTime() + math.random(MovementPauseRange.min, MovementPauseRange.max);
	PauseDurationTimer = GetTime();
	
	--Set up the state table for movement.  We only need this so we can add pauses to players' movement
	MoveState = { "MOVING", "PAUSED" };
	CurMoveState = 1;
	
	--Initialize the Tick counter on the Zone Server.
	Server("GetZoneServerTickCnt");
	
	--Initialize the CPU and Memory usage stats on the Zone Server
	Server("GetPerformanceInfo");
	
	--Make sure that all of the equipment is removed from the inventory, except for the spell book.
	ClearPlayerInventory();
	Server("AddInventory", 97486);
	GetEvent("OnItemAddedToInventory");
	EquipItem(97486, "Deck");
	EquipLevelOneSpells();

	-- teleport to the first zone in the recorded path if not there already
	currentZoneName = GetZoneName();
	if(currentZoneName ~= pathTable[pathIndex].zone) then
		TeleportToCorrectZone();
	end;
	
	--Make sure we have the state variables initialized correctly
	InPlanningPhase = false;

	local eventLogFile = io.open(GameDataDir.."Scripts/EventLogFile.txt", "w+");
	
	while( Retrace_Done == 0 ) do 
		-- GetEvent called with no parameters = get any event and no timeout
		event = GetEvent();
		if( event ) then
			if(eventLogFile ~= nil) then
				--write the event name
				eventLogFile:write(event.EventName.."\t"..os.date("%X").."\n");
				eventLogFile:flush();
				
				--write out all other values contained in the event
				for i, v in ipairs(event) do
					if(i ~= "EventName") then
						eventLogFile:write(event.EventName.."-->"..i.."\t"..v.."\t"..os.date("%X").."\n");
						eventLogFile:flush();
					end
				end
			end

			-- since all of our registered events have a callback, 
			-- we will not have to handle event parsing within our main()
			if ( event.LUA_CallBack ) then
				event.LUA_CallBack( event );
			end
		end
	end
	
	ClearPlayerInventory();
	
	Log("Ending RetracePath Script");	
end

function OnMoveTimer()
	--If it is time to query for the number of players on the Zone Server...
	if(LogMetrics == true) then
		if(GetTime() > NumPlayersTimer) then
			Server("Search", "UserName", "=", "*");
			NumPlayersTimer = GetTime() + NumPlayersInterval;
		end
	end
	
	--If the Zone Server Sys Stats interval has elapsed, then get the current Zone Server CPU and
	--memory usage stats
	if(LogMetrics == true) then
		if(GetTime() > SysStatsTimer) then
			Server("GetPerformanceInfo");
			SysStatsTimer = GetTime() + SysStatsInterval;
		end
	end
	
	--If the FPS interval has elapsed, then get the current FPS
	if(LogMetrics == true) then
		if(GetOS() ~= "Linux") then
			if(GetTime() > FpsTimer) then
				table.insert(Metrics["FPS"], GetFPS());
				FpsTimer = GetTime() + FpsInterval;
			end
		end
	end
	
	--If the Tick interval has elapsed, then get the number of tick counts that the zone server has
	--gone through during this interval
	if(LogMetrics == true) then
		if(GetTime() > TickTimer) then
			--Tell the server to send an event with it's updated tick count.  We catch that event and
			--output the results in the OnNewTickCntAvailable function.
			Server("GetZoneServerTickCnt");
			TickTimer = GetTime() + TickCountInterval;
		end
	end
	
	--Update the chat, since you can chat whether you're moving, or in combat, or doing anything else.
	if(GetTime() > ChatTimer) then
		ChatTimer = GetTime() + math.random(ChatTimeRange["min"], ChatTimeRange["max"]);
		
		--Determine what we are going to say.
		Say(ConstructRandomPhrase(math.random(ChatWordCntRange["min"], ChatWordCntRange["max"])));
	end

	--We don't want to be trying to move while we're in the middle of a fight.
	if(IsPlayerParalyzed() > 0) then
		--Make sure the player moves at the end of this, otherwise, we'll invariably end up pausing
		--for some time after each combat, which I don't think is very characteristic of most
		--players' behavior.
		if(MoveState[CurMoveState] ~= "MOVING") then
			ChangeMoveState("MOVING");
		end
		MovementPauseTimer = GetTime() + math.random(MovementPauseRange.min, MovementPauseRange.max);
		
		return;
	end
	
	if(InCombat == true) then
		return;
	end
	
	--Add the item to inventory
	if(WaitingForAdd == false and EquipState[CurEquipState] == "AddToInventory" and GetTime() > EquipTimer) then
		--Add our item to inventory
		StartTime.AddToInventory = GetTime();
		Server("AddInventory", NewTemplateId);
		WaitingForAdd = true;

		--Store the template ID in the correct equipment slot.
		CurEquipment = NewTemplateId;
		
		--Set the fail time out
		FailTime = GetTime() + TIME_OUT;
		
		--Start waiting for the add to take place
		ChangeEquipState();
	end
	
	--Wait for the item to be added to inventory
	if(EquipState[CurEquipState] == "WaitForAddToInventory") then
		if(GetTime() > FailTime) then
			--We failed to add the item to the inventory, so go ahead and try to add another item.
			ChangeEquipState("AddToInventory");
			
			--Get a new item randomly from our equipment list.
			local tmpLvl;
			local tmpFocus;
			EquipIndex, NewTemplateId, tmpLvl, tmpFocus, NewEquipSlot = GetNextItemInfo();
			if(tmpFocus == NewSchoolFocus) then
				--If this is the same school of focus as we already have, then we don't need to change
				--school of focus.
				NewSchoolFocus = nil;
			else
				NewSchoolFocus = tmpFocus;
			end

			WaitingForAdd = false;
		end
	end
	
	--Set the character's required school so they can equip this item
	if(WaitingForSchoolFocus == false and EquipState[CurEquipState] == "SetSchoolFocus" and GetTime() > EquipTimer) then
		if(NewSchoolFocus ~= nil and NewSchoolFocus ~= CurSchoolFocus) then
			--There's a required school focus, so set the character's focus school to it
			Server("SetPrimarySchool", NewSchoolFocus);
			CurSchoolFocus = NewSchoolFocus;
			WaitingForSchoolFocus = true;
			ChangeEquipState();

			--Set the fail time out
			FailTime = GetTime() + TIME_OUT;
		else
			--There is no required school focus, so do nothing and equip the item
			ChangeEquipState("Equip");
		end
	end
	
	--Wait for the character's school of focus to be set
	if(EquipState[CurEquipState] == "WaitForSchoolFocus") then
		if(GetTime() > FailTime) then
			--We failed to set the school of focus.  We won't be able to equip it, so just remove it.
			ChangeEquipState("Unequip");
			WaitingForSchoolFocus = false;
		end
	end

	--Equip the item
	if(WaitingForEquip == false and EquipState[CurEquipState] == "Equip" and GetTime() > EquipTimer) then
		StartTime.Equip = GetTime();
		EquipItem(NewTemplateId, NewEquipSlot);
		WaitingForEquip = true;
		ChangeEquipState();

		--Set the fail time out
		FailTime = GetTime() + TIME_OUT;
	end
	
	--Wait for the character's school of focus to be set
	if(EquipState[CurEquipState] == "WaitForEquip") then
		if(GetTime() > FailTime) then
			--We failed to set the school of focus.  We won't be able to equip it, so just remove it.
			ChangeEquipState();
			WaitingForEquip = false;
		end
	end

	--Unequip the item
	if(WaitingForUnequip == false and EquipState[CurEquipState] == "Unequip" and GetTime() > EquipTimer) then
		--Get a new item randomly from our equipment list.
		EquipIndex, NewTemplateId, NewSchoolFocus, NewEquipSlot = GetNextItemInfo();

		--Remove the item that is currently occupying the equipment slot that the new item needs.
		StartTime.Unequip = GetTime();
		UnequipItem(CurEquipment);
		WaitingForUnequip = true;
		ChangeEquipState();

		--Set the fail time out
		FailTime = GetTime() + TIME_OUT;
	end
	
	--Wait for this item to be equipped
	if(EquipState[CurEquipState] == "WaitForUnequip") then
		if(GetTime() > FailTime) then
			--We failed to unequip the item; remove it from inventory and add a new item
			DeleteItemFromInventory(CurEquipment);
			ChangeEquipState();
			WaitingForUnequip = false;
		end
	end
	
	--See if it's time to pause
	if(MoveState[CurMoveState] == "MOVING" and MovementPauseTimer < GetTime()) then
		ChangeMoveState();
		PauseDurationTimer = GetTime() + math.random(PauseDurationRange.min, PauseDurationRange.max);
	end
	
	--See if we're supposed to be paused
	if(MoveState[CurMoveState] == "PAUSED") then
		if(PauseDurationTimer < GetTime()) then
			ChangeMoveState();
			MovementPauseTimer = GetTime() + math.random(MovementPauseRange.min, MovementPauseRange.max);
		else
			return;
		end
	end

	if(GetTime() > MoveTimer) then
		MoveTimer = GetTime() + 1;
		
		-- if(pathIndex == 1 and WaitingForTeleport == false) then
			---- This is the first time running, so let's make sure we teleport to the correct zone
			-- TeleportToCorrectZone();
		-- end
		
		--We don't want to be trying to move while we're supposed to be teleporting
		if(WaitingForTeleport == true) then
			return;
		end

		if(pathIndex > table.getn(pathTable)) then
			--We have finished retracing the recorded path
			--Retrace_Done = 1;
			--return;
			
			--Instead of finishing after we have run the path, go back to the beginning of the path.
			--This will make it run forever.
			pathIndex = 1;
		end
		
--		this is to catch situations where you have stepped on a teleporter and are in process of teleporting.
		if(pathTable[pathIndex].zone ~= currentZoneName) then
			if(pathTable[pathIndex].zone ~= pathTable[pathIndex - 1].zone) then
			--this would happen if you have hit a teleporter and are in process of teleporting when the script looped through or 
			-- the path file was created by combining two and the path ended somewhere in the middle of a zone.  so we send you to teleport to the new zone
				TeleportToCorrectZone();
			end
			--if you have made it here, there were coordinates recorded in the path that are past the embedded teleporter (i.e. you kept running after hitting the teleport trigger).
			--this can result in being teleported to a new zone but still having recorded coordinates in the previous zone.  so we are going to remove those unnecessary coordinates from the table
			--and continue on our merry way.
			table.remove(pathTable,pathIndex);
			return;
		end

		--Get the next position to move to.
		local pos = pathTable[pathIndex];

		--Move the player to that position
		SetPlayerPosition(pos.x, pos.y, pos.z, pos.yaw);

		pathIndex = pathIndex + 1;
		
	end
end

function ChangeEquipState(state)
	--If the calling function requested a particular state, then change it to that state
	if(state ~= nil) then
		for i = 1, table.getn(EquipState) do
			if(EquipState[i] == state) then
				CurEquipState = i;
				return;
			end
		end
	end
	
	--If the calling function did not request a particular state, then just increment the state
	--counter.
	if(CurEquipState == table.getn(EquipState)) then
		CurEquipState = 1;
	else
		CurEquipState = CurEquipState + 1;
	end
end

function ChangeMoveState(state)
	--If the calling function requested a particular state, then change it to that state
	if(state ~= nil) then
		for i = 1, table.getn(MoveState) do
			if(MoveState[i] == state) then
				CurEquipState = i;
				return;
			end
		end
	end

	--If the calling function did not request a particular state, then just increment the state
	--counter.
	if(CurMoveState == table.getn(MoveState)) then
		CurMoveState = 1;
	else
		CurMoveState = CurMoveState + 1;
	end
end

function OnItemEquipped(event)
	if(EquipState[CurEquipState] == "WaitForEquip") then
		table.insert(Metrics["Equip_RTT"], (GetTime() - StartTime.Equip));
		
		ChangeEquipState();
		WaitingForEquip = false;
		EquipTimer = GetTime() + math.random(EquipTimeRange.min, EquipTimeRange.max);
	end
end

function OnItemUnequipped(event)
	table.insert(Metrics["Unequip_RTT"], (GetTime() - StartTime.Unequip));
	ChangeEquipState();
	WaitingForUnequip = false;
	DeleteItemFromInventory(CurEquipment);
end

function OnItemAddedToInventory(event)
	if(EquipState[CurEquipState] == "WaitForAddToInventory") then
		table.insert(Metrics["AddToInventory_RTT"], (GetTime() - StartTime.AddToInventory));
		
		ChangeEquipState();
		WaitingForAdd = false;
	end
end

function OnSchoolFocusChanged(event)
	if(EquipState[CurEquipState] == "WaitForSchoolFocus") then
		ChangeEquipState();
		WaitingForSchoolFocus = false;
	end
end

--This function will randomly choose words out of the dictionary and put them together to form a
--phrase that is as long as we want it to be.
function ConstructRandomPhrase(numWords)
	local phrase = "";
	if(GetOS() == "Win32") then
		--If we're in windows, then we can get the wide string character phrase from the game.
		phrase = GetRandomPhrase(numWords);
	else
		--If we're in Linux, then the wide string phrase doesn't work correctly, so I need to
		--construct my phrase from my locally stored dictionary
		for i = 1, numWords do
			local wordIndex = math.random(table.getn(Dictionary));
			phrase = phrase..Dictionary[wordIndex];
		end
	end
	return phrase;
end

function OnNetworkStatsEvent(event)
	table.insert(Metrics["AvgNetwork_RTT"], event.AvgRTT);
end

function Output(metric, numSamples, median, avg, stdev, maximum, minimum)
	if(LogMetrics == true) then
		--Always output the Metric and the Number of Samples associated with it
		PerformanceLog:write(metric.."\t"..numSamples);
		
		--Only put out the stats if they are passed in
		PerformanceLog:write("\t");
		if(median ~= nil) then
			PerformanceLog:write(median);
		end
		PerformanceLog:write("\t");
		if(avg ~= nil) then
			PerformanceLog:write(avg);
		end
		PerformanceLog:write("\t");
		if(stdev ~= nil) then
			PerformanceLog:write(stdev);
		end
		PerformanceLog:write("\t");
		if(maximum ~= nil) then
			PerformanceLog:write(maximum);
		end
		PerformanceLog:write("\t");
		if(minimum ~= nil) then
			PerformanceLog:write(minimum);
		end
		PerformanceLog:write("\t"..os.date("%H:%M:%S").."\n");
		PerformanceLog:flush();
	end
end

function OnNewTickCntAvailable(event)
	--Get the total number of ticks since the last time we polled.
	local numTicksThisInterval = event.TickCnt - LastTickCnt;
	
	--Get the amount of time in seconds that has passed since the last time we polled
	local newTime = GetTime();
	local timeInterval = (newTime - LastTickCntTime) / 1000;
	
	--Calculate the number of ticks per second during this last polling interval
	local numTicksPerSecond = numTicksThisInterval / timeInterval;
	if(LastTickCnt ~= 0) then
		--We really only want to output the tick count in every interval.  So, if we haven't
		--already gotten a good Tick Cnt reading, then we won't output it, since it'll just be the
		--number of ticks since the server was started.
		table.insert(Metrics["ZoneTick_Cnt"], numTicksPerSecond);
	end
	LastTickCnt = event.TickCnt;
	LastTickCntTime = newTime;
end

function OnNewSysStatsAvailable(event)
	if(FirstSysStats == false) then
		table.insert(Metrics["CpuUsage"], event.CpuUsage);
		table.insert(Metrics["VirtualMem_KB"], event.VMemUsed);
		table.insert(Metrics["ResidentMem_KB"], event.RMemUsed);
	else
		FirstSysStats = false;
	end
end

function OnNewCsrSearchResults(event)
	if(event.StartEnd == 1) then
		--Sometimes, we don't get the End message, so we'll have some data that we haven't included
		--in our stats.  When that happens, just go ahead and tally the stats before moving on.
		if(NumPlayersPerZone ~= nil) then
			TallyStats();
		end
		
		--We just started the query, so reset all of the numbers
		NumPlayersPerZone = nil;
		NumPlayersPerZone = {};
	elseif(event.StartEnd == 0) then
		--This is actual data containing information about a player, so add it to the table
		
		--See if we have already seen a player from this zone
		for zoneCnt = 1, table.getn(NumPlayersPerZone) do
			if(NumPlayersPerZone[zoneCnt].ZoneName == event.ZoneName) then
				--We already found a player in this zone, so just increment the count
				NumPlayersPerZone[zoneCnt].PlayerCnt = NumPlayersPerZone[zoneCnt].PlayerCnt + 1;
				return;
			end
		end
		
		--We have not already seen a player from this zone, so create an entry in the table for
		--this zone
		local newZone = {};
		newZone.ZoneName = event.ZoneName;
		newZone.PlayerCnt = 1;
		table.insert(NumPlayersPerZone, newZone);
	end

	--Close the search results window.
	local closeBtn = OpenClass(FindNamedWindow("Close"));
	if closeBtn ~= nil then
		PushButton(closeBtn);
		DestroyClass(closeBtn);
	end
end

function OnMsgRawText(event)
	if(InPlanningPhase == true) then
		if(string.find(event.Message, "Your spell selection %d is invalid") ~= nil) then
			if(NumSpellAttempts == 56) then
				--We can try 56 times to get a good random selection.  If we don't get one by then,
				--then we should just try non-randomly to see if there are any valid combinations
				--available.
				NumSpellAttmepts = NumSpellAttempts + 1;
				OnPlanningPhase(false);
			elseif(NumSpellAttempts > 56) then
				--If we have tried more than 56 times, then we have tried every combination available
				--and we are still coming up blank.  So, we need to discard a card and go to the next round.
				local spell = math.random(0,6);
				Server("SelectDiscard", string.format("%d", spell));
				Server("SelectFocus");
			else
				--We are in the planning phase and we just tried to cast a spell that was invalid.  So, try again.
				NumSpellAttempts = NumSpellAttempts + 1;
				OnPlanningPhase(true);
			end
		end
	end
end

function TallyStats()
	--Output the total number of players and break it down by zone name
	local totalPlayers = 0;
	for zoneCnt = 1, table.getn(NumPlayersPerZone) do
		totalPlayers = totalPlayers + NumPlayersPerZone[zoneCnt].PlayerCnt;
		Output("Num Players In "..NumPlayersPerZone[zoneCnt].ZoneName, NumPlayersPerZone[zoneCnt].PlayerCnt);
	end
	Output("Total Players In Game", totalPlayers);
	NumPlayersPerZone = nil;
	
	--Calculate the statistics for each metric and output them
	local median, avg, stdev, maximum, minimum = CalcStats(Metrics.AddToInventory_RTT);
	Output("AddToInventory_RTT", table.getn(Metrics.AddToInventory_RTT), median, avg, stdev, maximum, minimum);
	if(GetOS() ~= "Linux") then
		median, avg, stdev, maximum, minimum = CalcStats(Metrics.FPS);
		Output("FPS", table.getn(Metrics.FPS), median, avg, stdev, maximum, minimum);
	end
	median, avg, stdev, maximum, minimum = CalcStats(Metrics.CpuUsage);
	Output("CpuUsage_%", table.getn(Metrics.CpuUsage), median, avg, stdev, maximum, minimum);
	median, avg, stdev, maximum, minimum = CalcStats(Metrics.VirtualMem_KB);
	Output("VirtualMem_KB", table.getn(Metrics.VirtualMem_KB), median, avg, stdev, maximum, minimum);
	median, avg, stdev, maximum, minimum = CalcStats(Metrics.ResidentMem_KB);
	Output("ResidentMem_KB", table.getn(Metrics.ResidentMem_KB), median, avg, stdev, maximum, minimum);
	median, avg, stdev, maximum, minimum = CalcStats(Metrics.ZoneTick_Cnt);
	Output("ZoneTick_Cnt", table.getn(Metrics.ZoneTick_Cnt), median, avg, stdev, maximum, minimum);
	median, avg, stdev, maximum, minimum = CalcStats(Metrics.AvgNetwork_RTT);
	Output("AvgNetwork_RTT", table.getn(Metrics.AvgNetwork_RTT), median, avg, stdev, maximum, minimum);
	median, avg, stdev, maximum, minimum = CalcStats(Metrics.Equip_RTT);
	Output("Equip_RTT", table.getn(Metrics.Equip_RTT), median, avg, stdev, maximum, minimum);
	median, avg, stdev, maximum, minimum = CalcStats(Metrics.Unequip_RTT);
	Output("Unequip_RTT", table.getn(Metrics.Unequip_RTT), median, avg, stdev, maximum, minimum);

	--Reset all of the stats so we get stats only for each sampling interval, rather than cumulative stats.
	Metrics = {	["AddToInventory_RTT"] = {},
				["FPS"] = {},
				["CpuUsage"] = {},
				["VirtualMem_KB"] = {},
				["ResidentMem_KB"] = {},
				["ZoneTick_Cnt"] = {},
				["AvgNetwork_RTT"] = {},
				["Equip_RTT"] = {},
				["Unequip_RTT"] = {} };
end

function GetEquipmentList()
	--Set up the return list in the format:  returnList[equip_type]
	local returnList = {};

	--Get a listing of all files and folders at the ObjectData level, so we can tell how many tier
	--folders there are.
	local objectdDataListing;
	if(GetOS() == "Win32") then
		local directory = string.gsub(ObjectDataDir, "/", "\\");
		objectDataListing = ExecuteSysCmd("dir \""..directory.."\"");
	else
		objectDataListing = ExecuteSysCmd("ls -l \""..ObjectDataDir.."\"");
	end
	
	--Go through all equipment tier levels
	-- local curTierPos, endTierName = string.find(objectDataListing, "Tier%d*");
	local curTierPos, endTierName = string.find(objectDataListing, "Tier1");
	while(curTierPos ~= nil) do
		--Get the name of the current tier folder
		local tierFolderName = string.sub(objectDataListing, curTierPos, endTierName);
		tierFolderName = ObjectDataDir..tierFolderName;
		
		--Go through all of the different types of equipment in this tier
		for equipCnt = 1, table.getn(EquipTypes) do
			--Get the equipment file list for this equipment type
			local fileList = GetXmlFileList(tierFolderName.."/"..EquipTypes[equipCnt].."/");
			
			--Add this list to the global list of files for this equipment type
			if(returnList[equipCnt] == nil) then
				table.insert(returnList, {});
			end
			for fileCnt = 1, table.getn(fileList) do
				table.insert(returnList[equipCnt], fileList[fileCnt]);
			end
		end
		
		--Go to the next Tier
		-- curTierPos, endTierName = string.find(objectDataListing, "Tier%d*", endTierName+1);
		curTierPos = nil;
	end
	
	--Return the list of files
	return returnList;
end

function CalcStats(data)
	if(data == nil) then
		return;
	end
	local tableSize = table.getn(data);
	if(tableSize == 0) then
		return;
	end
	local maximum = data[1];
	local minimum = data[1];
	local average = data[1]/tableSize;
	for dataCnt = 2, tableSize do
		maximum = math.max(maximum, data[dataCnt]);
		minimum = math.min(minimum, data[dataCnt]);
		average = average + data[dataCnt]/tableSize;
	end
	
	local stdev = ((data[1] - average)^2)/tableSize;
	for dataCnt = 2, tableSize do
		stdev = stdev + ((data[dataCnt] - average)^2)/tableSize;
	end
	stdev = math.sqrt(stdev);
	
	table.sort(data);
	local median;
	if(math.fmod(tableSize, 2) == 0) then
		--The table size is even, so we need to average the 2 middle values
		median = (data[tableSize/2] + data[tableSize/2 + 1]) / 2;
	else
		--The table size is odd, so there is a unique middle value
		median = data[math.ceil(tableSize/2)];
	end
	
	return median, average, stdev, maximum, minimum;
end

function GetNextItemInfo()
	local equipIndex = math.random(1, table.getn(EquipTypes));
	local equipItemNum = math.random(1, table.getn(EquipmentList[equipIndex]));
	local newTemplateId = GetXmlValueFromFile(EquipmentList[equipIndex][equipItemNum], "m_templateID");
	local reqSchoolSectTxt;
	local reqSchoolSectEnd;
	local reqSchoolSectBegin;
	reqSchoolSectTxt, reqSchoolSectEnd, reqSchoolSectBegin = GetXmlValueFromFile(EquipmentList[equipIndex][equipItemNum], "Class", 1, -1, 'Name="class ReqSchoolOfFocus"');
	local newSchoolFocus = GetXmlValueFromFile(EquipmentList[equipIndex][equipItemNum], "m_magicSchool", reqSchoolSectBegin, reqSchoolSectEnd);
	local newEquipSlot;
	if(EquipTypes[equipIndex] == "Shoes") then
		--All of the inventory tabs have the same name as the equipment type minus the "S",
		--except Shoes, which includes the "S"
		newEquipSlot = EquipTypes[equipIndex];
	else
		newEquipSlot = string.sub(EquipTypes[equipIndex], 1, -2);
	end
	return equipIndex, newTemplateId, newSchoolFocus, newEquipSlot;
end
