--[[
	filename: LoginLibrary.lua
	description: login functions
	author: jeff everett
	use require "LoginLibrary" to use
]]



startTime = 0;
nextCheckTime = 0;


ClassLogin = {username="", password="", currentState=0};
ClassLogin.__index = ClassLogin;


function ClassLogin.new()
	local currentLogin = {};
	currentLogin.username = "";
	currentLogin.password = "";
	setmetatable(currentLogin, ClassLogin);
	return currentLogin;
end



function ClassLogin:login(username, password)
	self.username = username;
	self.password = password;
	
	print("User:"..username.." Pass:"..password);
	
	Login(username,password);	
	self.state = 0;
	local done = false;
	startTime = GetTime()+1;
	nextCheckTime = startTime+1000;
	
	while(self.state ~= 1)
	do
		self:MessagePump();
	end
end

function ClassLogin:SelectFirstCharacter()
	
	print("SelectFirstCharacter");

	SelectFirstCharacter();
	
	self.state = 0;
	local done = false;
	startTime = GetTime()+1;
	nextCheckTime = startTime+1000;
	
	while(self.state ~= 1)
	do
		self:MessagePump();
	end
end

function ClassLogin:SelectZone(zonename)
	
	print("Selecting Zone");
	SelectZone(zonename);
	
	self.state = 0;
	local done = false;
	
	startTime = GetTime()+1;
	nextCheckTime = startTime+1000;

	while(self.state ~= 1)
	do
		self:MessagePump();
	end
	print("Done Select");
end


function ClassLogin:MessagePump()
	-- for now just delay 
	
	local currentTime = GetTime()+1;
	if(currentTime > nextCheckTime) then
		done = true;
		self.state = 1;
	end
end



