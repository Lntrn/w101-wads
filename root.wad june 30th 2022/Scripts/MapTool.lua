--[[ 
	MapTool.lua

	(c)2008 Kingsisle Entertainment
	Author: David Sapirstein
]]

Include("Scripts/GUI/GUICommon.lua");
Include("Scripts/API/Utilities.lua");

DEBUG = false;

---------------------------------------------------------------------------------------------------------
-- Constants
---------------------------------------------------------------------------------------------------------

MAP_FILE = "map.xml";
ZONE_PATH = "ZoneData/";

---------------------------------------------------------------------------------------------------------
-- Globals
---------------------------------------------------------------------------------------------------------

g_MainWindow = nil;

g_Windows = { Close = "Close",
              Save = "SaveButton",
              Screenshot = "ScreenshotButton",
              ZoneName = "ZoneName",
              MapViewMode = "mapViewCheckBox",
              OverlayViewMode = "overlayViewCheckBox",
              LockAspect = "lockAspectCheckBox",
              OverlayWindow = "OverlayWindow",
              CenterX = "CenterX",
              CenterY = "CenterY",
              Degrees = "Degrees",
              Width = "Width",
              Height = "Height",
            };

-- uses the same keys as g_Windows
g_WIDs = {};

g_AspectRatio = nil;
g_CurrentZone = nil;
g_MapData = nil;
g_FilePath = nil;
g_TL = {};
g_TR = {};
g_BL = {};
g_BR = {};
g_Center = {};
g_Size = {};
g_Rotation = nil;

g_MapViewOn = false;
g_OverlayOn = false;
g_OverlayMaterial = nil;

---------------------------------------------------------------------------------------------------------
-- Helpers
---------------------------------------------------------------------------------------------------------

function InitData()
   g_AspectRatio = GetAspectRatio();

   g_CurrentZone = GetZoneName();
   g_FilePath = GetDataRoot() .. ZONE_PATH .. g_CurrentZone .. "/";

   g_TL = GetPointTableFromString( g_MapData.GetTopLeft() );
   g_TR = GetPointTableFromString( g_MapData.GetTopRight() );
   g_BL = GetPointTableFromString( g_MapData.GetBottomLeft() );
   g_BR = GetPointTableFromString( g_MapData.GetBottomRight() );

   -- figure out initial center, rotation, and extents
   g_Center[1] = (g_TL[1] + g_TR[1] + g_BL[1] + g_BR[1]) / 4;
   g_Center[2] = (g_TL[2] + g_TR[2] + g_BL[2] + g_BR[2]) / 4;

   g_Size[1] = math.sqrt((g_TR[1] - g_TL[1])^2 + (g_TR[2] - g_TL[2])^2);
   g_Size[2] = math.sqrt((g_TL[1] - g_BL[1])^2 + (g_TL[2] - g_BL[2])^2);

   g_Rotation = math.deg( math.atan2( (g_TR[2] - g_TL[2]), (g_TR[1] - g_TL[1]) ) );
end

function UpdateData()
   -- calculate coordinate frame
   local right = {};
   right[1] = math.cos( math.rad( g_Rotation ) );
   right[2] = math.sin( math.rad( g_Rotation ) );
   local up = {};
   up[1] = -right[2];
   up[2] = right[1];

   -- figure out corners from our data
   g_TL[1] = g_Center[1] + ((-right[1] * g_Size[1] + up[1] * g_Size[2]) / 2);
   g_TL[2] = g_Center[2] + ((-right[2] * g_Size[1] + up[2] * g_Size[2]) / 2);
   g_TR[1] = g_Center[1] + ((right[1] * g_Size[1] + up[1] * g_Size[2]) / 2);
   g_TR[2] = g_Center[2] + ((right[2] * g_Size[1] + up[2] * g_Size[2]) / 2);
   g_BR[1] = g_Center[1] + ((right[1] * g_Size[1] - up[1] * g_Size[2]) / 2);
   g_BR[2] = g_Center[2] + ((right[2] * g_Size[1] - up[2] * g_Size[2]) / 2);
   g_BL[1] = g_Center[1] + ((-right[1] * g_Size[1] - up[1] * g_Size[2]) / 2);
   g_BL[2] = g_Center[2] + ((-right[2] * g_Size[1] - up[2] * g_Size[2]) / 2);

   -- set the new data
   g_MapData.SetTopLeft( MakePointString(g_TL[1], g_TL[2]) );
   g_MapData.SetTopRight( MakePointString(g_TR[1], g_TR[2]) );
   g_MapData.SetBottomLeft( MakePointString(g_BL[1], g_BL[2]) );
   g_MapData.SetBottomRight( MakePointString(g_BR[1], g_BR[2]) );
end

function SaveData()
   UpdateData();
   g_MapData.SaveToXML(g_FilePath, MAP_FILE);
   Log(MAP_FILE.." saved to "..g_FilePath);
end

function InitGUI()
   BeginCriticalSection();

   g_MainWindow = OpenClass(MyWindow);
   -- Store off subwindows and WIDs
   for key, value in pairs(g_Windows) do
      g_Windows[key] = g_MainWindow.FindNamedWindow(value);
      g_WIDs[key] = g_Windows[key].GetWID();
   end

   g_Windows.ZoneName.SetText(g_CurrentZone);

   -- Set initial values
   g_Windows.CenterX.SetText(g_Center[1]);
   g_Windows.CenterY.SetText(g_Center[2]);
   g_Windows.Width.SetText(g_Size[1]);
   g_Windows.Height.SetText(g_Size[2]);
   g_Windows.Degrees.SetText(g_Rotation);

   EndCriticalSection();
end

function ToggleMapMode()
   ToggleMapCaptureMode();
   if(g_MapViewOn == false) then
      g_MapViewOn = true;
   else
      g_MapViewOn = false;
   end
end

function ToggleOverlay()
   local windowStyle = g_Windows.OverlayWindow.GetWindowStyle();

   if(g_OverlayOn == false) then
      g_OverlayOn = true;

      g_OverlayMaterial = CreateMaterialClass( g_MapData.GetMapImageFile() );
      windowStyle.SetBackMaterial( g_OverlayMaterial );
      windowStyle.SetBackColor( "80FFFFFF" );
   else
      g_OverlayOn = false;
      
      windowStyle.SetBackMaterial( nil );
      windowStyle.SetBackColor( "00FFFFFF" );
   end
end

---------------------------------------------------------------------------------------------------------
-- Event handlers
---------------------------------------------------------------------------------------------------------

function WB_BUTTONUP(a_Event)
   --Log(a_Event.WID);

      --if(g_MapViewOn == true) then
         --ToggleMapMode();
      --end
      --g_MainWindow.DetachSelf();

   if(a_Event.WID == g_WIDs.Close) then
      if(g_MapViewOn == true) then
         ToggleMapMode();
      end
      g_MainWindow.DetachSelf();
   elseif(a_Event.WID == g_WIDs.Save) then
      SaveData();
   elseif(a_Event.WID == g_WIDs.Screenshot) then
      Screenshot(false);
   elseif(a_Event.WID == g_WIDs.MapViewMode) then
      ToggleMapMode();
   elseif(a_Event.WID == g_WIDs.OverlayViewMode) then
      ToggleOverlay();
   elseif(a_Event.WID == g_WIDs.LockAspect and g_Windows.LockAspect.IsChecked()) then
      local width = GetNumberOrZero( g_Windows.Width.GetText() );
      local adjustedHeight = width / g_AspectRatio;
      g_Windows.Height.SetText( adjustedHeight );
      local empty = {};
      WE_EDITDONE(empty);
   end
end
g_EventManager:SubscribeEvent("WB_BUTTONUP", WB_BUTTONUP);

function GetNumberOrZero( a_Value )
   local returnVal = tonumber( a_Value );
   if(returnVal == nil) then
      returnVal = 0;
   end

   return returnVal;
end

function WE_EDITDONE(a_Event)
  -- Refresh data
  g_Center[1] = GetNumberOrZero( g_Windows.CenterX.GetText() );
  g_Center[2] = GetNumberOrZero( g_Windows.CenterY.GetText() );
  g_Size[1]   = GetNumberOrZero( g_Windows.Width.GetText() );
  g_Size[2]   = GetNumberOrZero( g_Windows.Height.GetText() );
  g_Rotation  = GetNumberOrZero( g_Windows.Degrees.GetText() );

  UpdateData();

  -- Cycle the map capture mode to show new settings
  if(g_MapViewOn == true) then
     ToggleMapCaptureMode();
     ToggleMapCaptureMode();
  end
end
g_EventManager:SubscribeEvent("WE_EDITDONE", WE_EDITDONE);

---------------------------------------------------------------------------------------------------------
-- Main Entry point
---------------------------------------------------------------------------------------------------------

function main()
   g_MapData = OpenClass(GetMapData());
   if(g_MapData == nil) then
      Log("Error: Zone map does not exist.");
      return;
   end

   InitData();
   InitGUI();

   g_EventManager:DoEventLoop();
end
