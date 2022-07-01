Include( "API/CharacterRecovery.lua" );
Include( "API/Utilities.lua" );

function main()

   RegisterEvent("CharEditBanksLoaded");
   RegisterEvent("CharacterEditCharLoaded");
   RegisterEvent("CharacterEditCharLoadFailed");

   e = GetEvent("Arguments");

   if(e.arg1 ~= nil) then
      LoadQuestData( e.arg1 );
   end
   
   local skipCharId = 0
   local fileName = "../Data/GameData/Scripts/"..e.arg0..".csv";
   for line in io.lines(fileName) 
   do 
      -- TODO:  Get the character id from the log line.
      local values = SplitString(line,":");
      local charId = "GID:"..values[1];
      
      if(skipCharId == 0 or charId ~= skipCharId) then

         skipCharId = 0; --Reset the skipCharId value

         local charRecovery = BeginCharacterRecovery(charId);
         if(charRecovery == 0) then
   	      -- end previous character recovery
            EndCharacterRecovery(true);
      		-- now try again...
      		charRecovery = BeginCharacterRecovery( charId );
         end

         if ( charRecovery == 1 ) then
            RecoverItem(values, charId);
         else
            Log( "Failed to Edit "..charId.." - Moving to next character." );
            skipCharId = charId;
         end
      end
   end
   
   -- flush any changes to last character..
   EndCharacterRecovery(true);

   Log( "ItemRecovery - SET COMPLETE - Save your WizardClient.log file!" );
end
