--[[
	Simple Timer class for LUA.
]]

Include( "API/Classes/class.lua" );

Timer = class( function( a )
		a.StartTime = 0;
		a.ElapsedTime = 0;
		a.Paused = false;
		end );
		
function Timer:Reset()
	self.StartTime = GetTime();
	self.ElapsedTime = 0;
	self.Paused = false;
end

function Timer:GetTime( InSeconds )
	local ElapsedTime = GetTime() - self.StartTime;

	if InSeconds ~= nil and InSeconds == true then
		if self.Paused == false then
			return ( ElapsedTime * 0.001 );
		end
		
		return ( self.ElapsedTime * 0.001 );
	end
	
	if self.Paused == true then
		return self.ElapsedTime;
	end
	
	return ( GetTime() - self.StartTime );
end

function Timer:Pause()
	if self.Paused == true then
		self.Paused = false;
		self.StartTime = GetTime() - self.ElapsedTime;
	else
		self.Paused = true;
		self.ElapsedTime = GetTime() - self.StartTime;
	end
end
