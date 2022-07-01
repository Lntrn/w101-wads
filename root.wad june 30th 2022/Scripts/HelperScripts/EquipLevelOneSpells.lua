function main()
	EquipLevelOneSpells();
end

function EquipLevelOneSpells()
	--level1Spells= {"Fire Cat", "Thunder Snake", "Bloodbat", "Frost Beetle", "Imp"};
	level1Spells = {GetSpellsByRank(1)};
	level2Spells = {GetSpellsByRank(2)};
	
	--Remove all level 2 spells from the deck
	for i = 1, table.getn(level2Spells) do
		for k = 1, 6 do
			Server("UnequipSpell", level2Spells[i]);
		end
	end

	--Make sure the palyer isn't equipping any spells yet
	for i = 1, table.getn(level1Spells) do
		--Make sure they don't have any of this spell already equipped in their deck
		for k = 1, 6 do
			Server("UnequipSpell", level1Spells[i]);
		end
	end
	
	--Add all level 1 spells to the deck
	for j = 1, 6 do
		for i = 1, table.getn(level1Spells) do
			--Make sure the character has this spell in their spell book
			Server("AddSpell", level1Spells[i]);
			
			--Add this spell to the player's deck
			Server("EquipSpell", level1Spells[i]);
		end
		
	end
end