--[[

	ControlTileMap.lua
	
	Class Type Functionality for ControlTileMap
			
	
]]

-- ControlTileMap derives from ControlWindow so include it
Include("API/Classes/ControlWindow.lua");

--[[
--------------------------------------------------------------------
	ControlTileMap
	Wrapper for ControlSprite 
--------------------------------------------------------------------
]]


ControlTileMap = class(Window, function(a, mapSizeX,mapSizeY,tileSizeX,tileSizeY)
			Window.init(a,0,0,0,0,true); -- init base class passing true as final arg means we will not call the c CreateWindow
			a.id = CreateObject( "class ControlTileMap" );
			a.mapSizeX = mapSizeX;
			a.mapSizeY = mapSizeY;
			a.tileSizeX = tileSizeX;
			a.tileSizeX = tileSizeX;
			
			SetProperty( a.id, "m_MapSize", MakePointString(mapSizeX,mapSizeY));
			SetProperty( a.id, "m_TileSize", MakePointString(tileSizeX,tileSizeY));

			-- set all cells to -1 (should probably be done in the constructor of the C Class
			for n=0,(mapSizeY*mapSizeX) do		
				SetProperty(a.id,"m_Map["..n.."]",-1);
			end
				
			HideWindow(a.id);
			if(WindowRootWindow) then
				AttachWindow( a.id,WindowRootWindow:GetID());
			else
				AttachWindow( a.id )
			end
		end);


function ControlTileMap:ClearAll(clearValue)
	if(not clearValue) then
		clearValue = -1;
	end
	
	for n=0,(self.mapSizeY*self.mapSizeX) do		
		SetProperty(self.id,"m_Map["..n.."]", clearValue);
	end
end

function ControlTileMap:AddTileTexture(tileNum, filename)

	local pTexture1 = CreateObject("class TextureD3D" );
	SetProperty( pTexture1, "m_strFilename", filename );
	local pMaterial1 = CreateObject( "class Material" );
	SetProperty( pMaterial1, "m_DiffuseMap", pTexture1 );
	
	
	SetProperty( self.id, "m_Tiles["..tileNum.."].m_Color", "FFFFFFFF");	
	SetProperty( self.id, "m_Tiles["..tileNum.."].m_pMaterial", pMaterial1 );

end

function ControlTileMap:AddTileColor(tileNum, color)
	
	SetProperty( self.id, "m_Tiles["..tileNum.."].m_Color", color);	
end

function ControlTileMap:SetCell(x,y ,n)
	local width=0;
	local height=0;
	local size = GetProperty(self.id,"m_MapSize");
	_,_,width,height = string.find(size,"(%d+),(%d+)");
	local cell = x+(y*width);
	return SetProperty(self.id,"m_Map["..cell.."]",n);
end

function ControlTileMap:SetCell1D(cell ,n)
	return SetProperty(self.id,"m_Map["..cell.."]",n);
end

function ControlTileMap:GetCell(x,y)
	local width =0;
	local height = 0;
	local size = GetProperty(self.id,"m_MapSize");
	_,_,width,height = string.find(size,"(%d+),(%d+)");
	local cell = x+(y*width);
	local value = GetProperty(self.id,"m_Map["..cell.."]");
	return tonumber(value);
end



--------------------------------------------------------------------
--[[ Express setup via table with following format:
		setupTable.Cols,
		setupTable.Rows,	
		setupTable.TileSizeX,
		setupTable.TileSizeY, 
		setupTable.PosX,
		setupTable.PosY,
		setupTable.Tiles -- Table with key(layer num) and value(string filepath) ]]	
function ControlSpriteSetup(SetupTable)
	return ControlSprite(	SetupTable.FilePath, 
							SetupTable.PosX, 
							SetupTable.PosY, 
							SetupTable.PosX + SetupTable.Width, 
							SetupTable.PosY + SetupTable.Height);
end


function ControlTileMapSetup(setupTable)
	local tileMap = ControlTileMap(	setupTable.Cols, 
									setupTable.Rows, 
									setupTable.TileSizeX,
									setupTable.TileSizeY);
										
	tileMap:Move( setupTable.PosX, setupTable.PosY );		

	-- Load all the textures that our tilemap needs.
	for k,v in pairs(setupTable.Tiles) do
		if(type(k) == "number" and type(v) == "string" ) then
			tileMap:AddTileTexture(k, v);
		end
	end       
	
	return tileMap;
end