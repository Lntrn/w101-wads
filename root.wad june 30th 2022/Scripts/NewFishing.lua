function main()
-- Local Variables used in the script
        -- Name of Character that is logged in
        local CharacterPlaying = GetLocalCharacterName();
                
        Log ("Giving New Fishing Spells to "..CharacterPlaying);
		
-- Add All Fishing Spells to the player
        Server("AddSpell", "CatchFishBalance3");
		Server("AddSpell", "CatchFishDeath3");
		Server("AddSpell", "CatchFishFire3");
		Server("AddSpell", "CatchFishIce3");
		Server("AddSpell", "CatchFishLife3");
		Server("AddSpell", "CatchFishMyth3");
		Server("AddSpell", "CatchFishStorm3");
		
		Server("AddSpell", "RevealFishRank1");
		Server("AddSpell", "BanishSentinels1");
		
		Server("AddSpell", "WinnowBalance");
		Server("AddSpell", "WinnowDeath");
		Server("AddSpell", "WinnowFire");
		Server("AddSpell", "WinnowIce");
		Server("AddSpell", "WinnowLife");
		Server("AddSpell", "WinnowMyth");
		Server("AddSpell", "WinnowStorm");
		
		Server("AddSpell", "RevealLargeFish");
		Server("AddSpell", "RevealSmallFish");
				
end;  -- Main