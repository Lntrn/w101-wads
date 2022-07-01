GameCanSpawn = 0;

function main()
	RegisterEvent("ClientInteraction");
	
	local event = GetEvent();
		
	if (event.EventName == "ClientInteraction") then
		-- player has clicked on this object, try to get them a slot
		AllocateSlot(event.CharacterGID, OwnerGID, GameCanSpawn);
	end
end
