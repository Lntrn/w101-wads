--This script will create user accounts.  You pass in the name of the account and the starting and
--ending indices and it will create user accounts in the grobold database called
--userName[start_index] to userName[end_index].  If you provide no index, then an account name will
--be created without any indicies called userName.  If you only provide one index, then only one
--account will be created called userName[start_index].
--
-- @param[in]	userName	The name of the user account to create (without the indices)
-- @param[in]	startIndex	The beginning index of the monkey user accounts you want to create
-- @param[in]	endIndex	The ending index of the monkey user accounts you want to create

Include("HelperScripts/GetArguments.lua");

function main()
	local doneEventArgs = {["ScriptName"] = "CreateMonkeyUsers.lua"};

	--Get the user name
	local args = GetArguments();
	local userName = "";
	local startIndex = nil;
	local endIndex = nil;
	if(args.arg0 == nil) then
		--The user didn't pass in a user name.  So, tell them how to use the function and return.
		Log("No user name provided\nUsage:  CreateMonkeyUsers UserName [StartIndex] [EndIndex]");
		doneEventArgs["ExitCode"] = 1;
		Log("Done running CreateMonkeys");
		SendEvent("DoneRunningScript", doneEventArgs);
		return;
	else
		userName = args.arg0;
	end

	--Connect to the Database that contains the user account Table.
	if(ConnectToDb("grobold", "WizardCore", "root", "") == 1) then
		Log("Could not connect to the database");
		doneEventArgs["ExitCode"] = 1;
		Log("Done running CreateMonkeys");
		SendEvent("DoneRunningScript", doneEventArgs);
		return;
	end

	--Get the indicies to make the accounts for
	Log("Creating accounts");
	if(args.arg1 ~= nil) then
		startIndex = args.arg1;
	else
		--If this account does not already exist, then add one.
		local recordInfo = {TableName = "user",
							KeyField = "Name",
							KeyValue = userName,
							Name = userName,
							Password = userName,
							Banned = "0",
							State = "0",
							AdminLevel = "roA=CSRAdmin"};
		doneEventArgs.ExitCode = UpdateRecord(recordInfo);
	
		Log("Done running CreateMonkeys");
		SendEvent("DoneRunningScript", doneEventArgs);
		return;
	end
	if(args.arg2 ~= nil) then
		endIndex = args.arg2;
	else
		endIndex = startIndex;
	end

	--Add each monkey account to the database
	doneEventArgs.ExitCode = 0;
	for i = startIndex, endIndex do
		local recordInfo = {TableName = "user",
							KeyField = "Name",
							KeyValue = userName..i,
							Name = userName..i,
							Password = userName..i,
							Banned = "0",
							State = "0",
							AdminLevel = "roA=CSRAdmin"};
		if(UpdateRecord(recordInfo) == 1) then
			doneEventArgs.ExitCode = 1;
		end
	end

	--Send an event to notify any other scripts that care that this script is done running
	Log("Done running CreateMonkeys");
	SendEvent("DoneRunningScript", doneEventArgs);
end
