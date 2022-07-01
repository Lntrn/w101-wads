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
Include("API/MinigameInterface.lua");


function main()
   Log("Starting client for "..GameName);
   if(DoPreGameInterface(GameName) == false) then
      exit();
   end
   runGame();  
   exit();
end

-- quit and send reward info message
function gameOver(score)    
      rewardInfo = {};
      rewardInfo.gameName = GameName;
      rewardInfo.score = score;      
      if(DoPostGameInterface(GameName, rewardInfo) == true) then
         resetClient();
      end
end

function exit()
  UnfreezePlayer();
   Kill(GetProcessID());
end

function resetClient()
   runGame();
end

function runGame()
   FreezePlayer();
   SendProcessMessage(Messages.Connect, {});
   Minigame(GameName);
   local gameOverEvent = "OnMinigameOver";
   RegisterEvent(gameOverEvent);
   local event = GetEvent(gameOverEvent);
   local score = event.Score;
   UnregisterEvent(gameOverEvent);
   gameOver(score);
end

