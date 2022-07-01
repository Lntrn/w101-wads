TIME_INTERVALS = {101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151};

ZONE_NAMES = {"WizardCity/WC_Hub",
              "WizardCity/WC_Ravenwood",
              "WizardCity/WC_Golem_Tower",
              "WizardCity/WC_OldeTown",
              "WizardCity/WC_Shop_Area",
};

startPos = {};

-- helper function to setup callbacks and register the event
function AddEvent(eventName, eventFunc)
   event_args = {};
   event_args.LUA_CallBack = eventFunc;
   RegisterEvent(eventName, event_args);
end

function OnTimer()
   Log("OnTimer");
   Server("Teleport", ZONE_NAMES[math.random(#ZONE_NAMES)]);
end

function Start()
   OnTimer();
   --Pick a random interval
   StartTimer("MonkeyTimer", TIME_INTERVALS[math.random(#TIME_INTERVALS)], false);
end

function CharacterCreated()
   Log("CharacterCreated()");
   UnregisterEvent("CharacterSelectState");
   
   --For some odd reason, trying to select a character too soon after getting the
   --CharacterSelectState event doesn't work.  So, I'm waiting a bit.
   Sleep(0.5);

   local success = nil;
   success = SelectFirstCharacter();

   if (success == 0) then
      Log("Problem creating character; ending script process.");
      Kill(GetProcessID());
   end
   
   Start();
end

function CharacterHandling()
   Log("CharacterHandling()");
   local success = nil;
   success = SelectFirstCharacter();

   --If successful then we'll get the message we teleported when in the game
   if (success == 0) then
      AddEvent("CharacterSelectState", CharacterCreated);
      WizCreateCharacter(1);
   end
end

function Init()
   startPos[1], startPos[2], startPos[3], startPos[4] = GetPlayerPosition();
   
   if (startPos[1] and startPos[2] and startPos[3] and startPos[4]) then
      Log("Player starting position: "..startPos[1]..", "..startPos[2]..", "..startPos[3]..", "..startPos[4]);
   end
   
   if (GetCharacterGID() == 0) then
      CharacterHandling();
   else
      Start();
   end


   AddEvent("MonkeyTimer", OnTimer);
   AddEvent("CombatPhase", OnCombatPhase);
   AddEvent("OnTeleported", CheckZone);
end

function main()
   Log("AIMonkeyTest Script Starting");
   --Server("Teleport","WizardCity/WC_Streets/WC_Unicorn");
   -- seed random and pop a few randoms off (docs say this ensures a "more" random first number...dont ask me
   math.randomseed(GetTime());
   math.random();
   math.random();
   math.random();
   math.random();

   Init();

   while(true) do 
      -- GetEvent called with no parameters = get any event and no timeout
      event = GetEvent();
      if(event) then
         Log("Event name: "..event.EventName);
         -- since all of our registered events have a callback, 
         -- we will not have to handle event parsing within our main()
         if (event.LUA_CallBack) then
            event.LUA_CallBack(event);
         end
      end
   end
   Log("Ending AIMonkeyTest Script");
end

--EOF
