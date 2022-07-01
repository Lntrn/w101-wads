--[[

	ControlText.lua
	
	Class Type Functionality for ControlText
	
]]

-- ControlText derives from ControlWindow so include it
Include("API/Classes/ControlWindow.lua");

--[[
--------------------------------------------------------------------
	ControlSprite
	Wrapper for ControlSprite 
--------------------------------------------------------------------
]]

ControlButton = class(Window, function(a, sLabel, sx,sy,ex,ey)
			Window.init(a,sx,sy,ex,ey,true); -- init base class passing true as final arg means we will not call the c CreateWindow
			a.sLabel = sLabel;
			a.id = CreateButton("ControlButton",sLabel,MakeRectString( sx, sy, ex, ey ) );
			HideWindow(a.id);
			if(WindowRootWindow) then
				AttachWindow( a.id,WindowRootWindow:GetID());
			else
				AttachWindow( a.id )
			end
			
		end);

--------------------------------------------------------------------
--[[ Express setup via table with following format:
		setupTable.ButtonText,
		setupTable.PosX,	
		setupTable.PosY,
		setupTable.Width, 
		setupTable.Height ]]		
function ControlButtonSetup(setupTable)
	if(not setupTable) then
		return nil;
	end
	
	return ControlButton(	setupTable.ButtonText, 
							setupTable.PosX, 
							setupTable.PosY, 
							setupTable.PosX + setupTable.Width, 
							setupTable.PosY + setupTable.Height);
end
