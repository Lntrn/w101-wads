
----------------- DdCommandStack singleton class ---------------------------------------------------
-- Maintain a stack for storing  commands as they are pressed on the keyboard, 
-- allowing for specific elements to be removed from the stack regardless of their position.
-- make sure that no more than one copy of the same command can be on the stack at any time
------------------------------------------------------------------------------------------------------

DdCommandStack = 
{
  stack = {}; -- stack starts out empty
} 

-- return the stack size
function DdCommandStack:size() 
  return #self.stack
end

-- place a new command on top of the stack as long as it is unique
function DdCommandStack:push(cmd)
  if(cmd) then
    local found = false;
    for searchIdx,peek in pairs(self.stack) do
      if(peek == cmd) then 
        found = true;
        break; 
      end
    end

    if(found == false) then
      self.stack[self:size() + 1] = cmd;    
    end
  end
end

-- remove a command from anywhere in the stack
function DdCommandStack:pop(cmd)
  if(cmd) then
    for searchIdx,peek in pairs(self.stack) do
      if(peek == cmd) then 
        for shiftIdx = searchIdx, self:size() do
          self.stack[shiftIdx] = self.stack[shiftIdx + 1];
        end
        break;
      end
    end
  end
end

-- return the command from the top of the stack without removing it
function DdCommandStack:top()
  return self.stack[self:size()];
end

-- remove all contents from the stack
function DdCommandStack:clearStack()
   self.stack = {};
end

