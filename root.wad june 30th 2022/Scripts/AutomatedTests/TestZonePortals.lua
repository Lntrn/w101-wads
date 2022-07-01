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
Include("HelperScripts/GetTeleportData.lua");
Include("HelperScripts/CompleteAllQuests.lua");
Include("HelperScripts/GetArguments.lua");

--States for state table
TESTING_DESTINATION_ZONE = 1;
WAITING_FOR_TELEPORT_TO_DESTINATION = 2;
TELEPORTING_TO_START_ZONE = 3;
WAITING_FOR_INITIAL_TELEPORT = 4;
PAUSING_IN_NEW_ZONE = 5;
MOVING_ALONG_PATH = 6;
WAITING_FOR_PORTAL_TELEPORT = 7;
SUCCESSFULLY_WENT_THROUGH_PORTAL = 8;
CurrentState = 1;

--Name of log file
RUN_MODE = "RELEASE";
if(RUN_MODE == "RELEASE") then
	LogFileName = "../Data/GameData/Scripts/ZoneConnectionsTest.log";
else
	LogFileName = "../../Data/GameData/Scripts/ZoneConnectionsTest.log";
end

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
			newFileName = string.gsub(LogFileName, "ZoneConnectionsTest.log", newFileName);
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
	
	TestZonePortals(newFileName, useStdOut, writeToDb, dbHost, dbName, dbUser, dbPassword, dbTableName);
end

function TestZonePortals(newFileName, useStdOut, writeToDb, dbHost, dbName, dbUser, dbPassword, dbTableName)
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
		query = query.."`Message` varchar(512) NOT NULL,";
		query = query.."`TimeStamp` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,";
		query = query.."PRIMARY KEY  (`id`));";
		CreateTable(DbTableName, query);
	end
	
	Log("Testing Zone Connections...");
	
	--Make sure the player has all of the quests completed so they can access all of the zone connections
	CompleteAllQuests();
    AddExtraQuests();
	
	--Clear the file out
	LogFile = io.open(LogFileName, "w+");
	if(LogFile == nil) then
		Log("Could not open file:  "..LogFileName.."\n");
		Exit(1);
	end
	
	--Get all of the data that was recorded
	NumPositionsInPathTable, StartZoneNameTable, FinalZoneNameTable, PathTable = GetTeleportData();
	
	-- setup the timer event;
	RegisterEventCallback("MonkeyTimer",Monkey_OnTimer);
	StartTimer("MonkeyTimer", (1/4), false);	--Have the timer trigger every 1/4 second

	--Add the event that will respond when your player is teleported.
	RegisterEventCallback("OnTeleported", OnTeleported);
	
	-- using this to make sure timer calls are smooth in case we get timer pulses in a not so exact time
	
	timer = GetTime();

	StillTestingPortals = true;
	while( StillTestingPortals == true ) do 
		-- GetEvent called with no parameters = get any event and no timeout
		event = GetEvent();
		if( event ) then
			-- since all of our registered events have a callback, 
			-- we will not have to handle event parsing within our main()
			if ( event.LUA_CallBack ) then
				event.LUA_CallBack( event );
			end
		end
	end
	
	--We're done testing, so disconnect from the database if we are alredy connected
	if(WriteToDb == true) then
		DisconnectFromDb();
	end
	
	Log("Done Testing Zone Connections");	

	--Send an event to notify any other scripts that care that this script is done running
	local doneEventArgs = {["ScriptName"] = "TestZonePortals.lua"};
	if(TestFailed) then
		doneEventArgs["ExitCode"] = 1;
	else
		doneEventArgs["ExitCode"] = 0;
	end
	SendEvent("DoneRunningScript", doneEventArgs);
end

function Monkey_OnTimer()

	if(GetTime() > timer) then
		timer = GetTime() + 1;
		if(CurrentState == TESTING_DESTINATION_ZONE) then
			--Check if there are any more rounds to go through
			if(table.getn(StartZoneNameTable) == 0) then
				--There are no more rounds, so end this
				StillTestingPortals = false;
				return;
			end
		
			--Initialize all variables for the next round
			PathIndex = 1;
			NumPositionsInPath = table.remove(NumPositionsInPathTable, 1);
			StartZoneName = table.remove(StartZoneNameTable, 1);
			FinalZoneName = table.remove(FinalZoneNameTable, 1);
			
			--We are going to wait for this teleport for 5 seconds
			EndWaitTime = GetTime() + 5000;
			
			--Teleport to the Final zone to see if the zone is up.  Otherwise, if the zone is not
			--up and you try to go through the zone portal, the game will die.
			TeleportToZone(FinalZoneName);
			ChangeState();
		end
		
		if(CurrentState == WAITING_FOR_TELEPORT_TO_DESTINATION) then
			if(EndWaitTime < GetTime()) then
				--The Time has expired.  That means the destination zone is down
				
				--Set the flag signifying that a test failed.
				TestFailed = true;
				
				--Write the test failure results
				OutputResults("FAIL", FinalZoneName.." is down\n");
				SkipThisRound();
			end
			
			--We are still waiting to teleport, so chill for a bit longer.
			return;
		end
		
		if(CurrentState == TELEPORTING_TO_START_ZONE) then
			--Make sure not to start teleporting too soon
			if(EndWaitTime < GetTime()) then
				--Wait for no more than 5 seconds for this teleport to happen.  If it doesn't, then
				--we'll know the start zone is down.
				EndWaitTime = GetTime() + 5000;
				
				--Teleport to the start zone
				TeleportToZone(StartZoneName);
				
				--Move onto the next state
				ChangeState();
			else
				--Need to wait a bit longer to let the player settle into this zone
				return;
			end
		end
		
		--We don't want to be trying to move while we're supposed to be teleporting
		if(CurrentState == WAITING_FOR_INITIAL_TELEPORT) then
			if(EndWaitTime < GetTime()) then
				--The Time has expired.  That means the start zone is down
				
				--Set the flag signifying that a test failed.
				TestFailed = true;
				
				--Open the log file
				OutputResults("FAIL", StartZoneName.." is down\n");
				SkipThisRound();
			end
			
			--We are still waiting to teleport, so chill for a bit longer.
			return;
		end
		
		--We need to pause in the new zone before we launch ourselves at a new portal.  For some
		--odd reason, when we go through a door, then immediately run back to it and try to go
		--through, it won't let you.  But, if we pause for even a 1/2 second, it lets us through.
		if(CurrentState == PAUSING_IN_NEW_ZONE) then
			if(EndWaitTime < GetTime()) then
				--We have waited long enough, move through the zone connection
				ChangeState();
			else
				--Still need to wait a bit before moving through the portal
				return;
			end
		end

		if(CurrentState == MOVING_ALONG_PATH) then
			--Get the next position to move to.
			local pos = table.remove(PathTable, 1);

			--Move the player to that position if we haven't already teleported
			if(GetZoneName() == StartZoneName) then
				SetPlayerPosition(pos.x, pos.y, pos.z, pos.yaw);
			end

			--If this was the last position in this path, then go to the next state, otherwise, go to the next position
			if(PathIndex == NumPositionsInPath) then
				--Wait for 5 seconds for the teleport to take place
				EndWaitTime = GetTime() + 5000;
				ChangeState();
			else
				PathIndex = PathIndex + 1;
			end
		end
		
		if(CurrentState == WAITING_FOR_PORTAL_TELEPORT) then
			if(EndWaitTime < GetTime()) then
				--The Time has expired.  That means this portal has failed

				--Set the flag signifying that a test failed.
				TestFailed = true;
				
				--Open the log file
				OutputResults("FAIL", StartZoneName.." --> "..FinalZoneName.."\n");
				CurrentState = 1;
			end
		end
		
		if(CurrentState == SUCCESSFULLY_WENT_THROUGH_PORTAL) then
			--The player successfully passed through a zone connection

			--Open the log file
			OutputResults("PASS", StartZoneName.." --> "..FinalZoneName.."\n");
			ChangeState();
		end
		
		
	end
end

function TeleportToZone(zoneName)
	if(zoneName ~= GetZoneName()) then
		Server("Teleport", zoneName);
	else
		--Dont need to teleport, already in correct zone
		ChangeState();

		--We should wait 1/2 second when we get to a new zone before trying to leave it, otherwise, the
		--zone connections don't work sometimes.
		EndWaitTime = GetTime() + 1000;
	end
end

function OnTeleported(event)
	if(CurrentState == WAITING_FOR_INITIAL_TELEPORT or CurrentState == WAITING_FOR_TELEPORT_TO_DESTINATION) then
		ChangeState();

		--We should wait 1/2 second when we get to a new zone before trying to leave it, otherwise, the
		--zone connections don't work sometimes.
		EndWaitTime = GetTime() + 1000;
	elseif(CurrentState == WAITING_FOR_PORTAL_TELEPORT) then
		ChangeState();
	elseif(CurrentState == MOVING_ALONG_PATH) then
		--Make sure there aren't any positions left from the last path that didn't get executed before we teleported
		for i = PathIndex, NumPositionsInPath do
			table.remove(PathTable, 1);
		end
		CurrentState = SUCCESSFULLY_WENT_THROUGH_PORTAL;
	end
end

function ChangeState()
	if(CurrentState == SUCCESSFULLY_WENT_THROUGH_PORTAL) then
		CurrentState = 1;
	else
		CurrentState = CurrentState + 1;
	end
end

function AddExtraQuests()
	--To ride Airships in Marleybone
	Server ("AddQuest", "MB-AIRHub-C03-001");    --Hyde Park
	Server ("AddQuest", "MB-AIRHub-C04-001");    --Chelsea Court
end

function SkipThisRound()
	--Remove all positions for this round
	for i = PathIndex, NumPositionsInPath do
		local pos = table.remove(PathTable, 1);
	end
	
	--Set the State to the beginning of the next round
	CurrentState = 1;
end

function OutputResults(resultStr, msg)
	local opStr = resultStr.."\t"..msg;
	LogFile:write(opStr);
	LogFile:flush();
	
	--Write out to std out, if the user specified to do so
	if(UseStdOut) then
		io.stdout:write(opStr);
		io.stdout:flush();
	end
	
	--Write to a database, if the suer specified to do so
	if(WriteToDb) then
		local recordInfo = {["TableName"] = DbTableName, ["Result"] = resultStr, ["Message"] = msg};
		UpdateRecord(recordInfo);
	end
end
