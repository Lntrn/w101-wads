--Waits for the specified number of miliseconds
function Wait(delay)
	RegisterEventCallback("MonkeyTimer", OnTimer);
	
	--Start a timer that will fire 4 times as fast as the delay, so that our delay lasts as long as we want +/- 25%
	local timerID = StartTimer("MonkeyTimer", delay / 4000, false);
	
	DoneWaiting = false;
	EndTime = GetTime() + delay;
	while(DoneWaiting == false) do
		event = GetEvent();
		if(event) then
			if(event.LUA_CallBack) then
				event.LUA_CallBack(event);
			end
		end
	end
	StopTimer(timerID);
	UnregisterEvent("MonkeyTimer");
end

function OnTimer()
	if(EndTime <= GetTime()) then
		Endtime = GetTime() + 1;
		DoneWaiting = true;
	end
end
