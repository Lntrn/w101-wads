--[[
	Simple Timer class for LUA.
]]

Include( "API/Classes/class.lua" );

SessionManager = class( function( a )
	a.Processes = {};
	a.CharacterGIDs = {};
	end );

function SessionManager:AddClient( characterGID )
	table.insert( self.CharacterGIDs, characterGID );
end

function SessionManager:RemoveClient( characterGID )
	for index, gid in pairs( self.CharacterGIDs ) do
		if gid == characterGID then
			table.remove( self.CharacterGIDs, index );
			break;
		end
	end
	self.Processes[characterGID] = nil;
end

function SessionManager:RunClientProcess( characterGID, scriptName )
	local socketID = GetSocketIdFromCharacterId( characterGID );
	self.Processes[characterGID] = RunClientProcess( socketID, scriptName );
end

function SessionManager:StopClientProcess( characterGID )
   local ObjectID = self.Processes[characterGID];
   KillClientProcess(ObjectID);
end

function SessionManager:BroadcastMessage( name, msg )
	for index, characterGID in pairs( self.CharacterGIDs ) do
		SendProcessMessage( self.Processes[characterGID], name, msg );
	end
end

function SessionManager:SendMessage( characterGID, name, msg )
	SendProcessMessage( self.Processes[characterGID], name, msg );
end

