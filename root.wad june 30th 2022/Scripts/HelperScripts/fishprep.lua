function main()
	fishPrep();
end

function fishPrep()
	
	schools = {"Life", "Death", "Fire", "Ice", "Myth", "Storm", "Balance"};
	
	--adds all catch fish spells. As more spells are added, just increase the number of loops to add them all
	--one loop for each school, will add CatchFish and Winnow spells for that school
	for i = 1, table.getn(schools) do
		--one loop for each rank of catch fish spell, will add the CatchFish spell for each rank
		for j = 1, 3 do
			Server("addspell", "CatchFish"..schools[i]..j);
		end
		Server("addspell", "Winnow"..schools[i]);
	end
	
	Server("addspell", "FishingTestSpell");
	Server("addspell", "CatchFishAll100");

	--adds spells that affect fish speed/direction
	Server("addspell", "CharmFish");
	Server("addspell", "SlowFish");
	Server("addspell", "SleepFish");
	
	--adds summon fish
	Server("addspell", "SummonFish");
	
	--adds reveal fish spells
	Server("addspell", "RevealFish");
	Server("addspell", "RevealLargeFish");
	Server("addspell", "RevealSmallFish");
	Server("addspell", "RevealFishSchool");
	Server("addspell", "RevealFishRank1");
	Server("addspell", "CSRRevealFishNames");
	
	--adds sentinel spell
	Server("addspell", "BanishSentinels1");

	--Set player to the max fishing level
	Server("SetFishingLevel", "15");
	
	Server("teleport", "WC_Unicorn");
	Sleep(2);
	Server("teleport", "WC_Hub");
	Log(COMPLETE);
end