function GetEventByName(eventName)
	RegisterEvent(eventName);
	local event = GetEvent(eventName);
	UnregisterEvent(eventName);
	return event;
end