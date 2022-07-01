Include("API/Debug.lua");
Include("API/Utilities.lua");
Include("API/Classes/SessionManager.lua");
Include("API/Classes/Timer.lua");

Include("Soblocks/Shared.lua");
Include("Soblocks/GameData.lua");
Include("Soblocks/Messages.lua");
Include("Soblocks/Config.lua");

RegisteredEvents = {};	-- Handles events that must first be registered.
Events = {};				-- Handles events that don't need to be registered.
MessageHandler = {};		-- Handles messages sent to the server

ClientManager = nil;

gameState = {};
gameState.gameType = nil;
gameState.halt = false;
gameState.paused = false;
gameState.clear = false;
gameState.countdown = false;

--NOTE: Board is in [row][col] form, NOT [x][y]!
board = {};
upcoming = {};

--Timers
CountdownTimer = nil;

function MSG_STARTSWAP(event)
   STARTSWAP_FUNC(event);
end
MessageHandler[Messages.StartSwap] = MSG_STARTSWAP;

function MSG_ADVANCEON(event)
	ClientManager:SendMessage(event.CharacterId, Messages.AdvanceOn, {});
end
MessageHandler[Messages.AdvanceOn] = MSG_ADVANCEON;

function MSG_ADVANCEOFF(event)
	ClientManager:SendMessage(event.CharacterId, Messages.AdvanceOff, {});
end
MessageHandler[Messages.AdvanceOff] = MSG_ADVANCEOFF;

function MSG_COUNTDOWN(event)
   if (not gameState.countdown and CheckCountdown(event.CharacterId)) then
      gameState.countdown = 3;
      SendSessionMessage(Messages.Countdown, {Number = 4});
      CountdownTimer:Reset();
   end
   
   if (gameState.countdown and CountdownTimer:GetTime() > 1000) then
      SendSessionMessage(Messages.Countdown, {Number = gameState.countdown});
      gameState.countdown = gameState.countdown - 1;
      CountdownTimer:Reset();
      if (gameState.countdown < 0) then
         gameState.countdown = false;
      end
   end
end
MessageHandler[Messages.Countdown] = MSG_COUNTDOWN;

--Sends a row of blocks to client
function SendRow(characterId, rowData)
   sendRow = {};
   sendRow.Index1 = rowData[1];
   sendRow.Index2 = rowData[2];
   sendRow.Index3 = rowData[3];
   sendRow.Index4 = rowData[4];
   sendRow.Index5 = rowData[5];
   sendRow.Index6 = rowData[6];
   sendRow.Index7 = rowData[7];
   --Log("Sending a row..."..math.random(1000));
   ClientManager:SendMessage(characterId, Messages.SendRow, sendRow);
end

function PrintBoard()
   local row = nil;
   local col = nil;
   
   for row = 1, MAP_HEIGHT do
      local text = "";
      for col = 1, MAP_WIDTH do
         text = text..board[row][col].." ";
      end
      --Log(text);
   end
end

function IsFalling(row, col)
   return false;
end

--Adds 2D position data to a table
function AddToData(data, row, col)
   local temp = {};
   temp.row = row;
   temp.col = col;
   table.insert(data, temp);
   return temp;
end

function AddMatch(data, row, col, index)
   local checkIndex = board[row][col];
   if (checkIndex == index and not IsFalling(row, col)) then
      AddToData(data, row, col);
   elseif (index <= NUM_TILES and checkIndex == BOMBS[index] and not IsFalling(row, col)) then
      AddToData(data, row, col);
      --table.insert(cursor.bomb, index);
   elseif (checkIndex <= NUM_TILES and index == BOMBS[checkIndex] and not IsFalling(x, y)) then
      AddToData(data, row, col);
      --table.insert(cursor.bomb, checkIndex);
   else
      return false;
   end
   return true;
end

function AddMatchesAbove(data, row, col)
   local index = board[row][col];
   local checkindex = nil;
   if (index == 0 or index == REMOVE_BLOCK) then return; end
   repeat
      row = row - 1;
      if (row < 1) then break; end
   until not AddMatch(data, row, col, index);
end

function AddMatchesBelow(data, row, col)
   local index = board[row][col];
   if (index == 0 or index == REMOVE_BLOCK) then return; end
   repeat
      row = row + 1;
      if (row > MAP_HEIGHT) then break; end
   until not AddMatch(data, row, col, index);
end

function AddMatchesLeft(data, row, col)
   local index = board[row][col];
   if (index == 0 or index == REMOVE_BLOCK) then return; end
   repeat
      col = col - 1;
      if (col < 1) then break; end
   until not AddMatch(data, row, col, index);
end

function AddMatchesRight(data, row, col)
   local index = board[row][col];
   if (index == 0 or index == REMOVE_BLOCK) then return; end
   repeat
      col = col + 1;
      if (col > MAP_WIDTH) then break; end
   until not AddMatch(data, row, col, index);
end

function CausesAMatch(row, col)
   --Checks only left and above since building a board starts from upper left
   local temp = {};
   AddMatchesAbove(temp, row, col);
   if (table.getn(temp) > 1) then return true; end
   temp = {};
   AddMatchesLeft(temp, row, col);
   if (table.getn(temp) > 1) then return true; end
   return false;
end

function ClearBoard()
   local row = nil;
   local col = nil;
   for row = 1, MAP_HEIGHT do
      for col = 1, MAP_WIDTH do
         board[row][col] = 0;
      end
   end
   gameState.clear = true;
end

function ResetServer()
   gameState.countdown = false;
end

function CoreInit()
   math.randomseed(GetRandomSeed());
   math.random();
   math.random();
   math.random();
   math.random();

   CountdownTimer = Timer();

   --Create a board of board[width][height]
   local row = nil;
   local col = nil;
   for row = 1, MAP_HEIGHT do
      table.insert(board, {});
      for col = 1, MAP_WIDTH do
         table.insert(board[row], 0);
      end
   end

   gameState.clear = true;
   resetPlayTiles();
end
