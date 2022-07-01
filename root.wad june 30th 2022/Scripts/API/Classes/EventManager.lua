--[[
   Wrapper for the event framework, following signals/observer patern. 
      - DoEventLoop blocks until the event 'BreakEventLoop' is recieved, or EventManager:BreakEventLoop() is called
      - Subscribers can be global functions or class methods
      - Multiple subscribers per event
      - Dynamic event registration
      - Handles events and messages the same way
      - Support immediate manual activation of custom events (for queued activation, use ScriptAPI SendEvent(..))
      - Allows all events to fallthrough to a handles registered for eventname "Event"
      
   Author: Josh Szepietowski
]]--

Include( "Scripts/API/Classes/class.lua" );
Include( "Scripts/API/Utilities.lua" );
Include( "Scripts/API/Debug.lua" );

---------------------------------------------------------------------------------------------------------
-- Constructor. Takes no arguments.
---------------------------------------------------------------------------------------------------------
EventManager = class( function( self )
   self.m_Events         = {};
   self.m_bDoEventLoop      = true;
      
   if( not self:SubscribeEvent("MSG", EventManager.MessageHandler, self) ) then
      error( "EventManager constructor could not subscribe the MSG event. Internal error -_-" )
   end
end );

---------------------------------------------------------------------------------------------------------
-- Message Handler, for propogating the 'MSG' event 
---------------------------------------------------------------------------------------------------------
function EventManager:MessageHandler( a_Event )
   self:SignalEvent(a_Event.MsgName, a_Event);
end

---------------------------------------------------------------------------------------------------------
-- DoEventLoop - loops GetEvent until "BreakEventLoop" is recieved, or EventManager:BreakEventLoop() is called
---------------------------------------------------------------------------------------------------------
function EventManager:DoEventLoop()
   self.m_bDoEventLoop = true;
   while ( self.m_bDoEventLoop ) do
      if self:WaitForEvent() then
         break;
      end
   end
end

---------------------------------------------------------------------------------------------------------
-- WaitForEvent - waits for and signals from a single event. Returns true if that event is BreakEventLoop.
---------------------------------------------------------------------------------------------------------
function EventManager:WaitForEvent()
   -- Wait for events
   local event = GetEvent();
   
   if event then
      -- Allow lua Callback, if provided
      if event.LUA_CallBack then
         event.LUA_CallBack( event );
      end
      
      -- If EventName is 'BreakEventLoop' then break the event loop
      if event.EventName == "BreakEventLoop" then
         return true;
      end
      
      -- Signal the event
      self:SignalEvent(event.EventName, event);
   end
   
   return false;
end

---------------------------------------------------------------------------------------------------------
-- BreakEventLoop - Break the current run of 'DoEventLoop'
---------------------------------------------------------------------------------------------------------
function EventManager:BreakEventLoop()
   self.m_bDoEventLoop = false;
end

---------------------------------------------------------------------------------------------------------
-- SignalEvent - Call this to immediately signal an event. This can be a real event or a custom one. 
--            Unlike SendEvent(..) this will immediately be carried out. Use SendEvent(..) for queued 
--            event signals.
---------------------------------------------------------------------------------------------------------
function EventManager:SignalEvent( a_EventName, a_EventTable )

   -- If we did not recieve an event name, give a warning and early out
   if ( a_EventName == nil ) then
      DebugLog("EventManager:SignalEvent WARNING: a_EventName is nil!");
      return;
   end
   
   if ( a_EventName == "BreakEventLoop" ) then
      self:BreakEventLoop();
      return;
   end

   -- Make sure the event table exists and that it has the event name
   if a_EventTable == nil then
      a_EventTable         = { EventName = a_EventName };
   elseif a_EventTable.EventName == nil then
      a_EventTable.EventName   = a_EventName;
   end

   -- Check if we have anything subscribing to the event         
   local eventSubscriberList = self.m_Events[a_EventName];
   if eventSubscriberList ~= nil then
      -- We do! Iterate through the subscribers and alert them      
      for _, subscriber in pairs(eventSubscriberList) do
         -- Is the subscriber a class method?
         if subscriber.m_Class ~= nil then
            -- Yes!
            subscriber.m_Func(subscriber.m_Class, a_EventTable);
         else
            -- Nope!
            subscriber.m_Func(a_EventTable);
         end
      end   
   else
      if   a_EventName ~= "Event" then
         DebugLog( "EventManager:SignalEvent warning - No subscribers found for " .. a_EventName );
      end
   end
   
   -- Fallthrough to 'Event' for all events other then 'Event' (to prevent recursion). Leave the 
   -- a_EventTable.EventName intact so that the original event name can be determined.
   if a_EventName ~= "Event" then
      self:SignalEvent( "Event", a_EventTable );
   end
end

---------------------------------------------------------------------------------------------------------
-- SendLocalEvent - Light wrapper for the script API function SendLocalEvent(..)
---------------------------------------------------------------------------------------------------------
function EventManager:SendLocalEvent( a_EventName, a_EventTable )
   SendLocalEvent( a_EventName, a_EventTable );
end

---------------------------------------------------------------------------------------------------------
-- FindSubscriberIndex - Find the index of a subscriber based on its registration information. 
--                  Intended for internal use.
--      Returns: nil if it was not found, a valid index otherwise
---------------------------------------------------------------------------------------------------------
function EventManager:FindSubscriberIndex( a_EventName, a_SubscriberFunc, a_SubscriberObject )
   
   -- If they do not provide an event name or a subscriber function we can not continue
   if( a_EventName == nil ) then
      error( string.format( "EventManager:FindSubscriberIndex( %s, %s, %s) error: (a_EventName == nil)!", 
         a_EventName, tostring(a_SubscriberFunc), tostring(a_SubscriberObject)) );
   elseif( a_SubscriberFunc == nil ) then
      error( string.format( "EventManager:FindSubscriberIndex( %s, %s, %s) error: (a_SubscriberFunc == nil)!", 
         a_EventName, tostring(a_SubscriberFunc), tostring(a_SubscriberObject)) );
   end
   
   -- Do we even have a subscriber list for this event?
   local subscriberList = self.m_Events[a_EventName];
   if subscriberList == nil then
      DebugLog( "EventManager:FindSubscriberIndex( %s, %s, %s) error: We do not have a subscriber list for [%s]!", 
         a_EventName, tostring(a_SubscriberFunc), tostring(a_SubscriberObject), a_EventName);
      return nil;
   end
   
   -- Ok, so iterate through the list and find the match
   for index, subscriber in pairs(subscriberList) do
      if ( subscriber.m_Class == a_SubscriberObject and subscriber.m_Func == a_SubscriberFunc ) then
         return index;
      end
   end
   
   -- Was not found
   return nil;   
end

---------------------------------------------------------------------------------------------------------
-- SubscribeEvent - Call this to subscribe to an event name. 
--
--      Returns: false if there is an error, true otherwise
---------------------------------------------------------------------------------------------------------
function EventManager:SubscribeEvent( a_EventName, a_SubscriberFunc, a_SubscriberObject )

   -- If they do not provide an event name or a subscriber function we can not continue, return nil for error
   if( a_EventName == nil ) then
      error( string.format( "EventManager:SubscribeEvent( %s, %s, %s) error: (a_EventName == nil)!", 
         a_EventName, tostring(a_SubscriberFunc), tostring(a_SubscriberObject)) );
   elseif( a_SubscriberFunc == nil ) then
      error( string.format( "EventManager:SubscribeEvent( %s, %s, %s) error: (a_SubscriberFunc == nil)!", 
         a_EventName, tostring(a_SubscriberFunc), tostring(a_SubscriberObject)) );
   end
   
   -- First create the subscriber table
   local subscriber = { m_Class = a_SubscriberObject, m_Func = a_SubscriberFunc }
   
   -- Do we need to add a subscriber list for this event?
   if self.m_Events[a_EventName] == nil then
      -- Yes, so add a subscriber list
      self.m_Events[a_EventName] = {};
      
      -- Also make sure the event is registered
      RegisterEvent(a_EventName);      
   else
      -- The list exists, make sure they are not already in the list.
      if ( self:FindSubscriberIndex( a_EventName, a_SubscriberFunc, a_SubscriberObject ) ~= nil ) then
         -- it exists, error out
         DebugLog( "EventManager:SubscribeEvent( %s, %s, %s) error: duplicate subscriber detected!", 
            a_EventName, tostring(a_SubscriberFunc), tostring(a_SubscriberObject));
         return false;
      end
   end
   
   -- Now add the subscriber to the subscriber list
   local subscriberList      = self.m_Events[a_EventName];
   local newIndex            = GetFirstFreeIndex(subscriberList);
   subscriberList[newIndex]   = subscriber;
   
   return true;
end


---------------------------------------------------------------------------------------------------------
-- UnsubscribeEvent - Call this to unsubscribe a given subscriber
--
--      Returns: true on success, false if an error (usually if it could not find the given subscriber)
---------------------------------------------------------------------------------------------------------
function EventManager:UnsubscribeEvent( a_EventName, a_SubscriberFunc, a_SubscriberObject )
   
   -- If they do not provide an event name or a subscriber function we can not continue, return nil for error
   if( (a_EventName == nil) or (a_SubscriberFunc == nil) ) then
      DebugLog( "EventManager:UnsubscribeEvent( %s, %s, %s) error: nil parameter!", 
            a_EventName, tostring(a_SubscriberFunc), tostring(a_SubscriberObject));
      return false;
   end
   
   -- Get the index
   local subscriberIndex = self:FindSubscriberIndex( a_EventName, a_SubscriberFunc, a_SubscriberObject );
   
   -- Did we find it?
   if ( subscriberIndex == nil ) then
      -- No, error out      
      DebugLog( "EventManager:UnsubscribeEvent( %s, %s, %s) error: subscriber was not found!", 
            a_EventName, tostring(a_SubscriberFunc), tostring(a_SubscriberObject));
      return false;
   end
   
   -- Find the subscriber list
   local subscriberList = self.m_Events[a_EventName];
   
   -- Sanity check: make sure that the subscriber list is not nil, make sure the subscribe is not nil               
   assert(subscriberList ~= nil, "EventManager:UnsubscribeEvent(..) encountered an internal error [1]!");
   assert(subscriberList[subscriberIndex] ~= nil, "EventManager:UnsubscribeEvent(..) encountered an internal error [2]!");
   
   -- Remove the subscribe from the list
   subscriberList[subscriberIndex]   = nil;
   
   -- If the subscriber list is now empty, remove the event
   if( #subscriberList == 0 ) then
      -- Remove the event
      self.m_Events[a_EventName] = nil;
   
      -- Finally unregister the event
      UnregisterEvent(a_EventName);
   end
   
   return true;
end


-- MockEventManager - An event manager mock for Lunity tests
MockEventManager = class( EventManager, function(self, params)
   self.calledDoEventLoop = 0;
   self.calledSendLocalEvent = {};
   self.calledSubscribeEvent = {};
   
   ReplaceMethod(self, "SubscribeEvent", function (self, name, func, target)
         assertType(self, "table");
         assertType(name, "string");
         assertType(func, "function");
         assertType(target, "table");
         self.calledSubscribeEvent[name] = true;
      end)
   
   ReplaceMethod(self, "DoEventLoop", function (self)
         self.calledDoEventLoop = self.calledDoEventLoop + 1;
      end)
   
   ReplaceMethod(self, "SendLocalEvent", function (self, eventName, eventTable)
         assertType(eventName, "string")
         assertType(eventTable, "table")
         self.calledSendLocalEvent[eventName] = true
      end)
   
end );
