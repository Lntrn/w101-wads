function main()
-- Local Variables used in the script
        -- Name of Character that is logged in
        local CharacterPlaying = GetLocalCharacterName();
                
        Log ("Giving All Fishing Spells to "..CharacterPlaying);
		
--Set Fishing Level to 1
        Server("SetFishingLevel", "1");
		
-- Add All Fishing Spells to the player
        Server("AddSpell", "CatchFishBalance1");
		Server("AddSpell", "CatchFishDeath1");
		Server("AddSpell", "CatchFishFire1");
		Server("AddSpell", "CatchFishIce1");
		Server("AddSpell", "CatchFishLife1");
		Server("AddSpell", "CatchFishMyth1");
		Server("AddSpell", "CatchFishStorm1");
        Server("AddSpell", "CatchFishBalance2");
		Server("AddSpell", "CatchFishDeath2");
		Server("AddSpell", "CatchFishFire2");
		Server("AddSpell", "CatchFishIce2");
		Server("AddSpell", "CatchFishLife2");
		Server("AddSpell", "CatchFishMyth2");
		Server("AddSpell", "CatchFishStorm2");
		Server("AddSpell", "CharmFish");
		Server("AddSpell", "RevealFish");
		Server("AddSpell", "RevealFishSchool");
		Server("AddSpell", "SummonFish");
		Server("AddSpell", "SlowFish");
		Server("AddSpell", "SleepFish");
		Server("AddSpell", "RevealSmallFish");
		Server("AddSpell", "RevealLargeFish");
		Server("AddSpell", "RevealFishRank1");
		Server("AddSpell", "WinnowFire");
		Server("AddSpell", "WinnowIce");
		Server("AddSpell", "WinnowStorm");
		Server("AddSpell", "WinnowMyth");
		Server("AddSpell", "WinnowLife");
		Server("AddSpell", "WinnowDeath");
		Server("AddSpell", "WinnowBalance");
		Server("AddSpell", "CatchFishBalance3");
		Server("AddSpell", "CatchFishDeath3");
		Server("AddSpell", "CatchFishFire3");
		Server("AddSpell", "CatchFishIce3");
		Server("AddSpell", "CatchFishLife3");
		Server("AddSpell", "CatchFishMyth3");
		Server("AddSpell", "CatchFishStorm3");
		Server("AddSpell", "BanishSentinels1");
		Server("AddSpell", "CSRRevealFishNames");
				
end;  -- Main