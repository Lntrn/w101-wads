--[[ 
   Utilities

   Some helpful Lua utilities. Intended to grow. Water it and care for it like your child.
]]

Include("Scripts/API/Classes/ControlSprite.lua");
Include("Scripts/API/Classes/ControlButton.lua");
Include("Scripts/API/TypeCheckers.lua");
Include("Scripts/API/Asserts.lua");
Include("Scripts/API/AssertWrappers.lua");

----------------------------------------------------------------------------------------------------------------------
--[[ A simple empty function. ]]
function EmptyFunction( )
   -- Do nothing
   DebugLog("Entered an empty function");
end

----------------------------------------------------------------------------------------------------------------------
--[[ Same as string.find() but starts at the end. Start index is not treated in 
     reverse! IE: ReverseStringFind("i been bad", "b", 4) will return 3 in reference to 'been']]
function ReverseStringFind(sourceStr, findStr, startIndex)
   local sLen = string.len(sourceStr);
   if type(startIndex) ~= 'number' then
      startIndex = sLen;
   elseif startIndex < 0 then
      -- Support standard lua negative indexes (ie: -1 for the last character)
      startIndex = sLen + startIndex;
   end
   
   local i = string.find(sourceStr, findStr);
   local p = nil;
   local fLen = string.len(findStr);
   
   while i ~= nil and i + fLen <= startIndex do
      p = i;
      i = string.find(sourceStr, findStr, i + 1);
   end
   return p;
end

----------------------------------------------------------------------------------------------------------------------
--[[ Split a string on the given character]]
function SplitString( str, splitter)
   assert(IsString(str));
   assert(IsString(splitter));
   
   local begin;
   local finish;
   local nextStart = 1;
   begin, finish = string.find(str, splitter, nextStart);
   local results = {};
   while begin ~= nil do
      local subSection = string.sub(str, nextStart, begin-1);
      table.insert(results, subSection);
      nextStart = finish + 1;
      begin, finish = string.find(str, splitter, nextStart);
   end
   local subSection = string.sub(str, nextStart);
   table.insert(results, subSection);
   
   return results;
end


----------------------------------------------------------------------------------------------------------------------
--[[ Get the local GID of a client ]]
function GetLocalGID( )
   return OpenClass(GetClientObject()).GetGlobalID();
end

----------------------------------------------------------------------------------------------------------------------
--[[ Get the first free index in an array-type table. Returns index of 'back' if array is full. ]]
function GetFirstFreeIndex( a_Array )
   
   -- loop for gaps
   for n = 1, #a_Array do
      if a_Array[n] == nil then
         return n;
      end
   end
   
   -- No gaps, send index of Size+1
   return #a_Array + 1;
end

----------------------------------------------------------------------------------------------------------------------
--[[ Helper Function to make a RectString ]]
function MakeRectString(sx,sy,ex,ey)
   return ""..sx..","..sy..","..ex..","..ey;
end

----------------------------------------------------------------------------------------------------------------------
--[[ Helper Function to tear apart a RectString ]]
function GetRectFromString(str)
   assert(IsString(str));
   
   local results = SplitString(str, ",");   
   local rect = {};
   for i = 1, 4 do
      rect[i] = tonumber(results[i]);
   end
   return rect;
end

----------------------------------------------------------------------------------------------------------------------
--[[ Helper Function to make a PointString ]]
function MakePointString(x,y)
   return ""..x..","..y;
end

----------------------------------------------------------------------------------------------------------------------
--[[ Helper Function to tear apart a PointString ]]
function GetPointFromString(str)
   assert(IsString(str));   
   local point = {};
   point = SplitString(str, ",");
   return point[1], point[2];   
end


----------------------------------------------------------------------------------------------------------------------
--[[ Helper Function to tear apart a PointString and return a table ]]
function GetPointTableFromString(str)
   assert(IsString(str));
   
   local results = SplitString(str, ",");
   local point = {};
   for i = 1, 2 do
      point[i] = tonumber(results[i]);
   end
   return point;
end

----------------------------------------------------------------------------------------------------------------------
--[[ Helper Function to make a VectorString ]]
function MakeVector3DString(x,y,z)
   return ""..x..","..y..","..z;
end

----------------------------------------------------------------------------------------------------------------------
--[[ Get time in seconds. ]]
function GetTimeInSeconds()
   return GetTime() * 0.001;
end

--[[Is Pont in rect? ]]
function IsPointInRect(x,y,rect)
   if(x > rect[1] and x < rect[3] and y > rect[2] and y < rect[4]) then
      return true;
   else
      return false;
   end
end

----------------------------------------------------------------------------------------------------------------------
--[[ Return a vector from a string]]
-- Call Lua API function: GetVectorFromString(str)

----------------------------------------------------------------------------------------------------------------------
--[[ Get the length between two vectors ]]
function Vector3DLength( x1, y1, z1, x2, y2, z2 )
   return math.sqrt( Distance3DSquared(x1, y1, z1, x2, y2, z2) );
end

----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
--[[ Some Table Manipulation Stuff ]]

----------------------------------------------------------------------------------------------------------------------
--[[ Returns a reverse lookup for the given table ]]
function CreateReverseLookup(inputTable)
   if(type(inputTable) ~= "table") then
      Log("CreateReverseLookup - Invalid inputTable");
      return nil;
   end
   
   local revInputTable = {};
   
   for k,v in pairs(inputTable) do
      revInputTable[v] = k;
   end
   
   return revInputTable;
end

----------------------------------------------------------------------------------------------------------------------
--[[ Copies the given table, returns the copy ]]
function CopyTable(inputTable)
   if(type(inputTable) ~= "table") then
      error("CopyTable - Invalid inputTable");
   end
   
   local copyTable = {};
   
   for k,v in pairs(inputTable) do
      copyTable[k] = v;
   end
   
   return copyTable;
end

----------------------------------------------------------------------------------------------------------------------
--[[ Recursivly copy tables with tables in tables!]]
function DeepCopyTable( t, lookup_table )
   if( type(t) ~= "table" ) then
      error("DeepCopyTable - Invalid table");
   end

   lookup_table = lookup_table or {}
   local tcopy = {}
   if not lookup_table[t] then
      lookup_table[t] = tcopy
   end
   for i,v in pairs( t ) do
      if type( i ) == "table" then
         if lookup_table[i] then
            i = lookup_table[i]
         else
            i = DeepCopyTable( i, lookup_table )
         end
      end
      if type( v ) ~= "table" then
         tcopy[i] = v
      else
         if lookup_table[v] then
            tcopy[i] = lookup_table[v]
         else
            tcopy[i] = DeepCopyTable( v, lookup_table )
         end
      end
   end
   return tcopy
end

----------------------------------------------------------------------------------------------------------------------
-- Joins two tables. In a key conflict the primaryTable takes precedence.
function JoinTable(primaryTable, secondaryTable)
   if( type(primaryTable) ~= "table" ) then
      error("JoinTable - Invalid primaryTable");
   elseif( type(secondaryTable) ~= "table" ) then
      error("JoinTable - Invalid secondaryTable");
   end
   
   local joinTable = CopyTable(secondaryTable);
   
   for k,v in pairs(primaryTable) do
      joinTable[k] = v;
   end
   
   return joinTable;
end

----------------------------------------------------------------------------------------------------------------------
-- Intrusively joins a secondaryTable into the targetTable. In a key 
-- conflict the targetTable takes precedence. Modifies targetTable in place.
function IntrusiveJoinTable(targetTable, secondaryTable)
   if( type(targetTable) ~= "table" ) then
      error("IntrusiveJoinTable - Invalid targetTable");
   elseif( type(secondaryTable) ~= "table" ) then
      error("IntrusiveJoinTable - Invalid secondaryTable");
   end
   
   for k, v in pairs(secondaryTable) do
      if targetTable[k] == nil then
         targetTable[k] = v
      end
   end
end

----------------------------------------------------------------------------------------------------------------------
-- Given val, clamp the value between min and max.
function CLAMP(val,min,max)
   if(val < min) then
      val = min;
   end
   if(val > max) then
      val = max;
   end
   return val;
end

----------------------------------------------------------------------------------------------------------------------
function RegisterEventCallback(a_eventName, a_callback)
   local eventArgs = {};
   eventArgs.Message = a_eventName;
   eventArgs.LUA_CallBack = a_callback;
   RegisterEvent(a_eventName, eventArgs  );
end

---------------------------------------------------------------------------------------------------------
function FindWindowsNamed(a_ParentWindow, a_WindowName)
   assert(a_ParentWindow ~= nil);
   
   a_ParentWindow = OpenClass(a_ParentWindow);

   local children = {};
   local windowCount = a_ParentWindow.GetChildCount();
   for childNum = 0, windowCount - 1 do
      local child = a_ParentWindow.GetChild(childNum);
      if ( child.GetName() == a_WindowName ) then
         table.insert(children, child);
      end
   end
   
   return children;
end

---------------------------------------------------------------------------------------------------------
-- Attach the given OID/WindowObject to the root window
---------------------------------------------------------------------------------------------------------
function AttachToRootWindow( a_window )
   a_window = OpenClass(a_window);
   a_window.DetachSelf();
   local rootWindow = OpenClass(GetRootWindow());
   rootWindow.AttachWindow(a_window);
end

---------------------------------------------------------------------------------------------------------
-- Attach the given OID/WindowObject to the World window
---------------------------------------------------------------------------------------------------------
function AttachToWorldWindow( a_window )
   a_window = OpenClass(a_window);
   a_window.DetachSelf();
   local worldWindow = OpenClass(GetWorldWindow());
   worldWindow.AttachWindow(a_window);
end

---------------------------------------------------------------------------------------------------------
-- Cycles through the given edit group of control edits
---------------------------------------------------------------------------------------------------------
function AdvanceTabEditGroup( a_editControlList )
   local foundKey = nil;
   for key, value in pairs(a_editControlList) do
      if(value.GetEditing()) then
         foundKey = key;
         value.OnEndEdit();
         break;
      end
   end

   local nextKey, nextValue = next(a_editControlList, foundKey);
   if(nextValue == nil) then
      nextKey, nextValue = next(a_editControlList, nil);
   end

   if(nextValue ~= nil) then
      nextValue.OnBeginEdit();
   end
end

---------------------------------------------------------------------------------------------------------
-- Converts multiple return values into a table structure
---------------------------------------------------------------------------------------------------------
function GetMultipleReturnsAsTable( ... )
   local newTable = {};
   for _, data in pairs{...} do
      table.insert( newTable, data );
   end

   return newTable;
end

---------------------------------------------------------------------------------------------------------
-- Trim the whitespace off a string
---------------------------------------------------------------------------------------------------------
function TrimWhitespace(s)
   return (string.gsub(s, "^%s*(.-)%s*$", "%1")); -- Rather hard to comprehend, isn't it? Thank you reqex languages.. :)
end

----------------------------------------------------------------------------------------------------------------------
-- Returns the max number index in a given table, even if it is sparsely packed.
-- Will return nil if no number indexes are found (eg: empty table)
----------------------------------------------------------------------------------------------------------------------
function GetMaxTableIndex(t)
   local maxIndex = nil;
   for index, _ in pairs(t) do
      if type(index) == "number" then
         if maxIndex == nil then
            maxIndex = index;
         elseif index > maxIndex then
            maxIndex = index;
         end
      end
   end
   return maxIndex;
end

----------------------------------------------------------------------------------------------------------------------
-- Returns true is one of the elements of t equals v (t[*] == v)
----------------------------------------------------------------------------------------------------------------------
function TableContainsValue(t, v)
   if type(t) ~= "table" then
      error("TableContainsValue must be given a table as it's first parameter");
   end

   for _, elem in pairs(t) do
      if elem == v then
         return true;
      end
   end
   
   return false;
end

----------------------------------------------------------------------------------------------------------------------
-- Returns true is the table contains no entries
----------------------------------------------------------------------------------------------------------------------
function TableEmpty(t)
   for _,_ in pairs(t) do
      return false;
   end
   return true;
end

----------------------------------------------------------------------------------------------------------------------
-- Replace a method on a table object and assert every step of the way
-- Useful for monkey patching methods in Lunity tests
----------------------------------------------------------------------------------------------------------------------
function ReplaceMethod(obj, fromName, toInvokable)
   assertNotNil(obj[fromName], "Method name \""..fromName.."\" does not exist in this object")
   assertInvokable(obj[fromName])
   assertInvokable(toInvokable)
   obj[fromName] = toInvokable
end

----------------------------------------------------------------------------------------------------------------------
-- There is never a need to run utilities, but sometimes it is helpful to use Core's parser to check for errors.. :)
function main()
   Log("Utilities was run... Good job!");
end

----------------------------------------------------------------------------------------------------------------------
--[[ Convert Screen-based coordinates to Window-based coordinates ]]
function ConvertScreenToWindow(x, y, window)
   if(not x) or (not y) or (not window) then
      Log("Error in ConvertWindowToScreen: Nil parameters not allowed!");
      return nil, nil;
   end
   local newCoordinates = window.ScreenToWindow(x..","..y);
   local newX, newY = string.match(nweCoordinates, "(%d+),(%d+)");
   
   return newX, newY;
end

--[[ Simplification of PlaySound ]]
function PlaySoundOnce( fileName )
	PlaySound( fileName, 1.0, 0.0, 0);
end

