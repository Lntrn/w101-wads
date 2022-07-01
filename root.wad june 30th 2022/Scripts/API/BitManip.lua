function AddFlag( Flags, FlagsToAdd )
	if not Flags or not FlagsToAdd then
		return nil;
	end
	
	if FlagsToAdd == "" then
		return Flags;
	end
	
	local flags = {};
	local flagsToAdd = {};
	local count = 1;
	
	for w in string.gfind( Flags, "[%w_]+" ) do
		table.insert( flags, w );
	end
	
	for w in string.gfind( FlagsToAdd, "[%w_]+" ) do
		table.insert( flagsToAdd, w );
	end

	for x = 1, table.getn( flags ) do
		for y = x + 1, table.getn( flags ) do
			if flags[x] == flags[y] then
				table.remove( flags, y );
				y = y - 1;
			end
		end
	end

	local addFlag = true;
	
	for x = 1, table.getn( flagsToAdd ) do
		for y = 1, table.getn( flags ) do
			if flagsToAdd[x] == flags[y] then
				addFlag = false;
				break;
			end
		end
		
		if addFlag == true then
			table.insert( flags, flagsToAdd[x] );
		end
		addFlag = true;
	end
	
	if table.getn( flags ) == 0 then
		return "";
	end
	
	Flags = flags[1];
	for w = 2, table.getn( flags ) do
		Flags = Flags .. "|" .. flags[w];
	end
	
	return Flags;
end

function ToggleFlag( Flags, FlagsToToggle )
	if not Flags or not FlagsToToggle then
		return nil;
	end
	
	if FlagsToToggle == "" then
		return Flags;
	end
	
	local flags = {};
	local flagsToToggle = {};
	local count = 1;
	
	for w in string.gfind( Flags, "[%w_]+" ) do
		table.insert( flags, w );
	end
	
	for w in string.gfind( FlagsToToggle, "[%w_]+" ) do
		table.insert( flagsToToggle, w );
	end

	for x = 1, table.getn( flags ) do
		for y = x + 1, table.getn( flags ) do
			if flags[x] == flags[y] then
				table.remove( flags, y );
				y = y - 1;
			end
		end
	end
	
	local addFlag = true;
	
	for x = 1, table.getn( flagsToToggle ) do
		for y = 1, table.getn( flags ) do
			if flagsToToggle[x] == flags[y] then
				table.remove( flags, y );
				addFlag = false;
				break;
			end
		end
		
		if addFlag == true then
			table.insert( flags, flagsToToggle[x] );
		end
		addFlag = true;
	end
	
	if table.getn( flags ) == 0 then
		return "";
	end
	
	Flags = flags[1];
	for w = 2, table.getn( flags ) do
		Flags = Flags .. "|" .. flags[w];
	end
	
	return Flags;
end

function CheckFlag( Flags, FlagsToCheck )
	if not Flags or not FlagsToCheck then
		return nil;
	end
	
	local flags = {};
	local flagsToCheck = {};
	local count = 1;
	local flagFound = false;
	
	for w in string.gfind( FlagsToCheck, "[%w_]+" ) do
		for w2 in string.gfind( Flags, "[%w_]+" ) do
			if w == w2 then
				flagFound = true;
				break;
			end
		end
		if flagFound == false then
			return false;
		end
		flagFound = false;
	end
	
	return true;
end

-- Not working correctly at the moment
function RemoveFlag( Flags, FlagsToRemove )
	if not Flags or not FlagsToRemove then
		return nil;
	end
	
	local flags = {};
	
	for w in string.gfind( Flags, "[%w_]+" ) do
		table.insert( flags, w );
	end
	
	for w in string.gfind( FlagsToRemove, "[%w_]+" ) do
		for x = 1, table.getn( flags ) do
			if w == flags[x] then
				table.remove( flags, x );
				x = x - 1;
			end
		end
	end
	
	if table.getn( flags ) == 0 then
		return "";
	end
	
	Flags = flags[1];
	for w = 2, table.getn( flags ) do
		Flags = Flags .. "|" .. flags[w];
	end
	
	return Flags;
end
