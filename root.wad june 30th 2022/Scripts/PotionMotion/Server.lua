GameName = "PotionMotion"

Include("API/Debug.lua");
Include("API/Utilities.lua");
Include("API/Globals.lua");
Include("API/ControlClasses.lua");
Include("API/BitManip.lua");
Include("API/Classes/ControlMessageBox.lua");
Include("API/KeyCodes.lua");
Include("API/Classes/Timer.lua");
Include("API/Classes/SessionManager.lua" );
Include(GameName.."/Messages.lua" );


ClientManager = nil;
savedCharacterGID = nil;
savedZoneID = nil;  -- zone id for wiz  minigames is the player's id

RegisteredEvents = {};	-- Handles events that must first be registered.
Events = {};		-- Handles events that don't need to be registered.
MessageHandler = {};	-- Handles messages sent to the server


---------------------------------------------------------------------------------------------------------
-- REGISTERED EVENTS
---------------------------------------------------------------------------------------------------------
--Registered events
function JoinSession_Event( event )
	Log(GameName.." ---- Server : JoinSession_Event");
	savedCharacterGID = event.CharacterGID;
   savedZoneID = GetZoneID( OwnerGID );

	Log(GameName.." ---- Server: JoinSession event.CharacterGID="..event.CharacterGID);
	ClientManager:AddClient( event.CharacterGID );
	ClientManager:RunClientProcess( event.CharacterGID, GameName.."/Client.lua" );
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
   Log(GameName.." sending ClientProcessEnd msg");
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
	MinigameStart(savedCharacterGID);
end
MessageHandler[Messages.Connect] = CONNECT_MSG;

function MSG_REWARDS(event)
   score = event.score;
   MinigameRewards(savedCharacterGID, event.score, event.gameName, 1000);
end
MessageHandler[Messages.Rewards] = MSG_REWARDS;

function MSG_MOVED(event)
	MinigameNotAFK(savedCharacterGID);
end
MessageHandler[Messages.Moved] = MSG_MOVED;

---------------------------------------------------------------------------------------------------------
-- Main
-- Register events, init, and handle messages.
---------------------------------------------------------------------------------------------------------
function main()
DEBUG = true;
Log("Starting "..GameName.." Server main()");
	ClientManager = SessionManager();
	local SessionID = RegisterSession( GetZoneID( OwnerGID ), 0, GameName, 0, 1, "Rules" );
	if DEBUG == true then
		Log( GameName.." server session " .. SessionID .. " active." );
	end
	
	for eventName, _ in pairs( RegisteredEvents ) do
		RegisterEvent( eventName );
	end

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

