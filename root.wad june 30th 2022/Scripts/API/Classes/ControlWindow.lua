--[[

	Window.lua
	
	Class Type Functionality for Windows
			
	
]]
Include("API/Classes/class.lua");

--[[
--------------------------------------------------------------------
	LuaWindow
	Wrapper for Window class 
--------------------------------------------------------------------
]]


WindowRootWindow = nil;

Window = class(function(a,sx,sy,ex,ey,dontcreate)
		a.sx = sx;
		a.sy = sy; 
		a.ex = ex;
		a.ey = ey;
		a.parentID = 0;
		if(not dontcreate) then
			a.id = CreateWindow(MakeRectString(sx,sy,ex,ey), 0);
			if(WindowRootWindow) then
				AttachWindow( a.id,WindowRootWindow:GetID());
			else
				AttachWindow( a.id )
			end
		else
			a.id = -1;
		end
		a.width = ex-sx;
		a.height = ey-sy;
		a.hidden = true; 
	end);
		
-- move window to a new position
function Window:Move(nx,ny)
	self.sx = nx;
	self.sy = ny;
	self.ex = nx+self.width;
	self.ey = ny+self.height;
	MoveWindow(self.id,""..nx..","..ny);
end

function Window:Hide()
	HideWindow(self.id);
	self.hidden = true;
end

function Window:Show()
	ShowWindow(self.id);
	self.hidden = false;
end

function Window:IsHidden()
	return self.hidden;
end

function Window:SetDepth(depth)
	WindowSetDepth(self.id, depth);
end

function Window:GetDepth()
	return WindowGetDepth(self.id);
end


function Window:SetWindowRect(sx,sy,ex,ey)
	self.sx=sx;
	self.ex=ex;
	self.sy=sy;
	self.ey=ey;
	rect = MakeRectString(sx,sy,ex,ey);
	Log("Making rect"..rect);
	SetWindowRect(self.id,rect);
end

function Window:GetRect()
	rect = GetProperty(self.id, "m_Window");
	return rect;
end

function Window:GetLeft()
	rect = GetProperty(self.id, "m_Window");
	_,_,sx,sy,ex,ey = string.find(rect, "(%d+),(%d+),(%d+),(%d+)");
	self.sx = tonumber(sx);
	return self.sx;
end

function Window:GetTop()
	rect = GetProperty(self.id, "m_Window");
	_,_,sx,sy,ex,ey = string.find(rect, "(%d+),(%d+),(%d+),(%d+)");
	self.sy = tonumber(sy);
	return self.sy;
end
function Window:GetRight()
	rect = GetProperty(self.id, "m_Window");
	_,_,sx,sy,ex,ey = string.find(rect, "(%d+),(%d+),(%d+),(%d+)");
	self.ex = tonumber(ex);
	return self.ex;
end
function Window:GetBottom()
	rect = GetProperty(self.id, "m_Window");
	_,_,sx,sy,ex,ey = string.find(rect, "(%d+),(%d+),(%d+),(%d+)");
	self.ey = tonumber(ey);
	return self.ey;
end

function Window:GetID()
	return self.id;
end

function Window:Attach(window)
	self.parentID = AttachWindow(self.id,window)
end

function Window:Detach()
	if(self.parentID ~= 0) then
		DetachWindow(self.parentID);
		self.parentID = 0;
	end
end


function SetMainAttachWindow(window)
	WindowRootWindow = window;
end
