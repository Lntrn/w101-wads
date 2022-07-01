function DebugLog( msg )
	if DEBUG == true then
		Log( msg );
	end
end

function DebugLogTable( t )
	if DEBUG == true then
		for i, v in pairs( t ) do
			Log( i .. ": " .. v );
		end
	end
end

function DebugBeginCriticalSection()
	if DEBUG == false then
		BeginCriticalSection();
	end
end

function DebugEndCriticalSection()
	if DEBUG == false then
		EndCriticalSection();
	end
end
