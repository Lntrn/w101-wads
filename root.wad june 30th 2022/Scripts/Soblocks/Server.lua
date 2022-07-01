DEBUG = true;

---------------------------------------------------------------------------------------------------------
-- Includes
---------------------------------------------------------------------------------------------------------
Include("API/Debug.lua");
Include("API/Utilities.lua");
Include("API/Classes/SessionManager.lua");
Include("API/Classes/Timer.lua");

Include("Soblocks/Shared.lua");
Include("Soblocks/GameData.lua");
Include("Soblocks/Config.lua");
Include("Soblocks/Messages.lua");
Include("Soblocks/ServerCore.lua");
Include("API/GameRegistry.lua");

player = nil;

--Registered events
function JoinSession_Event(event)
   JOINSESSION_FUNC(event);
end
RegisteredEvents["JoinSession"] = JoinSession_Event;

function LeaveSession_Event(event)
   ClientManager:StopClientProcess( event.CharacterGID );
   ClientManager:RemoveClient(event.CharacterGID);
   ResetServer();
end
RegisteredEvents["LeaveSession"] = LeaveSession_Event;

function ClientProcessEnd_Event(event)
   CLIENTPROCEND_FUNC(event.CharacterGID);
end
RegisteredEvents["ClientProcessEnd"] = ClientProcessEnd_Event;

function MSG_EVENT(event)
   for messageName, messageFunction in pairs(MessageHandler) do
      if messageName == event.MsgName then
         messageFunction(event);
         break;
      end
   end
end
Events["MSG"] = MSG_EVENT;

function MSG_READY(event)
end
MessageHandler[Messages.Ready] = MSG_READY;

function MSG_ENDGAME(event)
   ENDGAME_FUNC(event);
end
MessageHandler[Messages.EndGame] = MSG_ENDGAME;

function MSG_PAUSE(event)
   if (gameState.paused) then
      gameState.paused = false;
      ClientManager:SendMessage(event.CharacterId, Messages.PauseOff, {});
   else
      gameState.paused = true;
      ClientManager:SendMessage(event.CharacterId, Messages.PauseOn, {});
   end
end
MessageHandler[Messages.Pause] = MSG_PAUSE;

function MSG_RESETGAME(event)
   ClientManager:SendMessage(event.CharacterId, Messages.ResetGame, {});
end
MessageHandler[Messages.ResetGame] = MSG_RESETGAME;

function MSG_SELECTGAME(event)
   if     (event.GameType == GAMETYPES.SCORE) then
      gameState.gameType = GAMETYPES.SCORE;
   elseif (event.GameType == GAMETYPES.ITEM) then
      gameState.gameType = GAMETYPES.ITEM;
   elseif (event.GameType == GAMETYPES.BUCKS) then
      gameState.gameType = GAMETYPES.BUCKS;
   else
      return;
   end

   local select = {};
   select.GameType = gameState.gameType;
   gameState.halt = false;
   ClientManager:SendMessage(event.CharacterId, Messages.SelectGame, select);

   local row = nil;
   
   --Create board, then send board
   if (not gameState.clear) then
      resetPlayTiles();
      ClearBoard();
   end
   BuildBoard(event.CharacterId);
   PrintBoard();
   
   -- tells the wizard rewards manager not to listen
   -- as the minigame reward window will handle their display
   MinigameStart(savedCharacterGID);
end
MessageHandler[Messages.SelectGame] = MSG_SELECTGAME;

function MSG_SENDROW(event)
   BuildRow(event.CharacterId);
end
MessageHandler[Messages.RequestRow] = MSG_SENDROW;

function MSG_LEVELUP(event)
   JEWEL_CHANCE = event.Index1;
   BOMB_CHANCE = event.Index2;
   PINWHEEL_CHANCE = event.Index3;
   REINFORCED_CHANCE = event.Index4;
   FROZEN_CHANCE = event.Index5;
end
MessageHandler[Messages.SendRow] = MSG_LEVELUP;

function MSG_NEWBLOCK(event)
   table.insert(playtiles, table.remove(addtiles, 1));
end
MessageHandler[Messages.LevelUp] = MSG_NEWBLOCK;

function SendSessionMessage(message, data)
   SENDMESSAGE_FUNC(message, data);
end

function CheckCountdown()
   return true;
end

function BuildRow(characterId, noSpecial)
   local col = nil;
   local row = {};
   local index = nil;
   
   for col = 1, MAP_WIDTH do
      repeat
         index = playtiles[math.random(table.getn(playtiles))];
      until (col == 1) or not (index == row[col-1]);

      if (noSpecial) then
         row[col] = index;
      else
         if (FROZEN_CHANCE > 0 and math.random(FROZEN_CHANCE) == FROZEN_CHANCE) then
            row[col] = index + FROZEN_ALT;
         elseif (REINFORCED_CHANCE > 0 and math.random(REINFORCED_CHANCE) == REINFORCED_CHANCE) then
            row[col] = index + REINFORCED_ALT;
         elseif (PINWHEEL_CHANCE > 0 and math.random(PINWHEEL_CHANCE) == PINWHEEL_CHANCE) then
            row[col] = PINWHEEL_BLOCK;      
         elseif (BOMB_CHANCE > 0 and math.random(BOMB_CHANCE) == BOMB_CHANCE) then
            row[col] = BOMBS[index];
         elseif (JEWEL_CHANCE > 0 and math.random(JEWEL_CHANCE) == JEWEL_CHANCE) then
            row[col] = JEWEL_BLOCK;
         else
            row[col] = index;
         end
      end
   end
   SendRow(characterId, row);
   return row;
end

function BuildBoard(characterId)
   local row = nil;
   local col = nil;
   local index = nil;
   
   gameState.clear = false;
   --Fill board with random blocks and prevent three in a row
   for row = MAP_HEIGHT - STARTING_HEIGHT + 1, MAP_HEIGHT do
      for col = 1, MAP_WIDTH do
         repeat
            board[row][col] = playtiles[math.random(table.getn(playtiles))];
         until not CausesAMatch(row, col);
      end
      SendRow(characterId, board[row]);
   end
   BuildRow(characterId, true);
end

function Init()
   RegisterSession( GetZoneID( OwnerGID ), 0, "SoblocksSolo", 0, 1, "X" ); 
   ClientManager = SessionManager();
end

function main()
   for eventName, _ in pairs(RegisteredEvents) do
      RegisterEvent(eventName);
   end

   CoreInit();
   Init();

   while true do
      -- wait for events
      local event = GetEvent();
      local continue = true;
      
      if event then
         --DebugLogTable(event);
         
         for eventName, eventFunction in pairs(RegisteredEvents) do
            if event.EventName == eventName then
               eventFunction(event);
               continue = false;
               break;
            end
         end
         
         if continue == true then
            for eventName, eventFunction in pairs(Events) do
               if event.EventName == eventName then
                  eventFunction(event);
                  break;
               end
            end
         end
      end
   end

   return true;
end
