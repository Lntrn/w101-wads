--[[

	ControlMessageBox.lua
	
	Class Type Functionality for ControlMessageBox
	
]]

-- ControlMessageBox derives from ControlSprite and contains 2 ControlText obbjects
-- so include them

Include("API/Classes/ControlSprite.lua");
Include("API/Classes/ControlText.lua");

--[[
--------------------------------------------------------------------
	ControlMessageBox
	Create a messagebox
--------------------------------------------------------------------
]]

ControlMessageBox = class(ControlSprite, function(a, filename, sx,sy,ex,ey,borderSize,titleBarHeight)
			ControlSprite.init(a,filename,sx,sy,ex,ey);
			
			--[[ Revision note: Removed sx+ and sy+ from the title and text, as this would offset them by sz WITHIN the ControlMessageBox
					Also corrected the ex/ey for title and text ]]
			local innerEx = ex - borderSize * 2;
			local innerEy = ey - borderSize * 2;
			a.Title = ControlText(borderSize, borderSize, innerEx, innerEy );
			a.Text = ControlText(borderSize, titleBarHeight + borderSize, innerEx, innerEy );
			a.titleBarHeight = titleBarHeight;
			a.borderSize = borderSize;
			AttachWindow( a.Title:GetID(), a.id );
			AttachWindow( a.Text:GetID(), a.id );
			if(WindowRootWindow) then
				AttachWindow( a.id,WindowRootWindow:GetID());
			else
				AttachWindow( a.id )
			end
		end);




function ControlMessageBox:Move(nx,ny)
	self.sx = nx;
	self.sy = ny;
	self.ex = nx+self.width;
	self.ey = ny+self.height;
	MoveWindow(self.id,MakePointString(nx,ny));
	
end


function ControlMessageBox:Message(sTitle,sMessage,titleColor,textColor)
	if(not titleColor) then
		titleColor = "FFFFFFFF";
	end
	if(not textColor) then
		textColor = "FFFFFFFF";
	end
	self.Title:SetText(sTitle,titleColor);
	self.Text:SetText(sMessage,textColor);
end          


--[[ Attach the Title/Text ]]
function ControlMessageBox:Attach(Title, Text)
	if(Title) then
		AttachWindow( self.Title:GetID(), self:GetID() );
	end
	if(Text) then
		AttachWindow( self.Text:GetID(), self:GetID() );
	end
end

--------------------------------------------------------------------
--[[ Express setup via table with following format:
		setupTable.FilePath,
		setupTable.PosX,	
		setupTable.PosY,
		setupTable.Width, 
		setupTable.Height,
		setupTable.BorderSize,
		setupTable.TitleBarHeight ]]		
function ControlMessageBoxSetup(setupTable)
	if(not setupTable) then
		return nil;
	end
	
	return ControlMessageBox(	setupTable.FilePath, 
								setupTable.PosX, 
								setupTable.PosY, 
								setupTable.PosX + setupTable.Width, 
								setupTable.PosY + setupTable.Height,
								setupTable.BorderSize,
								setupTable.TitleBarHeight);
end


function main()
	Log("ControlMessageBox.lua run (for debugging purposes).");
end