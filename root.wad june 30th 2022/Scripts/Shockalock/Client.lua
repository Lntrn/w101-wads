GameName = "Shockalock"

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
   if(DoPreGameInterface(GameName, true) == false) then
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
   Log("Send process message rewards");
   SendProcessMessage(Messages.Rewards, rewardInfo);
   if (score > -1) then
     while (1) do
     end
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
   SendProcessMessage(Messages.Connect, {}); 
   Minigame(GameName);
   local gameOverEvent = "OnMinigameOver";
   RegisterEvent(gameOverEvent);
   local event = GetEvent(gameOverEvent);
   local score = event.Score;
   UnregisterEvent(gameOverEvent);
   gameOver(score);      
end

