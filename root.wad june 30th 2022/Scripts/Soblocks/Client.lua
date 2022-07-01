--[[ 
   Soblocks

   Author: Kristofer M. Kurtis
   KingsIsle Entertainment
   Date: March 5, 2007, 11:55 AM
]]

DEBUG = false;
SHOWPAUSE = false;

MessageHandler = {};

Include("API/Classes/class.lua");
Include("API/ControlClasses.lua");
Include("API/Utilities.lua");
Include("API/Classes/Timer.lua");
Include("API/Globals.lua");
Include("API/MinigameTemplate.lua");

Include("Soblocks/ClientCore.lua");
Include("Soblocks/Shared.lua");
Include("Soblocks/ClientConfig.lua");
Include("Soblocks/GameData.lua");
Include("Soblocks/Messages.lua");
Include("Soblocks/ParticleEffects.lua");
Include("API/MinigameInterface.lua");

function RECONNECT_TIMEOUT( event )
   Log("Server Timed Out during mini game.");
   while(true) do
      Sleep(1000);
   end   
end
RegisteredEvents["AppReconnectTimeout"] = RECONNECT_TIMEOUT;

function EMITTER_COMPLETE(event)
   local i = nil;
   for i = 1, table.getn(emitterScore) do
      if (emitterScore[i].id == event.ID) then
         replaceSound(sounds.explosion);

         if (emitterScore[i].level) then
            LevelNumber.GetMaterial().SetCurrentFrame(level - 1);
         else
            UpdateScore(emitterScore[i].amount, emitterScore[i].fraction);
         end
         table.remove(emitterScore, i);
         return;
      end
   end
end
RegisteredEvents["EmitterComplete"] = EMITTER_COMPLETE;

function CLIENT_ENDGAME(event)
   EndGame();
end
MessageHandler[Messages.EndGame] = CLIENT_ENDGAME;

function CLIENT_RESETGAME(event)
   initBoard();
   replaceSound(sounds.background);
   GameOver.ShowWindow(false);
   --Intro.ShowWindow(true);
   Container.ShowWindow(false);
   ItemContainer.ShowWindow(false);
   --ScoreContainer.ShowWindow(false);
   select = {};
   select.GameType = GAMETYPES.SCORE;
   SendProcessMessage(Messages.SelectGame, select);
end
MessageHandler[Messages.ResetGame] = CLIENT_RESETGAME;

function CLIENT_SELECTGAME(event)
   clientState.nextRows = {};
   resetBoard();
   clientState.gameType = event.GameType;
   --Intro.ShowWindow(false);
   InfoContainer.ShowWindow(true);
   Overlay.ShowWindow(false);
   
   if (clientState.gameType == GAMETYPES.ITEM) then
      --ScoreContainer.ShowWindow(false);
      ItemContainer.ShowWindow(true);
      ItemName.SetText("<center>"..item.name.."</center>");
      ItemIcon.SetMaterialByName(item.icon);
      ShowScoreDigits(false);
      ItemDot.ShowWindow(false);
      ItemPercent.ShowWindow(true);
   elseif (clientState.gameType == GAMETYPES.BUCKS) then
      --ScoreContainer.ShowWindow(false);
      ItemContainer.ShowWindow(true);
      ItemName.SetText("<center>Socia Bucks</center>");
      ItemIcon.SetMaterialByName(bucks.icon);   
      ShowScoreDigits(false);
      ItemDot.ShowWindow(true);
      ItemPercent.ShowWindow(false);
   else
      --ScoreContainer.ShowWindow(true);
      ItemContainer.ShowWindow(false);
      ShowScoreDigits(true);
   end

   cursor.spriteL.ShowWindow(true);
   cursor.spriteR.ShowWindow(true);

   ResetLevel();
   ClearScore();

   addcounter = 0;
   falloffset = 0;

   clientState.init = true;
   
   Pause.ShowWindow(true);
end
MessageHandler[Messages.SelectGame] = CLIENT_SELECTGAME;

function SendRowInfo()
end

function LeaveHelp()
   --SendProcessMessage(Messages.Pause, {});
   cursor.help = false;
end

function UpdateHelp()
   cursor.help = true;
   --if (not cursor.pause) then
      --SendProcessMessage(Messages.Pause, {});
   --end
   TurnPauseOn();
   Minigame:SetHelpText(help.page[help.current]);
   Minigame:SetHelpTitleText("<center>"..help.title[help.current].."</center>");
   HelpPageText.SetText("<center>Page "..help.current.." of "..help.max.."</center>");
end

function PauseToggle()
   if (not clientState.halt and not cursor.help) then
      if (cursor.pause) then
         TurnPauseOff();
      else
         TurnPauseOn();
      end
   end
end

function TurnPauseOn()
Log("TurnPauseOn");
   if (cursor.levelup or cursor.newlevel or cursor.pause) then
      --SendProcessMessage(Messages.Pause, {});
      return;
   end
   
   pauseTimers();
   cursor.pause = true;
   if (not SHOWPAUSE) then
      Container.ShowWindow(false);
      Pause.ShowWindow(true);
      AutoPauseText = GameWindow.FindNamedWindow("AutoPauseText");
      AutoPauseText.SetText("<string;MinigamesCommon_SOBLOCKS_PAUSETEXT></string>");
      AutoPauseText.ShowWindow(true);
      DestroyClass(AutoPauseTest);
   end
end

function TurnPauseOff()
Log("TurnPauseOff");
   if (not cursor.pause) then
      return;
   end

   pauseTimers();
   cursor.pause = false;
   Container.ShowWindow(true);
   AutoPauseText.ShowWindow(false);
   Pause.ShowWindow(false);
end

function ResetLevel()
   local i = nil;
   level = STARTING_LEVEL;
   blocksdestroyed = levels[level].blocks;
   LevelNumber.GetMaterial().SetCurrentFrame(0);
   cursor.newblock = 0;
   --resetPlayTiles();
   
   for i = 1, level do
      if (levels[i].newblock) then
         cursor.newblock = cursor.newblock + 1;
      end
   end
   
   RealLevelUp();
end

function RealLevelUp()
   local i = nil;
   for i = 1, cursor.newblock do
      --table.insert(playtiles, table.remove(addtiles, 1));
      SendProcessMessage(Messages.LevelUp, {});
   end
   
   chanceData = {};
   chanceData.Index1 = levels[level].jewel;
   chanceData.Index2 = levels[level].bomb;
   chanceData.Index3 = levels[level].pinwheel;
   chanceData.Index4 = levels[level].reinforced;
   chanceData.Index5 = levels[level].frozen;
   SendProcessMessage(Messages.SendRow, chanceData);
   clientState.nextRows = {};
   FillNextRowBuffer();
   combo = 0;
   cursor.newblock = 0;
   cursor.blankblocks = 0;
   cursor.levelup = false;
   ADD_TIME = levels[level].speed;
   ADD_TIME_STEP = levels[level].speedup;
   FALL_TIME = levels[level].fallspeed;
   REMOVE_TIME = levels[level].removespeed;
   REMOVE_TIME_SECONDS = REMOVE_TIME / 1000;
   MULTIPLIER = levels[level].bonus;
   COMBO_TIME = levels[level].combotime;
   MULTI_TIME = levels[level].multitime;
   SetNextLevelText();
end

function LevelUp()
   level = level + 1;
   if (levels[level].newblock) then
      cursor.newblock = cursor.newblock + 1;
   end
   addCaption("<color;00D7FF><string;MinigamesCommon_Soblocks_LevelUp></string>", 0, PO.level_offsety);      
   -- local emitter = CreateLevelUp();
   -- ParticleSystem.AttachEmitter(emitter);
   -- DestroyClass(emitter);
   -- emitter = nil;
   replaceSound(sounds.levelup);
   cursor.levelup = 0;
end

function SetNextLevelText()
   local text = nil;

   if (level < table.getn(levels)) then
      if (BLOCKS_GAME) then
         local remaining = levels[level+1].blocks - blocksdestroyed;
         NextLevelText.SetText(string.format("<string;MinigameInstructions_Sorcery_Stones_Remaining></string> %d", remaining));
      elseif (clientState.gameType == GAMETYPES.ITEM) then
         text = string.format("<center><string;MinigamesCommon_NEXT_LEVEL></string> %03d.%02d</center>", levels[level+1].itemscore, math.fmod(levels[level+1].itemscore * 100, 100));
         NextLevelText.SetText(text);
      elseif (clientState.gameType == GAMETYPES.BUCKS) then
         text = string.format("<center><string;MinigamesCommon_NEXT_LEVEL></string> %03d.%02d</center>", levels[level+1].buckscore, math.fmod(levels[level+1].buckscore * 100, 100));
         NextLevelText.SetText(text);
      else
         text = string.format("<center><string;MinigamesCommon_NEXT_LEVEL></string> %08d</center>", levels[level+1].score);
         NextLevelText.SetText(text);
      end
   else
      NextLevelText.SetText("<string;MinigameInstructions_Sorcery_Stones_LevelMax></string>");
   end
end

function addCaption(a_text, a_x, a_y)
   local wndContainer = OpenClass(FloatingWindowContainer);
   if wndContainer == 1 then
      wndContainer = FloatingWindowContainer;
   end
   local windowCount = wndContainer.ChildCount();
   if (windowCount > 10) then
      wndContainer.DetachWindowIndex(0);      
   end
   local banner = OpenClass(CreateTextWindowClass(a_text, true, wndContainer));  
   
   if(banner.GetAnimationCount() == 0) then   

      local captionWidth = wndContainer.GetWindowWidth();
      local captionHeight = 32;
      local fadeTime = 2;
      local riseTime = 2; -- in seconds      
      local riseAmount = a_y;
      
      RiseAnim.SetTargetLocation(a_x, a_y - riseAmount);
      RiseAnim.SetTime(riseTime);           
      --GrowAnim.SetSize(captionWidth*5, captionHeight*5);
      --GrowAnim.SetTime(captionTime);
      FadeAnim.SetCycleTime(fadeTime);
      FadeAnim.SetCycle(false);
      --CaptionAnim.AddAnimation(GrowAnim);
      CaptionAnim.AddAnimation(RiseAnim);
      CaptionAnim.AddAnimation(FadeAnim);
      
      banner.SetWindow("0,0,"..captionWidth..","..captionHeight);
      banner.SetLocation(a_x, a_y );
      banner.SetAlpha(1.0, false);
      banner.ShowWindow(true);
      banner.PushAnimation(CaptionAnim);
   end
end

function AddToScore(numblocks, endbonus, reinforced)
   local i = nil;
   if (not endbonus and BLOCKS_GAME) then
      if (not cursor.levelup and level < table.getn(levels)) then
         blocksdestroyed = blocksdestroyed + numblocks - reinforced;
         if (blocksdestroyed >= levels[level+1].blocks) then
            blocksdestroyed = levels[level+1].blocks;
            LevelUp();
            if (cursor.danger) then
               cursor.danger = false;
               replaceSound(sounds.background);
            end
         end
      end
      SetNextLevelText();
   end
   
   if (clientState.gameType == GAMETYPES.ITEM) then
      if (numblocks > table.getn(ITEMADD) + 2) then
         item.fraction = item.fraction + ITEMADD[table.getn(ITEMADD)] * numblocks * combo * MULTIPLIER;
      else
         item.fraction = item.fraction + ITEMADD[numblocks-2] * numblocks * combo * MULTIPLIER;
      end
      
      while (item.fraction >= item.rollover) do
         item.fraction = item.fraction - item.rollover;
         item.count = item.count + 1;
      end      

      if (not BLOCKS_GAME and level < table.getn(levels)) then
         if (item.count + item.fraction / item.rollover > levels[level+1].itemscore) then
            LevelUp();
         end
      end
   elseif (clientState.gameType == GAMETYPES.BUCKS) then
      if (numblocks > table.getn(BUCKSADD) + 2) then
         bucks.fraction = bucks.fraction + BUCKSADD[table.getn(BUCKSADD)] * numblocks * combo * MULTIPLIER;
      else
         bucks.fraction = bucks.fraction + BUCKSADD[numblocks-2] * numblocks * combo * MULTIPLIER;
      end

      while (bucks.fraction >= 100) do
         bucks.fraction = bucks.fraction - 100;
         bucks.count = bucks.count + 1;
      end      

      if (not BLOCKS_GAME and level < table.getn(levels)) then
         if (bucks.count + bucks.fraction * .01 > levels[level+1].buckscore) then
            LevelUp();
         end
      end
   else
      if (numblocks > table.getn(POINTS) + 2) then
         score = score + POINTS[table.getn(POINTS)] * numblocks * combo * MULTIPLIER;
      elseif (numblocks < 3) then
         score = score + POINTS[1] * numblocks * combo * MULTIPLIER;
      else
         score = score + POINTS[numblocks-2] * numblocks * combo * MULTIPLIER;
      end

      if (not BLOCKS_GAME and level < table.getn(levels)) then
         if (score >= levels[level+1].score) then
            LevelUp();
         end
      end   
   end
end

function CreateScoreFirework(x, y, weight)
   local emitterItem = {};   
   local emitter = CreatePointAttractor(x * TILE_SIZE + BOARD_LEFT + HALF_TILE_SIZE, y * TILE_SIZE + BOARD_TOP + HALF_TILE_SIZE, weight);
   emitterItem.id = ParticleSystem.AttachEmitter(emitter);
   DestroyClass(emitter);
   emitter = nil;
   if (clientState.gameType == GAMETYPES.ITEM) then
      emitterItem.amount = item.count;
      emitterItem.fraction = item.fraction;
   elseif (clientState.gameType == GAMETYPES.BUCKS) then
      emitterItem.amount = bucks.count;
      emitterItem.fraction = bucks.fraction;
   else
      emitterItem.amount = score;
   end
   table.insert(emitterScore, emitterItem);
   replaceSound(sounds.shoot);
end

function CreateLevelFirework(x, y, weight)
   local emitterItem = {};   
   local emitter = CreateLevelAttractor(x * TILE_SIZE + BOARD_LEFT + HALF_TILE_SIZE, y * TILE_SIZE + BOARD_TOP + HALF_TILE_SIZE, weight);
   emitterItem.id = ParticleSystem.AttachEmitter(emitter);
   DestroyClass(emitter);
   emitter = nil;
   emitterItem.level = true;
   table.insert(emitterScore, emitterItem);
   replaceSound(sounds.shoot);
end

function ClearScore()
   SetScore(true);
end

function UpdateScore(amount, fraction)
   if (clientState.gameType == GAMETYPES.SCORE) then
      local scoreAdd = nil;
      if (amount < prevScore) then
         return;
      end

      scoreAdd = amount - prevScore;

      if (clientState.scoreAnim) then
         SetScore();
      else
         replaceSound(sounds.lever);
      end

      
      local i = nil;
      local divide = 1;
      for i = table.getn(scoreNumbers), 1, -1 do
         if (scoreAdd * divide > MAX_REVOLUTIONS) then
            scoreNumbers[i].sprite.SetMaterial( scoreNumbers[i].blur );
         else
            scoreNumbers[i].spin.SetRate(scoreAdd * divide * FRAMES_PER_NUM / SCORE_TIME);
            scoreNumbers[i].spin.SetCurrentFrame(math.fmod(prevScore * divide, 10) * FRAMES_PER_NUM);
            scoreNumbers[i].sprite.SetMaterial( scoreNumbers[i].spin );
            scoreDigit = i;
            break;
         end
         divide = divide / 10;
      end

      StopAllJerks();
      prevScore = amount;
      ScoreTimer:Reset();
      clientState.scoreAnim = true;
      replaceSound(sounds.spin);
   else
      local rollover = 100;
      if (clientState.gameType == GAMETYPES.ITEM) then
         rollover = item.rollover;
      end
      scoreNumbers[7].sprite.GetMaterial().SetCurrentFrame(math.fmod(fraction / rollover * 100, 10));
      scoreNumbers[6].sprite.GetMaterial().SetCurrentFrame(math.fmod(fraction / rollover * 10, 10));
      
      scoreNumbers[4].sprite.GetMaterial().SetCurrentFrame(math.fmod(amount, 10));
      scoreNumbers[3].sprite.GetMaterial().SetCurrentFrame(math.fmod(amount / 10, 10));
      scoreNumbers[2].sprite.GetMaterial().SetCurrentFrame(math.fmod(amount / 100, 10));
   end
end

function SetScore(silent)
   --Need a special instance for the ones digit since LUA screws up multiplication w/ 8 significant digits
   local material = scoreNumbers[8].sprite.GetMaterial();
   scoreNumbers[8].digit = math.floor(math.fmod(prevScore, 10));
   if (not clientState.scoreAnim and scoreNumbers[8].jerking) then
      --Do nothing
   elseif (not clientState.scoreAnim and (material == scoreNumbers[8].spin or material == scoreNumbers[8].blur)) then
      SetScoreJerk(8, scoreNumbers[8].digit);
   else
      scoreNumbers[8].default.SetCurrentFrame(scoreNumbers[8].digit);
      scoreNumbers[8].sprite.SetMaterial( scoreNumbers[8].default );
   end
   local i = nil;
   local divide = 0.1;
   for i = table.getn(scoreNumbers) - 1, 1, -1 do
      local material = scoreNumbers[i].sprite.GetMaterial();
      scoreNumbers[i].digit = math.floor(math.fmod((prevScore + 0.5) * divide, 10));
      if (not clientState.scoreAnim and scoreNumbers[i].jerking) then
         --Do nothing
      elseif (not clientState.scoreAnim and (material == scoreNumbers[i].spin or material == scoreNumbers[i].blur)) then
         SetScoreJerk(i, scoreNumbers[i].digit);
      else
         scoreNumbers[i].default.SetCurrentFrame(scoreNumbers[i].digit);
         scoreNumbers[i].sprite.SetMaterial( scoreNumbers[i].default );
      end

      divide = divide / 10;
   end
   if (not clientState.scoreAnim and not silent) then
      replaceSound(sounds.spin, sounds.jerk);
   end
   clientState.scoreAnim = false;
end

function StopAllJerks()
   for i = table.getn(scoreJerk), 1, -1 do
      scoreNumbers[scoreJerk[i]].jerking = false;
      table.remove(scoreJerk, i);
   end
end

function CheckScoreJerk()
   for i = table.getn(scoreJerk), 1, -1 do
      local material = scoreNumbers[scoreJerk[i]].sprite.GetMaterial();
      if (material.GetCurrentFrame() == JERK_FRAMES_MINUS_ONE) then
         local default = scoreNumbers[scoreJerk[i]].default;
         default.SetCurrentFrame(scoreNumbers[scoreJerk[i]].digit);
         scoreNumbers[scoreJerk[i]].sprite.SetMaterial( default );
         scoreNumbers[scoreJerk[i]].jerking = false;
         table.remove(scoreJerk, i);
      end
   end
end

function SetScoreJerk(digit, num)
   if (num == 0) then num = 10; end
   scoreNumbers[digit].jerk[num].SetCurrentFrame(0);
   scoreNumbers[digit].sprite.SetMaterial( scoreNumbers[digit].jerk[num] );
   scoreNumbers[digit].jerking = true;
   table.insert(scoreJerk, digit);
end

function IncrementDigit(digit)
   if (digit < 0 or digit > table.getn(scoreNumbers)) then return; end

   local num = scoreNumbers[digit].digit + 1;
   scoreNumbers[digit].digit = math.fmod(num, 10);
   SetScoreJerk(digit, num);
   if (num == 10) then
      IncrementDigit(digit - 1);
   end
end

function EndGame()

   PRE_ENDGAME_FUNC();

   clientState.halt = true;
   TurnPauseOff();
   local text = nil;
   local scoretext = nil;
   combo = 0;
   combotime = 0;
   updateCombo();
   
   local scoreSend = score;
   
   if (clientState.gameType == GAMETYPES.ITEM) then
      text = "<center>Stain collected:</center>";
      scoretext = string.format("<center>%d</center>", item.count);
      giveItem();
      item.count = 0;
      item.fraction = 0;
   elseif (clientState.gameType == GAMETYPES.BUCKS) then
      text = "<center>Socia Bucks won:</center>";
      scoretext = string.format("<center>%d.%02d</center>", bucks.count, bucks.fraction);
      --NOTE: no call to add money!
      bucks.count = 0;
      bucks.fraction = 0;
   else
      text = "<string;MinigamesCommon_YOUR_SCORE></string>";      
      scoretext = string.format("<center>%08d</center>", score);
      score = 0;
      prevScore = 0;
   end
   GameOverText.SetText(text);
   GameOverScore.SetText(scoretext);
   
   replaceSound(sounds.background, nil, true);
   if (level < LEVEL_GOOD) then
      replaceSound(sounds.aw);
   elseif (level >= LEVEL_GREAT) then
      replaceSound(sounds.applause);
   else
      replaceSound(sounds.clap);
   end

   POST_ENDGAME_FUNC(scoreSend);
   
end

function InitScoreDigits()
   local i = nil;
   for i = 1, 8 do
      table.insert(scoreNumbers, {});
   end   
   
   scoreNumbers[1].sprite = GameWindow.FindNamedWindow("ScoreNumbersA");
   scoreNumbers[2].sprite = GameWindow.FindNamedWindow("ScoreNumbersB");
   scoreNumbers[3].sprite = GameWindow.FindNamedWindow("ScoreNumbersC");
   scoreNumbers[4].sprite = GameWindow.FindNamedWindow("ScoreNumbersD");
   scoreNumbers[5].sprite = GameWindow.FindNamedWindow("ScoreNumbersE");
   scoreNumbers[6].sprite = GameWindow.FindNamedWindow("ScoreNumbersF");
   scoreNumbers[7].sprite = GameWindow.FindNamedWindow("ScoreNumbersG");
   scoreNumbers[8].sprite = GameWindow.FindNamedWindow("ScoreNumbersH");
   
   for i = 1, table.getn(scoreNumbers) do
      scoreNumbers[i].digit = 0;
      scoreNumbers[i].default = scoreNumbers[i].sprite.GetMaterial();
      scoreNumbers[i].blur = CreateTileMaterialClass("Soblocks/ScoreSpin_blur.dds", BLUR_FRAMES, 1);
      scoreNumbers[i].blur.SetRate(BLUR_FPS[i]);
      scoreNumbers[i].spin = CreateTileMaterialClass("Soblocks/ScoreSpin.dds", 10 * FRAMES_PER_NUM, 1);
      scoreNumbers[i].jerking = false;
      scoreNumbers[i].jerk = {};
      local j = nil;
      for j = 1, 10 do
         local material = CreateTileMaterialClass("Soblocks/ScoreJerk"..math.fmod(j, 10)..".dds", JERK_FRAMES, 1)
         material.SetRate(JERK_FPS);
         table.insert(scoreNumbers[i].jerk, material)
      end
   end
end

function ShowScoreDigits(show)
   scoreNumbers[1].sprite.ShowWindow(show);
   scoreNumbers[5].sprite.ShowWindow(show);
   scoreNumbers[8].sprite.ShowWindow(show);
end


function UpdateSolo()
   if (clientState.scoreAnim) then
      if (scoreNumbers[scoreDigit].sprite.GetMaterial().GetCurrentFrame() == FRAMES_PER_NUM * 10 - 1) then
         if (not clientState.scoreRolled) then
            clientState.scoreRolled = true;
            IncrementDigit(scoreDigit - 1);
         end
      else
         clientState.scoreRolled = false;
      end
            
      if (ScoreTimer:GetTime() >= SCORE_TIME * 1000) then
         clientState.scoreAnim = false;
         SetScore();
      end
   end

   CheckScoreJerk();
   
   if (clientState.init) then
      if (table.getn(clientState.nextRows) < ROW_BUFFER) then
         return false;
      else
         --build the initial board
         BuildBoard();
         AutoPauseText.ShowWindow(false);
         Pause.ShowWindow(false);
         ResetTimers();
      end
   elseif (clientState.autoPause) then
      if (ComboTimer:GetTime() > FRAME_THROTTLE) then
         if (table.getn(clientState.nextRows) < ROW_BUFFER_WARN) then
            ComboTimer:Reset();
            return false;
         else
            clientState.autoPause = false;
            addBlocks();
            ResetTimers();
            AutoPauseText.SetText("<string;MinigamesCommon_SOBLOCKS_UNPAUSE_TEXT></string>");
         end
      end
   end
   
   if (not cursor.pause and clientState.halt and cursor.levelup and FallTimer:GetTime() > FRAME_THROTTLE) then
      FallTimer:Reset();
      while (cursor.levelup < Board.CellCount() and Board.GetCell1D(cursor.levelup).GetTileIndex() ~= 0) do
         cursor.levelup = cursor.levelup + 1;
      end
      
      if (cursor.levelup == Board.CellCount()) then
         combo = LEVELUP_COMBO;
         AddToScore(cursor.blankblocks, true);
         RealLevelUp();
         cursor.newlevel = 0;
         return false;
      else
         cursor.blankblocks = cursor.blankblocks + 1;
         local x = math.fmod(cursor.levelup, MAP_WIDTH);
         local y = math.floor(cursor.levelup / MAP_WIDTH);
         local emitter = CreateFirework(x * TILE_SIZE + BOARD_LEFT + HALF_TILE_SIZE, y * TILE_SIZE + BOARD_TOP + HALF_TILE_SIZE);
         ParticleSystem.AttachEmitter(emitter);
         DestroyClass(emitter);
         emitter = nil;
         Board.SetCell1D(cursor.levelup, REMOVE_BLOCK);
         cursor.startingheight = math.floor(cursor.levelup / MAP_WIDTH);
         replaceSound(sounds.whip);
      end
      cursor.levelup = cursor.levelup + 1;
      return false;
   elseif (not cursor.pause and cursor.newlevel and FallTimer:GetTime() > FRAME_THROTTLE) then
      FallTimer:Reset();
      local x = math.fmod(cursor.newlevel, MAP_WIDTH);
      local y = math.floor(cursor.newlevel / MAP_WIDTH);
      local emitter = CreateBlockAway(x * TILE_SIZE + BOARD_LEFT + HALF_TILE_SIZE, y * TILE_SIZE + BOARD_TOP + HALF_TILE_SIZE);
      ParticleSystem.AttachEmitter(emitter);
      DestroyClass(emitter);
      emitter = nil;
      KillOverlay(x, y);
      
      if (math.fmod(x, 2) == 1) then
         replaceSound(sounds.bulb);
      end
      
      Board.SetCell1D(cursor.newlevel, 0);
      cursor.newlevel = cursor.newlevel + 1;
      
      if (cursor.startingheight < math.floor(cursor.newlevel / MAP_WIDTH)) then
         resetBoard();
         cursor.spriteL.ShowWindow(true);
         cursor.spriteR.ShowWindow(true);
         clientState.halt = false;
         cursor.newlevel = false;
         CreateScoreFirework(3, cursor.startingheight, 100); --Start fireworks from center of last row erased
         CreateLevelFirework(3, cursor.startingheight);
      end
      return false;
   end
   return true;
end

function Init()
   GameWindow.ShowWindow(true);

   Minigame = MinigameTemplate(GameWindow, true);
   Minigame:Show();
   Minigame:SetOnEnterHelpFunc(resetHelp);
   Minigame:SetOnExitHelpFunc(LeaveHelp);
   Minigame:SetOnExitFunc(CLIENT_ENDGAME);

   GameOverScore = GameWindow.FindNamedWindow("GameOverScore");
   ItemName = GameWindow.FindNamedWindow("ItemName");
   ItemIcon = GameWindow.FindNamedWindow("ItemIcon");
   ItemContainer = GameWindow.FindNamedWindow("ItemContainer");
   --ScoreContainer = GameWindow.FindNamedWindow("ScoreContainer");
   Pause = GameWindow.FindNamedWindow("PauseGraphic");
   --Intro = GameWindow.FindNamedWindow("Intro");
   HighScore = GameWindow.FindNamedWindow("HighScore");
   HighScoreText = GameWindow.FindNamedWindow("HighScoreText");
   HighScoreNames = GameWindow.FindNamedWindow("HighScoreNames");
   NextLevelText = GameWindow.FindNamedWindow("NextLevelText");
   LevelNumber = GameWindow.FindNamedWindow("Level_number");
   ItemDot = GameWindow.FindNamedWindow("ItemDot");
   ItemPercent = GameWindow.FindNamedWindow("ItemPercent");
   AutoPauseText = GameWindow.FindNamedWindow("AutoPauseText");
   
   CaptionAnim = CreateClass("class WinAnimConcurrent");
   RiseAnim = CreateClass("class WinAnimMoveToLocationTime");      
   GrowAnim = CreateClass("class WinAnimSizeTime");
   FadeAnim = CreateClass("class WinAnimAlphaFade");         

   Pause.ShowWindow(false);
   GameOver.ShowWindow(false);
   AutoPauseText.ShowWindow(false);
   
   AddLevels();   
   InitScoreDigits();

   replaceSound(sounds.background);

   select = {};
   select.GameType = GAMETYPES.SCORE;
   SendProcessMessage(Messages.SelectGame, select);
   SendProcessMessage(Messages.Ready, {});
end

function main()
   Log("Starting Soblocks Solo script...");

   BEGINMAIN_FUNC();
      
   while true do
      -- Check for events
      local event = GetEvent("", false);

      DebugBeginCriticalSection();
      -- Process any event that is found
      if event then
         Minigame:ProcessMessage(event);
      end

      if (UpdateSolo()) then
         UpdateBoard();
      end
      DebugEndCriticalSection();
   end
end
