--[[ 
   Type checkers. Basic functions to deal with lua types.
]]

----------------------------------------------------------------------------------------------------------------------
-- Basic types
function IsNil(value) return type(value)=='nil'; end
function IsBoolean(value) return type(value)=='boolean'; end
function IsNumber(value) return type(value)=='number'; end
function IsString(value) return type(value)=='string'; end
function IsTable(value) return type(value)=='table'; end
function IsFunction(value) return type(value)=='function'; end
function IsThread(value) return type(value)=='thread'; end
function IsUserdata(value) return type(value)=='userdata'; end

----------------------------------------------------------------------------------------------------------------------
-- Higher level types

-- Invokable is anything that can be called as a function (namely functions
-- and tables with metatable .__call functions)
function IsInvokable(value)
   local meta = getmetatable(value);
   return (IsFunction(value)) or (meta and meta.__call and IsFunction(meta.__call));
end
