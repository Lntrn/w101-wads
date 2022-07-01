Include( "API/CharacterRecovery.lua" );
Include( "API/Utilities.lua" );

function main()

   e = GetEvent("Arguments");
   
   Log( "ScrollOfFortuneAddPoints - STARTED for file "..e.arg0..".csv" );

   local fileName = "../Data/GameData/Scripts/"..e.arg0..".csv";
   for line in io.lines(fileName) 
   do 
      local values = SplitString(line,":");
      local charId = values[1];
      local charIdToPrint = "GID:"..values[1];
      local pointsToAdd = values[2];
 
      Server("SOFAddPoints", pointsToAdd, charId);
      Log( "ScrollOfFortuneAddPoints - character id = "..charIdToPrint ..", points added = "..pointsToAdd );
      Sleep(1);

   end

   Log( "ScrollOfFortuneAddPoints - COMPLETE for file "..e.arg0..".csv - Save your WizardClient.log file!" );
end