--[[ 

	SkullRiders - This handles all client messages and validates all moves.

	Author: Cheryl Chunco
	KingsIsle Entertainment
	Date: March 27, 2007
]]

DEBUG = true;

---------------------------------------------------------------------------------------------------------
-- Includes
---------------------------------------------------------------------------------------------------------
Include( "API/Debug.lua" );
Include( "API/Utilities.lua" );
Include( "API/Classes/Timer.lua" );
Include( "SkullRiders/Messages.lua" );
Include( "API/Classes/SessionManager.lua" );

---------------------------------------------------------------------------------------------------------
-- Variables
---------------------------------------------------------------------------------------------------------

savedCharacterGID = nil;
savedZoneID = nil;  -- zone id for wiz  minigames is the player's id
score = 0;

RegisteredEvents = {};	-- Handles events that must first be registered.
Events = {};		-- Handles events that don't need to be registered.
MessageHandler = {};	-- Handles messages sent to the server

ClientManager = nil;

---------------------------------------------------------------------------------------------------------
-- REGISTERED EVENTS
---------------------------------------------------------------------------------------------------------
--Registered events
function JoinSession_Event( event )
	Log("SkullRiders ---- Server : JoinSession_Event");

	savedCharacterGID = event.CharacterGID;
	savedZoneID = GetZoneID( OwnerGID );

	Log("SkullRiders ---- Server: JoinSession event.CharacterGID="..event.CharacterGID);
	ClientManager:AddClient( event.CharacterGID );
	ClientManager:RunClientProcess( event.CharacterGID, "SkullRiders/Client.lua" );
end
RegisteredEvents["JoinSession"] = JoinSession_Event;

function LeaveSession_Event( event )
   ClientManager:StopClientProcess( event.CharacterGID );
	ClientManager:RemoveClient( event.CharacterGID );
end
RegisteredEvents["LeaveSession"] = LeaveSession_Event;

function ClientProcessEnd_Event( event )
	if (savedCharacterGID ~= event.CharacterGID) then
		return;
	end
	MinigameEnd(savedCharacterGID, score, savedZoneID);
end
RegisteredEvents["ClientProcessEnd"] = ClientProcessEnd_Event;

---------------------------------------------------------------------------------------------------------
-- OTHER EVENTS
---------------------------------------------------------------------------------------------------------
function MSG_EVENT( event )
	for messageName, messageFunction in pairs( MessageHandler ) do
		if messageName == event.MsgName then
			messageFunction( event );
			break;
		end
	end
end
Events["MSG"] = MSG_EVENT;

---------------------------------------------------------------------------------------------------------
-- MESSAGES
---------------------------------------------------------------------------------------------------------
function CONNECT_MSG( event )
   -- tells the wizard rewards manager not to listen
   -- as the minigame reward window will handle their display
   MinigameStart(savedCharacterGID);
end
MessageHandler[Messages.Connect] = CONNECT_MSG;

function MSG_REWARDS(event)
   score = event.score;
   MinigameRewards(savedCharacterGID, event.score, "SkullRiders", 1000);
end
MessageHandler[Messages.Rewards] = MSG_REWARDS;

function MSG_MOVED(event)
	MinigameNotAFK(savedCharacterGID);
end
MessageHandler[Messages.Moved] = MSG_MOVED;

---------------------------------------------------------------------------------------------------------
-- BroadcastMessage
---------------------------------------------------------------------------------------------------------
function BroadcastMessage( messageIndex, messageTable )
	SendSessionMessage( messageIndex, messageTable );
end

---------------------------------------------------------------------------------------------------------
-- Init
---------------------------------------------------------------------------------------------------------
function Init()
end

---------------------------------------------------------------------------------------------------------
-- Main
-- Register events, init, and handle messages.
---------------------------------------------------------------------------------------------------------
function main()
	ClientManager = SessionManager();
	local SessionID = RegisterSession( GetZoneID( OwnerGID ), 0, "SkullRiders", 0, 1, "Rules" );
	if DEBUG == true then
		Log( "SkullRiders server session " .. SessionID .. " active." );
	end
	
	for eventName, _ in pairs( RegisteredEvents ) do
		RegisterEvent( eventName );
	end
	
	Init();

	while true do
		-- wait for events
		local event = GetEvent();
		local continue = true;
		
		if event then
			if DEBUG == true then
				for i, j in pairs( event ) do
					Log( i .. " " .. j );
				end
				Log( "-------" );
			end


--local eventFunc = RegisteredEvents[event.EventName];
--if eventFunc then
--            eventFunc( event );
--else
--            eventFunc = Events[event.EventName];
--            if eventFunc then
--                        eventFunc( event );
--            end
--end


			
			for eventName, eventFunction in pairs( RegisteredEvents ) do
				if event.EventName == eventName then
					eventFunction( event );
					continue = false;
					break;
				end
			end
			
			if continue == true then
				for eventName, eventFunction in pairs( Events ) do
					if event.EventName == eventName then
						eventFunction( event );
						break;
					end
				end
			end
		end
	end
	
	return true;
end
