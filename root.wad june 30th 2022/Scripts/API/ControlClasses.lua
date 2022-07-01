--[[

	ControlClasses.lua
	
	Window Control Class Functionality

]]




------------------------------------------
--[[ CONTROL CLASS CREATION FUNCTIONS ]]--
------------------------------------------

--[[ Attaches a window to the passed in parent or the game window if parent is nil ]]
function AttachNewWindow(newWindow, parent)
 
	if (parent == nil) then
		AttachWindow(newWindow)
	else
		AttachWindow(newWindow, parent);
	end
end

--[ Create a new GUI class of from the defined GUI file
function CreateGUIClass( gui, visible )
	return OpenClass( LoadGUI( gui, visible ) );
end

--[[ Opens an existing Window class ]]
function OpenWindowClass( name, parent )
	return OpenClass( OpenWindow(name, parent) );
end

--[[ Create a new Window class of the defined sub-type ]]
function CreateWindowClass( rect, visible, klass, parent )
	
	local newClass = OpenClass( CreateWindow( rect, visible, klass ) );
	AttachNewWindow(newClass, parent)

	return newClass;
end

--[[ Create a new ControlTileMap class ]]
function CreateTileMapClass( sx, sy, cols, rows, tileWidth, tileHeight, visible, parent )

	local ex = sx + cols * tileWidth;
	local ey = sy + rows * tileHeight;

	local tileMap = CreateWindowClass( sx..","..sy..","..ex..","..ey, visible, "class ControlTileMap", parent );
	AttachNewWindow(tileMap, parent)

	tileMap.SetTileSize( tileWidth..","..tileHeight );
	tileMap.SetMapSize(cols..","..rows);

	return tileMap;
end

--[[ Adds a new tile with the defined texture to the specified ControlTileMap ]]
function TileMap_AddTileTexture(classTileMap, texture)

	tile = classTileMap.AddTile();
	tile.SetMaterial( CreateMaterialClass(texture) );
	tile.SetColor( "FFFFFFFF" );

end

--[[ Adds a new tile with the defined color to the specified ControlTileMap ]]
function TileMap_AddTileColor(classTileMap, color)

	tile = classTileMap.AddTile();
	tile.SetColor( color );

end

--[[ Returns a string with proper color coding to make the entire text the passed in color ]]
function FormatTextColor( text, color)

return "<color;"..color..">"..text.."</color>";

end

--[[ Create a new ControlButton class ]]
function CreateButtonClass( name, label, rect, visible, parent )

	local newClass = OpenClass( CreateButton( name, label, rect, visible ) );
	AttachNewWindow(newClass, parent)

	return newClass;
end

--[[ Create a new ControlSprite class ]]
function CreateSpriteClass( texture, rect, visible, parent )

	local newClass = OpenClass( CreateSprite( texture, rect, visible ) );
	AttachNewWindow(newClass, parent)

	return newClass
end

--[[ Create a new ControlLine class ]]
function CreateLineClass( line, color, parent )

	local newClass = OpenClass( CreateLine( line, color ) );
	AttachNewWindow(newClass, parent)

	return newClass;

end

--[[ Create a new Material class ]]
function CreateMaterialClass( texture )
	return OpenClass( CreateMaterial( texture ) );
end

function CreateTextWindowClass(text,visible,parent)
	local newClass = OpenClass(CreateTextWindow(text,visible));
	AttachNewWindow(newClass, parent)
	return newClass;
end

function CreateTileMaterialClass( texture, x, y )
	local textured3d = CreateClass( "TextureD3D" );
	textured3d.SetFileName( texture );
	
	local material = CreateClass( "TileMaterial" );
	material.SetDiffuseTexture( textured3d );
	material.SetTilesX( x );
	material.SetTilesY( y );
	material.CalculateFrames();
	
	return material;
end

function PushABState()
	PushActionBarState();
end

function PopABState()
	PopActionBarState();
end

function SetABButton( index, material, name, visible )
	SetActionBarButton( index, material, name, visible );
end

function SetABButtonMaterial( index, material )
	SetActionBarButtonMaterial( index, material );
end

function SetABButtonName( index, name )
	SetActionBarButtonName( index, name );
end

function SetABButtonVisible( index, visible )
	SetActionBarButtonVisible( index, visible );
end

-- Easier to use interface for messing with the ActionBar!
ActionBar	= {	Push = PushABState,
				Pop = PopABState,
				SetButton = SetABButton,
				SetButtonMaterial = SetABButtonMaterial,
				SetButtonName = SetABButtonName,
				ShowButton = SetABButtonVisible };
