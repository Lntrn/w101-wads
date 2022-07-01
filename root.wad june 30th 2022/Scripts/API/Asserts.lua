--[[  
   Asserts
   
   Full duplication of Lunity assert functions so that they can be used from 
   outside Lunity with reasonable results. Lunity actually relies on this file
   now so compatibility is ensured.
   
   The body of these comes partly from Lunity so..
         Lunity v0.9 by Gavin Kistner
      Extended/Modified for KingsIsle Entertainment by Josh Szepietowski

      This work is licensed under the Creative Commons Attribution 3.0
      United Packes License. To view a copy of this license, visit
      http://creativecommons.org/licenses/by/3.0/us/ or send a letter to
         Creative Commons
         171 Second Street, Suite 300
         San Francisco, California, 94105, USA
         
   Full list of assert functions and their usage:
   
      -- Standard assert. testCondition must evaluate to true
      assert(testCondition, msg)
      
      -- Assert that actual is equal to expected. Does not compare table contents.
      assertEqual(actual, expected, msg)
      
      -- Assert that table contents are equal between actual and expected.
      assertTableEqual(actual, expected, msg)
      
      -- Assert that actual and expected are not equal.
      assertNotEqual(actual, expected, msg)
      
      -- Assert that actual == true.
      assertTrue(actual, msg)
      
      -- Assert that actual == false.
      assertFalse(actual, msg)
      
      -- Assert that actual is a thread
      assertThread(actual, msg)
      
      -- Assert that actual is a boolean
      assertBoolean(actual, msg)
      
      -- Assert that actual is a number
      assertNumber(actual, msg)
      
      -- Assert that actual is a string
      assertString(actual, msg)
      
      -- Assert that actual is a userdata
      assertUserdata(actual, msg)
      
      -- Assert that actual is a table
      assertTable(actual, msg)
      
      -- Assert that actual == nil.
      assertNil(actual, msg)
      
      -- Assert that actual ~= nil.
      assertNotNil(actual, msg)
      
      -- Assert that type(actual) == expectedType. Expected type must be a string.
      assertType(actual, expectedType, msg)
      
      -- Asserts that the value is a function OR may be called as one.
      assertInvokable(value, msg)
      
      -- Asserts that the value is invokable and that when called it generates an error.
      assertError(invokable, ...)
      
      -- Asserts that the value is invokable and that when called it does not generate an error.
      assertDoesNotError(invokable, ...)
      
      -- Fails automatically.
      fail(msg)
]]

Include("Scripts/API/TypeCheckers.lua");

-- Save off built in assert.
luaAssert = assert;

-- Assert 'helper' functions. These are safe to overide if you want something 
-- special to happen when one occures (this is how Lunity 'hooks' into these)
failedAssert = function (msg, ...)
   error(string.format(msg, ...), 1);
   return false;
end

passedAssert = function ()
   return true;
end

assert = function (testCondition, msg)
   if not testCondition then
      if not IsString(msg) then msg = "assert() failed: value was "..tostring(testCondition) end
      failedAssert(msg);
   end
   return passedAssert();
end

assertEqual = function (actual, expected, msg)
   if actual ~= expected then
      if not IsString(msg) then
         msg = string.format("assertEqual() failed: expected %s, was %s",
            tostring(expected),
            tostring(actual))
      end
      failedAssert(msg);
   end
   return passedAssert();
end

assertTableEqual = function (actual, expected, msg, keyPath)
   -- Easy out
   if actual == expected then
      if not keyPath then
         return passedAssert();
      else
         return true
      end
   end
   
   if not keyPath then keyPath = {} end

   if type(actual) ~= 'table' then
      if not IsString(msg) then
         msg = "Value passed to assertTableEqual(); was not a table."
      end         
      failedAssert(msg, 2 + #keyPath)
   end
      
   -- Ensure all keys in t1 match in t2
   for key,expectedValue in pairs(expected) do
      keyPath[#keyPath+1] = tostring(key)
      local actualValue = actual[key]
      if type(expectedValue)=='table' then
         if type(actualValue)~='table' then
            if not IsString(msg) then
               msg = "Tables not equal; expected "..table.concat(keyPath,'.').." to be a table, but was a "..type(actualValue)
            end         
            failedAssert(msg, 1 + #keyPath)
         elseif expectedValue ~= actualValue then
            Lunity__assertTableEquals(actualValue, expectedValue, msg, keyPath)
         end
      else
         if actualValue ~= expectedValue then
            if not IsString(msg) then
               if actualValue == nil then
                  msg = "Tables not equal; missing key '"..table.concat(keyPath,'.').."'."
               else
                  msg = "Tables not equal; expected '"..table.concat(keyPath,'.').."' to be "..tostring(expectedValue)..", but was "..tostring(actualValue)
               end
            end         
            failedAssert(msg, 1 + #keyPath)
         end
      end
      keyPath[#keyPath] = nil
   end
   
   -- Ensure actual doesn't have keys that aren't expected
   for k,_ in pairs(actual) do
      if expected[k] == nil then
         if not IsString(msg) then
            msg = "Tables not equal; found unexpected key '"..table.concat(keyPath,'.').."."..tostring(k).."'"
         end         
         failedAssert(msg, 2 + #keyPath)
      end
   end
   
   return passedAssert();
end

assertNotEqual = function (actual, expected, msg)
   if actual == expected then
      if not IsString(msg) then
         msg = string.format("assertNotEqual() failed: value not allowed to be %s",
            tostring(actual))
      end
      failedAssert(msg);
   end
   return passedAssert();
end

assertTrue = function (actual, msg)
   if actual ~= true then
      if not IsString(msg) then
         msg = string.format("assertTrue() failed: value was %s, expected true",
            tostring(actual))
      end
      failedAssert(msg);
   end
   return passedAssert();
end

assertFalse = function (actual, msg)
   if actual ~= false then
      if not IsString(msg) then
         msg = string.format("assertFalse() failed: value was %s, expected false",
            tostring(actual))
      end
      failedAssert(msg);
   end
   return passedAssert();
end

assertNil = function (actual, msg)
   if actual ~= nil then
      if not IsString(msg) then
         msg = string.format("assertNil() failed: value was %s, expected nil",
            tostring(actual))
      end
      failedAssert(msg);
   end
   return passedAssert();
end

assertNotNil = function (actual, msg)
   if actual == nil then
      if not IsString(msg) then msg = "assertNotNil() failed: value was nil" end
      failedAssert(msg);
   end
   
   return passedAssert();
end

assertBoolean = function (actual, msg)
   if not IsString(actual) then
      if not IsBoolean(msg) then
         msg = string.format("assertTable() failed: type was %s, expected boolean",
            type(actual))
      end
      failedAssert(msg)
   end
   return passedAssert()
end

assertString = function (actual, msg)
   if not IsString(actual) then
      if not IsString(msg) then
         msg = string.format("assertTable() failed: type was %s, expected string",
            type(actual))
      end
      failedAssert(msg)
   end
   return passedAssert()
end

assertNumber = function (actual, msg)
   if not IsNumber(actual) then
      if not IsString(msg) then
         msg = string.format("assertFunction() failed: type was %s, expected number",
            type(actual))
      end
      failedAssert(msg)
   end
   return passedAssert()
end

assertFunction = function (actual, msg)
   if not IsFunction(actual) then
      if not IsString(msg) then
         msg = string.format("assertFunction() failed: type was %s, expected function",
            type(actual))
      end
      failedAssert(msg)
   end
   return passedAssert()
end

assertThread = function (actual, msg)
   if not IsThread(actual) then
      if not IsString(msg) then
         msg = string.format("assertTable() failed: type was %s, expected thread",
            type(actual))
      end
      failedAssert(msg)
   end
   return passedAssert()
end

assertUserdata = function (actual, msg)
   if not IsUserdata(actual) then
      if not IsString(msg) then
         msg = string.format("assertTable() failed: type was %s, expected userdata",
            type(actual))
      end
      failedAssert(msg)
   end
   return passedAssert()
end

assertTable = function (actual, msg)
   if not IsTable(actual) then
      if not IsString(msg) then
         msg = string.format("assertTable() failed: type was %s, expected table",
            type(actual))
      end
      failedAssert(msg)
   end
   return passedAssert()
end

assertType = function (actual, expectedType, msg)
   if type(actual) ~= expectedType then
      if not IsString(msg) then
         msg = string.format("assertType() failed: value %s is a %s, expected to be a %s",
            tostring(actual),
            type(actual),
            expectedType);
      end
      failedAssert(msg);
   end
   return passedAssert();
end

assertInvokable = function (value, msg)
   if not IsInvokable(value) then 
      if not IsString(msg) then
         msg = string.format("assertInvokable() failed: '%s' can not be called as a function",
            tostring(value));
      end
      failedAssert(msg);
   end
   return passedAssert();
end

assertError = function(invokable, ...)
   assertInvokable(invokable);
   if pcall(invokable, ...) then
      local msg = string.format("assertErrors() failed: %s did not raise an error",
         tostring(invokable))
      failedAssert(msg);
   end
   return passedAssert();
end

assertDoesNotError = function(invokable, ...)
   assertInvokable(invokable)
   if not pcall(invokable, ...) then
      local msg = string.format("assertDoesNotError() failed: %s raised an error",
         tostring(invokable))
      failedAssert(msg);
   end
   return passedAssert();
end

-- Fails
function fail(msg)
   if not IsString(msg) then msg = "(failure)" end
   failedAssert(msg);
end

function main()
   Log("Asserts run, good job!");
end
