function AwardSpells( args )

	Log( "Awarding starting spells and adding three of them to the deck ");

   local objID = args.GameObjectID;
   local zoneID = args.ZoneID;
   
   -- What character class?
   local characterClass = DetermineMagicSchool(objID);
   local error = 0;
   
   if(characterClass == "Fire") then 
      GrantSpell(objID,"Fire Cat");
      AddSpellToDeck(objID,"Fire Cat",3);
   elseif(characterClass == "Ice") then
      GrantSpell(objID,"Frost Beetle");
      AddSpellToDeck(objID,"Frost Beetle",3);
   elseif(characterClass == "Storm") then
      GrantSpell(objID,"Thunder Snake");
      AddSpellToDeck(objID,"Thunder Snake",3);
   elseif(characterClass == "Myth") then
      GrantSpell(objID,"Bloodbat");
      AddSpellToDeck(objID,"Bloodbat",3);
   elseif(characterClass == "Death") then
      GrantSpell(objID,"Dark Sprite");
      AddSpellToDeck(objID,"Dark Sprite",3);
   elseif(characterClass == "Balance") then
      GrantSpell(objID,"Scarab");
      AddSpellToDeck(objID,"Scarab",3);
   elseif(characterClass == "Life") then
      GrantSpell(objID,"Imp");
      AddSpellToDeck(objID,"Imp",3);
   else
      local szError = "Unknown school: ";
      -- szError += characterClass;
      Log(szError);
      error = 1;
   end
   
   -- Modify training points
   if(error == 0) then
      -- Player doesn't start with any training points, so we only would
      -- need this if that changed.
      -- ModifyTrainingPoints(objID,-1);
   end

end

