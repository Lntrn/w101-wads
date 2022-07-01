function GetArguments()
	local eventName = "Arguments";
	RegisterEvent(eventName);
	local event = GetEvent(eventName);
	UnregisterEvent(eventName);
	return event;
end