GameName = "concentration"

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
   FreezePlayer();
   if(DoPreGameInterface(GameName) == false) then
      exit();
   end
   runGame();  
   exit();
end

-- quit and send reward info message
function gameOver(score)      
   Log("Minigame recv'd Game Over event with score"..score); 
   rewardInfo = {};
   rewardInfo.gameName = GameName;
   rewardInfo.score = score;      
   if(DoPostGameInterface(GameName, rewardInfo) == false) then
      exit();
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
   while(true) do   
      SendProcessMessage(Messages.Connect, {});   
      Minigame(GameName);
      local gameOverEvent = "OnMinigameOver";
      RegisterEvent(gameOverEvent);
      local event = GetEvent(gameOverEvent);
      local score = event.Score;
      UnregisterEvent(gameOverEvent);
      gameOver(score);      
   end
end

