
Include("Scripts/API/ControlClasses.lua");
Include("Scripts/API/Globals.lua");
Include("Scripts/API/Classes/EventManager.lua");
Include("Scripts/API/Debug.lua");

g_EventManager = EventManager();

---------------------------------------------------------------------------------------------------------
-- Helper function, used in initialization to reduce duplicate code
-- Usage: Some scripts use a table with the format:
--       windowTable.GUI             -- The root of the GUI the windowTable represents
--       windowTable[$(windowName)]  -- Holds the direct reference to the window with the name $(windowName)
---------------------------------------------------------------------------------------------------------
function WindowIntoTable(a_TargetTable, a_WindowName) 
   a_TargetTable[a_WindowName] = a_TargetTable.GUI.FindNamedWindow(a_WindowName);
   assert(a_TargetTable[a_WindowName] ~= nil, a_WindowName.." does not exist!" );
   return a_TargetTable[a_WindowName];
end
