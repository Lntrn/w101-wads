
Include("API/Classes/class.lua");
Include("Tutorials/API/Debug.lua");
Include("API/WindowAnimations.lua");

---------------------------------------------------------------------------------------------------------
-- Declaration - This class manages the TutorialDialog gui, which is used in the tutorials
---------------------------------------------------------------------------------------------------------
TutorialArrow = class( function( self, a_targetWindow, a_side, a_bounceDistance, a_time, a_deprecated, a_boundToWindow, a_rect )
		self.m_ArrowDock = nil;
		self.m_Arrow = nil;
		self.m_bounceDistance = a_bounceDistance;
		self.m_time = a_time;		
		-- if a_boundToWindow is true, we want to anchor onto the passed-in window instead of
		-- creating a temporary window.
		if(a_boundToWindow) then
			Log("BoundToWindow");
			self.m_targetWindow = a_targetWindow;
		else
			Log("NOT BoundToWindow");         
         -- if a_rect is provided, use that as the rect of the new window and use a_targetWindow as the parent
         if(a_rect and a_targetWindow) then
           Log("Tutorial Arrow -- Using a_rect to create a new window");
            self.m_targetWindow = CreateWindowClass( a_rect, true, "class Window", a_targetWindow );         
         else
            self.m_targetWindow = CreateWindowClass( a_targetWindow.ScreenWindow(), true, "class Window", nil );
         end
			self.m_targetWindow.m_Flags = "VISIBLE|NOCLIP";
			self.m_targetWindow.m_Style = "HAS_NO_BORDER|DO_NOT_CAPTURE_MOUSE";
         self.m_targetWindow.SetName("TutorialArrow Target");
		end
		self.m_side = a_side;
		self:SetSide(a_side);
	end );
	
---------------------------------------------------------------------------------------------------------
-- Show or Hide the dialog window
---------------------------------------------------------------------------------------------------------
function TutorialArrow:ShowWindow( a_bShow )
	if( self.m_ArrowDock ) then
		self.m_ArrowDock.SetVisible(a_bShow);
	end
end

---------------------------------------------------------------------------------------------------------
-- Set the side of the parent window to attach to
---------------------------------------------------------------------------------------------------------
function TutorialArrow:SetSide( a_side )
	self.m_side = a_side;
	local myArrowDockStyle 	= "HAS_NO_BORDER|DO_NOT_CAPTURE_MOUSE|IGNORE_PARENT_SCALE";
	if ( a_side == "Top" ) then
		self.m_ArrowDock = CreateWindowClass( 	MakeRectString(0, 0, 70, 128 + self.m_bounceDistance), 
											true, 
											"class Window", 
											self.m_targetWindow );		
		self.m_ArrowDock.m_Flags = "VISIBLE|DOCK_TOP|DOCK_OUTSIDE|HCENTER";

	elseif ( a_side == "Bottom" ) then
		self.m_ArrowDock = CreateWindowClass( 	MakeRectString(0, 0, 70, 128 + self.m_bounceDistance), 
											true, 
											"class Window", 
											self.m_targetWindow );
		self.m_ArrowDock.m_Flags = "VISIBLE|DOCK_BOTTOM|DOCK_OUTSIDE|HCENTER";
		
	elseif ( a_side == "Left" ) then
		self.m_ArrowDock = CreateWindowClass( 	MakeRectString(0, 0, 128 + self.m_bounceDistance, 128), 
											true, 
											"class Window", 
											self.m_targetWindow );
		self.m_ArrowDock.m_Flags = "VISIBLE|DOCK_LEFT|DOCK_OUTSIDE|VCENTER";
		
	elseif ( a_side == "Right" ) then
		self.m_ArrowDock = CreateWindowClass( 	MakeRectString(0, 0, 128 + self.m_bounceDistance, 128), 
											true, 
											"class Window", 
											self.m_targetWindow );
		self.m_ArrowDock.m_Flags = "VISIBLE|DOCK_RIGHT|DOCK_OUTSIDE|VCENTER";
		
	else
		DebugLog("TutorialDialog:SetSide failed to produce a valid dock! No valid side input recieved!");
	end
   
   self.m_ArrowDock.SetName("Tutorial Arrow");	
	self.m_ArrowDock.m_Style = myArrowDockStyle;
	self.m_Arrow = CreateSpriteClass("Art/Art_Tutorial_Arrow.dds", MakeRectString(0,0,70,128), true, self.m_ArrowDock);
	self.m_Arrow.m_Style = "HAS_NO_BORDER|DO_NOT_CAPTURE_MOUSE";
	self.m_Arrow.m_Flags = "VISIBLE";
	
	if ( a_side == "Bottom" ) then
		self.m_Arrow.SetRotation(180);		
		
	elseif ( a_side == "Left" ) then
		self.m_Arrow.SetRotation(-90);
		
	elseif ( a_side == "Right" ) then
		self.m_Arrow.SetRotation(90);
	end
	
	self:RecreateAnimations();
end


---------------------------------------------------------------------------------------------------------
-- Detach the TutorialDialog from the root window (essentially remove it)
---------------------------------------------------------------------------------------------------------
function TutorialArrow:DetachSelf()
	self.m_ArrowDock.DetachSelf();
end

---------------------------------------------------------------------------------------------------------
-- INTERNAL USE: Recreate the animations, based on internal m_side
---------------------------------------------------------------------------------------------------------
function TutorialArrow:RecreateAnimations()
	self.m_Arrow.ClearAnimationQueue();
	
	local movementLoop = CreateClass("WinAnimContainer");		
	if( self.m_side == "Top" or self.m_side == "Bottom" ) then		
		movementLoop.AddAnimation(CreateWinAnimMoveToLocationTimeEaseApprox( 0, 0, self.m_time, 0.35, 5 ));
		movementLoop.AddAnimation(CreateWinAnimMoveToLocationTimeEaseApprox( 0, self.m_bounceDistance, self.m_time, 0.35, 5 ));
	else
		self.m_Arrow.SetLocation( 35, 0 );
		movementLoop.AddAnimation(CreateWinAnimMoveToLocationTimeEaseApprox( 35, 0, self.m_time, 0.35, 5 ));
		movementLoop.AddAnimation(CreateWinAnimMoveToLocationTimeEaseApprox( 35 + self.m_bounceDistance, 0, self.m_time, 0.35, 5 ));
	end
	
	movementLoop.SetLooping(true);
	self.m_Arrow.PushAnimation(movementLoop);
end
