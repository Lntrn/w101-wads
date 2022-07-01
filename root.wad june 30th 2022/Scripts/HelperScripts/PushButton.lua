--This function pushes then releases a button N times.
function PushButton(btn, N)
	if(N == nil) then
		N = 1;
	end
   
	for i = 1, N do
		btn.SetButtonDown(true);
		Sleep(0.1);
		btn.SetButtonDown(false);
		Sleep(0.1);
	end
end

-- get the root window if we don't already have it
-- find the button off the root window and try to push it
-- return true if we found it
-- return false if it wasn't found or it was disabled.
function PushButtonByName(a_buttonName, N)
   --LogFile:write("DEBUG: Clicking on "..a_buttonName..":   ");         
   --LogFile:flush();
   
   -- Get a handle on the root and store in this global.  If we've already got it, don't get it again.
   PB_RootWindow = PB_RootWindow or OpenClass(GetRootWindow());
   
   local btn = PB_RootWindow.FindNamedWindow(a_buttonName);
   
   if(not btn) then
      --LogFile:write("ERROR: Button not found\n"); 
      --LogFile:flush();
      return false;
   end
   
   if(btn.Greyed()) then
      --LogFile:write("ERROR: Button Disabled\n");         
      --LogFile:flush();
      DestroyClass(btn);
      return false;
   end
   
   PushButton(btn, N); -- push the button N times (or once if n is nil)
   --LogFile:write("OK\n");         
   --LogFile:flush();  
   
   DestroyClass(btn);
   return true;
end
