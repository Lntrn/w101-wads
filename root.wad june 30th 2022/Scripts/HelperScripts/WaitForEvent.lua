--This function will wait for the specified event
--
--@param[in]	eventName	The name of the event to wait for
function WaitForEvent(eventName)
	RegisterEvent(eventName);
	GetEvent(eventName);
	UnregisterEvent(eventName);
end
