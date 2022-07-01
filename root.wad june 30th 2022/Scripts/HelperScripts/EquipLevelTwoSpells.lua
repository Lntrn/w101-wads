function main()
	level2Spells = {"Pixie", "Troll", "Fire Elf", "Snow Serpent", "Lightning Bats"};
	level1Spells= {"Fire Cat", "Thunder Snake", "Bloodbat", "Frost Beetle", "Imp"};
	
	--Remove all level 1 spells from the deck for now, but make sure they still have it in their spell book
	for i = 1, table.getn(level1Spells) do
		Server("AddSpell", level1Spells[i]);
		for k = 1, 6 do
			Server("UnequipSpell", level1Spells[i]);
		end
	end

	--Add the level 2 spells to the deck
	for i = 1, table.getn(level2Spells) do
		--Make sure the character has this spell in their spell book
		Server("AddSpell", level2Spells[i]);
		
		--Make sure they don't have any of this spell already equipped in their deck
		for k = 1, 6 do
			Server("UnequipSpell", level2Spells[i]);
		end
		
		--Add as many of this spell to the deck as we can.
		for j = 1, 6 do
			Server("EquipSpell", level2Spells[i]);
		end
		
	end
	
	--Finally, add level 1 spells evenly until there isn't any room left in the deck
	for i = 1, 6 do
		for j = 1, table.getn(level1Spells) do
			Server("EquipSpell", level1Spells[j]);
		end
	end
end