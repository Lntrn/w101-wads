riTypeIndex = 2;
riTemplateIDIndex = 3;
riLocationIndex = 4;
riGlobalID = 5;
riNameKeyIndex = 6;
riTalentsIndex = 7;
riMaxStatsIndex = 8;
riPetLevelIndex = 9;

flagQuestCommandsLoaded = false;
quests = {}; 
questOrder = {};
goalOrder = {};
dynaMods = {};
dynaModIdx = {};
dynaCount = 1;

function BeginCharacterRecovery(a_charID)
	local r = EditCharacter( a_charID );
   if(r == 0) then
      return 0;
   end
   if(r == 1) then
		-- wait for character to get loaded...
		local charLoaded = false;

		while ( charLoaded == false ) do
			e = GetEvent();			-- block for event
			if ( e.EventName == "CharacterEditCharLoadFailed" ) then
				Log( "ItemRecovery - Character "..a_charID.." - Load character failed" );
				EndEditCharacter(0);
            Sleep(1);
            return -1;
			elseif ( e.EventName == "CharacterEditCharLoaded" ) then
            StopTimer(charTimerID);
				charLoaded = true;
			end
		end

		-- wait for banks to get loaded...
      charLoaded = false;

		local timerID = StartTimer( "BankLoadedTimeOut", 30, true );	-- start a timeout event 
		while ( charLoaded == false ) do
			e = GetEvent();			-- block for event
			if ( e.EventName == "BankLoadedTimeOut" ) then
				Log( "ItemRecovery - Character "..a_charID.." - Bank Load timeout");
				charLoaded = true;
			elseif ( e.EventName == "CharEditBanksLoaded" ) then
            StopTimer(timerID);
				charLoaded = true;
			end
		end

      return 1;

   elseif ( r == 2 ) then
	   -- character already loaded and ready for edit..
      return 1;
	end

	Log( "ItemRecovery - Character "..a_charID.." - Failed to edit character" );
	return 0;
end

function EndCharacterRecovery(a_save)
   if(a_save == true) then
	   Log( "ItemRecovery - Pushing edits to database" );
      EndEditCharacter(1);
   else
	   Log( "ItemRecovery - Cancelling edits to database (except for Pets added through CreatePet)" );
      EndEditCharacter(0);
   end

   Sleep(1);

end


function RecoverItem(a_values, a_charID)
   recoveryType = a_values[riTypeIndex];

   if(recoveryType == "Item") then
      local templateId = a_values[riTemplateIDIndex];
      local addTheItem = true;
      if(a_values[riGlobalID] ~= "0") then
         local itemGID = "GID:"..a_values[riGlobalID];
         local foundItem = FindItem(itemGID,templateId);
         if(foundItem ~= 0) then
            Log( "ItemRecovery Item "..templateId.." ["..itemGID.."] for charcter "..a_charID.." exists" );
            addTheItem = false;
         end
      end
      
      if(addTheItem == true) then
         Log( "ItemRecovery Item "..templateId.." ADDED to charcter "..a_charID );
         AddItemTo(templateId,1,a_values[riLocationIndex]);
      end

   elseif(recoveryType == "Pet") then
      local templateId = a_values[riTemplateIDIndex];
      local addTheItem = true;
      if(a_values[riGlobalID] ~= "0") then
         local itemGID = "GID:"..a_values[riGlobalID];
         local foundItem = FindItem(itemGID,templateId);
         if(foundItem ~= 0) then
            Log( "ItemRecovery Pet "..templateId.." ["..itemGID.."] for charcter "..a_charID.." exists" );
            addTheItem = false;
         end
      end

      if(addTheItem == true) then
         Log( "ItemRecovery Pet "..templateId.." ADDED to charcter "..a_charID );
         CreatePet(templateId,a_values[riNameKeyIndex],a_values[riTalentsIndex],a_values[riMaxStatsIndex],a_values[riPetLevelIndex]);
      end
      
   elseif(recoveryType == "Spell") then
      Log( "ItemRecovery Spell "..a_values[riTemplateIDIndex].." ADDED to charcter "..a_charID );
      AddSpell(a_values[riTemplateIDIndex]);

   elseif(recoveryType == "Gold") then
      Log( "ItemRecovery Gold "..a_values[riTemplateIDIndex].." ADDED to charcter "..a_charID );
      AddGold(a_values[riTemplateIDIndex]);

   elseif(recoveryType == "AccessPass") then
      local accessPassName = a_values[riTemplateIDIndex];
      if(accessPassName ~= "PvPDayPass") then
         Log( "ItemRecovery AccessPass "..accessPassName.." ADDED to charcter "..a_charID );
         AddAccessPass(accessPassName);
      end
	elseif(recoveryType == "DynaMod") then
      Log( "Starting DynamodRecovery");
      
      
      
      --reinitialize these because we're gonna nil them out at the bottom.
      dynaMods = {};
      dynaModIdx = {};
      dynaCount = 1;
      local questIdx = 1;
      
      --Run EnterWorld Dynamods.
      DoQuestDynamods("EnterZone",1,"Start");

      while questOrder[questIdx] do
         local curQuestName = questOrder[questIdx];
         if(curQuestName ~= "EnterZone") then
            --call into code to get the questStatus of the character
            local questStatus = GetQuestStatus(curQuestName);
            Log(curQuestName..":"..questStatus);
            if(questStatus == 1 or questStatus == 2) then -- underway OR done
               --do the quest start dynamods
               DoQuestDynamods(curQuestName,questStatus,"Start");
                           
               local goalIdx = 1;
               if(goalOrder[curQuestName] ~= nil) then
                  while goalOrder[curQuestName][goalIdx] do
                     local curGoalName = goalOrder[curQuestName][goalIdx]
                     local goalStatus = GetGoalStatus(curQuestName,curGoalName);
                     Log(curQuestName..":"..curGoalName..":"..goalStatus);
                     if(goalStatus == 2) then
                        local goalDynaModIdx = 1;
                        while quests[curQuestName][curGoalName][goalDynaModIdx] do
                           Log("IDX:"..goalDynaModIdx.."NAME:"..quests[curQuestName][curGoalName][goalDynaModIdx].tagName.." order:"..quests[curQuestName][curGoalName][goalDynaModIdx].order);
                           if(quests[curQuestName][curGoalName][goalDynaModIdx].temporary == 1 and questStatus == 2) then
                              Log(curQuestName..":"..curGoalName.." Temporary");
                           else
                              HandleMod(quests[curQuestName][curGoalName][goalDynaModIdx].tagName, quests[curQuestName][curGoalName][goalDynaModIdx]);
                           end
                           goalDynaModIdx = goalDynaModIdx + 1;
                        end
                     end
                     
                     goalIdx = goalIdx + 1;
                  end -- end goal loop
               end
               if(questStatus == 2) then -- do the end quest dynamods
                  DoQuestDynamods(curQuestName,questStatus,"End");
               end -- questStatus is 2 
               
            end--questStatus 1 or questStatus 2
         end--if curQuestName not equal EnterZone
         questIdx = questIdx + 1;
      end -- end while
      
      -- now I get to loop over all the dynamod commands and execute them.
      Log("DONE! starting to apply dnyamods :"..dynaCount-1);
      
      local dynaIdx = 1;
      while dynaIdx < dynaCount do
         local dynaName = dynaModIdx[dynaIdx];
         if(dynaName ~= nil and dynaName ~= "") then
            
            --remove and reapply the appropriate dynamods
            local modIdx = 1;
            while dynaMods[dynaName][modIdx] do
               local modCommand = dynaMods[dynaName][modIdx];
               local state = "";
               if(modCommand.state ~= nil) then 
                  state = modCommand.state;
               end
               local remove = "";
               if(modCommand.remove ~= nil) then 
                  remove = modCommand.remove;
               end
               Log(dynaName..":::"..modCommand.command);
               if(modCommand.command ~= "Remove") then
                  Log("Add mod :"..modCommand.tagName.." State:"..state.." Remove:"..remove);
                  AddMod(modCommand, a_charID);
               else
                  Log("Remove mod :"..modCommand.tagName);
                  RemoveMod(modCommand, a_charID);
               end -- not Remove
               modIdx = modIdx + 1;
            end
         end
         dynaIdx = dynaIdx + 1;
      end -- end dyna commands.
      
      --attempt cleanup here.
      dynaMods = nil;
      dynaModIdx = nil;
      dynaCount = nil;

   elseif(recoveryType == "PetStatAdjust") then
      local templateId = a_values[riTemplateIDIndex];
      if(a_values[riGlobalID] ~= "0") then
         local itemGID = "GID:"..a_values[riGlobalID];
         local foundItem = FindItem(itemGID,templateId);
         if(foundItem ~= 0) then
            Log( "ItemRecovery PetStatAdjust "..templateId.." ["..itemGID.."] for charcter "..a_charID.." exists" );
            
            
         else
            Log( "ItemRecovery PetStatAdjust "..templateId.." ["..itemGID.."] for charcter "..a_charID.." does not exist.  PetStatAdjustPetDoesNotExist" );
         end


      end

   end

end

function HandleMod(a_tagName, a_mod)
   local found = true;
   if(dynaMods[a_tagName] == nil) then
      dynaMods[a_tagName] = {};
      found = false;
   end
   table.insert(dynaMods[a_tagName],a_mod);
   if(found == false) then      
      dynaModIdx[dynaCount] = a_tagName;
      dynaCount = dynaCount + 1;
   end
end

function DoQuestDynamods(a_curQuestName, a_questStatus, a_orderFlag)
   Log(a_curQuestName.." startingToProcess flag:"..a_orderFlag);
   local startDynaModIdx = 1;
   while quests[a_curQuestName][startDynaModIdx] do
      Log("IDX:"..startDynaModIdx.."NAME:"..quests[a_curQuestName][startDynaModIdx].tagName.." order:"..quests[a_curQuestName][startDynaModIdx].order);
      if(quests[a_curQuestName][startDynaModIdx].order == a_orderFlag) then
         --if we are temp mod and we're a done quest then dont put on.
         if(quests[a_curQuestName][startDynaModIdx].temporary == 1 and a_questStatus == 2) then
            --dont put it on.
         else
            HandleMod(quests[a_curQuestName][startDynaModIdx].tagName, quests[a_curQuestName][startDynaModIdx]);
         end
      end -- start dynamods
      startDynaModIdx = startDynaModIdx + 1;
   end
end

function AddMod(a_mod, a_charID)

   local zoneName = "0";
   local state = "0";
   local questName = "0";
   if(a_mod.zoneName ~= nil and a_mod.zoneName ~= "") then
      zoneName = a_mod.zoneName;
   end
   if(a_mod.state ~= nil and a_mod.state ~= "") then
      state = a_mod.state;
   end
   if(a_mod.temporary ~= nil) then
      if(a_mod.temporary == "1") then
         questName = a_mod.qname;
      end
   end

   Server("AddDynaMod", a_mod.tagName, questName, a_mod.remove, state, zoneName, a_charID);
end

function RemoveMod(a_mod, a_charID)
   Server("RemoveDynaMods", a_mod.tagName, a_charID);
end


function LoadQuestData(fileName)
   if(flagQuestCommandsLoaded==false) then
      flagQuestCommandsLoaded = true;
      local lastQuestName = nil;
      local lastGoalName = nil;
      local qindex = 1;
      local gindex = 1;
      local lineNum = 1;
      for line in io.lines(fileName) 
      do

         local questName = ""; 
         local goalName = "";
         local command = "";

         -- do setup on the commands.
         local values = SplitString(line,";");
         questName = values[1];
         goalName = values[2];

         command = values[3];


         Log( "LineNum:"..lineNum);
         if(questName ~= lastQuestName) then
            Log("QuestName:"..questName);
            questOrder[qindex] = questName;
            lastGoalName = "";
            qindex = qindex + 1;
            lastQuestName = questName;
            gindex = 1;
         end

         if(goalName == "") then

             if( quests[questName] == nil) then
               quests[questName] = {};
             end

             local dynamod = {};
             if(command ~= "Remove") then
               dynamod.temporary = values[4];
               dynamod.remove = values[6];
               dynamod.state = values[7];
               dynamod.zoneName = values[8];
               dynamod.order = values[9];
               dynamod.tagName = values[5];
             else
               dynamod.tagName = values[4];
               dynamod.order = values[6];
             end
             dynamod.qname = questName;
             dynamod.command = command;

             table.insert(quests[questName],dynamod);

         else
            Log("GoalName:"..goalName.." QuestName:"..questName);
            if( goalName ~= lastGoalName ) then
               if(goalOrder[questName] == nil) then
                  goalOrder[questName] = {};
               end

               Log("GoalName:"..goalName.." QuestName:"..questName.." GoalIndex:"..gindex);
               goalOrder[questName][gindex] = goalName;
               gindex = gindex + 1;
               lastGoalName = goalName;
            end

            if(quests[questName] == nil) then
               quests[questName] = {};
            end

            if(quests[questName][goalName] == nil) then
               quests[questName][goalName] = {};
            end

            local dynamod = {};
            local count = table.getn(quests[questName][goalName]) + 1;
            if(command ~= "Remove") then
               Log("Store Add "..values[5].." at index "..count);
               dynamod.temporary = values[4];
               dynamod.remove = values[6];
               dynamod.state = values[7];
               dynamod.zoneName = values[8];
               dynamod.order = values[9];
               dynamod.tagName = values[5];
            else
               Log("Store Remove "..values[4].." at index "..count);
               dynamod.tagName = values[4];
               dynamod.order = values[6];
            end
            dynamod.qname = questName;
            dynamod.command = command;
            table.insert(quests[questName][goalName],dynamod);

         end
         lineNum = lineNum + 1;
      end -- for loop
   end -- done loading commands.
end