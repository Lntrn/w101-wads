--[[

	WrapSprite.lua
	
	Class Type Functionality for Windows
			
	
]]
Include("API/Classes/class.lua");


--[[
--------------------------------------------------------------------
	WrapSpirte
	A Sprite that wraps and draws a partial part of itself on the other side of the screen when it is clipped
	
--------------------------------------------------------------------
]]


WrapSprite = class(function(a, name, width,height,clipWindow)
		a.name = name;
		a.width = width; 
		a.height = height;
		a.clipWindow = clipWindow;
		a.wrapMode = true;
		a.normalSprite = CreateSpriteClass(name,MakeRectString(0,0,width,height),false,clipWindow);	
		a.LeftRightWrapSprite = CreateSpriteClass(name,MakeRectString(0,0,width,height),false,clipWindow);	
		a.TopBottomWrapSprite = CreateSpriteClass(name,MakeRectString(0,0,width,height),false,clipWindow);	
	end);
		
-- move window to a new position
function WrapSprite:Move(nx,ny)
		self.normalSprite.SetLocation(nx,ny);
		if(wrapMode == true) then
			local bx = (self.clipWindow.GetRight() - self.clipWindow.GetLeft())-self.width;
			local by = (self.clipWindow.GetBottom() - self.clipWindow.GetTop())-self.height;
			-- handle right clip
			if(nx > bx) then
				self.LeftRightWrapSprite.SetLocation(nx-(bx+self.width),ny);
				self.LeftRightWrapSprite.ShowWindow(true);
			elseif(nx< 0) then
				self.LeftRightWrapSprite.SetLocation(nx+(bx+self.width),ny);
				self.LeftRightWrapSprite.ShowWindow(true);
			else
				self.LeftRightWrapSprite.ShowWindow(false);
			end

			if(nx > (bx+self.width)) then
				nx = nx-(bx+self.width);
				self.normalSprite.SetLocation(nx,ny);
			end
			-- handle left clip
			if(nx < -self.width) then
				nx = nx+(bx)+self.width;
				self.normalSprite.SetLocation(nx,ny);
			end

			if(ny > by) then
				self.TopBottomWrapSprite.SetLocation(nx,ny-(by+self.height));
				self.TopBottomWrapSprite.ShowWindow(true);
			elseif(ny< 0) then
				self.TopBottomWrapSprite.SetLocation(nx,ny+by+self.height);
				self.TopBottomWrapSprite.ShowWindow(true);
			else
				self.TopBottomWrapSprite.ShowWindow(false);
			end

			if(ny > (by+self.height)) then
				ny = ny-(by+self.height);
				self.normalSprite.SetLocation(nx,ny);
			end

			if(ny < -self.height) then
				ny = ny+(by)+self.height;
				self.normalSprite.SetLocation(nx,ny);
			end
		end
		return nx,ny;
end


function WrapSprite:GetPosition()
	local nx = self.normalSprite.GetLeft();
	local ny = self.normalSprite.GetTop();
	return nx,ny;
end

function WrapSprite:EnableWrap()
	wrapMode = true;
end

function WrapSprite:DisableWrap()
	wrapMode = false;
end

function WrapSprite:Destroy()
	self.normalSprite.DetachSelf();
	DestroyClass(self.normalSprite);
	self.normalSprite  = nil;
	self.LeftRightWrapSprite.DetachSelf();
	DestroyClass(self.LeftRightWrapSprite);
	self.LeftRightWrapSprite  = nil;
	self.TopBottomWrapSprite.DetachSelf();
	DestroyClass(self.TopBottomWrapSprite);
	self.TopBottomWrapSprite  = nil;
end

function WrapSprite:SetRotation(rot)
	if(rot > 360) then
		rot = rot - 360;
	end
	self.normalSprite.SetRotation(rot);
	self.LeftRightWrapSprite.SetRotation(rot);
	self.TopBottomWrapSprite.SetRotation(rot);
	return rot;
end

function WrapSprite:SetAlpha(alpha)
	self.normalSprite.SetAlpha(alpha,false);
	self.LeftRightWrapSprite.SetAlpha(alpha,false);
	self.TopBottomWrapSprite.SetAlpha(alpha,false);
end


function WrapSprite:Show()
	self.normalSprite.ShowWindow(true);
end

function WrapSprite:Hide()
	self.normalSprite.ShowWindow(false);
	self.LeftRightWrapSprite.ShowWindow(false);
	self.TopBottomWrapSprite.ShowWindow(false);
end
