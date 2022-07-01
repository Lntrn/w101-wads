Include("Scripts/API/Asserts.lua");

----------------------------------------------------------------------------------------------------------------------
-- Wrappers for asserts which return the value/actual if the assert passes
----------------------------------------------------------------------------------------------------------------------

function Equal(actual, expected, msg)
   if assertEqual(actual, expected, msg) then
      return actual
   end
end

function TableEqual(actual, expected, msg)
   if assertTableEqual(actual, expected, msg) then
      return actual
   end
end

function NotEqual(actual, expected, msg)
   if assertNotEqual(actual, expected, msg) then
      return actual
   end
end

function True(value, msg)
   if assertTrue(value, msg) then
      return value
   end
end

function False(value, msg)
   if assertFalse(value, msg) then
      return value
   end
end

function Nil(value, msg)
   if assertNil(value, msg) then
      return value
   end
end

function NotNil(value, msg)
   if assertNotNil(value, msg) then
      return value
   end
end

function Type(actual, expectedType, msg)
   if assertType(actual, expectedType, msg) then
      return actual
   end
end

function Invokable(value, msg)
   if assertInvokable(value, msg) then
      return value
   end
end

function Error(invokable, ...)
   if assertError(invokable, ...) then
      return invokable
   end
end

function DoesNotError(invokable, ...)
   if assertDoesNotError(invokable, ...) then
      return invokable
   end
end
