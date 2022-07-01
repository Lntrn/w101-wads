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
Include("API/ControlClasses.lua");
Include("HelperScripts/GetXmlValueFromFile.lua");
Include("HelperScripts/GetArguments.lua");

RUN_MODE = "RELEASE";
if(RUN_MODE == "RELEASE") then
	XpConfigFileName = "../Data/GameData/MagicXPConfig.xml";
	LogFileName = "../Data/GameData/Scripts/PlayerProgression.log"
else
	XpConfigFileName = "../../Data/GameData/MagicXPConfig.xml";
	LogFileName = "../../Data/GameData/Scripts/PlayerProgression.log"
end

--This file is going to let me check that players are progressing properly as they gain experience.
--To do that, I am going to add experience and make sure the players level at the correct
--experience cutoffs.   Also, I am going to make sure that they receive the correct amount of
--health points, mana, and training points when they level.

--I am going to get all data I need from the same GUI the user would use, so if the text there is
--wrong, the test will fail and will be flagged.  The GUI file is CharStatsSpellbookPage.gui and
--the text controls that I will need are named CharLevel, Health, Mana, and TrainingPoints.

--I will get cutoffs and proper level rewards from the MagicXPConfig.xml file, so that it can be
--easily configured without having to rewrite the test.

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
			newFileName = string.gsub(LogFileName, "PlayerProgression.log", newFileName);
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
	TestPlayerProgression(newFileName, useStdOut, writeToDb, dbHost, dbName, dbUser, dbPassword, dbTableName);
end

function TestPlayerProgression(newFileName, useStdOut, writeToDb, dbHost, dbName, dbUser, dbPassword, dbTableName)
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
		query = query.."`Level` varchar(45) NOT NULL,";
		query = query.."`XP` varchar(45) NOT NULL,";
		query = query.."`HP` varchar(45) NOT NULL,";
		query = query.."`Mana` varchar(45) NOT NULL,";
		query = query.."`Training_Pts` varchar(45) NOT NULL,";
		query = query.."`TimeStamp` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,";
		query = query.."PRIMARY KEY  (`id`));";
		CreateTable(DbTableName, query);
	end

	Log("Beginning Player Progression Test...");
	
	--Open the XP config file for reading, so whatever values we compare against are up-to-date
	XpConfigFile = io.open(XpConfigFileName);
	
	--Open the log file for writing.  Clear the file for a fresh start
	LogFile = io.open(LogFileName, "w+");
	if(LogFile == nil) then
		Log("Could not open file:  "..LogFileName.."\n");
		Exit(1);
	end
	
	--Loop until we've read all of the level information from the file
	local lvlCnt = 1;
	local curLvl;
	local curXp;
	local xmlXp;
	local lastXmlXp = 0;
	local curHp;
	local xmlHp;
	local curMana;
	local xmlMana;
	local curTp;
	local stats = {GetPlayerStats()};
	local lastTp = stats[6];
	local xmlTp;
	while ( true ) do
		--Get the stats information for the current player to make sure that all of the stats are appropriate for this new level
		stats = {GetPlayerStats()};
		curLvl = tonumber(stats[1]);
		curXp = tonumber(stats[2]);
		curTp = tonumber(stats[6]);
		curHp = tonumber(stats[8]);
		curMana = tonumber(stats[10]);
		
		--Get the information we want for the current level
		xmlXp, xmlHp, xmlMana, xmlTp = GetLevelInfo(lvlCnt);
		if(xmlXp == nil or xmlHp == nil or xmlMana == nil or xmlTp == nil) then
			--Hit the end of the file, so stop looping
			break;
		end
		
		--Verify that all of the stats are correct for this level
		Log("Current:  \tLevel:  "..curLvl.."\tTraining Pts:  "..curTp-lastTp.."\tHP:  "..curHp.."\tMana:  "..curMana);
		Log("Expected:  \tLevel:  "..lvlCnt.."\tTraining Pts:  "..xmlTp.."\tHP:  "..xmlHp.."\tMana:  "..xmlMana);
		if (curLvl ~= lvlCnt) or (curHp ~= xmlHp) or (curMana ~= xmlMana) or (curTp-lastTp ~= xmlTp) then
			--Set the flag signifying that a test failed.
			TestFailed = true;
				
			--Write to the log that we failed
			OutputResults("FAIL", curLvl, curXp, curHp, curMana, curTp);
		else
			--Write to the log file that we succeeded
			OutputResults("PASS", curLvl, curXp, curHp, curMana, curTp);
		end
		
		--Set the XP to just under the cutoff
		local xpNum = tonumber(xmlXp);
		Server("AddSchoolXP", xpNum - lastXmlXp - 1);
		Sleep(1);
		
		--Get the stats information for the current player again to make sure none of our stats have changed
		stats = {GetPlayerStats()};
		curLvl = tonumber(stats[1]);
		curXp = tonumber(stats[2]);
		curTp = tonumber(stats[6]);
		curHp = tonumber(stats[8]);
		curMana = tonumber(stats[10]);
		
		--Verify that all of the stats are still correct for this level
		if (curLvl ~= lvlCnt) or (curHp ~= xmlHp) or (curMana ~= xmlMana) or (curTp-lastTp ~= xmlTp) then
			--Set the flag signifying that a test failed.
			TestFailed = true;
				
			--Write to the log that we failed
			OutputResults("FAIL", curLvl, curXp, curHp, curMana, curTp);
		else
			--Write to the log file that we succeeded
			OutputResults("PASS", curLvl, curXp, curHp, curMana, curTp);
		end
		
		--Bump the XP up, which should go to the next level
		Server("AddSchoolXP", 1);
		Sleep(1);
		
		--Remember the last xp cutoff, so we can add the correct amount of xp for every level
		lastXmlXp = xpNum;
		
		--Also remember the last Training Points so that we can tell how much they adjust by, since
		--the xml file only tells the amount to adjust the training points by.
		lastTp = curTp;

		--Go to the next level
		lvlCnt = lvlCnt + 1;
	end

	--We're done testing, so disconnect from the database if we are alredy connected
	if(WriteToDb == true) then
		DisconnectFromDb();
	end

	Log("Done Testing Player Progression");

	--Send an event to notify any other scripts that care that this script is done running
	local doneEventArgs = {["ScriptName"] = "TestPlayerProgression.lua"};
	if(TestFailed) then
		doneEventArgs["ExitCode"] = 1;
	else
		doneEventArgs["ExitCode"] = 0;
	end
	SendEvent("DoneRunningScript", doneEventArgs);
end

function GetLevelInfo(level)
	--Find the section in the xml file for the level that was passed in
	local lvlInfo, endPos, startPos = GetXmlValueFromFile(XpConfigFileName, "m_levelInfo", 1, -1, "key=\""..level.."\"");
	
	--Get all of the values from this section
	if(lvlInfo == nil) then
		return nil;
	end
	
	local xp = GetXmlValueFromFile(XpConfigFileName, "m_xpToLevel", startPos, endPos);
	local hp = GetXmlValueFromFile(XpConfigFileName, "m_hitpoints", startPos, endPos);
	local mana = GetXmlValueFromFile(XpConfigFileName, "m_mana", startPos, endPos);
	local tp = GetXmlValueFromFile(XpConfigFileName, "m_trainingPoints", startPos, endPos);
	
	return tonumber(xp), tonumber(hp), tonumber(mana), tonumber(tp);
end

function OutputResults(resultStr, curLvl, curXp, curHp, curMana, curTp)
	local opStr = resultStr.."\tLevel:  "..curLvl.."\tXP:  "..curXp.."\tHealth:  "..curHp.."\tMana:  "..curMana.."\tTraining Points:  "..curTp.."\n"
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
							["Level"] = tostring(curLvl),
							["XP"] = tostring(curXp),
							["HP"] = tostring(curHp),
							["Mana"] = tostring(curMana),
							["Training_Pts"] = tostring(curTp)};
		UpdateRecord(recordInfo);
	end
end
