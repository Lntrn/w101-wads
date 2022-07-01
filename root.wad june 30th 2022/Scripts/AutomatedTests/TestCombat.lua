--TODO: Test creating a character in TextClient if need be

TIME_INTERVAL = 10;
SPELL_COPIES = 3;

ZONE_NAME = "WizardCity/WC_Streets/WC_Unicorn";

POS = {{-5918.7299804688, 7264.0478515625, -1.0610961914063, 2.4177582263950},
       {-10379.045898438, 3720.3933105469, -1.0610656738281, 2.7922363281250},
       {-12099.911132813, 7517.9028320313, -151.06199645996, 4.5917406082150},
       {-10036.895507813, 13727.924804688, -100.98605346680, 3.6291587352750},
       {-13568.387695313, 13754.524414063, -1.0607910156250, 5.4236469268799},
       {-19440.064453125, 13310.559570313, -1.0608673095703, 1.2717169523239},
       {-22965.376953125, 13240.254882813, -100.85740661621, 2.7444953918457},
       {-22449.009765625, 16912.496093750, -1.0642852783203, 3.5814154148102},
       {-22493.941406250, 19663.253906250, -100.36116027832, 4.5364627838135},
};

SPELL_LIST = {"Fire Cat",
              "Frost Beetle",
              "Imp",
              "Scarab",
              "Bloodbat",
              "Thunder Snake",
              "Dark Sprite",
              "Leprechaun",
              "Lightning Bats",
              "Scorpion",
              "Snow Serpent",
              "Troll",
              "Fire Elf",
              "Ghoul",
};

SCHOOL_NAMES = {"Fire",
                "Ice",
                "Storm",
                "Myth",
                "Death",
                "Life",
                "Balance",
};

startPos = {};
waitingForTeleport = false;
charInit = false;

-- helper function to setup callbacks and register the event
function AddEvent(eventName, eventFunc)
   event_args = {};
   event_args.LUA_CallBack = eventFunc;
   RegisterEvent( eventName, event_args );
end

function OnPlanningPhase()
   Server("SelectSpell", "0", "1");
   Server("SelectSpell", "0", "2");
   Server("SelectSpell", "0", "3");
   Server("SelectSpell", "0", "4");
   Server("SelectSpell", "0", "5");
   Server("SelectSpell", "0", "6");
   Server("SelectSpell", "0", "7");
   Server("SelectSpell", "0", "8");
end

function OnVictoryPhase()
   SendVictoryMessage();
   Refill();
end

function OnCombatPhase(event)
   Log("OnCombatPhase "..event.Phase);
   if(event.Phase == 2) then
      OnPlanningPhase();
   end
   if(event.Phase == 6) then
      OnVictoryPhase();
   end
end

function OnTimer()
Log("OnTimer");
   if(IsPlayerParalyzed() > 0 or waitingForTeleport) then
      return;
   end

   local pos = POS[math.random(#POS)];
   
   SetPlayerPosition(pos[1], pos[2], pos[3], pos[4]);
   --SetPlayerPosition(pos[1], pos[2], pos[3], pos[4]);
   --SimulateKeyPress("W"); --Only works on graphical client
end

function CheckZone()
   Log("CheckZone()");
   if(GetZoneName() ~= ZONE_NAME) then
      waitingForTeleport = true;
      Server("Teleport", ZONE_NAME);
   else
      waitingForTeleport = false;
      PowerUp();
   end      
end

function Refill()
   Server("SetHealth","10000");
   Server("SetMana","10000");
end

function PowerUp()
   if (not charInit) then
      Server("SetLevel", 50);
      Server("SetPrimarySchool", SCHOOL_NAMES[math.random(#SCHOOL_NAMES)]);
      ClearPlayerInventory();
      GiveDeck();
      Refill();
      charInit = true;
   end
end

function EquipSpells()
   local i = nil;
   local j = nil;
   local level1Spells = nil;
   local level2Spells = nil;
   
   level1Spells = {GetSpellsByRank(1)};
   level2Spells = {GetSpellsByRank(2)};
   
   for i = 1, #level2Spells do
      Server("UnequipSpell", level2Spells[i]);
   end

   for i = 1, #level1Spells do
      Server("UnequipSpell", level1Spells[i]);
   end
   
   for i = 1, #SPELL_LIST do
      Server("AddSpell", SPELL_LIST[i]);
      for j = 1, SPELL_COPIES do
         Server("EquipSpell", SPELL_LIST[i]);
      end
   end
end

function EquipDeck()
   UnregisterEvent("OnItemAddedToInventory");
   EquipItem(97486, "Deck");
   EquipSpells();
   Start();
end

function GiveDeck()
   AddEvent("OnItemAddedToInventory", EquipDeck);

   --Adds Lotus Deck: 50 spells, 20 sideboard, max 4 copies, req level 30
   Server("AddInventory", 97486);
end

function Start()
   CheckZone();
   OnTimer();
   StartTimer("MonkeyTimer", TIME_INTERVAL, false);
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
      PowerUp();
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
