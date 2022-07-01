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

ControlText = class(Window, function(a, sx,sy,ex,ey)
			Window.init(a,sx,sy,ex,ey,true); -- init base class passing true as final arg means we will not call the c CreateWindow
			a.id = CreateWindow(""..sx..", "..sy..", "..ex..", "..ey, 1, "class ControlText");
			if(WindowRootWindow) then
				AttachWindow( a.id,WindowRootWindow:GetID());
			else
				AttachWindow( a.id )
			end
			
		end);

function ControlText:SetText(text,color)
      if(not color) then
         SetProperty(self.id, "m_sText", text);
      else
         SetProperty(self.id, "m_sText", "<color;"..color..">"..text.."</color>");
      end
end