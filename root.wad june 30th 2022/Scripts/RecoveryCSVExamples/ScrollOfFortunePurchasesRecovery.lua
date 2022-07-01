Include( "API/CharacterRecovery.lua" );
Include( "API/Utilities.lua" );

function main()

   e = GetEvent("Arguments");
   
   Log( "ScrollOfFortunePurchases - STARTED for file "..e.arg0..".csv" );

   local fileName = "../Data/GameData/Scripts/"..e.arg0..".csv";
   for line in io.lines(fileName) 
   do 
      local values = SplitString(line,":");
      local charId = values[1];
      local charIdToPrint = "GID:"..values[1];
 
      Server("GiveSeasonPass", charId);
      Log( "ScrollOfFortunePurchases - character id = "..charIdToPrint);
      Sleep(1);

   end

   Log( "ScrollOfFortunePurchases - COMPLETE for file "..e.arg0..".csv - Save your WizardClient.log file!" );
end
