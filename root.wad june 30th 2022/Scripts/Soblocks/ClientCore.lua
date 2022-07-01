Include("Soblocks/Shared.lua");
Include("Soblocks/ClientConfig.lua");
Include("Soblocks/GameData.lua");
Include("Soblocks/Messages.lua");
Include("Soblocks/ParticleEffects.lua");

--Windows
GameWindow = nil;
GameSubWindow = nil;
Minigame = nil;
Container = nil;
Board = nil;
CursorLayer = nil;
Next = nil;
ComboText = nil;
GameOver = nil;
GameOverScore = nil;
ItemName = nil;
ItemIcon = nil;
ItemContainer = nil;
--ScoreContainer = nil;
GameOverText = nil;
HelpPageText = nil;
Pause = nil;
--Intro = nil;
InfoContainer = nil;
ParticleSystem = nil;
HighScore = nil;
HighScoreText = nil;
HighScoreNames = nil;
LevelUp = nil;
LevelUpText = nil;
NextLevelText = nil;
ParticleContainer = nil;
Overlay = nil;
ItemDot = nil;
ItemPercent = nil;
AutoPauseText = nil;
InfoText = nil;
Gate = nil;
Countdown = nil;
CountdownText = nil;

scoreDigit = nil;
scoreNumbers = {};
scoreJerk = {};
materials = {};
matTreads = nil;

--Gamestates for client
clientState = {};
clientState.gameType = GAMETYPES.SCORE;
clientState.nextRows = {};
clientState.init = false;
clientState.autoPause = false;
clientState.scoreAnim = false;
clientState.shine = false;
clientState.info = nil;
clientState.gateAnim = false;
clientState.jewels = {};
clientState.frozen = {};
clientState.melting = {};
clientState.reinforced = {};
clientState.halt = true;
clientState.countdown = false;
clientState.countdownFade = false;
clientState.gameOver = nil;
clientState.still = true;

--Sizes
TILE_SIZE = 36; --Tiles are square, this is their height and width
HALF_TILE_SIZE = 18;
BOARD_LEFT = nil;
BOARD_TOP = nil;
CNST_BOARD_TOP = nil;
MAP_LEFT = nil;
MAP_TOP = nil;
CNST_MAP_TOP = nil;
GATE_TOP = nil;

TREADS_FRAMES = nil;

TILES1 = {};
TILES2 = {};

falloffset = nil;
prevScore = nil;

cursor.spriteL = nil;
cursor.spriteR = nil;
cursor.x = nil;
cursor.y = nil;
cursor.graphic1 = nil;
cursor.graphic2 = nil;
cursor.reinforced1 = nil;
cursor.reinforced2 = nil;
cursor.mousex = 700;
cursor.mousey = 200;
cursor.danger = false;

spritelist = {};
emitterScore = {};

function MSG_EVENT(event)
   for messageName, messageFunction in pairs(MessageHandler) do
      if messageName == event.MsgName then
         messageFunction(event);
         break;
      end
   end
end
Events["MSG"] = MSG_EVENT;

function GM_MOUSEBTNDOWN(event)
   if (not cursor.pause and not cursor.help and not clientState.halt) then
      SendProcessMessage(Messages.StartSwap, {});
      startSwap();
   end
end
RegisteredEvents["GM_MOUSEBTNDOWN"] = GM_MOUSEBTNDOWN;

function GM_MOUSEBTNUP(event)
   if (advance) then
      SendProcessMessage(Messages.AdvanceOff, {});
      advance = false;
   end
end
RegisteredEvents["GM_MOUSEBTNUP"] = GM_MOUSEBTNUP;

function WB_BUTTONUP(event)
   if (event.Name == "PlayAgain") then
      SendProcessMessage(Messages.ResetGame, {});
   elseif (event.Name == "Quit") then
      EndGame();
   elseif(event.Name == "HelpNext") then
      help.current = help.current + 1;
      if (clientState.gameType == GAMETYPES.BASH) then
         if (help.current > help.bashMax) then
            help.current = help.bashMax;
         end
      else
         if (help.current > help.max) then
            help.current = help.max;
         end
      end
      UpdateHelp();
   elseif(event.Name == "HelpPrev") then
      help.current = help.current - 1;
      if (help.current < 1) then
         help.current = 1;
      end
      UpdateHelp();
   elseif (event.Name == "Pause") then
      if (not clientState.autoPause) then
         --SendProcessMessage(Messages.Pause, {});
         PauseToggle();
      end
   elseif (event.Name == "Stop" and not clientState.halt and not cursor.help) then
      SendProcessMessage(Messages.EndGame, {});
   elseif (event.Name == "ScoreButton") then
      local select = {};
      select.GameType = GAMETYPES.SCORE;
      SendProcessMessage(Messages.SelectGame, select);
   elseif (event.Name == "ItemButton") then
      local select = {};
      select.GameType = GAMETYPES.ITEM;
      SendProcessMessage(Messages.SelectGame, select);
   elseif (event.Name == "BucksButton") then
      local select = {};
      select.GameType = GAMETYPES.BUCKS;
      SendProcessMessage(Messages.SelectGame, select);
   elseif (event.Name == "HighScoreExit") then
      HighScore.ShowWindow(false);
   end
end

RegisteredEvents["WB_BUTTONUP"] = WB_BUTTONUP;

function WB_BUTTONDOWN(event)
   if (event.Name == "Fast") then
      SendProcessMessage(Messages.AdvanceOn, {});
      advance = true;
   end
end
RegisteredEvents["WB_BUTTONDOWN"] = WB_BUTTONDOWN;

function GM_KEYDOWN(event)
   if (event.Key == KP_Z) then
      --SendProcessMessage(Messages.AdvanceOn, {});
      advance = true;
   elseif (event.Key == KP_P) then
      --SendProcessMessage(Messages.Pause, {});
      PauseToggle();
   elseif (event.Key == KP_Q and not clientState.halt and not cursor.help) then
      -- Disable the 'Q' button to quit since we're not telling the player about that option
      --EndGame();
   end
end
RegisteredEvents["GM_KEYDOWN"] = GM_KEYDOWN;

function GM_KEYUP(event)
   if (event.Key == KP_Z) then
      --SendProcessMessage(Messages.AdvanceOff, {});
      advance = false;
   end
end
RegisteredEvents["GM_KEYUP"] = GM_KEYUP;

function GM_MOUSEMOVE(event)
   --Account for the cursor being two blocks wide
   cursor.mousex = event.X;
   cursor.mousey = event.Y;
   setCursorLocation(event.X, event.Y);
end
RegisteredEvents["GM_MOUSEMOVE"] = GM_MOUSEMOVE;

function CLIENT_STARTSWAP(event)
   startSwap();
end
--MessageHandler[Messages.StartSwap] = CLIENT_STARTSWAP;

--function CLIENT_PAUSEON(event)
   --TurnPauseOn();
--end
--MessageHandler[Messages.PauseOn] = CLIENT_PAUSEON;

--function CLIENT_PAUSEOFF(event)
   --TurnPauseOff();
--end
MessageHandler[Messages.PauseOff] = CLIENT_PAUSEOFF;

function CLIENT_ADVANCEON(event)
   advance = true;
end
--MessageHandler[Messages.AdvanceOn] = CLIENT_ADVANCEON;

function CLIENT_ADVANCEOFF(event)
   advance = false;
end
--MessageHandler[Messages.AdvanceOff] = CLIENT_ADVANCEOFF;

function CLIENT_GETROW(event)
   newRow = {};
   table.insert(newRow, event.Index1);
   table.insert(newRow, event.Index2);
   table.insert(newRow, event.Index3);
   table.insert(newRow, event.Index4);
   table.insert(newRow, event.Index5);
   table.insert(newRow, event.Index6);
   table.insert(newRow, event.Index7);
   table.insert(clientState.nextRows, newRow);
end
MessageHandler[Messages.SendRow] = CLIENT_GETROW;

function CLIENT_COUNTDOWN(event)
   clientState.countdown = true;
   clientState.init = false;
   --Countdown.ShowWindow(true);
   CountdownText.ShowWindow(true);   
   if (event.Number == 0) then
      --Countdown.GetMaterial().SetCurrentFrame(4);      
      CountdownText.SetText("<center><string;MinigamesCommon_Soblocks_Go></string></center>");
      clientState.countdownFade = 0;
      clientState.halt = false;
      ResetTimers();
      replaceSound(sounds.begin);
   elseif (event.Number == 4) then
      --Countdown.GetMaterial().SetCurrentFrame(4 - event.Number);
      CountdownText.SetText("<center><string;MinigamesCommon_Soblocks_Ready></string></center>");
      replaceSound(sounds.count);
   else
      --Countdown.GetMaterial().SetCurrentFrame(4 - event.Number);
      CountdownText.SetText(string.format("<center>%d</center>", event.Number));
      replaceSound(sounds.count);
      --if (event.Number == 3) then
      --   SendRowInfo();
      --end
   end
end
MessageHandler[Messages.Countdown] = CLIENT_COUNTDOWN;

function MoveDataUp(data)
   local i = nil;
   for i = 1, table.getn(data) do
      data[i].y = data[i].y - 1;
   end
end

function MoveFrozenDataUp(data)
   local i = nil;
   for i = 1, table.getn(data) do
      data[i].y = data[i].y - 1;
      if (data[i].y < MELT_ROW) then
         data[i].sprite.GetMaterial().SetRate(FROZEN_FPS);
         table.insert(clientState.melting, data[i]);
      end
   end
end

function pauseTimers()
   FallTimer:Pause();
   SwapFallTimer:Pause();
   RemoveTimer:Pause();
   AddTimer:Pause();
end

function resetHelp()
   help.current = 1;
   UpdateHelp();
end

function setCursorCell(tilex, tiley)
   --Check to see if cursor is in range... note that the x coordinate is handled differently because the swapping takes place between x and x + 1
   if (tilex < -1 or tilex > MAP_WIDTH_MINUS_ONE or tiley < 0 or tiley >= MAP_HEIGHT) then
      cursor.x = -1;
      cursor.y = -1;
      cursor.spriteL.ShowWindow(false);
      cursor.spriteR.ShowWindow(false);
      return false;
   elseif (tilex == -1) then
      tilex = 0;
   elseif (tilex == MAP_WIDTH_MINUS_ONE) then
      tilex = MAP_WIDTH_MINUS_TWO;
   end

   if (cursor.x == -1) then
      cursor.spriteL.ShowWindow(true);
      cursor.spriteR.ShowWindow(true);
   end

   cursor.x = tilex;
   cursor.y = tiley;
   x = tilex * TILE_SIZE - 1;
   y = tiley * TILE_SIZE - 1;
   cursor.spriteL.SetLocation(x, y);
   cursor.spriteR.SetLocation(x + TILE_SIZE, y);
   return true;
end

function setCursorLocation(x, y)
   --local tilex = math.floor((x - BOARD_LEFT) / TILE_SIZE - 0.5);
   --local tiley = math.floor((y - BOARD_TOP) / TILE_SIZE);
   local tilex = math.floor( Container.ScreenToWindowX( x ) / TILE_SIZE - 0.5);
   local tiley = math.floor( Container.ScreenToWindowY( y - falloffset ) / TILE_SIZE);
   
   return setCursorCell(tilex, tiley);
end

function replaceSound(sound, newSound, stop)
   if (sound.id) then
      StopSound(sound.id)
   end
   
   if (stop) then return; end
   
   if (newSound) then
      sound.id = PlaySound(newSound.filename, newSound.volume, newSound.pan, newSound.loopcount);
   else
      sound.id = PlaySound(sound.filename, sound.volume, sound.pan, sound.loopcount);
   end
end

function updateCombo()
   if (combo > 1) then
      ComboText.SetText("X"..combo);
      ComboText.ShowWindow(true);
      
      if     (combo == 2) then
         replaceSound(sounds.comboA);
      elseif (combo == 3) then
         replaceSound(sounds.comboA, sounds.comboB);
      elseif (combo == 4) then
         replaceSound(sounds.comboA, sounds.comboC);
      elseif (combo == 5) then
         replaceSound(sounds.comboA, sounds.comboD);
      else
         replaceSound(sounds.comboA, sounds.comboE);
      end
   else
      ComboText.SetText("");
      lastcombo = 0;
   end
  
   if (combo > lastcombo) then
      lastcombo = combo;  
      addCaption("<color;00D7FF><string;MinigamesCommon_Soblocks_Combo></string>", 0, PO.combo_offsety);      
      -- local emitter = CreateCombo();
      -- ParticleSystem.AttachEmitter(emitter);
      -- DestroyClass(emitter);
      -- emitter = nil;
   end
end

function isFalling(x, y)
   return isInData(swapfall, x, y) or isInData(fall, x, y);
end

--Checks to see if the 2D position exists in the data
function isInData(data, x, y)
   local i = nil;
   for i = 1, table.getn(data), 1 do
      if (data[i].x == x and data[i].y == y) then
         return data[i], i;
      end
   end
   return false;
end

function noSpacesBelow(x, y)
   local i = nil;
   for i = MAP_HEIGHT_MINUS_ONE, y + 1, -1 do
      if (Board.GetCell(x, i).GetTileIndex() == 0) then
         return false;
      end
   end
   return true;
end

function sortData(data1, data2)
   if (data1.y < data2.y) then
      return true;
   elseif (data1.y == data2.y) then
      if (data1.x < data2.x) then
         return true;
      end
   end
   return false;
end

function SetBoardLocation(y)
   --y should always be zero or negative
   BOARD_LEFT = GameSubWindow.GetLeft() + MAP_LEFT;
   CNST_BOARD_TOP = GameSubWindow.GetTop() + MAP_TOP;

   MAP_TOP = CNST_MAP_TOP + y;
   BOARD_TOP = CNST_BOARD_TOP + y;
   Next.SetLocation(0, CNST_MAP_BOTTOM + y);
   Board.SetLocation(0, y);
   CursorLayer.SetLocation(0, y);
   
   if (y < TILE_SIZE * -0.9) then
      Gate.SetLocation(0, GATE_TOP - 9 * (y + TILE_SIZE));
   else
      Gate.SetLocation(0, GATE_TOP + y);
   end
   
   matTreads.SetCurrentFrame(math.floor(TREADS_FRAMES * (-y / TILE_SIZE)));
   setCursorLocation(cursor.mousex, cursor.mousey);
   falloffset = y;
end

function giveItem()
   local player = OpenClass(GetClientCoreInstance(0));
   local IBid = GetBehavior("class SociaClientInventoryBehavior", player.GetGlobalID());
   DestroyClass(player);
   player = nil;
   local IB = OpenClass(IBid);
   IB.AddItemRequest(item.id, item.count);
   DestroyClass(IB);
   IB = nil;
end

function FillNextRowBuffer()
   local queue = table.getn(clientState.nextRows);
   if (queue < ROW_BUFFER) then
      for i = 1, ROW_BUFFER - queue do
         SendProcessMessage(Messages.RequestRow, {});
      end
   end
end

function KillOverlay(x, y)
   local reinforcedBlock = nil;
   local reinforcedIndex = nil;
   reinforcedBlock, reinforcedIndex = isInData(clientState.reinforced, x, y);
   if (reinforcedBlock) then
      DetachWindow(reinforcedBlock.sprite);
      local oldBlock = table.remove(clientState.reinforced, reinforcedIndex);
      DestroyClass(oldBlock.sprite); oldBlock = nil;
   end
   local frozenBlock = nil;
   local frozenIndex = nil;
   frozenBlock, frozenIndex = isInData(clientState.frozen, x, y);
   if (frozenBlock) then
      DetachWindow(frozenBlock.sprite);
      local oldBlock = table.remove(clientState.frozen, frozenIndex);
      DestroyClass(oldBlock.sprite); oldBlock = nil;
   end
end

function addBlocks()
   addARowOfBlocks();
end

function addARowOfBlocks()
   local i = nil;
   local j = nil;
   local index = nil;
   local check = {};

   if (table.getn(clientState.nextRows) < 1) then
      clientState.autoPause = true; --Need to wait for next buffer to fill!
      AutoPauseText.SetText("<center>Waiting for server to respond...</center>");
      AutoPauseText.ShowWindow(true);
      TurnPauseOn();
      return;
   end

   for i = 0, MAP_WIDTH_MINUS_ONE, 1 do
      if (Board.GetCell(i, 0).GetTileIndex() ~= 0) then
         clientState.gameOver = -GAMEOVER_WAIT;
         clientState.halt = true;
         replaceSound(sounds.background, nil, true);
         replaceSound(sounds.crash);
         Overlay.ShowWindow(true);
         cursor.spriteL.ShowWindow(false);
         cursor.spriteR.ShowWindow(false);
         FallTimer:Reset();
         SendProcessMessage(Messages.Loss, {});
         break;
      end
   end

   Board.MoveCells(MakeRectString(0, 1, MAP_WIDTH_MINUS_ONE, MAP_HEIGHT_MINUS_ONE),
                   MakePointString(0, -1));
  
   for i = 0, MAP_WIDTH_MINUS_ONE do
      addToData(check, i, MAP_HEIGHT_MINUS_ONE);
      Board.SetCell(i, MAP_HEIGHT_MINUS_ONE, Next.GetCell(i, 0).GetTileIndex());
   end
  
   if (not cursor.danger) then
      for i = 0, MAP_WIDTH_MINUS_ONE do
         index = Board.GetCell(i, DANGER_HEIGHT).GetTileIndex();
         if (index ~= 0 and index ~= REMOVE_BLOCK) then
            replaceSound(sounds.background, sounds.danger);
            cursor.danger = true;
            break;
         end
      end
   end

   if (cursor.swap and cursor.swapy) then
      cursor.swapy = cursor.swapy - 1;
   end

   MoveDataUp(removal);
   MoveDataUp(swapfall);
   MoveDataUp(fall);
   MoveFrozenDataUp(clientState.frozen);
   --MoveDataUp(clientState.melting);
   MoveDataUp(clientState.reinforced);
   if (timedBlocks) then
      MoveDataUp(timedBlocks);
   end

   for i = table.getn(clientState.reinforced), 1, -1 do
      local newReinforcedBlock = {};
      newReinforcedBlock.sprite = CreateSpriteClass("Soblocks/Reinforced.dds", MakeRectString(0,0,TILE_SIZE,TILE_SIZE), false, Board);
      newReinforcedBlock.sprite.SetLocation(clientState.reinforced[i].x * TILE_SIZE, clientState.reinforced[i].y * TILE_SIZE);
      newReinforcedBlock.sprite.ShowWindow(true);
      newReinforcedBlock.x = clientState.reinforced[i].x;
      newReinforcedBlock.y = clientState.reinforced[i].y;
      DetachWindow(clientState.reinforced[i].sprite);
      local oldBlock = table.remove(clientState.reinforced, i);
      DestroyClass(oldBlock.sprite); oldBlock = nil;      
      table.insert(clientState.reinforced, newReinforcedBlock);       
   end

   for i = table.getn(clientState.frozen), 1, -1 do
      local newFrozenBlock = {};
      newFrozenBlock.sprite = CreateSpriteClass("Soblocks/Remove.dds", MakeRectString(0,0,TILE_SIZE,TILE_SIZE), false, Board);
      newFrozenBlock.sprite.SetMaterial( CreateTileMaterialClass("Soblocks/Frozen.dds", FROZEN_FRAMES, 1) );
      newFrozenBlock.sprite.SetLocation(clientState.frozen[i].x * TILE_SIZE, clientState.frozen[i].y * TILE_SIZE);
      newFrozenBlock.sprite.ShowWindow(true);
      newFrozenBlock.x = clientState.frozen[i].x;
      newFrozenBlock.y = clientState.frozen[i].y;
      DetachWindow(clientState.frozen[i].sprite);
      local oldFrozenBlock = table.remove(clientState.frozen, i);
      newFrozenBlock.sprite.GetMaterial().SetRate(oldFrozenBlock.sprite.GetMaterial().GetRate());
      newFrozenBlock.sprite.GetMaterial().SetCurrentFrame(oldFrozenBlock.sprite.GetMaterial().GetCurrentFrame());
      DestroyClass(oldFrozenBlock.sprite); oldFrozenBlock = nil;
      table.insert(clientState.frozen, newFrozenBlock);
   end

   if (not clientState.gameOver) then
      local newRow = table.remove(clientState.nextRows, 1);
      for i = 1, MAP_WIDTH do
         newRow[i] = CheckForFrozenAndReinforced(newRow[i], i - 1);
         Next.SetCell1D(i - 1, newRow[i]);
      end
      SendProcessMessage(Messages.RequestRow, {});

      checkMatches(check, false);
   end
end

function CheckForFrozenAndReinforced(index, x)
   if (math.floor(index / REINFORCED_ALT) == 1) then
      local newReinforcedBlock = {};
      newReinforcedBlock.x = x;
      newReinforcedBlock.y = MAP_HEIGHT;
      index = index - REINFORCED_ALT;
      newReinforcedBlock.sprite = CreateSpriteClass("Soblocks/Reinforced.dds", MakeRectString(0,0,TILE_SIZE,TILE_SIZE), false, Next);
      newReinforcedBlock.sprite.SetLocation(x * TILE_SIZE, 0);
      newReinforcedBlock.sprite.ShowWindow(true);
      table.insert(clientState.reinforced, newReinforcedBlock);
   elseif (math.floor(index / FROZEN_ALT) == 1) then
      local newFrozenBlock = {};
      newFrozenBlock.x = x;
      newFrozenBlock.y = MAP_HEIGHT;
      index = index - FROZEN_ALT;
      newFrozenBlock.sprite = CreateSpriteClass("Soblocks/Remove.dds", MakeRectString(0,0,TILE_SIZE,TILE_SIZE), false, Next);
      newFrozenBlock.sprite.SetMaterial(CreateTileMaterialClass("Soblocks/Frozen.dds", FROZEN_FRAMES, 1));
      newFrozenBlock.sprite.GetMaterial().SetRate(0);
      newFrozenBlock.sprite.SetLocation(x * TILE_SIZE, 0);
      newFrozenBlock.sprite.ShowWindow(true);
      table.insert(clientState.frozen, newFrozenBlock);
   end
   return index;
end

function addABlock()
   local i = nil;
   local x = math.random(MAP_WIDTH) - 1;
   local check = {};
   
   if (Board.GetCell(x, 0).GetTileIndex() ~= 0) then
      EndGame();
      return;
   end

   for i = 0, MAP_HEIGHT_MINUS_TWO, 1 do
      Board.SetCell(x, i, Board.GetCell(x, i + 1).GetTileIndex());
      addToData(check, x, i);
   end
   Board.SetCell(x, MAP_HEIGHT_MINUS_ONE, math.random(NUM_FILES));
   addToData(check, x, MAP_HEIGHT_MINUS_ONE);
   checkMatches(check, false);
end

function checkForSafety()
   local i = nil;
   local j = nil;
   if (not cursor.danger) then return; end
   for i = 0, MAP_WIDTH_MINUS_ONE do
      for j = 0, DANGER_HEIGHT do
         if (Board.GetCell(i, j).GetTileIndex() ~= 0) then
            return;
         end
      end
   end   
   replaceSound(sounds.background);
   cursor.danger = false;
end

function setSpriteLocation(sprite, x, y, offset)
   sprite.SetLocation(x * TILE_SIZE - 1, y * TILE_SIZE - 1 + offset);
end

function makeBlocksFallGradually(data)
   if (table.getn(data) == 0) then return; end
   local x = nil;
   local y = nil;
   local index = nil;
   local offset = FallTimer:GetTime() / FALL_TIME * TILE_SIZE;
   
   for i = table.getn(data), 1, -1 do
      x = data[i].x;
      y = data[i].y - 1;
      index = data[i].index;
      if (data[i].sprite) then
         setSpriteLocation(data[i].sprite, x, y, offset);
      end
      if (data[i].frozen) then
         setSpriteLocation(data[i].frozen, x, y, offset);
      end
      if (data[i].reinforced) then
         setSpriteLocation(data[i].reinforced, x, y, offset);
      end
   end
end

function makeBlocksFall(data)
   if (table.getn(data) == 0) then return; end
   local x = nil;
   local y = nil;
   local switch = nil;
   local check = {};
   local otherdata = {};
   local temp = {};
   local sprite = {};
   local fastfall = data == swapfall;
   
   if (fastfall) then otherdata = fall;
   else otherdata = swapfall;
   end
   
   --Make sure we're checking the lowest blocks first... also sort by x for convenience
   temp = table.sort(data, sortData);
   
   for i = table.getn(data), 1, -1 do
      temp = table.remove(data, i);
      x = temp.x;
      y = temp.y;
      index = temp.index;
      sprite = temp.sprite;
      local frozen = temp.frozen;
      local reinforced = temp.reinforced;
     
      --We've sorted by y then x... so we can simply check the next element to see if it is the same
      if (i == 1 or data[i-1].x ~= x or data[i-1].y ~= y) then
         if (index == PLACEHOLDER) then
            temp = addToIndexedData(data, x, y, Board.GetCell(x, y).GetTileIndex());
         elseif (index == REMOVE_BLOCK) then
            --Do nothing
         elseif (y == MAP_HEIGHT_MINUS_ONE) then
            if (timedBlocks) then
               local timedBlock = isInData(timedBlocks, x, y);
               if (timedBlock) then
                  local currentFrame = Board.GetCell(x, y).GetCurrentFrame();
                  Board.SetCell(x, y, index);
                  Board.GetCell(x, y).SetCurrentFrame(currentFrame);
               else
                  Board.SetCell(x, y, index);
               end
            else
               Board.SetCell(x, y, index);
            end
            if (sprite) then
               DetachWindow(sprite);
               DestroyClass(sprite);
               sprite = nil;
            end
            if (frozen) then
               DetachWindow(frozen);
               frozen = nil;
               local frozenBlock = isInData(clientState.frozen, x, y);
               if (frozenBlock) then
                  frozenBlock.sprite.ShowWindow(true);
               end
            end
            if (reinforced) then
               DetachWindow(reinforced);
               reinforced = nil;
               local reinforcedBlock = isInData(clientState.reinforced, x, y);
               if (reinforcedBlock) then
                  reinforcedBlock.sprite.ShowWindow(true);
               end
            end
            addToData(check, x, y);
         elseif (Board.GetCell(x, y + 1).GetTileIndex() == PLACEHOLDER) then
            temp = addToIndexedData(data, x, y, index);
         elseif (isInData(data, x, y + 1)) then
            temp = addToIndexedData(data, x, y, index);
         elseif (isInData(otherdata, x, y + 1) and fastfall) then
            temp = addToIndexedData(fall, x, y, index);
            if (not sprite and index and index ~= 0 and index ~= PLACEHOLDER) then
            --???
               temp.sprite = createFallingSprite(x, y, index);
            end
         elseif (Board.GetCell(x, y + 1).GetTileIndex() == 0) then
            temp = addToIndexedData(data, x, y + 1, index);

            local frozenBlock = nil;
            frozenBlock = isInData(clientState.frozen, x, y);
            if (frozenBlock) then
               if (not fastfall) then
                  frozenBlock.sprite.ShowWindow(false);
               end
               frozenBlock.sprite.SetLocation(x * TILE_SIZE, (y + 1) * TILE_SIZE);
               frozenBlock.y = y + 1;
            end
            local reinforcedBlock = nil;
            reinforcedBlock = isInData(clientState.reinforced, x, y);
            if (reinforcedBlock) then
               if (not fastfall) then
                  reinforcedBlock.sprite.ShowWindow(false);
               end
               reinforcedBlock.sprite.SetLocation(x * TILE_SIZE, (y + 1) * TILE_SIZE);
               reinforcedBlock.y = y + 1;
            end

            local currentFrame = nil;
            if (timedBlocks) then
               local timedBlock = isInData(timedBlocks, x, y);
               if (timedBlock) then
                  if (Board.GetCell(x, y).GetTileIndex() == TIMED_BLOCK) then
                     currentFrame = Board.GetCell(x, y).GetCurrentFrame();
                     timedBlock.frame = currentFrame;
                  end
                  timedBlock.y = y + 1;
               end
            end
            
            if (fastfall) then
               Board.SetCell(x, y + 1, index);
               if (currentFrame) then
                  Board.GetCell(x, y + 1).SetCurrentFrame(currentFrame);
               end
            elseif (not sprite and index and index ~= 0 and index ~= PLACEHOLDER) then
               temp.sprite = createFallingSprite(x, y, index);
               
               if (frozenBlock) then
                  temp.frozen = createFallingSprite(x, y, FROZEN_ALT);
               end
               if (reinforcedBlock) then
                  temp.reinforced = createFallingSprite(x, y, REINFORCED_ALT);
               end
               
            end
            Board.SetCell(x, y, 0);
         else
            if (timedBlocks) then
               local timedBlock = isInData(timedBlocks, x, y);
               if (timedBlock) then
                  Board.SetCell(x, y, index);
                  Board.GetCell(x, y).SetCurrentFrame(timedBlock.frame);
               else
                  Board.SetCell(x, y, index);
               end
            else
               Board.SetCell(x, y, index);
            end

            if (sprite) then
               DetachWindow(sprite);
               DestroyClass(sprite);
               sprite = nil;
            end
            if (frozen) then
               DetachWindow(frozen);
               frozen = nil;
               local frozenBlock = isInData(clientState.frozen, x, y);
               if (frozenBlock) then
                  frozenBlock.sprite.ShowWindow(true);
               end
            end
            if (reinforced) then
               DetachWindow(reinforced);
               reinforced = nil;
               local reinforcedBlock = isInData(clientState.reinforced, x, y);
               if (reinforcedBlock) then
                  reinforcedBlock.sprite.ShowWindow(true);
               end
            end

            addToData(check, x, y);
         end
         if (sprite and temp) then
            temp.sprite = sprite;
            if (frozen) then
               temp.frozen = frozen;
            end
            if (reinforced) then
               temp.reinforced = reinforced;
            end
         end
      end     
   end
   if (table.getn(check) > 0) then
      replaceSound(sounds.land)
      checkMatches(check, data == fall);
      check = {};
   end
end

function createFallingSprite(x, y, index)
   local material = nil;
   local filename = "Soblocks/Remove.dds";
   local frame = nil;
   if (index > 0 and index <= NUM_TILES) then
      material = materials[index].default;
   elseif (index == FROZEN_ALT) then
      material = CreateTileMaterialClass("Soblocks/Frozen.dds", FROZEN_FRAMES, 1);
      material.SetRate(0);
   elseif (index == REINFORCED_ALT) then
      filename = "Soblocks/Reinforced.dds";
   elseif (index == TIMED_BLOCK) then
      material = CreateTileMaterialClass("Soblocks/Countdown.dds", TIMED_FRAMES, 1);
      frame = math.floor(Board.GetCell(x, y).GetCurrentFrame());
      material.SetCurrentFrame(frame);
      material.SetRate(0);
   else
      material = Board.GetTile(index).GetMaterial();
   end

   local sprite = CreateSpriteClass(filename, MakeRectString(0,0,TILE_SIZE,TILE_SIZE), false, Board);
   if (material) then
      sprite.SetMaterial(material);
   end
   setSpriteLocation(sprite, x, y, 0);
   sprite.ShowWindow(true);
   table.insert(spritelist, sprite);
   return sprite;
end

function AddIfNotARepeat(data, index)
   local i = nil;
   i = 1, table.getn(data) do
      if (data[i] == index) then
         return false;
      end
   end
   table.insert(data, index);
   return true;
end

function AddToDestroy(data, index1, index2)
   if (TheseMatch(index1, index2)) then
      if (index1 > NUM_TILES and index1 <= LAST_BOMB) then
         AddIfNotARepeat(data, index1 - NUM_TILES);
      elseif (index1 > 0 and index1 <= NUM_TILES) then
         AddIfNotARepeat(data, index1);
      elseif (index2 > NUM_TILES and index2 <= LAST_BOMB) then
         AddIfNotARepeat(data, index2 - NUM_TILES);
      elseif (index2 > 0 and index2 <= NUM_TILES) then
         AddIfNotARepeat(data, index2);
      end
   end
end

function JewelMatches(data, newData)
   local x = nil;
   local y = nil;
   local index1 = nil;
   local index2 = nil;
   local i = nil;
   local jewelCount = table.getn(clientState.jewels);
   local destroy = {};
   
   if (jewelCount < 1) then return end;
   for i = 1, jewelCount do
      x = clientState.jewels[i].x;
      y = clientState.jewels[i].y;
      --Log(x..","..y);
      --Sleep(5);
      --Check above jewel
      if (y > 1) then
         index1 = Board.GetCell(x, y - 1).GetTileIndex();
         index2 = Board.GetCell(x, y - 2).GetTileIndex(); 
         AddToDestroy(destroy, index1, index2);
      end
      --Check below jewel
      if (y < MAP_HEIGHT_MINUS_TWO) then
         index1 = Board.GetCell(x, y + 1).GetTileIndex();
         index2 = Board.GetCell(x, y + 2).GetTileIndex(); 
         AddToDestroy(destroy, index1, index2);
      end
      --Check left of jewel
      if (x > 1) then
         index1 = Board.GetCell(x - 1, y).GetTileIndex();
         index2 = Board.GetCell(x - 2, y).GetTileIndex(); 
         AddToDestroy(destroy, index1, index2);
      end
      --Check right of jewel
      if (x < MAP_WIDTH_MINUS_TWO) then
         index1 = Board.GetCell(x + 1, y).GetTileIndex();
         index2 = Board.GetCell(x + 2, y).GetTileIndex(); 
         AddToDestroy(destroy, index1, index2);
      end
      if ( x > 0 and x < MAP_WIDTH_MINUS_ONE) then
         index1 = Board.GetCell(x - 1, y).GetTileIndex();
         index2 = Board.GetCell(x + 1, y).GetTileIndex(); 
         AddToDestroy(destroy, index1, index2);
      end
      if ( y > 0 and y < MAP_HEIGHT_MINUS_ONE) then
         index1 = Board.GetCell(x, y - 1).GetTileIndex();
         index2 = Board.GetCell(x, y + 1).GetTileIndex(); 
         AddToDestroy(destroy, index1, index2);
      end
   end

   --Start at bottom left
   for y = MAP_HEIGHT_MINUS_ONE, 0, -1 do
      for x = 0, MAP_WIDTH_MINUS_ONE do
         for i = 1, table.getn(destroy) do
            index = Board.GetCell(x, y).GetTileIndex();
            if ((index == destroy[i] or index == BOMBS[destroy[i]]) and not isInData(data, x, y)) then
               addToData(newData, x, y);
            end
         end
      end
   end
   --clientState.jewels = {};
end

--Removes destroyed blocks after they've existed long enough
function removeBlocksLater()
   local i = nil;
   for i = table.getn(removal), 1, -1 do
      if (GetTime() > removal[i].birth + REMOVE_TIME) then
         Board.SetCell(removal[i].x, removal[i].y, 0);
         addAboveUntilBlank(fall, removal[i].x, removal[i].y);
         table.remove(removal, i);
      end
   end
end

--Replaces matched block with X blocks to be removed
function removeMatchedBlocks(matches, noScore)
   local i = nil;
   local x = nil;
   local y = nil;
   local numblocks = table.getn(matches);
   local reinforcedMatches = {};
   local reinforcedCount = 0;
   local rockDrop = false;
   local freezeBlocks = 0;
   local clockBlocks = 0;
   
   if (numblocks < 1) then return; end
   notAtRest();
   for i = numblocks, 1, -1 do
      x = matches[i].x;
      y = matches[i].y;
      local emitter = CreatePop(x * TILE_SIZE + BOARD_LEFT + HALF_TILE_SIZE, y * TILE_SIZE + BOARD_TOP + HALF_TILE_SIZE, Board.GetCell(x, y).GetTileIndex());
      ParticleSystem.AttachEmitter(emitter);
      DestroyClass(emitter);
      emitter = nil;
      local reinforcedBlock = nil;
      local reinforcedIndex = nil;
      reinforcedBlock, reinforcedIndex = isInData(clientState.reinforced, x, y);
      if (reinforcedBlock) then
         reinforcedCount = reinforcedCount + 1;
         local emitter = CreateLightSpark(x * TILE_SIZE + BOARD_LEFT + HALF_TILE_SIZE, y * TILE_SIZE + BOARD_TOP + HALF_TILE_SIZE);
         ParticleSystem.AttachEmitter(emitter);
         DestroyClass(emitter);
         emitter = nil;
         DetachWindow(reinforcedBlock.sprite);
         DestroyClass(reinforcedBlock.sprite);
         local oldBlock = table.remove(clientState.reinforced, reinforcedIndex);
         DestroyClass(oldBlock.sprite); oldBlock = nil; 
         if (noSpacesBelow(x, y)) then
            addToData(reinforcedMatches, x, y);
         end
      else
         local index = nil;
         index = Board.GetCell(x, y).GetTileIndex();
         if (index == STONE_BLOCK) then
            rockDrop = true;
         elseif (index == ICECUBE_BLOCK) then
            freezeBlocks = freezeBlocks + 1;
         elseif (index == CLOCK_BLOCK) then
            clockBlocks = clockBlocks + 1;
         elseif (index > NUM_TILES and index <= LAST_BOMB) then
            local j = nil;
            local k = nil;
            local blastRadius = 1;
            if (numblocks > 4) then blastRadius = 2; end
            local minx = x - blastRadius;
            local miny = y - blastRadius;
            local maxx = x + blastRadius;
            local maxy = y + blastRadius;
            if (minx < 0) then minx = 0; end
            if (miny < 0) then miny = 0; end
            if (maxx > MAP_WIDTH_MINUS_ONE) then maxx = MAP_WIDTH_MINUS_ONE; end
            if (maxy > MAP_HEIGHT_MINUS_ONE) then maxy = MAP_HEIGHT_MINUS_ONE; end
            for j = minx, maxx do
               for k = miny, maxy do
                  index = Board.GetCell(j, k).GetTileIndex();
                  if (index ~= 0 and index ~= PLACEHOLDER and index ~= REMOVE_BLOCK) then
                     Board.SetCell(j, k, REMOVE_BLOCK);
                     addToTimedData(removal, j, k);
                     KillOverlay(j, k);
                  end
               end
            end
         end
         if (Board.GetCell(x, y).GetTileIndex() ~= REMOVE_BLOCK) then
            Board.SetCell(x, y, REMOVE_BLOCK);
            addToTimedData(removal, x, y);
         end
      end
      local frozenBlock = nil;
      local frozenIndex = nil;
      frozenBlock, frozenIndex = isInData(clientState.frozen, x, y);
      if (frozenBlock) then
         DetachWindow(frozenBlock.sprite);
         local oldBlock = table.remove(clientState.frozen, frozenIndex);
         DestroyClass(oldBlock.sprite); oldBlock = nil;
      end
      table.remove(matches);
   end

   if (clientState.gameType == GAMETYPES.BASH) then
      local attacknum = 0;
      if (combo > 1 or numblocks == 4 or numblocks == 5) then
         attacknum = combo - clockBlocks - freezeBlocks;
      elseif (numblocks > 5) then
         attacknum = math.floor(numblocks * 0.34) * combo - clockBlocks - freezeBlocks;
      end
      if (rockdrop) then attacknum = attacknum - 3; end
      
      local attackBool = false;
      if (attacknum > 0) then
         SendProcessMessage(Messages.Attack, {Index1 = attacknum});
         attackBool = true;
      end
      if (clockBlocks > 0) then
         SendProcessMessage(Messages.TimedDrop, {Index1 = clockBlocks});
         attackBool = true;
      end
      if (freezeBlocks > 0) then
         SendProcessMessage(Messages.FreezeBlocks, {Amount = freezeBlocks});
         attackBool = true;
      end
      if (rockDrop) then
         SendProcessMessage(Messages.RockDrop, {});
         attackBool = true;
      end

      if (attackBool) then
         CreateBashFirework(x, y);
      end
   end
   
   if (not noScore) then
      AddToScore(numblocks, false, reinforcedCount);
      if (numblocks > 3 or combo > 1) then
         CreateScoreFirework(x, y, (numblocks - 1) * (1 + combo * 0.5));
      else
         UpdateScore(score);
      end
      if (numblocks > 3) then
         combotime = combotime + MULTI_TIME;
         ComboTimer:Reset();
      end
   end
   checkMatches(reinforcedMatches);
end

function enoughToMatch(destination, source, orientation, enough)
   --Must be at least three in a row otherwise we don't have a match
   local i = nil;
   local matching = table.getn(source);
   if (matching >= 3 or (enough and matching == 2)) then
      for i = matching, 1, -1 do
         source[i].matchflag = orientation;
         if (not isInData(destination, source[i].x, source[i].y)) then
            table.insert(destination, table.remove(source));
         end
      end
      return true;
   end
   return false;
end

--Adds 2D position data with an index to a table
function addToIndexedData(data, x, y, index)
   local temp = {};
   temp.x = x;
   temp.y = y;
   temp.index = index;
   table.insert(data, temp);
   return temp;
end

--Adds 2D position data and birth time to a table
function addToTimedData(data, x, y)
   local temp = {};
   temp.x = x;
   temp.y = y;
   temp.birth = GetTime();
   table.insert(data, temp);
   return temp;
end

--Adds 2D position data to a table
function addToData(data, x, y)
   local temp = {};
   temp.x = x;
   temp.y = y;
   table.insert(data, temp);
   return temp;
end

function AddMatchesAbove(data, x, y)
   local index = Board.GetCell(x, y).GetTileIndex();
   local previous = index;
   local twoBefore = nil;
   local wildcard = nil;
   local check = nil;
   if (index == 0 or index == REMOVE_BLOCK) then return; end
   repeat
      y = y - 1;
      if (y < 0) then break; end
      check = AddMatch(data, x, y, previous, twoBefore);
      if (IsWildcard(index) and not wildcard) then wildcard = check; end
      twoBefore = previous;
      previous = check;
   until not check;
   return wildcard;
end

function AddMatchesBelow(data, x, y, wildcard)
   local index = Board.GetCell(x, y).GetTileIndex();
   local previous = index;
   local twoBefore = nil;
   local threeBefore = nil;
   local check = nil;
   if (index == 0 or index == REMOVE_BLOCK) then return; end
   repeat
      y = y + 1;
      if (y > MAP_HEIGHT_MINUS_ONE) then
         break;
      end
      check = AddMatch(data, x, y, previous, twoBefore, wildcard);
      wildcard = nil;
      threeBefore = twoBefore;
      twoBefore = previous;
      previous = check;
   until not check;
   return;
end

function AddMatchesLeft(data, x, y, enough)
   local index = Board.GetCell(x, y).GetTileIndex();
   local previous = index;
   local twoBefore = nil;
   local wildcard = nil;
   local check = nil;
   if (index == 0 or index == REMOVE_BLOCK) then return; end
   repeat
      x = x - 1;
      if (x < 0) then break; end
      check = AddMatch(data, x, y, previous, twoBefore, false, enough);
      if (IsWildcard(index) and not wildcard) then wildcard = check; end
      twoBefore = previous;
      previous = check;
   until not check;
   return wildcard;
end

function AddMatchesRight(data, x, y, wildcard, enough)
   local index = Board.GetCell(x, y).GetTileIndex();
   local previous = index;
   local twoBefore = nil;
   local threeBefore = nil;
   local check = nil;
   if (index == 0 or index == REMOVE_BLOCK) then return; end
   repeat
      x = x + 1;
      if (x > MAP_WIDTH_MINUS_ONE) then break; end
      check = AddMatch(data, x, y, previous, twoBefore, wildcard, enough);
      wildcard = nil;
      threeBefore = twoBefore;
      twoBefore = previous;
      previous = check;
   until not check;
   if (table.getn(data) > 3 and IsWildcard(threeBefore) and not TheseMatch(twoBefore, previous)) then
      local oldData = table.remove(data);
      DestroyClass(oldData.sprite); oldData = nil;
   end
   return;
end

function IsWildcard(index)
   return index == PINWHEEL_BLOCK or index == JEWEL_BLOCK;
end

function TheseMatch(index1, index2)
   if (not index1 or not index2 or index1 == 0 or index2 == 0 or index1 == ROCK or index2 == ROCK or
         index1 == TIMED_BLOCK or index2 == TIMED_BLOCK) then
      return false;
   elseif (index1 == PINWHEEL_BLOCK or index2 == PINWHEEL_BLOCK or index1 == JEWEL_BLOCK or index2 == JEWEL_BLOCK or
         index1 == index2) then
      return true;
   elseif (index1 > 0 and index1 <= NUM_TILES and index2 == BOMBS[index1]) then
      return true;
   elseif (index2 > 0 and index2 <= NUM_TILES and index1 == BOMBS[index2]) then
      return true;
   else
      return false;
   end
end

function AddMatch(data, x, y, previous, twoBefore, wildcard, enough)
   local index = Board.GetCell(x, y).GetTileIndex();
   
   if (index == 0 or index == REMOVE_BLOCK) then
      return false;
   elseif (index == JEWEL_BLOCK) then
      if (not isInData(clientState.jewels, x, y)) then
         addToData(clientState.jewels, x, y);
      end
   end
   
   if (IsWildcard(previous)) then
      local dataSize = table.getn(data);
      if (wildcard and dataSize < 3 and (dataSize < 2 or not enough) and not TheseMatch(index, wildcard)) then
         local oldData = table.remove(data);
         DestroyClass(oldData.sprite); oldData = nil;
      elseif (not wildcard and twoBefore and not TheseMatch(index, twoBefore)) then
         return false;
      end
      addToData(data, x, y);
   elseif (TheseMatch(index, previous)) then
      addToData(data, x, y);
   else
      return false;
   end
   
   return index;
end

function checkMatches(data, addcombo)
   local i = nil;
   local x = nil;
   local y = nil;
   local matchflag = nil;
   local item = {};
   local temp = {};
   local matches = {};
   local enough = nil;
   local prevcombo = combo;
   local wildcard = nil;
   
   clientState.jewels = {};
   
   for i = 1, table.getn(data), 1 do
      x = data[i].x;
      y = data[i].y;
      item = isInData(matches, x, y);
      local checkIndex = Board.GetCell(x, y).GetTileIndex();
      if (checkIndex == JEWEL_BLOCK) then
         if (not isInData(clientState.jewels, x, y)) then
            addToData(clientState.jewels, x, y);
         end
      end
      if (not item or IsWildcard(checkIndex)) then
         --Checks above block
         addToData(temp, x, y);
         wildcard = AddMatchesAbove(temp, x, y);

         --Checks below block
         AddMatchesBelow(temp, x, y, wildcard);
         enough = enoughToMatch(matches, temp, VERTICAL);
         temp = {};

         --Add only one to combo per set of falling blocks
         if (addcombo and enough) then
            combo = prevcombo + 1;
            updateCombo();
         elseif (enough and combo < 1) then
            combo = 1;
         end
         
         --Checks left of block
         if (not enough) then addToData(temp, x, y); end
         wildcard = AddMatchesLeft(temp, x, y, enough);
         AddMatchesRight(temp, x, y, wildcard, enough);
         enough = enoughToMatch(matches, temp, HORIZONTAL, enough);
         temp = {};

         if (addcombo and enough) then
            combo = prevcombo + 1;
            updateCombo();
         elseif (enough and combo < 1) then
            combo = 1;
         end
      --elseif (item.matchflag == HORIZONTAL) then
         --This block has already been used for a horizontal match... check for additional matches vertically only
         --AddMatchesAbove(temp, x, y);
         --AddMatchesBelow(temp, x, y);
         --enough = enoughToMatch(matches, temp, VERTICAL, true);
         --temp = {};
      --elseif (item.matchflag == VERTICAL) then
         --Vertical match already made, check horizontal
         --AddMatchesLeft(temp, x, y);
         --AddMatchesRight(temp, x, y);
         --enough = enoughToMatch(matches, temp, HORIZONTAL, true);
         --temp = {};
      end
      temp = {};
   end
      
   if (table.getn(matches) > 0) then
      replaceSound(sounds.glass);
      local destroy = {};
      JewelMatches(matches, destroy);
      removeMatchedBlocks(matches);
      removeMatchedBlocks(destroy, true);
   end
   clientState.jewels = {};
end

--This function adds blocks above a gap to a table so they will fall
function addAboveUntilBlank(data, x, y)
   local i = nil;
   local index = nil;
   local added = false;
   
   for i = y - 1, 0, -1 do
      index = Board.GetCell(x, i).GetTileIndex();
      if (index == 0 or index == REMOVE_BLOCK) then
         return added;
      else
         --May be possible that something is in fall and swapfall at the same time...
         addToIndexedData(data, x, i, index);
         added = true;
      end
   end
   
   return added;
end

function startSwap()
   if (cursor.x ~= -1 and not cursor.swap) then
      cursor.swap = 0;
   end
end

function swapBlocks()
   local x = cursor.x;
   local y = cursor.y;
   
   if (x < 0 or x > MAP_WIDTH_MINUS_TWO or y < 0 or y > MAP_HEIGHT_MINUS_ONE or 
            isInData(clientState.frozen, x, y) or isInData(clientState.frozen, x + 1, y)) then
      cursor.swap = nil;
      return false;
   end
   
   local switch1 = Board.GetCell(x, y).GetTileIndex();
   local switch2 = Board.GetCell(x + 1, y).GetTileIndex();
   local tilex = nil;
   local tiley = nil;
   
   if (isInData(swapfall, x, y) or isInData(swapfall, x + 1, y)) then
      cursor.swap = nil;
      return false;
   end

   if (isInData(fall, x, y) or isInData(fall, x + 1, y)) then
      cursor.swap = nil;
      return false;
   end
   
   if (switch1 == REMOVE_BLOCK or switch2 == REMOVE_BLOCK or switch1 == PLACEHOLDER or switch2 == PLACEHOLDER) then
      cursor.swap = nil;
      return false;
   end

   local frame1 = nil; --For timed blocks
   local frame2 = nil;

   if (timedBlocks) then
      local timedBlock1 = isInData(timedBlocks, x, y);
      local timedBlock2 = isInData(timedBlocks, x + 1, y);
      if (timedBlock1) then
         timedBlock1.x = x + 1;
         timedBlock1.frame = Board.GetCell(x, y).GetCurrentFrame();
      end
      if (timedBlock2) then
         timedBlock2.x = x;
         timedBlock2.frame = Board.GetCell(x + 1, y).GetCurrentFrame();
      end
   end
   
   
   if (switch2 ~= 0) then
      if (switch2 == TIMED_BLOCK) then
         frame2 = math.floor(Board.GetCell(x + 1, y).GetCurrentFrame());
      end
      Board.SetCell(x, y, PLACEHOLDER);
   else
      Board.SetCell(x, y, 0);
   end
   if (switch1 ~= 0) then
      if (switch1 == TIMED_BLOCK) then
         frame1 = math.floor(Board.GetCell(x, y).GetCurrentFrame());
      end
      Board.SetCell(x + 1, y, PLACEHOLDER);
   else
      Board.SetCell(x + 1, y, 0);
   end
   
   cursor.swapx = x;
   cursor.swapy = y;
   cursor.index1 = switch1;
   cursor.index2 = switch2;
   
   if (switch1 ~= 0 or switch2~= 0) then
      replaceSound(sounds.swap);
   end
   
   tilex = x * TILE_SIZE - 1;
   tiley = y * TILE_SIZE - 1;
   
   if (switch2 ~= 0) then
      cursor.graphic2 = TILES2[switch2];
      if (frame2) then
         cursor.graphic2.GetMaterial().SetCurrentFrame(frame2);
      end
      cursor.graphic2.SetLocation(tilex + TILE_SIZE, tiley + falloffset);
      cursor.graphic2.ShowWindow(true);
      local reinforcedBlock = isInData(clientState.reinforced, x + 1, y);
      if (reinforcedBlock) then
         cursor.reinforced2.SetLocation(tilex + TILE_SIZE, tiley + falloffset);
         cursor.reinforced2.ShowWindow(true);
         reinforcedBlock.sprite.ShowWindow(false);
      end
   end
   if (switch1 ~= 0) then
      cursor.graphic1 = TILES1[switch1];
      if (frame1) then
         cursor.graphic1.GetMaterial().SetCurrentFrame(frame1);
      end
      cursor.graphic1.SetLocation(tilex, tiley + falloffset);
      cursor.graphic1.ShowWindow(true);
      local reinforcedBlock = isInData(clientState.reinforced, x, y);
      if (reinforcedBlock) then
         cursor.reinforced1.SetLocation(tilex, tiley + falloffset);
         cursor.reinforced1.ShowWindow(true);
         reinforcedBlock.sprite.ShowWindow(false);
      end
   end
   return 1;
end

function finishSwap()
   local x = cursor.swapx;
   local y = cursor.swapy;
   local switch1 = cursor.index1;
   local switch2 = cursor.index2;

   Board.SetCell(x, y, switch2);
   Board.GetCell(x, y).SetCurrentFrame(cursor.graphic2.GetMaterial().GetCurrentFrame());
   Board.SetCell(x + 1, y, switch1);
   Board.GetCell(x + 1, y).SetCurrentFrame(cursor.graphic1.GetMaterial().GetCurrentFrame());

   --See if there's a gap below the newly swapped blocks
   local float1 = nil;
   local float2 = nil;
   if (y < MAP_HEIGHT_MINUS_ONE) then
      float1 = Board.GetCell(x, y + 1).GetTileIndex() == 0;
      float2 = Board.GetCell(x + 1, y + 1).GetTileIndex() == 0;
   end
   
   local reinforcedBlock1 = isInData(clientState.reinforced, x, y);
   local reinforcedBlock2 = isInData(clientState.reinforced, x + 1, y);
   if (reinforcedBlock1) then
      reinforcedBlock1.x = x + 1;
      reinforcedBlock1.sprite.SetLocation(reinforcedBlock1.x * TILE_SIZE, reinforcedBlock1.y * TILE_SIZE);
      reinforcedBlock1.sprite.ShowWindow(true);
   end
   if (reinforcedBlock2) then
      reinforcedBlock2.x = x;
      reinforcedBlock2.sprite.SetLocation(reinforcedBlock2.x * TILE_SIZE, reinforcedBlock2.y * TILE_SIZE);
      reinforcedBlock2.sprite.ShowWindow(true);
   end
   if (cursor.reinforced1) then
      cursor.reinforced1.ShowWindow(false);
   end
   if (cursor.reinforced2) then
      cursor.reinforced2.ShowWindow(false);
   end

   --TODO: Clean this mess up
   if (switch1 == switch2) then
      --Do nothing
   elseif (switch2 == 0) then
      --We're swapping a blank tile with a block... need to make blocks above the gap fall and update # of blocks in each column
      if (addAboveUntilBlank(swapfall, x, y)) then
         notAtRest();
      end
      if (float2) then
         addToIndexedData(swapfall, x + 1, y, switch1);
         notAtRest();
      else
         local data = {};
         addToData(data, x + 1, y);
         checkMatches(data);
      end
   elseif (switch1 == 0) then
      if (addAboveUntilBlank(swapfall, x + 1, y)) then
         notAtRest();
      end
      if (float1) then
         addToIndexedData(swapfall, x, y, switch2);
         notAtRest();
      else
         local data = {};
         addToData(data, x, y);
         checkMatches(data);
      end
   else
      --For previous cases or floating there should be no matching until the blocks land
      local data = {};
      
      if (float1) then
         addToIndexedData(swapfall, x, y, switch2);
         notAtRest();
      else
         addToData(data, x, y);
      end
      
      if (float2) then
         addToIndexedData(swapfall, x + 1, y, switch1);
         notAtRest();
      else
         addToData(data, x + 1, y);
      end
      
      checkMatches(data);
   end
end

function notAtRest()
   if (atrest) then
      combotime = combotime - ComboTimer:GetTime();
      if (combotime < -1) then combotime = -1; end
      ComboTimer:Reset();
   end
   atrest = false;
end

function isAtRest()
   local i = nil;
   --Check for blocks to be removed or ones falling
   if (table.getn(removal) > 0 or table.getn(fall) > 0 or table.getn(swapfall) > 0 or cursor.swap) then
      return false;
   end
   
   --Double check for annoying, persistent floating blocks
   local row = nil;
   local col = nil;
   local foundGap = false;
   for row = 0, MAP_HEIGHT_MINUS_TWO do
      for col = 0, MAP_WIDTH_MINUS_ONE do
         if (Board.GetCell(col, row).GetTileIndex() ~= 0) then
            if (Board.GetCell(col, row + 1).GetTileIndex() == 0) then
               --Make it and anything above the gap fall
               addAboveUntilBlank(fall, col, row + 1);
               foundGap = true;
            end
         end
      end
   end
   
   if (foundGap) then
      return false;
   end
   
   if (combo > 1) then
      combotime = combotime + COMBO_TIME * (combo - 1);
      ComboTimer:Reset();
   end
   
   ComboTimer:Reset();
   AddTimer:Reset();
   combo = 0;
   updateCombo();
   
   if (cursor.levelup == 0) then
      clientState.halt = true;
      cursor.spriteL.ShowWindow(false);
      cursor.spriteR.ShowWindow(false);

      --if (cursor.pause) then
         --SendProcessMessage(Messages.Pause, {});
      --end
      TurnPauseOff();
   end
   
   return true;
end

function animateSwap()
   if (cursor.swap >= SWAP_TIME) then
      cursor.graphic1.ShowWindow(false);
      cursor.graphic2.ShowWindow(false);
      finishSwap();
      cursor.swap = nil;
      return;
   end
   
   local offset = FallTimer:GetTime() / FALL_TIME * TILE_SIZE;
   local ratio = cursor.swap / SWAP_TIME;
   local posx = (cursor.swapx + ratio) * TILE_SIZE - 1;
   local vert = 0.5 * math.sin(ratio * math.pi);
   local posy = (cursor.swapy - vert) * TILE_SIZE - 1 + falloffset;

   if (cursor.graphic1) then
      if (cursor.index2 == 0) then cursor.graphic1.SetLocation(posx, posy);
      else cursor.graphic1.SetLocation(posx, (cursor.swapy + vert) * TILE_SIZE - 1 + falloffset);
      end
   end
   if (cursor.graphic2) then
      cursor.graphic2.SetLocation((cursor.swapx + 1 - ratio) * TILE_SIZE - 1, posy);
   end
   if (cursor.reinforced1) then
      if (cursor.index2 == 0) then cursor.reinforced1.SetLocation(posx, posy);
      else cursor.reinforced1.SetLocation(posx, (cursor.swapy + vert) * TILE_SIZE - 1 + falloffset);
      end
   end
   if (cursor.reinforced2) then
      cursor.reinforced2.SetLocation((cursor.swapx + 1 - ratio) * TILE_SIZE - 1, posy);
   end
end

function ResetTimers()
   FallTimer:Reset();
   SwapFallTimer:Reset();
   RemoveTimer:Reset();
   AddTimer:Reset();
   ComboTimer:Reset();
end

function BuildBoard()
   local i = nil;
   local j = nil;
   local row = nil;

   for i = MAP_HEIGHT - STARTING_HEIGHT, MAP_HEIGHT_MINUS_ONE do
      row = table.remove(clientState.nextRows, 1);
      for j = 0, MAP_WIDTH_MINUS_ONE do
         Board.SetCell(j, i, row[j+1]);
      end
   end

   row = table.remove(clientState.nextRows, 1);
   for j = 0, MAP_WIDTH_MINUS_ONE do
      local index = CheckForFrozenAndReinforced(row[j+1], j);
      Next.SetCell1D(j, index);
   end
   
   --Board.SetCell(0, 10, TILES.white);
   --Board.SetCell(1, 10, TILES.orange);
   --Board.SetCell(2, 10, PINWHEEL_BLOCK);
   --Board.SetCell(3, 10, TILES.white);
   --Board.SetCell(4, 10, TILES.white);
   --Board.SetCell(5, 10, TILES.white);
   --Board.SetCell(6, 10, TILES.white);

   --Board.SetCell(3, 12, TILES.white);
   --Board.SetCell(3, 14, TILES.white);
   --Board.SetCell(1, 13, TILES.orange);
   --Board.SetCell(2, 13, TILES.orange);
   --Board.SetCell(4, 13, PINWHEEL_BLOCK);
   clientState.init = false;
   
   SendProcessMessage(Messages.Countdown, {});
end

function UpdateBoard()
   local i = nil;

   --Shine on, you crazy diamond
   --TODO: When ControlTileMap animation gets fixed, fix SHINE_FRAMES_MINUS_ONE - 1
   if (clientState.shine and ShineTimer:GetTime() > (SHINE_FRAMES_MINUS_ONE - 1) / SHINE_FPS * 1000) then
      for i = 1, NUM_TILES do
         Board.GetTile(i).SetMaterial(materials[i].default);
      end
      clientState.shine = false;
      ShineTimer:Reset();
   elseif (not clientState.shine and ShineTimer:GetTime() > SHINE_INTERVAL) then
      for i = 1, NUM_TILES do
         Board.GetTile(i).SetMaterial(materials[i].shine);
      end
      clientState.shine = true;
      ShineTimer:Reset();
   end

   if (not clientState.gameOver) then
      for i = table.getn(clientState.melting), 1, -1 do
         local index = nil;
         local fBlock = nil;
         fBlock, index = isInData(clientState.frozen, clientState.melting[i].x, clientState.melting[i].y);
         if (fBlock and fBlock.sprite.GetMaterial().GetCurrentFrame() == FROZEN_FRAMES - 2) then
            DetachWindow(fBlock.sprite);
            local oldFrozenBlock = table.remove(clientState.frozen, index);
            local oldMeltingBlock = table.remove(clientState.melting, i);
            DestroyClass(oldFrozenBlock.sprite); oldFrozenBlock = nil;
            DestroyClass(oldMeltingBlock.sprite); oldMeltingBlock = nil;
         end
      end
   end
      
   if (clientState.countdown) then
      if (clientState.info ~= 1) then
         local thisInfo = info;
         if (clientState.gameType == GAMETYPES.BASH) then
            thisInfo = bashInfo;
         end
         clientState.info = 1;
         InfoText.SetText(thisInfo[clientState.info]);
      end

      if (clientState.countdownFade) then
         clientState.countdownFade = clientState.countdownFade + InfoTimer:GetTime();
         InfoTimer:Reset();
         if (clientState.countdownFade > 1000) then
            clientState.countdown = false;
            clientState.countdownFade = false;
            --Countdown.ShowWindow(false);
            CountdownText.ShowWindow(false);
         end
      else
         if (InfoTimer:GetTime() > 500) then
            SendProcessMessage(Messages.Countdown, {})
            InfoTimer:Reset();
         end
         return false;
      end
   end

   if (clientState.gameOver and clientState.gameOver < 0) then
      clientState.gameOver = clientState.gameOver + FallTimer:GetTime();
      if (clientState.gameOver > 0) then
         clientState.gameOver = 0;
      end
      FallTimer:Reset();
      return;
   elseif (clientState.gameOver and FallTimer:GetTime() > FRAME_THROTTLE) then
      FallTimer:Reset();
      local x = math.fmod(clientState.gameOver, MAP_WIDTH);
      local y = math.floor(clientState.gameOver / MAP_WIDTH);
      local emitter = CreateSpark(x * TILE_SIZE + BOARD_LEFT + HALF_TILE_SIZE, y * TILE_SIZE + BOARD_TOP + HALF_TILE_SIZE);
      ParticleSystem.AttachEmitter(emitter);
      DestroyClass(emitter);
      emitter = nil;
      KillOverlay(x, y);
      
      local fallBlock = nil;
      fallBlock = isInData(fall, x, y);

      --Only detach for now; these will be destroyed when starting a new game.
      if (fallBlock) then
         DetachWindow(fallBlock.sprite);
         if (fallBlock.frozen) then
            DetachWindow(fallBlock.frozen);
         elseif (fallBlock.reinforced) then
            DetachWindow(fallBlock.reinforced);
         end
      end
      
      if (math.fmod(x, 2) == 1) then
         replaceSound(sounds.pop);
      end
--[[
      local i = nil;
      for i = #spritelist, 1, -1 do
      --Log(i);
         if (type(spritelist[i]) == "userdata" and spritelist[i].Parent()) then         
            local sx = spritelist[i].GetLeft() + 1;
            local sy = spritelist[i].GetTop() + 1;
            if (sx < 0 or sy < 0) then
               local oldSprite = table.remove(spritelist, i);
               DetachWindow(oldSprite);
               DestroyClass(oldSprite);
               oldSprite = nil;            
               break;
            end
            
            sx = math.floor(sx / TILE_SIZE);
            sy = math.floor(sy / TILE_SIZE);
            
            if (sx == x and sy == y) then
               local oldSprite = table.remove(spritelist, i);
               DetachWindow(oldSprite);
               DestroyClass(oldSprite);
               oldSprite = nil;            
               break;
            end
         end
      end
      ]]
      Board.SetCell1D(clientState.gameOver, GAMEOVER_BLOCK);
      
      if (y == cursor.swapy) then
         if (x == cursor.swapx) then
            cursor.graphic1.ShowWindow(false);
         elseif (x == cursor.swapx + 1) then
            cursor.graphic2.ShowWindow(false);
         end
      end
      
      clientState.gameOver = clientState.gameOver + 1;
      if (clientState.gameOver == Board.CellCount()) then
         EndGame();
         clientState.gameOver = false;
      end
      return;
   elseif (clientState.halt or cursor.pause or cursor.help) then
      return;
   end
   
   if (InfoTimer:GetTime() > INFO_INTERVAL) then
      local thisInfo = info;
      if (clientState.gameType == GAMETYPES.BASH) then
         thisInfo = bashInfo;
      end
      clientState.info = clientState.info + 1;
      if (clientState.info > table.getn(thisInfo)) then
         clientState.info = 1;
      end
      InfoText.SetText(thisInfo[clientState.info]);
      InfoTimer:Reset();
   end

   --Removes blocks that have been matched and Xed out	
   if (RemoveTimer:GetTime() > FRAME_THROTTLE and not clientState.gameOver) then
      if (cursor.swap) then
         if (cursor.swap == 0) then
            cursor.swap = swapBlocks();
         else
            cursor.swap = cursor.swap + RemoveTimer:GetTime();
            animateSwap();
         end
      end
      RemoveTimer:Reset();
      removeBlocksLater();
   end
   
   if (not atrest or clientState.gameType == GAMETYPES.BASH) then
      --Comboed blocks fall at a more leisurely pace than swapped ones
      if (FallTimer:GetTime() > FALL_TIME) then
         SwapFallTimer:Reset();
         FallTimer:Reset();
         makeBlocksFall(swapfall);
         makeBlocksFall(fall);
         atrest = isAtRest();
         if (atrest) then
            for i = #spritelist, 1, -1 do
               local oldSprite = table.remove(spritelist, i);
               DetachWindow(oldSprite);
               DestroyClass(oldSprite);
               oldSprite = nil;            
            end
         end
         checkForSafety();
      --Blocks that are swapped must fall almost instantly
      elseif (SwapFallTimer:GetTime() > FRAME_THROTTLE) then
         SwapFallTimer:Reset();
         makeBlocksFallGradually(fall);
         makeBlocksFall(swapfall);
         checkForSafety();
      end
   end
   
   if (atrest or advance or clientState.gameType == GAMETYPES.BASH) then
      if (combotime > MAX_STOP_TIME * COMBO_TIME) then
         combotime = MAX_STOP_TIME * COMBO_TIME;
      end
      
      if (ComboTimer:GetTime() > combotime) then
         combotime = -1;
         if (advance) then
            addcounter = addcounter + AddTimer:GetTime() / MIN_ADD * ADD_TIME;
         else
            addcounter = addcounter + AddTimer:GetTime();
         end
         AddTimer:Reset();
         if (addcounter >= ADD_TIME) then
            addcounter = 0;
            addBlocks();
            if (ADD_TIME > MIN_ADD) then
               ADD_TIME = ADD_TIME - ADD_TIME_STEP;
            end
         end
            SetBoardLocation(-addcounter / ADD_TIME * TILE_SIZE);
      else
         if (advance) then
            combotime = -1;
         end
         AddTimer:Reset();
      end
   end
end

function causesAMatch(x, y)
   --Checks only left and below since building a board starts from lower left
   local temp = {};
   AddMatchesBelow(temp, x, y);
   if (table.getn(temp) > 1) then return true; end
   temp = {};
   AddMatchesLeft(temp, x, y);
   if (table.getn(temp) > 1) then return true; end
   return false;
end

function initBoard()
   prevScore = 0;
   
   local cell = nil;
   for cell = 0, Board.CellCount() - 1 do
      Board.SetCell1D(cell, 0);
   end
   
   for cell = 0, MAP_WIDTH_MINUS_ONE do
      Next.SetCell1D(cell, 0);
   end
   
   resetBoard();
end

function resetBoard()
   combo = 0;
   lastcombo = 0;
   combotime = 0;
   addcounter = 0;
   falloffset = 0;
   clientState.info = 0;
   atrest = true;
   cursor.swap = nil;
   cursor.swapx = 0;
   cursor.swapy = 0;
   cursor.index1 = 0;
   cursor.index2 = 0;

   fall = {};
   swapfall = {};
   removal = {};
   for i = table.getn(spritelist), 1, -1 do
      local oldSprite = table.remove(spritelist);
      DetachWindow(oldSprite);
      DestroyClass(oldSprite); oldSprite = nil;
   end
   for i = table.getn(clientState.frozen), 1, -1 do
      local oldBlock = table.remove(clientState.frozen);
      DetachWindow(oldBlock.sprite);
      DestroyClass(oldBlock.sprite); oldBlock = nil;
   end
   for i = table.getn(clientState.reinforced), 1, -1 do
      local oldBlock = table.remove(clientState.reinforced);
      DetachWindow(oldBlock.sprite);      
      DestroyClass(oldBlock.sprite); oldBlock = nil;
   end
   clientState.melting = {};
   cursor.graphic1.ShowWindow(false);
   cursor.graphic2.ShowWindow(false);

   SetBoardLocation(0);
   Container.ShowWindow(true);

   FallTimer:Reset();
   SwapFallTimer:Reset();
   RemoveTimer:Reset();
   AddTimer:Reset();
end

function CoreInit()
   math.randomseed(GetRandomSeed());
   math.random();
   math.random();
   math.random();
   math.random();

   FallTimer = Timer();
   SwapFallTimer = Timer();
   RemoveTimer = Timer();
   AddTimer = Timer();
   ComboTimer = Timer();
   ScoreTimer = Timer();
   ShineTimer = Timer();
   InfoTimer = Timer();

   GameOver = GameWindow.FindNamedWindow("GameOver");
   GameSubWindow = GameWindow.FindNamedWindow("SoblocksSolo");
   GameOverText = GameWindow.FindNamedWindow("GameOverText");
   Container = GameWindow.FindNamedWindow("Container");
   Board = GameWindow.FindNamedWindow("Board");
   CursorLayer = GameWindow.FindNamedWindow("CursorLayer");
   Next = GameWindow.FindNamedWindow("Next");
   ComboText = GameWindow.FindNamedWindow("ComboText");
   FloatingWindowContainer = GameWindow.FindNamedWindow("FloatingWindowContainer");
   HelpPageText = GameWindow.FindNamedWindow("HelpPageText");
   InfoContainer = GameWindow.FindNamedWindow("InfoContainer");
   ParticleContainer = GameWindow.FindNamedWindow("ParticleContainer");
   InfoText = GameWindow.FindNamedWindow("InfoText");
   Gate = GameWindow.FindNamedWindow("Gate");
   matTreads = GameWindow.FindNamedWindow("Treads").GetMaterial();
   Countdown = GameWindow.FindNamedWindow("Countdown");
   CountdownText = GameWindow.FindNamedWindow("CountdownText");
   Overlay = GameWindow.FindNamedWindow("Overlay");

   matTreads.SetRate(0);
   TREADS_FRAMES = matTreads.GetAnimEnd() - matTreads.GetAnimBegin() + 1;

   ComboText.SetText("");
   
   cursor.levelup = nil;
   clientState.gameOver = nil;
   cursor.newlevel = nil;
   cursor.pause = nil;
   cursor.help = nil;
   clientState.halt = true;
   
   --Create both sides of the cursor... right side is flipped 180 degrees
   cursor.spriteL = CreateSpriteClass("Soblocks/Cursor.png", MakeRectString(0,0,TILE_SIZE,TILE_SIZE), false, CursorLayer);
   cursor.zoneL = CreateWindowClass(MakeRectString(0,0,TILE_SIZE,TILE_SIZE), false, "ControlZone", cursor.spriteL);
   cursor.zoneL.SetName( "CursorL" );
   cursor.spriteR = CreateSpriteClass("Soblocks/Cursor.png", MakeRectString(0,0,TILE_SIZE,TILE_SIZE), false, CursorLayer);
   cursor.zoneR = CreateWindowClass(MakeRectString(0,0,TILE_SIZE,TILE_SIZE), false, "ControlZone", cursor.spriteR);
   cursor.zoneR.SetName( "CursorR" );
   cursor.spriteR.SetRotation(180);
   setCursorCell(0, MAP_HEIGHT_MINUS_ONE);
   cursor.spriteL.ShowWindow(true);
   cursor.spriteR.ShowWindow(true);
   cursor.zoneL.ShowWindow(true);
   cursor.zoneR.ShowWindow(true);

   Overlay.ShowWindow(false);
   GameOver.ShowWindow(false);
   Container.ShowWindow(false);
   Countdown.ShowWindow(false);
   CountdownText.ShowWindow(false);
   --GameWindow.SetLocation(0, 0);

   MAP_WIDTH = Board.MapWidth();
   MAP_WIDTH_MINUS_ONE = MAP_WIDTH - 1;
   MAP_WIDTH_MINUS_TWO = MAP_WIDTH - 2;
   MAP_HEIGHT = Board.MapHeight();
   MAP_HEIGHT_MINUS_ONE = MAP_HEIGHT - 1;
   MAP_HEIGHT_MINUS_TWO = MAP_HEIGHT - 2;
   MAP_LEFT = Container.GetLeft() - 1;
   CNST_MAP_TOP = Container.GetTop() - 1;
   MAP_TOP = CNST_MAP_TOP;
   CNST_MAP_BOTTOM = Board.MapHeight() * TILE_SIZE;
   GATE_TOP = Gate.GetTop() - 1;
   
   BOARD_LEFT = GameSubWindow.GetLeft() + MAP_LEFT;
   CNST_BOARD_TOP = GameSubWindow.GetTop() + MAP_TOP;
   BOARD_TOP = CNST_BOARD_TOP;

   local sprite = nil;
   local tile = nil;
   local material = nil;
   
   Next.AddTile().SetColor( "00000000" );

   for i = 1, Board.TileCount() - 1 do
      if (i ~= PLACEHOLDER) then
         material = Board.GetTile(i).GetMaterial();
         sprite = CreateSpriteClass("Soblocks/Remove.dds", MakeRectString(0,0,TILE_SIZE,TILE_SIZE), false, Container);
         sprite.SetMaterial(material);
         table.insert(TILES2, i, sprite);
         tile = Next.AddTile();
         tile.SetMaterial(material);
         tile.SetColor("FF808080");
      else
         Next.AddTile();
         table.insert(TILES2, i, {});
      end
   end

   cursor.graphic2 = TILES2[1];
   cursor.reinforced2 = CreateSpriteClass("Soblocks/Reinforced.dds", MakeRectString(0,0,TILE_SIZE,TILE_SIZE), false, Container);

   for i = 1, Board.TileCount() - 1 do
      if (i ~= PLACEHOLDER) then
         material = Board.GetTile(i).GetMaterial();
         sprite = CreateSpriteClass("Soblocks/Remove.dds", MakeRectString(0,0,TILE_SIZE,TILE_SIZE), false, Container);
         sprite.SetMaterial(material);
         table.insert(TILES1, i, sprite);
      else
         table.insert(TILES1, i, {});
      end
   end

   cursor.graphic1 = TILES1[1];
   cursor.reinforced1 = CreateSpriteClass("Soblocks/Reinforced.dds", MakeRectString(0,0,TILE_SIZE,TILE_SIZE), false, Container);
      
   for i = 1, NUM_TILES do
      table.insert(materials, {});
      materials[i].default = CreateMaterialClass(DEFAULT_FILES[i]);
      materials[i].shine = CreateTileMaterialClass(SHINE_FILES[i], SHINE_FRAMES, 1);
      materials[i].shine.SetRate(SHINE_FPS);
   end
   
   if(not ParticleSystem) then
      ParticleSystem = CreateClass( "class ParticleSystem2D" );
      AttachWindow(ParticleSystem, ParticleContainer);
   end
   
   initBoard();
end
