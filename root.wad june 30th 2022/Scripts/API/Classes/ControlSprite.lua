--[[

	ControlSprite.lua
	
	Class Type Functionality for ControlSprites
	
]]

-- ControlSprite derives from ControlWindow so include it
Include("API/Classes/ControlWindow.lua");

--[[
--------------------------------------------------------------------
	ControlSprite
	Wrapper for ControlSprite 
--------------------------------------------------------------------
]]

ControlSprite = class(Window, function(a, filename, sx,sy,ex,ey)
			Window.init(a,sx,sy,ex,ey,true); -- init base class passing true as final arg means we will not call the c CreateWindow
			a.id = CreateSprite( filename, MakeRectString(sx,sy,ex,ey), 0);
			if(WindowRootWindow) then
				AttachWindow( a.id,WindowRootWindow:GetID());
			else
				AttachWindow( a.id )
			end
		end);

function ControlSprite:SetSprite( filename )
	SetSpriteMaterial(self.id,filename);
end

--------------------------------------------------------------------
--[[ Express setup via table with following format:
		setupTable.FilePath,
		setupTable.PosX,	
		setupTable.PosY,
		setupTable.Width, 
		setupTable.Height ]]		
function ControlSpriteSetup(setupTable)
	if(not setupTable) then
		return nil;
	end
	
	return ControlSprite(	setupTable.FilePath, 
							setupTable.PosX, 
							setupTable.PosY, 
							setupTable.PosX + setupTable.Width, 
							setupTable.PosY + setupTable.Height);
end
