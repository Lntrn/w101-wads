--[[

   SkullRider Client.lua

	Skull Riders!  Yeah!

	Author: Cheryl
	KingsIsle Entertainment
	Date: January 30, 2007
]]

-- Include classes that are needed for various UIs
Include( "API/Classes/class.lua");
Include( "API/ControlClasses.lua" );
Include( "API/Utilities.lua" );

Include( "API/Classes/Timer.lua" );
Include( "SkullRiders/Messages.lua");
Include( "SkullRiders/Constants.lua");
Include( "API/Globals.lua");
Include( "API/MinigameInterface.lua");

DEBUG = false;

function DoDebugLog(event)
 --Log incoming server messages
	if DEBUG == true then
		for i, j in pairs( event ) do
			Log( i .. " " .. j );
		end
		Log( "-------" );
	end
end


Script_Name = "Skull_Riders";

AnyKeyPressed = 0;
LastTimeMSG_Moved = 0;
GameState = 0; -- game state 0 means intro page, 1 means real game
OuterWindow = nil;
ParticleContainer = nil;
ParticleSystem = nil;
GameWindow = nil;
IntroWindow = nil;
IntroPlayButton = nil;
Background = nil;
GameTimer = nil;
time = nil;
times = 0;
numSkullRiders = 0;
wingFlapSound = nil;
footstepSound = nil;
currentSkullRiderMax = 12;
RegisteredEvents = {}; -- table of events to register   

function RECONNECT_TIMEOUT( event )
   Log("Server Timed Out during mini game.");
   while(true) do
      Sleep(1000);
   end   
end
RegisteredEvents["AppReconnectTimeout"] = RECONNECT_TIMEOUT;


function WB_BUTTONUP_EVENT( event )

 	if (event.Name == "CloseButton") then
      GameOver();      
	elseif (event.Name == "exit") then
	    ExitIntro();
	end
	
end
RegisteredEvents["WB_BUTTONUP"] = WB_BUTTONUP_EVENT;


-- Key A for going left        A == 65, a == 97
-- Key D for going right       D == 68, d == 100  
-- Key W for going up            W == 87
-- Up Arrow for going up         Up Arrow == 38
-- Space bar for shooting        == 32
-- left arrow for moving left    == 37
-- right arrow for moving right  == 39
-- down arrow for shooting       == 40
-- q fires skullrider 1 fireball == 113
-- w fires skullrider 2 fireball == 119

function GM_KEYUP( event )
   if (p1gameover == 0 and (p1state < STATE_Death or p1state > STATE_Death6) and GameState == 1) then

	if(event.Key ==38) then
		upArrowNextState = ARROWSTATE_Up;
   elseif(event.Key == 87) then
      upArrowNextState = ARROWSTATE_Up;
      
	elseif(event.Key ==97) then
		leftArrowNextState = ARROWSTATE_Up;
	elseif(event.Key ==65) then
		leftArrowNextState = ARROWSTATE_Up;
	elseif(event.Key ==37) then
		leftArrowNextState = ARROWSTATE_Up;

	elseif(event.Key ==39) then
		rightArrowNextState = ARROWSTATE_Up;
	elseif(event.Key ==68) then
		rightArrowNextState = ARROWSTATE_Up;
	elseif(event.Key ==100) then
		rightArrowNextState = ARROWSTATE_Up;

	elseif(event.Key ==40) then
		downArrowNextState = ARROWSTATE_Up;
	end
   end

   AnyKeyPressed = 1;

end

function GM_KEYDOWN( event )

   if (p1gameover == 0 and (p1state < STATE_Death or p1state > STATE_Death6) and GameState == 1) then
	p1gameovertext.SetText("");
   
	if(event.Key ==38) then
		upArrowNextState = ARROWSTATE_Down;
   elseif(event.Key == 87) then
      upArrowNextState = ARROWSTATE_Down;      
      
	elseif(event.Key ==97) then
		leftArrowNextState = ARROWSTATE_Down;
	elseif(event.Key ==65) then
		leftArrowNextState = ARROWSTATE_Down;
	elseif(event.Key ==37) then
		leftArrowNextState = ARROWSTATE_Down;

	elseif(event.Key ==39) then
		rightArrowNextState = ARROWSTATE_Down;
	elseif(event.Key ==68) then
		rightArrowNextState = ARROWSTATE_Down;
	elseif(event.Key ==100) then
		rightArrowNextState = ARROWSTATE_Down;

	elseif(event.Key ==32) then
		p1Shoot();
		if (wingFlapSound ~= nil) then
		end
	elseif(event.Key ==40) then
		downArrowNextState = ARROWSTATE_Down;

--	elseif((event.Key ==113) or (event.Key==81)) then
--		s1Shoot();
--	elseif((event.Key ==119) or (event.Key ==87)) then
--		s2Shoot();
	end
   end

end

RegisteredEvents["GM_KEYUP"] = GM_KEYUP;
RegisteredEvents["GM_KEYDOWN"] = GM_KEYDOWN;


function main()

   -- Freeze the player in the 3D world -- Dont forget to unfreeze before quitting!
   FreezePlayer();

   if(DoPreGameInterface(Script_Name) == false) then
      Exit();
   end

   Log("Starting '"..Script_Name.."' Script");	
   
   --Handle all object creation here outside the game loop
   GameWindow = CreateGUIClass("SkullRiders.gui",false);
   GameWindow.ShowWindow( false );
   OuterWindow = GameWindow.FindNamedWindow("GameWindow");
   InnerWindow = GameWindow.FindNamedWindow("innerWindow");
   ParticleContainer = GameWindow.FindNamedWindow("ParticleContainer");
   BannerOffset = {};
   BannerOffset.x, BannerOffset.y  = GetPointFromString(InnerWindow.GetLocation());
   ShootBanners = {};
   ShootBanners[BLUE] = CreateClass("class ControlBanner"); 
   ShootBanners[BLUE].ShowWindow(false);
   OuterWindow.AttachWindow(ShootBanners[BLUE]);
   ShootBanners[BLUE].AddScalingText(string.format("%d",POINTS_SHOOT), "0xff0000ff", nil);
   ShootBanners[GREEN] = CreateClass("class ControlBanner"); 
   ShootBanners[GREEN].ShowWindow(false);
   OuterWindow.AttachWindow(ShootBanners[GREEN]);
   ShootBanners[GREEN].AddScalingText(string.format("%d",POINTS_SHOOT * 2), "0xff0000ff", nil);
   ShootBanners[BLACK] = CreateClass("class ControlBanner"); 
   ShootBanners[BLACK].ShowWindow(false);
   OuterWindow.AttachWindow(ShootBanners[BLACK]);
   ShootBanners[BLACK].AddScalingText(string.format("%d",POINTS_SHOOT * 3), "0xff0000ff", nil);
   ShootBanners[RED] = CreateClass("class ControlBanner"); 
   ShootBanners[RED].ShowWindow(false);
   OuterWindow.AttachWindow(ShootBanners[RED]);
   ShootBanners[RED].AddScalingText(string.format("%d",POINTS_SHOOT * 4), "0xff0000ff", nil);
   EggBanner = CreateClass("class ControlBanner"); 
   EggBanner.ShowWindow(false);
   OuterWindow.AttachWindow(EggBanner);  
   EggBanner.AddScalingText(string.format("%d",POINTS_EGG), "0xff0000ff", nil);   
   WraithBanner = CreateClass("class ControlBanner"); 
   WraithBanner.ShowWindow(false);
   OuterWindow.AttachWindow(WraithBanner);  
   WraithBanner.AddScalingText(string.format("%d",POINTS_WRAITH), "0xff0000ff", nil);   
   
   CaptionAnim = CreateClass("class WinAnimConcurrent");
   RiseAnim = CreateClass("class WinAnimMoveToLocationTime");      
   GrowAnim = CreateClass("class WinAnimSizeTime");
   FadeAnim = CreateClass("class WinAnimAlphaFade");
   l1p1sprite = CreateSpriteClass("SkullRiders/Platform_Bottom_Spawn.dds",MakeRectString(0,0,152,72),false, InnerWindow);	
   l1p2sprite = CreateSpriteClass("SkullRiders/Platform_Bottom.dds",MakeRectString(0,0,160,71),false, InnerWindow);
   l1p3sprite = CreateSpriteClass("SkullRiders/Platform_Bottom.dds",MakeRectString(0,0,160,71),false, InnerWindow);
   
   
   
   
   p1leftfly = CreateSpriteClass(CreateTileMaterialClass("SkullRiders/Boy_Red_Fly_Left.dds", 3, 1),MakeRectString(0,0,76,76),false,InnerWindow);
   p1rightfly = CreateSpriteClass(CreateTileMaterialClass("SkullRiders/Boy_Red_Fly_Right.dds", 3, 1),MakeRectString(0,0,76,76),false,InnerWindow);
   p1leftrun = CreateSpriteClass(CreateTileMaterialClass("SkullRiders/Boy_Red_Run_Left.dds", 2, 2),MakeRectString(0,0,76,76),false,InnerWindow);
   p1leftidle = CreateSpriteClass(CreateTileMaterialClass("SkullRiders/Boy_Red_Idle_Left.dds", 3, 1),MakeRectString(0,0,76,76),false,InnerWindow);
   p1leftstop = CreateSpriteClass(CreateTileMaterialClass("SkullRiders/Boy_Red_Stop_Left.dds", 2, 1),MakeRectString(0,0,76,76),false,InnerWindow);
   p1leftshoot = CreateSpriteClass(CreateTileMaterialClass("SkullRiders/Boy_Red_Shoot_Left.dds", 3, 1),MakeRectString(0,0,76,76),false,InnerWindow);
   p1leftdeath = CreateSpriteClass(CreateTileMaterialClass("SkullRiders/Boy_Red_Death_Left.dds", 2, 2),MakeRectString(0,0,76,76),false,InnerWindow);
   p1rightrun = CreateSpriteClass(CreateTileMaterialClass("SkullRiders/Boy_Red_Run_Right.dds", 2, 2),MakeRectString(0,0,76,76),false,InnerWindow);
   p1rightidle = CreateSpriteClass(CreateTileMaterialClass("SkullRiders/Boy_Red_Idle_Right.dds", 3, 1),MakeRectString(0,0,76,76),false,InnerWindow);
   p1rightstop = CreateSpriteClass(CreateTileMaterialClass("SkullRiders/Boy_Red_Stop_Right.dds", 2, 1),MakeRectString(0,0,76,76),false,InnerWindow);
   p1rightshoot = CreateSpriteClass(CreateTileMaterialClass("SkullRiders/Boy_Red_Shoot_Right.dds", 3, 1),MakeRectString(0,0,76,76),false,InnerWindow);
   p1rightdeath = CreateSpriteClass(CreateTileMaterialClass("SkullRiders/Boy_Red_Death_Right.dds", 2, 2),MakeRectString(0,0,76,76),false,InnerWindow);
   p1leftdragonfly = CreateSpriteClass(CreateTileMaterialClass("SkullRiders/Dragon_Red_Fly_Left.dds", 3, 1),MakeRectString(0,0,76,76),false,InnerWindow);
   p1rightdragonfly = CreateSpriteClass(CreateTileMaterialClass("SkullRiders/Dragon_Red_Fly_Right.dds", 3, 1),MakeRectString(0,0,76,76),false,InnerWindow);
   bonepit = CreateSpriteClass("SkullRiders/Bonepit.dds",MakeRectString(0,0,598,38),true, InnerWindow);
   leftfbsprite = CreateSpriteClass(CreateTileMaterialClass("SkullRiders/Fireball_Player_Left.dds", 3, 1),MakeRectString(0,0,50,46),false,InnerWindow);
   rightfbsprite = CreateSpriteClass(CreateTileMaterialClass("SkullRiders/Fireball_Player_Right.dds", 3, 1),MakeRectString(0,0,50,46),false,InnerWindow);
   leftsr1sprite = CreateSpriteClass(CreateTileMaterialClass("SkullRiders/Fireball_Player_Left.dds", 3, 1),MakeRectString(0,0,50,46),false,InnerWindow);
   rightsr1sprite = CreateSpriteClass(CreateTileMaterialClass("SkullRiders/Fireball_Player_Right.dds", 3, 1),MakeRectString(0,0,50,46),false,InnerWindow);
   leftsr2sprite = CreateSpriteClass(CreateTileMaterialClass("SkullRiders/Fireball_Player_Left.dds", 3, 1),MakeRectString(0,0,50,46),false,InnerWindow);
   rightsr2sprite = CreateSpriteClass(CreateTileMaterialClass("SkullRiders/Fireball_Player_Right.dds", 3, 1),MakeRectString(0,0,50,46),false,InnerWindow);
   p1healthsprites = {};
   p1healthsprites[5] = CreateSpriteClass("SkullRiders/Heart.dds", MakeRectString(63,576,85,592), true, OuterWindow);
   p1healthsprites[4] = CreateSpriteClass("SkullRiders/Heart.dds", MakeRectString(97,576,119,592), true, OuterWindow);
   p1healthsprites[3] = CreateSpriteClass("SkullRiders/Heart.dds", MakeRectString(131,576,153,592), true, OuterWindow);
   p1healthsprites[2] = CreateSpriteClass("SkullRiders/Heart.dds", MakeRectString(165,576,187,592), true, OuterWindow);
   p1healthsprites[1] = CreateSpriteClass("SkullRiders/Heart.dds", MakeRectString(199,576,221,592), true, OuterWindow);
   p1text = CreateTextWindowClass("<string;MinigamesCommon_SCORECOLON></string>", true, OuterWindow);
   p1level = 1;
   p1gameovertext = CreateTextWindowClass("           ".."<string;MinigamesCommon_LEVEL></string> "..p1level, true, OuterWindow);
   p1levelindicator = CreateTextWindowClass("<string;MinigamesCommon_LEVEL></string> "..p1level, true, OuterWindow);
	p1gameoverscore = CreateTextWindowClass("", true, OuterWindow);
	p1gameoverlevel = CreateTextWindowClass("", true, OuterWindow);
	p1exittext = CreateTextWindowClass("", true, OuterWindow);
   p1score = 0;
	local str = string.format("%i",p1score);
	p1scoredisplay = CreateTextWindowClass(str, true, OuterWindow);
   --exitbutton = CreateButtonClass( "newexit", "", "0,0,47,47", true, OuterWindow );
   
   l2p1sprite = CreateSpriteClass(CreateTileMaterialClass("SkullRiders/Platform_Large_Spawn.dds", 1, 3),MakeRectString(0,0,190,44),false,InnerWindow);
   l2p1sprite.GetMaterial().SetRate(0);
   l2p1sprite.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;
   l2p1sprite.ShowWindow(true);

   l2p1crumble = CreateSpriteClass(CreateTileMaterialClass("SkullRiders/Crumbling.dds", 1, 5),MakeRectString(0,0,100,40),false,InnerWindow);
   l2p1crumble.GetMaterial().SetRate(0);   
   l2p1crumble.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;
   l2p1crumble.ShowWindow(false);

   l2p2sprite = CreateSpriteClass(CreateTileMaterialClass("SkullRiders/Platform_Large_Spawn.dds", 1, 3),MakeRectString(0,0,190,44),false,InnerWindow);
   l2p2sprite.GetMaterial().SetRate(0);
   l2p2sprite.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;
   l2p2sprite.ShowWindow(true);

   l2p2crumble = CreateSpriteClass(CreateTileMaterialClass("SkullRiders/Crumbling.dds", 1, 5),MakeRectString(0,0,100,40),false,InnerWindow);
   l2p2crumble.GetMaterial().SetRate(0);
   l2p2crumble.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;
   l2p2crumble.ShowWindow(false);

   l3p2sprite = CreateSpriteClass(CreateTileMaterialClass("SkullRiders/Platform_Large_Spawn.dds", 1, 3),MakeRectString(0,0,190,44),false,InnerWindow);
   l3p2sprite.GetMaterial().SetRate(0);   
   l3p2sprite.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;
   l3p2sprite.ShowWindow(true);

   l3p2crumble = CreateSpriteClass(CreateTileMaterialClass("SkullRiders/Crumbling.dds", 1, 5),MakeRectString(0,0,100,40),false,InnerWindow);
   l3p2crumble.GetMaterial().SetRate(0);   
   l3p2crumble.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;
   l3p2crumble.ShowWindow(false);

   l3p1sprite = CreateSpriteClass(CreateTileMaterialClass("SkullRiders/Platform_Small.dds", 1, 3),MakeRectString(0,0,100,28),false,InnerWindow);
   l3p1sprite.GetMaterial().SetRate(0);   
   l3p1sprite.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;
   l3p1sprite.ShowWindow(true);

   l3p1crumble = CreateSpriteClass(CreateTileMaterialClass("SkullRiders/Crumbling.dds", 1, 5),MakeRectString(0,0,100,40),false,InnerWindow);
   l3p1crumble.GetMaterial().SetRate(0);   
   l3p1crumble.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;
   l3p1crumble.ShowWindow(false);

   l3p3sprite = CreateSpriteClass(CreateTileMaterialClass("SkullRiders/Platform_Small.dds", 1, 3),MakeRectString(0,0,100,28),false,InnerWindow);
   l3p3sprite.GetMaterial().SetRate(0);   
   l3p3sprite.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;
   l3p3sprite.ShowWindow(true);

   l3p3crumble = CreateSpriteClass(CreateTileMaterialClass("SkullRiders/Crumbling.dds", 1, 5),MakeRectString(0,0,100,40),false,InnerWindow);
   l3p3crumble.GetMaterial().SetRate(0);
   l3p3crumble.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;
   l3p3crumble.ShowWindow(false);
  
  
   -- Register all required events
   for eventName, _ in pairs( RegisteredEvents ) do
      RegisterEvent( eventName );
   end  
   
   DebugBeginCriticalSection();
   Init();
   PlayGame();
   DebugEndCriticalSection();
      
	while( true ) do      
      event = GetEvent("", false);
      if (event) then
         local func = RegisteredEvents[event.EventName];
         if func then
            DebugBeginCriticalSection();
            func(event);
            DebugEndCriticalSection();
         end      
      end       
      Client_Update();      
	end   
end
local speed = 1.0;

function Client_Update()
	DebugBeginCriticalSection();
	time = GameTimer:GetTime();
	if(time > 10) then
	   GameTimer:Reset();
	CurrentTime = CurrentTime + (time/1000);

	if (CurrentTime - LastTimeMSG_Moved > 60) then
	   LastTimeMSG_Moved = CurrentTime;
	   if (AnyKeyPressed == 1) then
	      AnyKeyPressed = 0;
	      MovedInfo = {};
     	  SendProcessMessage(Messages.Moved, MovedInfo);
	   end
	end

  	skullRiderSpawnTimer = skullRiderSpawnTimer + (SKULLRIDER_SPAWNCHANGERATE * time / 1000);

	if ((numSkullRiders < thisLevelNumSkullRiders) 
	and (l2p1state ~= PLATFORM_Respawn)
	and (l2p2state ~= PLATFORM_Respawn)
	and (l3p1state ~= PLATFORM_Respawn)
	and (l3p2state ~= PLATFORM_Respawn)
	and (l3p3state ~= PLATFORM_Respawn)
	) then

	   if (skullRiderSpawnTimer >= SKULLRIDER_SPAWNDELAY) then

		if (  (thisLevelSpawnLocs[thisLevelSpawnIncrementer] == 0 and 
			(  l2p1state == PLATFORM_Crumble1
			or l2p1state == PLATFORM_Crumble2
			or l2p1state == PLATFORM_Crumble3
                        ) 
		      )
		   or (thisLevelSpawnLocs[thisLevelSpawnIncrementer] == 1 and 
			(  l2p2state == PLATFORM_Crumble1
			or l2p2state == PLATFORM_Crumble2
			or l2p2state == PLATFORM_Crumble3
                        ) 
		      )
		   or (thisLevelSpawnLocs[thisLevelSpawnIncrementer] == 2 and 
			(  l3p2state == PLATFORM_Crumble1
			or l3p2state == PLATFORM_Crumble2
			or l3p2state == PLATFORM_Crumble3
                        ) 
		      )
		) then

		   numSkullRiders = numSkullRiders + 1;

		   useLevel = p1level - 1;
		   if (useLevel >= 9) then
		   	   useLevel = 9;
		   end

		   CreateSkullRider((numSkullRiders -1), LevelConfigs[BADGUYS][useLevel][numSkullRiders], thisLevelSpawnLocs[thisLevelSpawnIncrementer]);

		   skullRiderSpawnTimer = 0; 
		else
			--player is stuck, need to respawn a platform
			RespawnAllPlatformsForLevel(p1level - 1);
		end


		if (thisLevelSpawnIncrementer == (thisLevelNumSpawnLocs - 1)) then
			thisLevelSpawnIncrementer = 0;
		else
			thisLevelSpawnIncrementer = thisLevelSpawnIncrementer + 1;
		end
	   end
	end	



	if (p1timeInCorridor > TIME_IN_CORRIDOR) then
		done = 0;
		if (ChangeThisSkullRiderCorridor >= numSkullRiders) then
		   ChangeThisSkullRiderCorridor = 0;
		end

		skullridercorridor = 0;

		for index = ChangeThisSkullRiderCorridor, (numSkullRiders - 1) do
			if ((done == 0) and (skullriderlist[index].state == STATE_Fly or skullriderlist[index].state == STATE_Idle)) then
				if (skullriderlist[index].ceiling >= CORRIDOR1) then
					skullridercorridor = 1;
					skullriderlist[index].destinationCeiling = CORRIDOR_HEIGHTS[2];
					skullriderlist[index].ceiling = CORRIDOR_HEIGHTS[2];
					-- moves skullrider up to the middle corridor
					done = 1;
					ChangeThisSkullRiderCorridor = index + 1;
				elseif (skullriderlist[index].ceiling >= CORRIDOR2) then
					skullridercorridor = 2;
					if (skullriderlist[index].ceiling > CORRIDOR_HEIGHTS[p1corridor]) then
						-- go up
						skullriderlist[index].ceiling = CORRIDOR_HEIGHTS[p1corridor];
					end
					skullriderlist[index].destinationCeiling = CORRIDOR_HEIGHTS[p1corridor];
					-- go wherever the player is
					done = 1;
					ChangeThisSkullRiderCorridor = index + 1;
				else
					skullridercorridorcorridor = 3;
					skullriderlist[index].destinationCeiling = CORRIDOR_HEIGHTS[2];
					-- moves skullrider down to the middle corridor
					done = 1;
					ChangeThisSkullRiderCorridor = index + 1;
				end	
			end

		end
		p1timeInCorridor = 0;
	end


	-- skull rider movements

	if (GameState == 1) then
	  for index = 0, (numSkullRiders - 1) do 

		MoveSkullRiders(index);

  	  end
	end


			if (p1state >= STATE_Death and p1state <= STATE_Death6) then
				upArrowState = ARROWSTATE_Up;
				upArrowNextState = ARROWSTATE_Up;
				leftArrowState = ARROWSTATE_Up;
				leftArrowNextState = ARROWSTATE_Up;
				rightArrowState = ARROWSTATE_Up;
				rightArrowNextState = ARROWSTATE_Up;
				downArrowState = ARROWSTATE_Up;
				downArrowNextState = ARROWSTATE_Up;
			end

			if (upArrowState == ARROWSTATE_Up and upArrowNextState == ARROWSTATE_Down) then
				p1Fly();
				upArrowTimer = 0;
			end

			if (leftArrowState == ARROWSTATE_Up and leftArrowNextState == ARROWSTATE_Down) then
				p1GoLeft();
				leftArrowTimer = 0;
			end			

			if (rightArrowState == ARROWSTATE_Up and rightArrowNextState == ARROWSTATE_Down) then
				p1GoRight();
				rightArrowTimer = 0;
			end	

			if (downArrowState == ARROWSTATE_Up and downArrowNextState == ARROWSTATE_Down) then
				p1Down();
				downArrowTimer = 0;
			end
	



			if (upArrowState == ARROWSTATE_Down) then
				upArrowTimer = upArrowTimer + (time / 1000);
				--Log("upArrowTimer="..upArrowTimer);
				if (upArrowTimer > UPARROW_TIME) then
					p1Fly();
					upArrowTimer = 0;
				end
			end
			if (leftArrowState == ARROWSTATE_Down) then
				leftArrowTimer = leftArrowTimer + (time / 1000);
				if (leftArrowTimer > LRARROW_TIME) then
					p1GoLeft();
					leftArrowTimer = 0;
				end
			end
			if (rightArrowState == ARROWSTATE_Down) then
				rightArrowTimer = rightArrowTimer + (time / 1000);
				if (rightArrowTimer > LRARROW_TIME) then
					p1GoRight();
					rightArrowTimer = 0;
				end
			end
			if (downArrowState == ARROWSTATE_Down) then
				downArrowTimer = downArrowTimer + (time / 1000);
				if (downArrowTimer > DNARROW_TIME) then
					p1Down();
					downArrowTimer = 0;
				end
			end


			upArrowState = upArrowNextState;
			leftArrowState = leftArrowNextState;
			rightArrowState = rightArrowNextState;
			downArrowState = downArrowNextState;



			alldone = 0;
			if (numSkullRiders > 0) then
				alldone = 1;
			end			
	

			for index = 0, (numSkullRiders - 1) do 
				if (skullriderlist[index].state ~= STATE_Invisible) then
					alldone = 0;
				end
			end

			if (numSkullRiders < thisLevelNumSkullRiders) then
				alldone = 0;
			end

			if (alldone == 1) then
				p1level = p1level +1;
            p1gameovertext.SetText("           ".."<string;MinigamesCommon_LEVEL></string> "..p1level);
            p1levelindicator.SetText("<string;MinigamesCommon_LEVEL></string> "..p1level);

				-- reset player	
				p1sprite.ShowWindow(false);
   				p1leftfly.ShowWindow(false);
   				p1rightfly.ShowWindow(false);
   				p1leftidle.ShowWindow(false);
   				p1rightidle.ShowWindow(false);
   				p1leftrun.ShowWindow(false);
   				p1rightrun.ShowWindow(false);
   				p1leftstop.ShowWindow(false);
   				p1rightstop.ShowWindow(false);
   				p1leftdeath.ShowWindow(false);
   				p1rightdeath.ShowWindow(false);
   				p1leftshoot.ShowWindow(false);
   				p1rightshoot.ShowWindow(false);
   				p1leftdragonfly.ShowWindow(false);
   				p1rightdragonfly.ShowWindow(false);
				leftfbsprite.ShowWindow(false); 
   				rightfbsprite.ShowWindow(false);

				p1sprite = p1leftidle;
				p1nextsprite = p1leftidle;
				p1face = 0;
				p1nextface = 0;
				p1state = STATE_Idle;
				p1nextstate = STATE_Idle;
				p1sprite.SetLocation(p1startx, p1starty);
				p1sprite.ShowWindow(true);
				p1x = p1startx;
				p1y = p1starty;	
				p1currentplatformleft = l1p1left;
				p1currentplatformright = l1p1right;
				p1RiseSpeed = -1;
				p1FallSpeed = -1;
				p1LeftSpeed = 0;
				p1RightSpeed = 0;

				if (p1level > (FINALLEVEL + 1) ) then
					InitLevel(FINALLEVEL);
				else
					InitLevel(p1level - 1);
				end
				
			end


			-- player updates

			---------------------------
			---------------------------
			-- RiseSpeed == 
			-- -1 means you're standing on a platform and gravity does not affect you
			-- > 1 means this is the amount you rise by
			-- RiseSpeed keeps decreasing each time (due to gravity) and when it gets
			-- down to zero it stops decreasing, and then the FallSpeed starts increasing
			---------------------------
			---------------------------
			-- FallSpeed == 
			-- does not need to be set to -1 on the platform and then reset to 0 on fall off.
			-- FallSpeed increases with time when RiseSpeed == 0, to increase gravity.
			---------------------------
			---------------------------
			-- RightSpeed and LeftSpeed are always greater than zero			
			---------------------------
			---------------------------

			if (p1state < STATE_Death or p1state > STATE_Death6) then
				if (p1RiseSpeed == 0) then
					p1FallSpeed = p1FallSpeed + (PLAYER_FALLRATE * time / 1000);
	        		elseif (p1RiseSpeed > 1) then 
					p1RiseSpeed = p1RiseSpeed - (PLAYER_RISESLOWRATE * time / 1000);
				elseif (p1RiseSpeed <= 1 and p1RiseSpeed > -1) then -- necessary to avoid -0 situation
					p1RiseSpeed = 0;
				end
			end

			for index = 0, (numSkullRiders - 1) do 

				if (skullriderlist[index].RiseSpeed == 0) then
					skullriderlist[index].FallSpeed = skullriderlist[index].FallSpeed + (SKULLRIDER_FALLRATE * time / 1000);
		        	elseif (skullriderlist[index].RiseSpeed > 1) then 
					skullriderlist[index].RiseSpeed = skullriderlist[index].RiseSpeed - (SKULLRIDER_RISESLOWRATE * time / 1000);
				elseif ((skullriderlist[index].RiseSpeed <= 1) and (skullriderlist[index].RiseSpeed > -1)) then -- necessary to avoid -0 situation
					skullriderlist[index].RiseSpeed = 0;
				end

			end


			if (p1state < STATE_Death or p1state > STATE_Death6) then
				p1LeftSpeed, p1RightSpeed = SlowDown(p1LeftSpeed, p1RightSpeed);
			end

			for index = 0, (numSkullRiders - 1) do 

				skullriderlist[index].LeftSpeed, skullriderlist[index].RightSpeed = 
					SlowDown(skullriderlist[index].LeftSpeed, skullriderlist[index].RightSpeed);

			end


			------------------------------------------------------------------------------
			--
			-- Calculate next location
			--
			------------------------------------------------------------------------------
			if (p1state < STATE_Death or p1state > STATE_Death6) then
				p1nexty = p1y + (p1FallSpeed - p1RiseSpeed);
				p1nextx = p1x + (p1RightSpeed - p1LeftSpeed);
			end


			for index = 0, (numSkullRiders - 1) do 
				skullriderlist[index].nexty = skullriderlist[index].y + 
					(skullriderlist[index].FallSpeed - skullriderlist[index].RiseSpeed);
				skullriderlist[index].nextx = skullriderlist[index].x + 
					(skullriderlist[index].RightSpeed - skullriderlist[index].LeftSpeed);
			end

			------------------------------------------------------------------------------
			--
			-- Check for changes in state
			--
			------------------------------------------------------------------------------

			---------------------------------------
			-- updates state, RiseSpeed, FallSpeed
			---------------------------------------
			if (p1state < STATE_Death or p1state > STATE_Death6) then
				if (p1RiseSpeed == -1) then
					CheckFallOffp1();
				end
			end

			for index = 0, (numSkullRiders - 1) do 
			
				if (skullriderlist[index].RiseSpeed == -1) then
					if (skullriderlist[index].state == STATE_Egg) then
						skullriderlist[index].nextstate = STATE_HatchWait;
						--if (skullriderlist[index].nextx < 0) then
						--	skullriderlist[index].nextx  = 0;
						--elseif (skullriderlist[index].nextx > 580) then
						--	skullriderlist[index].nextx  = 580;
						--end
					end
				end

			end


			---------------------------------------
			-- must be done before CheckRunIntoPlatform since there is no nextstate for platforms
			---------------------------------------
			if (l2p1state == PLATFORM_Fall) then
				l2p1y = l2p1y + PLATFORM_FALLRATE;
				l2p1sprite.SetLocation(l2p1x, l2p1y);
			elseif (l2p1state == PLATFORM_Respawn) then
				l2p1y = l2p1y + PLATFORM_FALLRATE;
				if (l2p1y >= l2p1starty) then
					l2p1y = l2p1starty;
					l2p1state = PLATFORM_Crumble1;
				end
				l2p1sprite.SetLocation(l2p1x, l2p1y);

			end
			if (l2p2state == PLATFORM_Fall) then
				l2p2y = l2p2y + PLATFORM_FALLRATE;
				l2p2sprite.SetLocation(l2p2x, l2p2y);
			elseif (l2p2state == PLATFORM_Respawn) then
				l2p2y = l2p2y + PLATFORM_FALLRATE;
				if (l2p2y >= l2p2starty) then
					l2p2y = l2p2starty;
					l2p2state = PLATFORM_Crumble1;
				end
				l2p2sprite.SetLocation(l2p2x, l2p2y);

  			end
			if (l3p1state == PLATFORM_Fall) then
				l3p1y = l3p1y + PLATFORM_FALLRATE;
				l3p1sprite.SetLocation(l3p1x, l3p1y);
			elseif (l3p1state == PLATFORM_Respawn) then
				l3p1y = l3p1y + PLATFORM_FALLRATE;
				if (l3p1y >= l3p1starty) then
					l3p1y = l3p1starty;
					l3p1state = PLATFORM_Crumble1;
				end
				l3p1sprite.SetLocation(l3p1x, l3p1y);

			end
			if (l3p2state == PLATFORM_Fall) then
				l3p2y = l3p2y + PLATFORM_FALLRATE;
				l3p2sprite.SetLocation(l3p2x, l3p2y);
			elseif (l3p2state == PLATFORM_Respawn) then
				l3p2y = l3p2y + PLATFORM_FALLRATE;
				if (l3p2y >= l3p2starty) then
					l3p2y = l3p2starty;
					l3p2state = PLATFORM_Crumble1;
				end
				l3p2sprite.SetLocation(l3p2x, l3p2y);

			end
			if (l3p3state == PLATFORM_Fall) then
				l3p3y = l3p3y + PLATFORM_FALLRATE;
				l3p3sprite.SetLocation(l3p3x, l3p3y);
			elseif (l3p3state == PLATFORM_Respawn) then
				l3p3y = l3p3y + PLATFORM_FALLRATE;
				if (l3p3y >= l3p3starty) then
					l3p3y = l3p3starty;
					l3p3state = PLATFORM_Crumble1;
				end
				l3p3sprite.SetLocation(l3p3x, l3p3y);
			end

			---------------------------------------
			-- updates RiseSpeed, FallSpeed, LeftSpeed, RightSpeed
			---------------------------------------
			if (p1state < STATE_Death or p1state > STATE_Death6) then
				CheckRunIntoPlatformsp1();
			end
			for index = 0, (numSkullRiders - 1) do 
				if (skullriderlist[index].state ~= STATE_Invisible) then
					CheckRunIntoPlatformsSkullRider(index);
				end
			end

			-- transition from run to idle
			if (p1state == STATE_Run and p1nextstate ~= STATE_Stop and p1LeftSpeed <= 0 and p1RightSpeed <= 0) then
				p1nextstate = STATE_Idle;
			end
			if (p1state == STATE_Stop) then
				p1nextstate = STATE_Stop2;
			end
			if (p1state == STATE_Stop2) then
				p1nextstate = STATE_Idle;
			end
			if (p1state == STATE_Shoot) then
				p1nextstate = STATE_Shoot2;
			end
			if (p1state == STATE_Shoot2) then
				p1nextstate = STATE_Shoot3;
			end
			if (p1state == STATE_Shoot3) then

				--Log ("p1shootsave="..p1shootsave);
				p1nextstate = p1shootsave;
			end
			if ((p1state >= STATE_Death) and (p1state <= STATE_Death4)) then
				p1nextstate = p1state + 1;
			end


			for index = 0, (numSkullRiders - 1) do 
	
				if (skullriderlist[index].state == STATE_Shoot) then
					skullriderlist[index].nextstate = STATE_Shoot2;
				
				elseif (skullriderlist[index].state == STATE_Shoot2) then
					skullriderlist[index].nextstate = STATE_Shoot3;
				
				elseif (skullriderlist[index].state == STATE_Shoot3) then
					--Log ("skullriderlist[index].shootsave="..skullriderlist[index].shootsave);
					skullriderlist[index].nextstate = skullriderlist[index].shootsave;
				
				elseif ((skullriderlist[index].state >= STATE_Death) and (skullriderlist[index].state <= STATE_Death5)) then
					--Log(" nextstate = death2");					
					skullriderlist[index].nextstate = skullriderlist[index].state + 1;
				
				elseif (skullriderlist[index].state == STATE_Death6) then
					--Log(" nextstate = egg");
					skullriderlist[index].nextstate = STATE_Egg;
					skullriderlist[index].hatchtimer = HATCH_TIME;
				
				elseif (skullriderlist[index].state == STATE_HatchWait) then
					if (skullriderlist[index].hatchtimer <= 0) then
						skullriderlist[index].nextstate = STATE_Hatch;
					else
						skullriderlist[index].hatchtimer = skullriderlist[index].hatchtimer - (HATCH_RATE * time / 1000);
					end
				
				elseif (skullriderlist[index].state >= STATE_Hatch and skullriderlist[index].state <= STATE_Hatch9) then
					skullriderlist[index].nextstate = skullriderlist[index].state + 1;
				
				elseif (skullriderlist[index].state == STATE_Hatch10) then
					skullriderlist[index].nextstate = STATE_WraithIdle;
				
				elseif (skullriderlist[index].state == STATE_Mount) then
					if (skullriderlist[index].face == 0) then
						skullriderlist[index].vulturex = skullriderlist[index].vulturex + (VULTURE_SPEED * time / 1000);
						skullriderlist[index].vulturerunright.SetLocation(skullriderlist[index].vulturex, skullriderlist[index].vulturey);
					else
						skullriderlist[index].vulturex = skullriderlist[index].vulturex - (VULTURE_SPEED * time / 1000);
						skullriderlist[index].vulturerunleft.SetLocation(skullriderlist[index].vulturex, skullriderlist[index].vulturey);
					end
				end
			
----- vulture state
				if (skullriderlist[index].vultureState == VSTATE_Run) then
				--  or skullriderlist[index].state == STATE_Invisible
					if (skullriderlist[index].face == 0) then
						skullriderlist[index].vulturex = skullriderlist[index].vulturex + (VULTURE_SPEED * time / 1000);
						skullriderlist[index].vultureflyright.SetLocation(skullriderlist[index].vulturex, skullriderlist[index].vulturey);
					else
						skullriderlist[index].vulturex = skullriderlist[index].vulturex - (VULTURE_SPEED * time / 1000);
						skullriderlist[index].vultureflyleft.SetLocation(skullriderlist[index].vulturex, skullriderlist[index].vulturey);
					end
				end


			end



			------------------------------------------------------------------------------
			--
			-- Check for action items.  needs to go here, after state advancements.
			-- changes player to state death, needs to override sequential nextstates
			-- like Stop2 and Shoot2, Shoot3.
			--
			------------------------------------------------------------------------------


			-- if the player runs into a skull rider they respawn

			for index = 0, (numSkullRiders - 1) do 

				if ((p1state < STATE_Death or p1state > STATE_Death6) and skullriderlist[index].state == STATE_Fly) then
					CheckCollisionp1SkullRider(index);
				end
			end


			for index = 0, (numSkullRiders - 1) do 
				if (skullriderlist[index].state >= STATE_Egg and skullriderlist[index].state <= STATE_Hatch10) then
					--Log("state_egg or state_hatchwait");
					PickUpEggSkullRider(index);
				-- have overlapping condidtions here because PickUpEgg
				-- code has different collision req's than PickUpWraith
				elseif (skullriderlist[index].state >= STATE_Hatch and skullriderlist[index].state <= STATE_WraithIdle) then
					--Log("state_wraithidle");
					PickUpWraithSkullRider(index);
				end
			end


			if (fbleft == 1 or fbright == 1) then
				CheckSkullRidersFireBallHit();
			end


			if (sr1left == 1 or sr1right == 1) then
				Checksr1PlayerFireBallHit();
			end

			if (sr2left == 1 or sr2right == 1) then
				Checksr2PlayerFireBallHit();
			end


			for index = 0, (numSkullRiders - 1) do 
				if (skullriderlist[index].state == STATE_WraithIdle) then
					CheckSkullRiderVulturePlatform(index);
				end
			end


			for index = 0, (numSkullRiders - 1) do 

				if (skullriderlist[index].state == STATE_Mount) then
					CheckSkullRiderVultureHit(index);
				end
			end


			------------------------------------------------------------------------------
			--
			-- Set next location
			--
			------------------------------------------------------------------------------
			
			---------------------------------------
			-- no state or image changes.
			-- updates nextx and nexty
			---------------------------------------


			CheckRunIntoGameEdges();


			if (p1y > CORRIDOR1) then
				p1corridor = 1;
			elseif (p1y > CORRIDOR2) then
				p1corridor = 2;
			else
				p1corridor = 3;
			end
			--if (p1nexty > CORRIDOR1) then
			--	p1nextcorridor = 1;
			--elseif (p1nexty > CORRIDOR2) then
			--	p1nextcorridor = 2;
			--else
			--	p1nextcorridor = 3;
			--end
			--if (p1corridor ~= p1nextcorridor) then
			--	p1timeInCorridor = 0;
			--else
				p1timeInCorridor = p1timeInCorridor + time/1000;
			--end


			p1y = p1nexty;
			p1x = p1nextx;

			for index = 0, (numSkullRiders - 1) do 
				skullriderlist[index].x = skullriderlist[index].nextx;
				skullriderlist[index].y = skullriderlist[index].nexty;
			end


			if (fbleft == 1) then
				fbx = fbx - (FIREBALLSPEED * time / 1000);
				leftfbsprite.SetLocation(fbx, fby);
				local effectPos = InnerWindow.WindowToScreen(leftfbsprite.GetLocation());
            			local effectX, effectY = GetPointFromString(effectPos);
            			effectX = effectX + 50;
            			effectY = effectY + 30;
            			fbeffect.SetEmitterPosition(effectX, effectY);
			elseif (fbright == 1) then
				fbx = fbx + (FIREBALLSPEED * time / 1000);
				rightfbsprite.SetLocation(fbx, fby);
				local effectPos = InnerWindow.WindowToScreen(rightfbsprite.GetLocation());
            			local effectX, effectY = GetPointFromString(effectPos);
            			effectY = effectY + 30;
            			fbeffect.SetEmitterPosition(effectX, effectY);
			end

			if (sr1left == 1) then
				sr1x = sr1x - (FIREBALLSPEED * time / 1000);
				leftsr1sprite.SetLocation(sr1x, sr1y);
			elseif (sr1right == 1) then
				sr1x = sr1x + (FIREBALLSPEED * time / 1000);
				rightsr1sprite.SetLocation(sr1x, sr1y);
			end

			if (sr2left == 1) then
				sr2x = sr2x - (FIREBALLSPEED * time / 1000);
				leftsr2sprite.SetLocation(sr2x, sr2y);
			elseif (sr2right == 1) then
				sr2x = sr2x + (FIREBALLSPEED * time / 1000);
				rightsr2sprite.SetLocation(sr2x, sr2y);
			end


			-- set location 
			p1sprite.SetLocation(p1x, p1y);

			for index = 0, (numSkullRiders - 1) do 
				skullriderlist[index].sprite.SetLocation(skullriderlist[index].x, skullriderlist[index].y);
			end

			------------------------------------------------------------------------------
			--
			-- Update display image
			--  set frame to zero for animations that only play once: stop, shoot (death)
			--
			------------------------------------------------------------------------------

			if (p1state == p1nextstate and p1face ~= p1nextface) then
				if (p1state == STATE_Fly) then
					if (p1nextface == 0) then
						p1nextsprite = p1leftfly;
					else
						p1nextsprite = p1rightfly;
					end
				end
				Changeimagep1();
			
			elseif ((p1state == STATE_Idle or p1state == STATE_Shoot3) 
			and p1nextstate == STATE_Run) then
				if (p1nextface == 0) then
					p1nextsprite = p1leftrun;
				else
					p1nextsprite = p1rightrun;
				end
				Changeimagep1();

			elseif (p1nextstate == STATE_Stop) then
				if (p1nextface == 0) then 
					p1rightstop.GetMaterial().SetCurrentFrame(0)
					p1nextsprite = p1rightstop;
				else
					p1leftstop.GetMaterial().SetCurrentFrame(0)
					p1nextsprite = p1leftstop;
					
				end
				Changeimagep1();

			elseif (p1nextstate == STATE_Shoot3) then
				if (p1nextface == 0) then
					leftfbsprite.SetLocation(p1x - 31, p1y +12);
					fbx = p1x - 31;
					fby = p1y +12;
				else
					rightfbsprite.SetLocation(p1x + 59, p1y +12);
					fbx = p1x + 59;
					fby = p1y +12;
				end

			elseif ((p1state == STATE_Idle or p1state == STATE_Run or p1state == STATE_Shoot3)
			and p1nextstate == STATE_Fly) then
				if (p1nextface == 0) then
					p1nextsprite = p1leftfly;
				else
					p1nextsprite = p1rightfly;
				end
				Changeimagep1();
			
			elseif (p1nextstate == STATE_Death and p1gameover == 0) then

				-- we must remove one of the hearts.  p1healthsprites[5] is the leftmost heart
				-- if we start with 5 healths, decrease by 1, now we have p1health == 4.
				p1healthsprites[p1health].ShowWindow(false);
				p1health = p1health - 1;

				if (p1nextface == 0) then
					p1leftdeath.GetMaterial().SetCurrentFrame(0)
					p1nextsprite = p1leftdeath;
				else
					p1rightdeath.GetMaterial().SetCurrentFrame(0)
					p1nextsprite = p1rightdeath;
				end

				p1respawntimer = RESPAWN_TIME;
				Changeimagep1();

				if (p1health == 0) then
					-- game over.
					-- still want to go through death sequence first though
					p1gameover = 1;
				end

			elseif (p1state == STATE_Death4 and p1nextstate == STATE_Death5) then

				p1dragonx = p1x;
				p1dragony = p1y;

				if (p1x <= RightWall/2) then
					p1nextface = 1;
					p1rightdragonfly.SetLocation(p1dragonx, p1dragony);
					p1rightdragonfly.ShowWindow(true);

				else
					p1nextface = 0;
					p1leftdragonfly.SetLocation(p1dragonx, p1dragony);
					p1leftdragonfly.ShowWindow(true);
				end
				
				p1sprite.ShowWindow(false);
				p1RiseSpeed = -1;
				p1FallSpeed = -1;
				p1LeftSpeed = 0;
				p1RightSpeed = 0;

				p1currentplatformleft = l1p1left;
				p1currentplatformright = l1p1right;

				p1dragonx = p1x;
				p1dragony = p1y;

				p1nextx = spawn1x;
				p1nexty = spawn1y;
				p1x = spawn1x;
				p1y = spawn1y;
				p1sprite.SetLocation(p1x, p1y);


			elseif (p1state == STATE_Death5) then

				if (p1dragony < spawn1y) then
					p1dragony = p1dragony + DRAGON_MOVE;
				else
					p1dragony = spawn1y;
				end


				if (p1nextface == 0) then
					if(p1dragonx > spawn1x) then
						p1dragonx = p1dragonx - DRAGON_MOVE;
					else
						p1dragonx = spawn1x;
						p1nextstate = STATE_Death6;
					end

					p1leftdragonfly.SetLocation(p1dragonx, p1dragony);
				else
					if(p1dragonx < spawn1x) then
						p1dragonx = p1dragonx + DRAGON_MOVE;
					else
						p1dragonx = spawn1x;
						p1nextstate = STATE_Death6;
					end
					p1rightdragonfly.SetLocation(p1dragonx, p1dragony);
				end

			elseif (p1state == STATE_Death6) then
				if (p1dragony < spawn1y) then
					p1dragony = p1dragony + DRAGON_MOVE;
				else
					p1dragony = spawn1y;
					p1nextstate = STATE_Idle;
					PlaySoundOnce(string.format("MiniGames/SkullRiders/player_spawn.wav"));
				end

				if (p1nextface == 0) then
					p1leftdragonfly.SetLocation(p1dragonx, p1dragony);
				else
					p1rightdragonfly.SetLocation(p1dragonx, p1dragony);
				end

			elseif ((p1state == STATE_Run or p1state == STATE_Fly 
			         or p1state == STATE_Shoot3 or p1state == STATE_Stop2)
			        and p1nextstate == STATE_Idle) then
				if (p1nextface == 0) then
					p1nextsprite = p1leftidle;
				else
					p1nextsprite = p1rightidle;
				end

				if (p1gameover == 0) then				
					Changeimagep1();
				else
					GameOver();
				end

			end

			if (p1state == STATE_Death6 and p1nextstate == STATE_Idle) then
				if (p1nextface == 0) then
					p1nextsprite = p1leftidle;
					p1leftdragonfly.ShowWindow(false);
				else
					p1nextsprite = p1rightidle;
					p1rightdragonfly.ShowWindow(false);
				end

				if (p1gameover == 0) then				
					Changeimagep1();
				else
					GameOver();
				end

			end


			if (p1state ~= STATE_Fly and p1nextstate == STATE_Fly) then
				if (wingFlapSound == nil) then
					wingFlapSound = PlaySound(string.format("MiniGames/SkullRiders/SR_Player_Uplift.wav"),1.0,0.0,-1);
				end
			end
			if (p1nextstate ~= STATE_Fly) then
				if (wingFlapSound ~= nil) then
					StopSound(wingFlapSound);
					wingFlapSound = nil;
				end
			end
         
         if (p1state ~= STATE_Run and p1nextstate == STATE_Run) then
				if (footstepSound == nil) then
					footstepSound = PlaySound(string.format("MiniGames/SkullRiders/footstep_left.wav"),1.0,0.0,-1);
				end
			end
			if (p1nextstate ~= STATE_Run) then
				if (footstepSound ~= nil) then
					StopSound(footstepSound);
					footstepSound = nil;
				end
			end

			--change states here
			p1state = p1nextstate;
			p1face = p1nextface;
		

			for index = 0, (numSkullRiders - 1) do 
			
				if (skullriderlist[index].state == skullriderlist[index].nextstate and skullriderlist[index].face ~= skullriderlist[index].nextface) then
					if (skullriderlist[index].state == STATE_Fly) then
						if (skullriderlist[index].nextface == 0) then
							skullriderlist[index].nextsprite = skullriderlist[index].leftfly;
						else
							skullriderlist[index].nextsprite = skullriderlist[index].rightfly;
						end
					end
					ChangeimageSkullRider(index);

				elseif (skullriderlist[index].nextstate == STATE_Shoot3) then
					if (skullriderlist[index].nextface == 0) then
						leftsr1sprite.SetLocation(skullriderlist[index].x - 31, skullriderlist[index].y +12);
						sr1x = skullriderlist[index].x - 31;
						sr1y = skullriderlist[index].y + 12;
					else
						rightsr1sprite.SetLocation(skullriderlist[index].x + 59, skullriderlist[index].y +12);
						sr1x = skullriderlist[index].x + 59;
						sr1y = skullriderlist[index].y + 12;
					end

				elseif ((skullriderlist[index].state == STATE_Idle or skullriderlist[index].state == STATE_Shoot3)
					and skullriderlist[index].nextstate == STATE_Fly) then
					if (skullriderlist[index].nextface == 0) then
						skullriderlist[index].nextsprite = skullriderlist[index].leftfly;
					else
						skullriderlist[index].nextsprite = skullriderlist[index].rightfly;
					end
					ChangeimageSkullRider(index);

				elseif ((skullriderlist[index].state == STATE_Fly or skullriderlist[index].state == STATE_Shoot3) 
				        and skullriderlist[index].nextstate == STATE_Idle) then
					if (skullriderlist[index].nextface == 0) then
						skullriderlist[index].nextsprite = skullriderlist[index].leftidle;
					else
						skullriderlist[index].nextsprite = skullriderlist[index].rightidle;
					end
					ChangeimageSkullRider(index);

				elseif (skullriderlist[index].nextstate == STATE_Death) then
					if (skullriderlist[index].nextface == 0) then
						skullriderlist[index].leftdeath.GetMaterial().SetCurrentFrame(0)
						skullriderlist[index].nextsprite = skullriderlist[index].leftdeath;
					else
						skullriderlist[index].rightdeath.GetMaterial().SetCurrentFrame(0)
						skullriderlist[index].nextsprite = skullriderlist[index].rightdeath;
					end
					ChangeimageSkullRider(index);
               				addCaption(ShootBanners[skullriderlist[index].rank], skullriderlist[index].nextx, skullriderlist[index].nexty);
					p1score = p1score + POINTS_SHOOT * ( 1 + skullriderlist[index].rank);
					--local str = string.format("%.7i",p1score);
					p1scoredisplay.SetText(string.format("%i",p1score));

				elseif (skullriderlist[index].nextstate == STATE_Egg and skullriderlist[index].state ~= STATE_Egg) then
					skullriderlist[index].skull.SetRotation(180);				
					skullriderlist[index].nextsprite = skullriderlist[index].skull;

					-- change location because skull is smaller and needs to sit lower.
					
					if (skullriderlist[index].state ~= STATE_HatchWait) then
						skullriderlist[index].x = skullriderlist[index].x + SKULL_X_INIT;
						skullriderlist[index].y = skullriderlist[index].y + SKULL_Y_INIT;
					end

					-- if we're already on a platform, it needs to go down even further to sit on the platform
					if (skullriderlist[index].RiseSpeed == -1) then
						skullriderlist[index].y = skullriderlist[index].y + SKULL_ON_PLATFORM_DIST;
					end

					ChangeimageSkullRider(index);
					skullriderGoUp(index);

					if (skullriderlist[index].rank < RED) then
						IncreaseRank(index);
					end

				
				elseif(skullriderlist[index].nextstate == STATE_Hatch) then
					skullriderlist[index].hatch.GetMaterial().SetCurrentFrame(0)
					skullriderlist[index].nextsprite = skullriderlist[index].hatch;		

					-- restore regular placement for skullrider

					skullriderlist[index].x = skullriderlist[index].x - SKULL_X_INIT;
					skullriderlist[index].y = skullriderlist[index].y - SKULL_Y_INIT;

					if (skullriderlist[index].x < LeftWall) then
						skullriderlist[index].x = LeftWall;
						skullriderlist[index].nextx = LeftWall;
					elseif (skullriderlist[index].x > RightWall) then
						skullriderlist[index].x = RightWall;
						skullriderlist[index].nextx = RightWall;
					end			

					-- probably also need to add SKULL_OFFSEST to y.
	
					skullriderlist[index].y = skullriderlist[index].y - SKULL_HATCH_CORRECT;

					ChangeimageSkullRider(index);
	
					PlaySoundOnce(string.format("MiniGames/SkullRiders/skull_hatch.wav"));
               local x = math.floor(skullriderlist[index].x+38);
               local y = math.floor(skullriderlist[index].y+38);            
               local effectPos = MakePointString(x, y);           
               local x, y = GetPointFromString(InnerWindow.WindowToScreen(effectPos));
               enemyDeathEffect(x, y);

				elseif(skullriderlist[index].state == STATE_Hatch10 and skullriderlist[index].nextstate == STATE_WraithIdle) then
					skullriderlist[index].nextsprite = skullriderlist[index].wraithidle;
					skullriderlist[index].vultureState = VSTATE_Run;

					skullriderlist[index].x = skullriderlist[index].x - 3;

					ChangeimageSkullRider(index);

					if (skullriderlist[index].x <= RightWall/2) then
						-- send in the vulture from the right (more distance to fly)
						skullriderlist[index].vulturex = RightWall;
						skullriderlist[index].vulturey = skullriderlist[index].y;
						skullriderlist[index].vultureflyleft.SetLocation(skullriderlist[index].vulturex, skullriderlist[index].vulturey);
						--Log("left side set location x="..skullriderlist[index].vulturex.." y="..skullriderlist[index].vulturey);
						--face toward the vulture, because he will walk toward it
						skullriderlist[index].face = 1;
						skullriderlist[index].nextface = 1;
					else
						skullriderlist[index].vulturex = LeftWall - 50;
						skullriderlist[index].vulturey = skullriderlist[index].y;
						skullriderlist[index].vultureflyright.SetLocation(skullriderlist[index].vulturex, skullriderlist[index].vulturey);
						--Log("right side set location x="..skullriderlist[index].vulturex.." y="..skullriderlist[index].vulturey);
						skullriderlist[index].face = 0;
						skullriderlist[index].nextface = 0;
					end

				elseif(skullriderlist[index].state == STATE_WraithIdle and skullriderlist[index].nextstate == STATE_Mount) then
					if (skullriderlist[index].face == 0) then
						skullriderlist[index].vulturerunright.SetLocation(skullriderlist[index].vulturex, skullriderlist[index].vulturey);
						skullriderlist[index].vultureflyright.ShowWindow(false);
						skullriderlist[index].vulturerunright.ShowWindow(true);
					else
						skullriderlist[index].vulturerunleft.SetLocation(skullriderlist[index].vulturex, skullriderlist[index].vulturey);
						skullriderlist[index].vultureflyleft.ShowWindow(false);
						skullriderlist[index].vulturerunleft.ShowWindow(true);	
					end	

				elseif(skullriderlist[index].state == STATE_Mount and skullriderlist[index].nextstate == STATE_Idle) then
					if (skullriderlist[index].face == 0) then
						skullriderlist[index].vulturerunright.ShowWindow(false);
						skullriderlist[index].nextsprite = skullriderlist[index].rightidle;
						skullriderlist[index].face = 1;
						skullriderlist[index].nextface = 1;
					else
						skullriderlist[index].vulturerunleft.ShowWindow(false);
						skullriderlist[index].nextsprite = skullriderlist[index].leftidle;
						skullriderlist[index].face = 0;
						skullriderlist[index].nextface = 0;
					end
					ChangeimageSkullRider(index);

				elseif(skullriderlist[index].nextstate == STATE_Invisible) then
					killEffect(skullriderlist[index].effect);
               skullriderlist[index].effect = nil;
               skullriderlist[index].sprite.ShowWindow(false);
				end

				--change states here
            skullriderlist[index].state = skullriderlist[index].nextstate;
				skullriderlist[index].face = skullriderlist[index].nextface;

			end




		-------------------
		-- advances animations according to state
		-------------------
		UpdateTime(time);
	
	end
	DebugEndCriticalSection();

end

function Changeimagep1()
	p1nextsprite.SetLocation(p1x, p1y);
	p1sprite.ShowWindow(false);
	p1nextsprite.ShowWindow(true);
	p1sprite = p1nextsprite;
end

function ChangeimageSkullRider(index)
	skullriderlist[index].nextsprite.SetLocation(skullriderlist[index].x, skullriderlist[index].y);
	skullriderlist[index].sprite.ShowWindow(false);
	skullriderlist[index].nextsprite.ShowWindow(true);
	skullriderlist[index].sprite = skullriderlist[index].nextsprite;
end


function CheckSkullRiderVultureHit(index)

	if (skullriderlist[index].face == 0) then
		if (skullriderlist[index].vulturex >= skullriderlist[index].x - VULTURE_DIST) then
			skullriderlist[index].nextstate = STATE_Idle;
		end
	else
		if (skullriderlist[index].vulturex <= skullriderlist[index].x + VULTURE_DIST) then
			skullriderlist[index].nextstate = STATE_Idle;
		end
	end
end


function CheckSkullRiderVulturePlatform(index)

	if (skullriderlist[index].vulturex <= (skullriderlist[index].currentplatformright) 
		and skullriderlist[index].vulturex >= (skullriderlist[index].currentplatformleft)) then
		skullriderlist[index].nextstate = STATE_Mount;
	end
end


function CheckCollisionp1SkullRider(index)

	if (CheckCollisionNew(p1nextx, p1nexty, skullriderlist[index].nextx - COLLISION_LEFT, skullriderlist[index].nextx + COLLISION_RIGHT,
			skullriderlist[index].nexty - COLLISION_TOP, skullriderlist[index].nexty + COLLISION_BOTTOM) == 1) then
		p1nextstate = STATE_Death;
		PlaySoundOnce(string.format("MiniGames/SkullRiders/player_death.wav"));
	end
end

function CheckCollisionNew(nextx, nexty, left, right, top, bottom)

	hit = 0;

	if ((nextx < left) or (nextx > right) or (nexty > bottom) or (nexty < top)) then
		-- do nothing	
	else
		hit = 1;
	end

	return hit;
end

function PickUpEggSkullRider(index)

	if (CheckCollisionNew(p1nextx, p1nexty, skullriderlist[index].nextx - SKULL_COLLISION_LEFT, skullriderlist[index].nextx + SKULL_COLLISION_RIGHT,
			skullriderlist[index].nexty - SKULL_COLLISION_TOP, skullriderlist[index].nexty - SKULL_COLLISION_BOTTOM) == 1) then
		skullriderlist[index].nextstate = STATE_Invisible;
		skullriderlist[index].state = STATE_Invisible;
		addCaption(EggBanner, skullriderlist[index].nextx, skullriderlist[index].nexty);
      p1score = p1score + POINTS_EGG;
		p1scoredisplay.SetText(string.format("%i",p1score));
		PlaySoundOnce(string.format("MiniGames/SkullRiders/walk_over_egg.wav"));      
	end
end

function PickUpWraithSkullRider(index)

	--Log("pickupwraithskullrider");

	if (CheckCollisionNew(p1nextx, p1nexty, skullriderlist[index].nextx - COLLISION_LEFT, skullriderlist[index].nextx + COLLISION_RIGHT,
			skullriderlist[index].nexty - COLLISION_TOP, skullriderlist[index].nexty + COLLISION_BOTTOM) == 1) then
		--Log("collided with wraith");
		skullriderlist[index].nextstate = STATE_Invisible;
		skullriderlist[index].state = STATE_Invisible;
		addCaption(WraithBanner, skullriderlist[index].nextx, skullriderlist[index].nexty);
      p1score = p1score + POINTS_WRAITH;
		p1scoredisplay.SetText(string.format("%i",p1score));      
		PlaySoundOnce(string.format("MiniGames/SkullRiders/walk_over_egg.wav"));
	end
end


function CheckSkullRidersFireBallHit()
	for index = 0, (numSkullRiders - 1) do 
		if (skullriderlist[index].state == STATE_Fly or skullriderlist[index].state == STATE_Idle) then

			if (CheckCollisionNew(fbx, fby, skullriderlist[index].x - 13, skullriderlist[index].x + 42, 
					skullriderlist[index].y - 24, skullriderlist[index].y + 40) == 1) then
				if (fbleft == 1) then
					leftfbsprite.ShowWindow(false);
					skullriderlist[index].nextstate = STATE_Death;
					fbleft = 0;
				end
				if (fbright == 1) then
					rightfbsprite.ShowWindow(false);
					skullriderlist[index].nextstate = STATE_Death;
					fbright = 0;
				end
				PlaySoundOnce(string.format("MiniGames/SkullRiders/enemy_death.wav"));
            killEffect(fbeffect);
            fbeffect = nil;
            local x = math.floor(skullriderlist[index].x+38);
            local y = math.floor(skullriderlist[index].y+38);            
            local effectPos = MakePointString(x, y);           
            local x, y = GetPointFromString(InnerWindow.WindowToScreen(effectPos));
            enemyDeathEffect(x, y);
	    Log("FireBallHit");
			end
		end
	end
end

function Checksr1PlayerFireBallHit()


	if (CheckCollisionNew(sr1x, sr1y, p1x - 13, p1x + 42, p1y - 24, p1y + 40) == 1) then
		if (sr1left == 1) then
			leftsr1sprite.ShowWindow(false);
			p1nextstate = STATE_Death;
			sr1left = 0;
		end
		if (sr1right == 1) then
			rightsr1sprite.ShowWindow(false);
			p1nextstate = STATE_Death;
			sr1right = 0;
		end
		PlaySoundOnce(string.format("MiniGames/SkullRiders/player_death.wav"));
	end
end

function Checksr2PlayerFireBallHit()


	if (CheckCollisionNew(sr2x, sr2y, p1x - 13, p1x + 42, p1y - 24, p1y + 40) == 1) then
		if (sr2left == 1) then
			--Log("Hit s1 left");
			leftsr2sprite.ShowWindow(false);
			p1nextstate = STATE_Death;
			sr2left = 0;
		end
		if (sr2right == 1) then
			--Log("Hit s1 right");
			rightsr2sprite.ShowWindow(false);
			p1nextstate = STATE_Death;
			sr2right = 0;
		end
		PlaySoundOnce(string.format("MiniGames/SkullRiders/player_death.wav"));
	end
end



function CheckRunIntoPlatform(x, y, nextx, nexty, left, right, top, bottom, LeftSpeed, RightSpeed, RiseSpeed, FallSpeed, nextstate, currentplatformleft, currentplatformright)

landOnPlatform = 0;

-- right side (bounce off to the right)

	if (x > right and nextx <= right) then

		if (nexty >= top and nexty <= bottom) then
		nextx = right + (right - nextx);

		LeftSpeed = 0;
		RightSpeed = 2;
		PlaySoundOnce(string.format("MiniGames/SkullRiders/bounce.wav"));
		end


-- left side (bounce off to the left)

	elseif (x < left and nextx >= left) then

		if (nexty >= top and nexty <= bottom) then
		nextx = left - (nextx - left);

		RightSpeed = 0;
		LeftSpeed = 2;
		PlaySoundOnce(string.format("MiniGames/SkullRiders/bounce.wav"));
		end
	

-- bottom (hit head on bottom as a ceiling)

	elseif (y >= bottom and nexty <= bottom) then

		if  ((nextx >= left) and (nextx <= right)) then
		nexty = bottom + (bottom - nexty);

		FallSpeed = 0;
		RiseSpeed = 0;
		PlaySoundOnce(string.format("MiniGames/SkullRiders/bounce.wav"));
		end
	

-- top (land and stay put)

	elseif ((y < top) and (nexty >= top)) then

		if (nextx >= left and nextx <= right) then
		nexty = top;
		
		FallSpeed = -1;
		RiseSpeed = -1;

		RightSpeed = 0;
		LeftSpeed = 0;

			if (nextstate == STATE_Egg) then
				nextstate = STATE_HatchWait;
				currentplatformleft = left - SKULL_OFFSETleft;
				currentplatformright = right - SKULL_OFFSETright;
			else
				nextstate = STATE_Idle;
				currentplatformleft = left;
				currentplatformright = right;
			end	

		landOnPlatform = 1;

		end
	end

	return LeftSpeed, RightSpeed, RiseSpeed, FallSpeed, nextx, nexty, nextstate, currentplatformleft, currentplatformright, landOnPlatform;


end

function Checkp1RunIntoPlatforml1p1()
	p1LeftSpeed, p1RightSpeed, p1RiseSpeed, p1FallSpeed, p1nextx, p1nexty, p1nextstate, p1currentplatformleft, p1currentplatformright = CheckRunIntoPlatform(p1x, p1y, p1nextx, p1nexty, l1p1left, l1p1right, l1p1top, l1p1bottom, p1LeftSpeed, p1RightSpeed, p1RiseSpeed, p1FallSpeed, p1nextstate, p1currentplatformleft, p1currentplatformright, landOnPlatform);
end
function Checkp1RunIntoPlatforml1p2()
	p1LeftSpeed, p1RightSpeed, p1RiseSpeed, p1FallSpeed, p1nextx, p1nexty, p1nextstate, p1currentplatformleft, p1currentplatformright = CheckRunIntoPlatform(p1x, p1y, p1nextx, p1nexty, l1p2left, l1p2right, l1p2top, l1p2bottom, p1LeftSpeed, p1RightSpeed, p1RiseSpeed, p1FallSpeed, p1nextstate, p1currentplatformleft, p1currentplatformright, landOnPlatform);
end
function Checkp1RunIntoPlatforml1p3()
	p1LeftSpeed, p1RightSpeed, p1RiseSpeed, p1FallSpeed, p1nextx, p1nexty, p1nextstate, p1currentplatformleft, p1currentplatformright = CheckRunIntoPlatform(p1x, p1y, p1nextx, p1nexty, l1p3left, l1p3right, l1p3top, l1p3bottom, p1LeftSpeed, p1RightSpeed, p1RiseSpeed, p1FallSpeed, p1nextstate, p1currentplatformleft, p1currentplatformright, landOnPlatform);
end
function Checkp1RunIntoPlatforml2p1()
	p1LeftSpeed, p1RightSpeed, p1RiseSpeed, p1FallSpeed, p1nextx, p1nexty, p1nextstate, p1currentplatformleft, p1currentplatformright = CheckRunIntoPlatform(p1x, p1y, p1nextx, p1nexty, l2p1left, l2p1right, l2p1top, l2p1bottom, p1LeftSpeed, p1RightSpeed, p1RiseSpeed, p1FallSpeed, p1nextstate, p1currentplatformleft, p1currentplatformright, landOnPlatform);

	if (landOnPlatform == 1) then
		l2p1crumblestate = l2p2crumblestate + 1;
		if (l2p1state < PLATFORM_Respawn) then
			l2p1state = l2p1state + 1;
		end
		if (l2p1state == PLATFORM_Fall) then
			p1Fly();
			for index = 0, (numSkullRiders - 1) do 
				if (skullriderlist[index].currentplatformleft == l2p1left
				and  (   skullriderlist[index].state >= STATE_HatchWait
 				     and skullriderlist[index].state <= STATE_WraithIdle 
				     )
				   ) then
					--skullriderGoUp(index);
					--skullriderlist[index].RiseSpeed = 0;
					--skullriderlist[index].FallSpeed = 0;
					skullriderlist[index].nextstate = STATE_Egg;
				end
			end
		end
		PlaySoundOnce(string.format("MiniGames/SkullRiders/SR_Platform_Crumbles.wav"));
	end
end
function Checkp1RunIntoPlatforml2p2()
	p1LeftSpeed, p1RightSpeed, p1RiseSpeed, p1FallSpeed, p1nextx, p1nexty, p1nextstate, p1currentplatformleft, p1currentplatformright = CheckRunIntoPlatform(p1x, p1y, p1nextx, p1nexty, l2p2left, l2p2right, l2p2top, l2p2bottom, p1LeftSpeed, p1RightSpeed, p1RiseSpeed, p1FallSpeed, p1nextstate, p1currentplatformleft, p1currentplatformright, landOnPlatform);

	if (landOnPlatform == 1) then
		l2p2crumblestate = l2p2crumblestate + 1;
		if (l2p2state < PLATFORM_Respawn) then
			l2p2state = l2p2state + 1;
		end
		if (l2p2state == PLATFORM_Fall) then
			p1Fly();
			for index = 0, (numSkullRiders - 1) do 
				if (skullriderlist[index].currentplatformleft == l2p2left
				and  (   skullriderlist[index].state >= STATE_HatchWait
 				     and skullriderlist[index].state <= STATE_WraithIdle 
				     )
				   ) then
					--skullriderGoUp(index);
					--skullriderlist[index].RiseSpeed = 0;
					--skullriderlist[index].FallSpeed = 0;
					skullriderlist[index].nextstate = STATE_Egg;
				end
			end
		end
		PlaySoundOnce(string.format("MiniGames/SkullRiders/SR_Platform_Crumbles.wav"));
	end

end
function Checkp1RunIntoPlatforml3p1()
	p1LeftSpeed, p1RightSpeed, p1RiseSpeed, p1FallSpeed, p1nextx, p1nexty, p1nextstate, p1currentplatformleft, p1currentplatformright = CheckRunIntoPlatform(p1x, p1y, p1nextx, p1nexty, l3p1left, l3p1right, l3p1top, l3p1bottom, p1LeftSpeed, p1RightSpeed, p1RiseSpeed, p1FallSpeed, p1nextstate, p1currentplatformleft, p1currentplatformright, landOnPlatform);

	if (landOnPlatform == 1) then
		l3p1crumblestate = l3p1crumblestate + 1;
		if (l3p1state < PLATFORM_Respawn) then
			l3p1state = l3p1state + 1;
		end
		if (l3p1state == PLATFORM_Fall) then
			p1Fly();
			for index = 0, (numSkullRiders - 1) do 
				if (skullriderlist[index].currentplatformleft == l3p1left
				and  (   skullriderlist[index].state >= STATE_HatchWait
 				     and skullriderlist[index].state <= STATE_WraithIdle 
				     )
				   ) then
					--skullriderGoUp(index);
					--skullriderlist[index].RiseSpeed = 0;
					--skullriderlist[index].FallSpeed = 0;
					skullriderlist[index].nextstate = STATE_Egg;
				end
			end
		end
		PlaySoundOnce(string.format("MiniGames/SkullRiders/SR_Platform_Crumbles.wav"));
	end

end
function Checkp1RunIntoPlatforml3p2()
	p1LeftSpeed, p1RightSpeed, p1RiseSpeed, p1FallSpeed, p1nextx, p1nexty, p1nextstate, p1currentplatformleft, p1currentplatformright = CheckRunIntoPlatform(p1x, p1y, p1nextx, p1nexty, l3p2left, l3p2right, l3p2top, l3p2bottom, p1LeftSpeed, p1RightSpeed, p1RiseSpeed, p1FallSpeed, p1nextstate, p1currentplatformleft, p1currentplatformright, landOnPlatform);

	if (landOnPlatform == 1) then
		l3p2crumblestate = l3p2crumblestate + 1;
		if (l3p2state < PLATFORM_Respawn) then
			l3p2state = l3p2state + 1;
		end
		if (l3p2state == PLATFORM_Fall) then
			p1Fly();
			for index = 0, (numSkullRiders - 1) do 
				if (skullriderlist[index].currentplatformleft == l3p2left
				and  (   skullriderlist[index].state >= STATE_HatchWait
 				     and skullriderlist[index].state <= STATE_WraithIdle 
				     )
				   ) then
					--skullriderGoUp(index);
					--skullriderlist[index].RiseSpeed = 0;
					--skullriderlist[index].FallSpeed = 0;
					skullriderlist[index].nextstate = STATE_Egg;
				end
			end
		end
		PlaySoundOnce(string.format("MiniGames/SkullRiders/SR_Platform_Crumbles.wav"));
	end

end
function Checkp1RunIntoPlatforml3p3()
	p1LeftSpeed, p1RightSpeed, p1RiseSpeed, p1FallSpeed, p1nextx, p1nexty, p1nextstate, p1currentplatformleft, p1currentplatformright = CheckRunIntoPlatform(p1x, p1y, p1nextx, p1nexty, l3p3left, l3p3right, l3p3top, l3p3bottom, p1LeftSpeed, p1RightSpeed, p1RiseSpeed, p1FallSpeed, p1nextstate, p1currentplatformleft, p1currentplatformright, landOnPlatform);

	if (landOnPlatform == 1) then
		l3p3crumblestate = l3p3crumblestate + 1;
		if (l3p3state < PLATFORM_Respawn) then
			l3p3state = l3p3state + 1;
		end
		if (l3p3state == PLATFORM_Fall) then
			p1Fly();
			for index = 0, (numSkullRiders - 1) do 
				if (skullriderlist[index].currentplatformleft == l3p3left
				and  (   skullriderlist[index].state >= STATE_HatchWait
 				     and skullriderlist[index].state <= STATE_WraithIdle 
				     )
				   ) then
					--skullriderGoUp(index);
					--skullriderlist[index].RiseSpeed = 0;
					--skullriderlist[index].FallSpeed = 0;
					skullriderlist[index].nextstate = STATE_Egg;
				end
			end
		end
		PlaySoundOnce(string.format("MiniGames/SkullRiders/SR_Platform_Crumbles.wav"));
	end

end
-----
function CheckSkullRiderRunIntoPlatforml1p1(index)
	if (skullriderlist[index].state == STATE_Egg) then 
		skullriderlist[index].LeftSpeed, skullriderlist[index].RightSpeed, skullriderlist[index].RiseSpeed, skullriderlist[index].FallSpeed, skullriderlist[index].nextx, skullriderlist[index].nexty, skullriderlist[index].nextstate, skullriderlist[index].currentplatformleft, skullriderlist[index].currentplatformright = CheckRunIntoPlatform(skullriderlist[index].x, skullriderlist[index].y, skullriderlist[index].nextx, skullriderlist[index].nexty, l1p1left + SKULL_OFFSETleft, l1p1right + SKULL_OFFSETright, l1p1top + SKULL_OFFSETtop, l1p1bottom, skullriderlist[index].LeftSpeed, skullriderlist[index].RightSpeed, skullriderlist[index].RiseSpeed, skullriderlist[index].FallSpeed, skullriderlist[index].nextstate, skullriderlist[index].currentplatformleft, skullriderlist[index].currentplatformright);
	else
		skullriderlist[index].LeftSpeed, skullriderlist[index].RightSpeed, skullriderlist[index].RiseSpeed, skullriderlist[index].FallSpeed, skullriderlist[index].nextx, skullriderlist[index].nexty, skullriderlist[index].nextstate, skullriderlist[index].currentplatformleft, skullriderlist[index].currentplatformright = CheckRunIntoPlatform(skullriderlist[index].x, skullriderlist[index].y, skullriderlist[index].nextx, skullriderlist[index].nexty, l1p1left, l1p1right, l1p1top, l1p1bottom, skullriderlist[index].LeftSpeed, skullriderlist[index].RightSpeed, skullriderlist[index].RiseSpeed, skullriderlist[index].FallSpeed, skullriderlist[index].nextstate, skullriderlist[index].currentplatformleft, skullriderlist[index].currentplatformright);
	end
end
function CheckSkullRiderRunIntoPlatforml1p2(index)
	if (skullriderlist[index].state == STATE_Egg) then 
		skullriderlist[index].LeftSpeed, skullriderlist[index].RightSpeed, skullriderlist[index].RiseSpeed, skullriderlist[index].FallSpeed, skullriderlist[index].nextx, skullriderlist[index].nexty, skullriderlist[index].nextstate, skullriderlist[index].currentplatformleft, skullriderlist[index].currentplatformright = CheckRunIntoPlatform(skullriderlist[index].x, skullriderlist[index].y, skullriderlist[index].nextx, skullriderlist[index].nexty, l1p2left + SKULL_OFFSETleft, l1p2right + SKULL_OFFSETright, l1p2top + SKULL_OFFSETtop, l1p2bottom, skullriderlist[index].LeftSpeed, skullriderlist[index].RightSpeed, skullriderlist[index].RiseSpeed, skullriderlist[index].FallSpeed, skullriderlist[index].nextstate, skullriderlist[index].currentplatformleft, skullriderlist[index].currentplatformright);
	else
		skullriderlist[index].LeftSpeed, skullriderlist[index].RightSpeed, skullriderlist[index].RiseSpeed, skullriderlist[index].FallSpeed, skullriderlist[index].nextx, skullriderlist[index].nexty, skullriderlist[index].nextstate, skullriderlist[index].currentplatformleft, skullriderlist[index].currentplatformright = CheckRunIntoPlatform(skullriderlist[index].x, skullriderlist[index].y, skullriderlist[index].nextx, skullriderlist[index].nexty, l1p2left, l1p2right, l1p2top, l1p2bottom, skullriderlist[index].LeftSpeed, skullriderlist[index].RightSpeed, skullriderlist[index].RiseSpeed, skullriderlist[index].FallSpeed, skullriderlist[index].nextstate, skullriderlist[index].currentplatformleft, skullriderlist[index].currentplatformright);
	end
end
function CheckSkullRiderRunIntoPlatforml1p3(index)
	if (skullriderlist[index].state == STATE_Egg) then 
		skullriderlist[index].LeftSpeed, skullriderlist[index].RightSpeed, skullriderlist[index].RiseSpeed, skullriderlist[index].FallSpeed, skullriderlist[index].nextx, skullriderlist[index].nexty, skullriderlist[index].nextstate, skullriderlist[index].currentplatformleft, skullriderlist[index].currentplatformright = CheckRunIntoPlatform(skullriderlist[index].x, skullriderlist[index].y, skullriderlist[index].nextx, skullriderlist[index].nexty, l1p3left + SKULL_OFFSETleft, l1p3right + SKULL_OFFSETright, l1p3top + SKULL_OFFSETtop, l1p3bottom, skullriderlist[index].LeftSpeed, skullriderlist[index].RightSpeed, skullriderlist[index].RiseSpeed, skullriderlist[index].FallSpeed, skullriderlist[index].nextstate, skullriderlist[index].currentplatformleft, skullriderlist[index].currentplatformright);
	else
		skullriderlist[index].LeftSpeed, skullriderlist[index].RightSpeed, skullriderlist[index].RiseSpeed, skullriderlist[index].FallSpeed, skullriderlist[index].nextx, skullriderlist[index].nexty, skullriderlist[index].nextstate, skullriderlist[index].currentplatformleft, skullriderlist[index].currentplatformright = CheckRunIntoPlatform(skullriderlist[index].x, skullriderlist[index].y, skullriderlist[index].nextx, skullriderlist[index].nexty, l1p3left, l1p3right, l1p3top, l1p3bottom, skullriderlist[index].LeftSpeed, skullriderlist[index].RightSpeed, skullriderlist[index].RiseSpeed, skullriderlist[index].FallSpeed, skullriderlist[index].nextstate, skullriderlist[index].currentplatformleft, skullriderlist[index].currentplatformright);
	end
end
function CheckSkullRiderRunIntoPlatforml2p1(index)
	if (skullriderlist[index].state == STATE_Egg) then 
		if (l2p1state ~= PLATFORM_Fall) then
			skullriderlist[index].LeftSpeed, skullriderlist[index].RightSpeed, skullriderlist[index].RiseSpeed, skullriderlist[index].FallSpeed, skullriderlist[index].nextx, skullriderlist[index].nexty, skullriderlist[index].nextstate, skullriderlist[index].currentplatformleft, skullriderlist[index].currentplatformright = CheckRunIntoPlatform(skullriderlist[index].x, skullriderlist[index].y, skullriderlist[index].nextx, skullriderlist[index].nexty, l2p1left + SKULL_OFFSETleft, l2p1right + SKULL_OFFSETright, l2p1top + SKULL_OFFSETtop, l2p1bottom, skullriderlist[index].LeftSpeed, skullriderlist[index].RightSpeed, skullriderlist[index].RiseSpeed, skullriderlist[index].FallSpeed, skullriderlist[index].nextstate, skullriderlist[index].currentplatformleft, skullriderlist[index].currentplatformright);
		end
	else
		skullriderlist[index].LeftSpeed, skullriderlist[index].RightSpeed, skullriderlist[index].RiseSpeed, skullriderlist[index].FallSpeed, skullriderlist[index].nextx, skullriderlist[index].nexty, skullriderlist[index].nextstate, skullriderlist[index].currentplatformleft, skullriderlist[index].currentplatformright = CheckRunIntoPlatform(skullriderlist[index].x, skullriderlist[index].y, skullriderlist[index].nextx, skullriderlist[index].nexty, l2p1left, l2p1right, l2p1top, l2p1bottom, skullriderlist[index].LeftSpeed, skullriderlist[index].RightSpeed, skullriderlist[index].RiseSpeed, skullriderlist[index].FallSpeed, skullriderlist[index].nextstate, skullriderlist[index].currentplatformleft, skullriderlist[index].currentplatformright);
	end
end
function CheckSkullRiderRunIntoPlatforml2p2(index)
	if (skullriderlist[index].state == STATE_Egg) then 
		if (l2p2state ~= PLATFORM_Fall) then
			skullriderlist[index].LeftSpeed, skullriderlist[index].RightSpeed, skullriderlist[index].RiseSpeed, skullriderlist[index].FallSpeed, skullriderlist[index].nextx, skullriderlist[index].nexty, skullriderlist[index].nextstate, skullriderlist[index].currentplatformleft, skullriderlist[index].currentplatformright = CheckRunIntoPlatform(skullriderlist[index].x, skullriderlist[index].y, skullriderlist[index].nextx, skullriderlist[index].nexty, l2p2left + SKULL_OFFSETleft, l2p2right + SKULL_OFFSETright, l2p2top + SKULL_OFFSETtop, l2p2bottom, skullriderlist[index].LeftSpeed, skullriderlist[index].RightSpeed, skullriderlist[index].RiseSpeed, skullriderlist[index].FallSpeed, skullriderlist[index].nextstate, skullriderlist[index].currentplatformleft, skullriderlist[index].currentplatformright);
		end
	else
		skullriderlist[index].LeftSpeed, skullriderlist[index].RightSpeed, skullriderlist[index].RiseSpeed, skullriderlist[index].FallSpeed, skullriderlist[index].nextx, skullriderlist[index].nexty, skullriderlist[index].nextstate, skullriderlist[index].currentplatformleft, skullriderlist[index].currentplatformright = CheckRunIntoPlatform(skullriderlist[index].x, skullriderlist[index].y, skullriderlist[index].nextx, skullriderlist[index].nexty, l2p2left, l2p2right, l2p2top, l2p2bottom, skullriderlist[index].LeftSpeed, skullriderlist[index].RightSpeed, skullriderlist[index].RiseSpeed, skullriderlist[index].FallSpeed, skullriderlist[index].nextstate, skullriderlist[index].currentplatformleft, skullriderlist[index].currentplatformright);
	end
end
function CheckSkullRiderRunIntoPlatforml3p1(index)
	if (skullriderlist[index].state == STATE_Egg) then 
		if (l3p1state ~= PLATFORM_Fall) then
			skullriderlist[index].LeftSpeed, skullriderlist[index].RightSpeed, skullriderlist[index].RiseSpeed, skullriderlist[index].FallSpeed, skullriderlist[index].nextx, skullriderlist[index].nexty, skullriderlist[index].nextstate, skullriderlist[index].currentplatformleft, skullriderlist[index].currentplatformright = CheckRunIntoPlatform(skullriderlist[index].x, skullriderlist[index].y, skullriderlist[index].nextx, skullriderlist[index].nexty, l3p1left + SKULL_OFFSETleft, l3p1right + SKULL_OFFSETright, l3p1top + SKULL_OFFSETtop, l3p1bottom, skullriderlist[index].LeftSpeed, skullriderlist[index].RightSpeed, skullriderlist[index].RiseSpeed, skullriderlist[index].FallSpeed, skullriderlist[index].nextstate, skullriderlist[index].currentplatformleft, skullriderlist[index].currentplatformright);
		end
	else
		skullriderlist[index].LeftSpeed, skullriderlist[index].RightSpeed, skullriderlist[index].RiseSpeed, skullriderlist[index].FallSpeed, skullriderlist[index].nextx, skullriderlist[index].nexty, skullriderlist[index].nextstate, skullriderlist[index].currentplatformleft, skullriderlist[index].currentplatformright = CheckRunIntoPlatform(skullriderlist[index].x, skullriderlist[index].y, skullriderlist[index].nextx, skullriderlist[index].nexty, l3p1left, l3p1right, l3p1top, l3p1bottom, skullriderlist[index].LeftSpeed, skullriderlist[index].RightSpeed, skullriderlist[index].RiseSpeed, skullriderlist[index].FallSpeed, skullriderlist[index].nextstate, skullriderlist[index].currentplatformleft, skullriderlist[index].currentplatformright);
	end
end
function CheckSkullRiderRunIntoPlatforml3p2(index)
	if (skullriderlist[index].state == STATE_Egg) then 
		if (l3p2state ~= PLATFORM_Fall) then
			skullriderlist[index].LeftSpeed, skullriderlist[index].RightSpeed, skullriderlist[index].RiseSpeed, skullriderlist[index].FallSpeed, skullriderlist[index].nextx, skullriderlist[index].nexty, skullriderlist[index].nextstate, skullriderlist[index].currentplatformleft, skullriderlist[index].currentplatformright = CheckRunIntoPlatform(skullriderlist[index].x, skullriderlist[index].y, skullriderlist[index].nextx, skullriderlist[index].nexty, l3p2left + SKULL_OFFSETleft, l3p2right + SKULL_OFFSETright, l3p2top + SKULL_OFFSETtop, l3p2bottom, skullriderlist[index].LeftSpeed, skullriderlist[index].RightSpeed, skullriderlist[index].RiseSpeed, skullriderlist[index].FallSpeed, skullriderlist[index].nextstate, skullriderlist[index].currentplatformleft, skullriderlist[index].currentplatformright);
		end
	else
		skullriderlist[index].LeftSpeed, skullriderlist[index].RightSpeed, skullriderlist[index].RiseSpeed, skullriderlist[index].FallSpeed, skullriderlist[index].nextx, skullriderlist[index].nexty, skullriderlist[index].nextstate, skullriderlist[index].currentplatformleft, skullriderlist[index].currentplatformright = CheckRunIntoPlatform(skullriderlist[index].x, skullriderlist[index].y, skullriderlist[index].nextx, skullriderlist[index].nexty, l3p2left, l3p2right, l3p2top, l3p2bottom, skullriderlist[index].LeftSpeed, skullriderlist[index].RightSpeed, skullriderlist[index].RiseSpeed, skullriderlist[index].FallSpeed, skullriderlist[index].nextstate, skullriderlist[index].currentplatformleft, skullriderlist[index].currentplatformright);
	end
end
function CheckSkullRiderRunIntoPlatforml3p3(index)
	if (skullriderlist[index].state == STATE_Egg) then 
		if (l3p3state ~= PLATFORM_Fall) then
			skullriderlist[index].LeftSpeed, skullriderlist[index].RightSpeed, skullriderlist[index].RiseSpeed, skullriderlist[index].FallSpeed, skullriderlist[index].nextx, skullriderlist[index].nexty, skullriderlist[index].nextstate, skullriderlist[index].currentplatformleft, skullriderlist[index].currentplatformright = CheckRunIntoPlatform(skullriderlist[index].x, skullriderlist[index].y, skullriderlist[index].nextx, skullriderlist[index].nexty, l3p3left + SKULL_OFFSETleft, l3p3right + SKULL_OFFSETright, l3p3top + SKULL_OFFSETtop, l3p3bottom, skullriderlist[index].LeftSpeed, skullriderlist[index].RightSpeed, skullriderlist[index].RiseSpeed, skullriderlist[index].FallSpeed, skullriderlist[index].nextstate, skullriderlist[index].currentplatformleft, skullriderlist[index].currentplatformright);
		end
	else
		skullriderlist[index].LeftSpeed, skullriderlist[index].RightSpeed, skullriderlist[index].RiseSpeed, skullriderlist[index].FallSpeed, skullriderlist[index].nextx, skullriderlist[index].nexty, skullriderlist[index].nextstate, skullriderlist[index].currentplatformleft, skullriderlist[index].currentplatformright = CheckRunIntoPlatform(skullriderlist[index].x, skullriderlist[index].y, skullriderlist[index].nextx, skullriderlist[index].nexty, l3p3left, l3p3right, l3p3top, l3p3bottom, skullriderlist[index].LeftSpeed, skullriderlist[index].RightSpeed, skullriderlist[index].RiseSpeed, skullriderlist[index].FallSpeed, skullriderlist[index].nextstate, skullriderlist[index].currentplatformleft, skullriderlist[index].currentplatformright);
	end
end
-----


function CheckRunIntoPlatformsp1()

	Checkp1RunIntoPlatforml1p1();
	--Checkp1RunIntoPlatforml1p2();
	--Checkp1RunIntoPlatforml1p3();
	if (l2p1state ~= PLATFORM_Fall) then
		Checkp1RunIntoPlatforml2p1();
	end
	if (l2p2state ~= PLATFORM_Fall) then
		Checkp1RunIntoPlatforml2p2();
	end
	if (l3p1state ~= PLATFORM_Fall) then
		Checkp1RunIntoPlatforml3p1();
	end
	if (l3p2state ~= PLATFORM_Fall) then
		Checkp1RunIntoPlatforml3p2();
	end
	if (l3p3state ~= PLATFORM_Fall) then
		Checkp1RunIntoPlatforml3p3();
	end
	--Log("here3.2 p1state="..p1state.." p1nextstate="..p1nextstate);

end

function CheckRunIntoPlatformsSkullRider(index)
	
	CheckSkullRiderRunIntoPlatforml1p1(index);
	if (l2p1state ~= PLATFORM_Fall) then
		CheckSkullRiderRunIntoPlatforml2p1(index);
	end
	if (l2p2state ~= PLATFORM_Fall) then
		CheckSkullRiderRunIntoPlatforml2p2(index);
	end
	if (l3p1state ~= PLATFORM_Fall) then
		CheckSkullRiderRunIntoPlatforml3p1(index);
	end
	if (l3p2state ~= PLATFORM_Fall) then
		CheckSkullRiderRunIntoPlatforml3p2(index);
	end
	if (l3p3state ~= PLATFORM_Fall) then
		CheckSkullRiderRunIntoPlatforml3p3(index);
	end
end

function CheckFallOffPlatform(left, right, x, y, RiseSpeed, FallSpeed, nextstate)
	if (x > right or x < left) then
		RiseSpeed = 0;
		FallSpeed = 0;
		nextstate = STATE_Fly;
	end
	return RiseSpeed, FallSpeed, nextstate;
end

function CheckFallOffp1()
	-- skullriders do not fall off platforms because they don't run.  only idle and fly.
	p1RiseSpeed, p1FallSpeed, p1nextstate = 
	CheckFallOffPlatform(p1currentplatformleft, p1currentplatformright, 
			     p1nextx, p1nexty, 
			     p1RiseSpeed, p1FallSpeed, p1nextstate);
end



function CheckRunIntoGameEdges()

	if (p1nexty > Floor) then
		PlaySoundOnce(string.format("MiniGames/SkullRiders/death_by_boneyard.wav"));
		p1nexty = Floor;
		p1nextstate = STATE_Death;
        end
	if (p1nexty < Ceiling) then
		p1nexty = Ceiling;
	end
	if (p1nextx < LeftWall) then
		p1nextx = RightWall - (LeftWall - p1nextx);
                -- reset these in case we're walking on the small platforms and wrapping around
   		if (l3p3state ~= PLATFORM_Fall) then
			p1currentplatformleft = l3p3left;
			p1currentplatformright = l3p3right;
		end
	end
	if (p1nextx > RightWall) then
		p1nextx = LeftWall + (p1nextx - RightWall);
		-- reset these in case we're walking on the small platforms and wrapping around
		if (l3p1state ~= PLATFORM_Fall) then
			p1currentplatformleft = l3p1left;
			p1currentplatformright = l3p1right;
		end
	end

	for index = 0, (numSkullRiders - 1) do 

		if (skullriderlist[index].state == STATE_Egg) then
			if (skullriderlist[index].nexty > Floor + SKULL_FLOOR_OFFSET) then
				skullriderlist[index].state = STATE_Invisible;
				skullriderlist[index].nextstate = STATE_Invisible;
			end
		elseif (skullriderlist[index].nexty > Floor) then
			skullriderlist[index].nexty = Floor;
		end

		if (skullriderlist[index].nexty < skullriderlist[index].ceiling) then
			skullriderlist[index].nexty = skullriderlist[index].ceiling;
		end


		if (skullriderlist[index].state >= STATE_Egg and skullriderlist[index].state <= STATE_HatchWait) then
			if (skullriderlist[index].nextx < (LeftWall + SKULL_OFFSET_LEFT_WALL)) then
				skullriderlist[index].nextx = RightWall + SKULL_OFFSET_RIGHT_WALL;
			elseif (skullriderlist[index].nextx > (RightWall + SKULL_OFFSET_RIGHT_WALL)) then
				skullriderlist[index].nextx = LeftWall + SKULL_OFFSET_LEFT_WALL;
			end
		elseif (skullriderlist[index].state == STATE_Hatch) then
		elseif (skullriderlist[index].state == STATE_WraithIdle) then
			if (skullriderlist[index].nextx < LeftWall) then
				skullriderlist[index].nextx = LeftWall;
			elseif (skullriderlist[index].nextx > RightWall) then
				skullriderlist[index].nextx = RightWall;
			end
		elseif (skullriderlist[index].nextx < LeftWall) then
			skullriderlist[index].nextx = RightWall - (LeftWall - skullriderlist[index].nextx);
		elseif (skullriderlist[index].nextx > RightWall) then
			skullriderlist[index].nextx = LeftWall + (skullriderlist[index].nextx - RightWall);
		end
	end


	if (fbleft == 1 and fbx < -48) then
	   killEffect(fbeffect);
      fbeffect = nil;
		fbleft = 0;
	end
	if (fbright == 1 and fbx > 598) then
		killEffect(fbeffect);
      fbeffect = nil;
		fbright = 0;
	end

	if (sr1left == 1 and sr1x < -48) then
		sr1left = 0;
	end
	if (sr1right == 1 and sr1x > 598) then
		sr1right = 0;
	end

	if (sr2left == 1 and sr2x < -48) then
		sr2left = 0;
	end
	if (sr2right == 1 and sr2x > 598) then
		sr2right = 0;
	end

end

function p1Down()

end

function p1Fly()
	p1RiseSpeed = 9;
	p1FallSpeed = 0;

	p1nextstate = STATE_Fly;
end

function SkullRiderFly(RiseSpeed, FallSpeed)
	RiseSpeed = 7;
	FallSpeed = 0;

	return RiseSpeed, FallSpeed;
end

function skullriderfly(index)
	skullriderlist[index].RiseSpeed, skullriderlist[index].FallSpeed = SkullRiderFly(skullriderlist[index].RiseSpeed, skullriderlist[index].FallSpeed);
	skullriderlist[index].nextstate = STATE_Fly;
end
function skullriderGoUp(index)
	skullriderlist[index].RiseSpeed, skullriderlist[index].FallSpeed = SkullRiderFly(skullriderlist[index].RiseSpeed, skullriderlist[index].FallSpeed);
end


function pGoLeft(x, y, LeftSpeed, RightSpeed, state)


	if (RightSpeed > 0) then
		RightSpeed = 0;
		LeftSpeed = 0;
		if (state == STATE_Run) then
			state = STATE_Stop;
		end
	elseif (RightSpeed <= 0 and LeftSpeed <= 0) then
		RightSpeed = 0;
		if (state == STATE_Idle) then
			state = STATE_Run;
		end
		LeftSpeed = 2;
	elseif (LeftSpeed < 8) then
		LeftSpeed = LeftSpeed + 2;
	end

	return LeftSpeed, RightSpeed, state;

end
function sGoLeft(x, y, LeftSpeed, RightSpeed, state, face)

	if (RightSpeed > 1 ) then
		RightSpeed = RightSpeed - 1;
                face = 1;
	elseif (RightSpeed > 0) then
		RightSpeed = 0;
		LeftSpeed = 0;
		if (state == STATE_Run) then
			state = STATE_Stop;
		end
		face = 0;
	elseif (RightSpeed <= 0 and LeftSpeed <= 0) then
		RightSpeed = 0;
		LeftSpeed = 2;
		face = 0;
	elseif (LeftSpeed < 8) then
		LeftSpeed = LeftSpeed + 2;
		face = 0;
	end

	return LeftSpeed, RightSpeed, state, face;

end

function pGoRight(x, y, LeftSpeed, RightSpeed, state)
	if (LeftSpeed > 0) then
		LeftSpeed = 0;
		RightSpeed = 0;
		if (state == STATE_Run) then
			state = STATE_Stop;
		end
	elseif (LeftSpeed <= 0 and RightSpeed <= 0) then
		Leftspeed = 0;
		if (state == STATE_Idle) then  
			state = STATE_Run;
		end
		RightSpeed = 2;
	elseif (RightSpeed < 8) then
		RightSpeed = RightSpeed + 1;
	end

	return LeftSpeed, RightSpeed, state;
end
function sGoRight(x, y, LeftSpeed, RightSpeed, state, face)
	if (LeftSpeed > 1 ) then
		LeftSpeed = LeftSpeed - 1;
		face = 0;
	elseif (LeftSpeed > 0) then
		LeftSpeed = 0;
		RightSpeed = 0;
		if (state == STATE_Run) then
			state = STATE_Stop;
		end
		face = 1;
	elseif (LeftSpeed <= 0 and RightSpeed <= 0) then
		Leftspeed = 0;
		RightSpeed = 2;
		face = 1;
	elseif (RightSpeed < 8) then
		RightSpeed = RightSpeed + 1;
		face = 1;
	end

	return LeftSpeed, RightSpeed, state, face;
end
function skullriderGoRight(index)
	skullriderlist[index].LeftSpeed, skullriderlist[index].RightSpeed, 
		skullriderlist[index].nextstate, skullriderlist[index].nextface = 
		sGoRight(skullriderlist[index].x, skullriderlist[index].y, 
		skullriderlist[index].LeftSpeed, skullriderlist[index].RightSpeed, 
		skullriderlist[index].state, skullriderlist[index].nextface);
end
function skullriderGoLeft(index)
	skullriderlist[index].LeftSpeed, skullriderlist[index].RightSpeed, 
		skullriderlist[index].nextstate, skullriderlist[index].nextface = 
		sGoLeft(skullriderlist[index].x, skullriderlist[index].y, 
		skullriderlist[index].LeftSpeed, skullriderlist[index].RightSpeed, 
		skullriderlist[index].state, skullriderlist[index].nextface);
end

function p1GoRight()
	p1LeftSpeed, p1RightSpeed, p1nextstate = pGoRight(p1x, p1y, p1LeftSpeed, p1RightSpeed, p1state);
	p1nextface = 1;
end
function p1GoLeft()
	p1LeftSpeed, p1RightSpeed, p1nextstate = pGoLeft(p1x, p1y, p1LeftSpeed, p1RightSpeed, p1state);
	p1nextface = 0;
end
function skullriderGo(direction,index)
	if (direction == 0) then
		skullriderGoLeft(index);
	else
		skullriderGoRight(index);
	end
end


function p1Shoot()
	if (fbleft == 0 and fbright == 0 and 
		(p1state == STATE_Idle or p1state == STATE_Run or p1state == STATE_Fly)) then
		p1nextstate = STATE_Shoot;
		p1shootsave = p1state;

		if (p1nextface == 0) then
			p1leftshoot.GetMaterial().SetCurrentFrame(0)
			p1nextsprite = p1leftshoot;
		else
			p1rightshoot.GetMaterial().SetCurrentFrame(0)
			p1nextsprite = p1rightshoot;
		end
		p1state = p1nextstate;
		Changeimagep1();
		PlaySoundOnce(string.format("MiniGames/SkullRiders/shoot_fireball.wav"));
	end
end

function s1Shoot()
	if (sr1left == 0 and sr1right == 0 and 
		(s1state == STATE_Fly)) then
		s1nextstate = STATE_Shoot;
		s1shootsave = s1state;

		if (s1nextface == 0) then
			s1leftshoot.GetMaterial().SetCurrentFrame(0)
			s1nextsprite = s1leftshoot;
		else
			s1rightshoot.GetMaterial().SetCurrentFrame(0)
			s1nextsprite = s1rightshoot;
		end
		s1state = s1nextstate;
		Changeimages1();
	end
end

function s2Shoot()
	if (sr2left == 0 and sr2right == 0 and 
		(s2state == STATE_Fly)) then
		s2nextstate = STATE_Shoot;
		s2shootsave = s2state;

		if (s2nextface == 0) then
			s2leftshoot.GetMaterial().SetCurrentFrame(0)
			s2nextsprite = s2leftshoot;
		else
			s2rightshoot.GetMaterial().SetCurrentFrame(0)
			s2nextsprite = s2rightshoot;
		end
		s2state = s2nextstate;
		Changeimages2();
	end
end


function SlowDown(LeftSpeed, RightSpeed)

	if (RightSpeed > 0 ) then
		RightSpeed = RightSpeed - (SLOWDOWN_SPEED * time / 1000);
	end
	if (LeftSpeed > 0 ) then
		LeftSpeed = LeftSpeed - (SLOWDOWN_SPEED * time / 1000);
	end

	if (RightSpeed < 0) then
		RightSpeed = 0;
	end
	if (LeftSpeed < 0) then
		LeftSpeed = 0;
	end

	return LeftSpeed, RightSpeed;
end

function ExitIntro()
	Exit();
end

function PlayGame()

	--IntroWindow.ShowWindow( false );
	GameWindow.ShowWindow(true);

	GameState = 1;

end

function Init()	   
   GameState = 0;	-- intro page will turn GameState to 1 when player is ready
   math.randomseed( GetTime() );
   
   -- connect to server
   SendProcessMessage(Messages.Connect, {});   

   numSkullRiders = 0;   
   fbleft = 0;		-- means there is a valid fireball moving left
   fbright = 0;		-- meanst there is a valid fireball moving right
   fbx = 0;
   fby = 0;

   sr1left = 0;
   sr1right = 0;
   sr1x = 0;
   sr1y = 0;

   sr2left = 0;
   sr2right = 0;
   sr2x = 0;
   sr2y = 0;

   upArrowState 	    = ARROWSTATE_Up;
   upArrowNextState    = ARROWSTATE_Up;
   leftArrowState      = ARROWSTATE_Up;
   leftArrowNextState  = ARROWSTATE_Up;
   rightArrowState     = ARROWSTATE_Up;
   rightArrowNextState = ARROWSTATE_Up;
   downArrowState      = ARROWSTATE_Up;
   downArrowNextState  = ARROWSTATE_Up;

   skullriderlist = {};
   skullriderlistl2 = {};
   skullriderlistl3 = {};
   skullriderlistl4 = {};
   
   p1state = STATE_Idle;
   p1nextstate = STATE_Idle;

   p1timeInCorridor = 0;
   p1corridor = 1;
   p1nextcorridor = 1;

   p1gameovertext.SetText("           ".."<string;MinigamesCommon_LEVEL></string> "..1);

   p1score = 0;
   p1health = 5;
   p1gameover = 0;
   p1dragonx = 0;
   p1dragony = 0;

   p1healthsprites[1].ShowWindow(true);
   p1healthsprites[2].ShowWindow(true);
   p1healthsprites[3].ShowWindow(true);
   p1healthsprites[4].ShowWindow(true);
   p1healthsprites[5].ShowWindow(true);

   l1p1sprite.ShowWindow(true);
   
   l1p1xfinal = 224;
   l1p1x = 224;
   l1p1yfinal = 377;
   --l1p1y = 450;
   l1p1y = l1p1yfinal;
   l1p1top = 326;    -- y - 51
   l1p1bottom = 450; -- (bottom screen)
   l1p1right = 332;  -- x + 103  -- i would like to add 5 to this one.  prev 327.  next 332.
   l1p1left = 188;   -- x - 36
   l1p1shake = 4;
   lp1pstate = PLATFORM_Crumble1;

   l1p2sprite.ShowWindow(false);
   
   l1p2x = 35;
   l1p2y = 378;
   l1p2top = 327;
   l1p2bottom = 450;
   l1p2right = 139;  -- x + 104
   l1p2left = -6;     -- x - 41
   l1p2state = PLATFORM_Crumble1;

   l1p3sprite.ShowWindow(false);
   
   l1p3x = 417;
   l1p3y = 378;
   l1p3top = 327;
   l1p3bottom = 450;
   l1p3right = 521;  -- x + 104
   l1p3left = 376;   -- x - 41
   l1p3state = PLATFORM_Crumble1;

   p1currentplatformleft = l1p1left;
   p1currentplatformright = l1p1right;

   
   skullRiderSpawnTimer = 0;
   p1respawntimer = 0;
   upArrowTimer = 0;
   leftArrowTimer = 0;
   rightArrowTimer = 0;
   downArrowTimer = 0;


   p1startx = 256;
   p1starty= 326;

   p1x = 256;
   p1y= 326;

   p1nextx = 0;
   p1nexty = 0;

   p1RiseSpeed = -1;
   p1FallSpeed = -1;

   p1LeftSpeed = 0;
   p1RightSpeed = 0;

   PlayerHeight = 76;


   -- bigplatfrom
   l2p1startx = 24;
   l2p1starty = 238;
   l2p1x = 24;
   l2p1y = 238;
   l2p1top = 184;    -- y - 54
   l2p1bottom = 265; -- y + 27
   l2p1right = 175;  -- x + 151 (was  168)
   l2p1left = -11;     -- x - 35 ( was 60)  
   l2p1state = PLATFORM_Crumble1;
   l2p1crumblestate = 0;

   -- big platform
   l2p2startx = 387;
   l2p2starty = 238;
   l2p2x = 387;
   l2p2y = 238;
   l2p2top = 184;
   l2p2bottom = 265;
   l2p2right = 538;
   l2p2left = 352;  
   l2p2state = PLATFORM_Crumble1;
   l2p2crumblestate = 0;

   -- big platform
   l3p2startx = 196;
   l3p2starty = 86;
   l3p2x = 196;
   l3p2y = 86;
   l3p2top = 32;
   l3p2bottom = 113;
   l3p2right = 347;
   l3p2left = 161;  
   l3p2state = PLATFORM_Crumble1;
   l3p2crumblestate = 0;

   -- small platform
   l3p1startx = -25;
   l3p1starty = 115;
   l3p1x = -25;
   l3p1y = 115;
   l3p1top = 58;     -- y - 57
   l3p1bottom = 128; -- y + 13
   l3p1right = 40;   -- x + 65
   l3p1left = -70;   -- x - 45 
   l3p1state = PLATFORM_Crumble1;
   l3p1crumblestate = 0;

   -- small platform
   l3p3startx = 517;
   l3p3starty = 115;
   l3p3x = 517;
   l3p3y = 115;
   l3p3top = 58;     -- y - 57
   l3p3bottom = 128; -- y + 13
   l3p3right = 582;  -- x + 65
   l3p3left = 472;   -- x - 45
   l3p3state = PLATFORM_Crumble1;
   l3p3crumblestate = 0;

   -- must be set after platform locations are set
   spawnlocations = { [0] = { x = 85,  y = 185, platformleft = l2p1left, platformright = l2p1right, ceiling = -16},
	           [1] = { x = 448, y = 185, platformleft = l2p2left, platformright = l2p2right, ceiling = 135},
		   [2] = { x = 257, y = 33,  platformleft = l3p2left, platformright = l3p2right, ceiling = -16}
		 };

   thisLevelNumSpawnLocs = 0;
   thisLevelSpawnLocs = {};
   thisLevelNumSkullRiders = 0;
   thisLevelSpawnIncrementer = 0;

   --StartSkullRiders = 0;

   UPARROW_holddown = 0;
   LEFTARROW_holddown = 0;
   RIGHTARROW_holddown = 0;


   CurrentTime = 0;
   
   

   if(not ParticleSystem) then
      ParticleSystem = CreateClass( "class ParticleSystem2D" );
      AttachWindow(ParticleSystem, ParticleContainer);
   end

	-- initial bottom platform
	l1p1sprite.SetLocation(l1p1x, l1p1y);
	l1p1sprite.SetStyle( 0x900 ); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;
	l1p1sprite.ShowWindow(true);

	l1p2sprite.SetLocation(l1p2x, l1p2y);
	l1p2sprite.SetStyle( 0x900 ); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;
	l1p2sprite.ShowWindow(false);

	l1p3sprite.SetLocation(l1p3x, l1p3y);
	l1p3sprite.SetStyle( 0x900 ); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;
	l1p3sprite.ShowWindow(false);

	InitLevel(LEVEL1);

	-- p1 fly (before bone pit)

	p1leftfly.GetMaterial().SetRate(8);
	p1leftfly.SetStyle( 0x900 ); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;
	
	p1rightfly.GetMaterial().SetRate(8);
	p1rightfly.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;

	-- p1 run idle and stop (after all platforms including l1p1)

	p1leftrun.GetMaterial().SetRate(8);
	p1leftrun.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;

	p1leftidle.GetMaterial().SetRate(8);
	p1leftidle.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;

	p1leftstop.GetMaterial().SetRate(0);
	p1leftstop.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;

	p1leftshoot.GetMaterial().SetRate(0);
	p1leftshoot.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;

	p1leftdeath.GetMaterial().SetRate(0);
	p1leftdeath.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;

	p1rightrun.GetMaterial().SetRate(8);
	p1rightrun.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;

	p1rightidle.GetMaterial().SetRate(8);
	p1rightidle.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;

	p1rightstop.GetMaterial().SetRate(0);
	p1rightstop.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;

	p1rightshoot.GetMaterial().SetRate(0);
	p1rightshoot.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;

	p1rightdeath.GetMaterial().SetRate(0);
	p1rightdeath.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;

	p1leftdragonfly.GetMaterial().SetRate(8);
	p1leftdragonfly.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;

	p1rightdragonfly.GetMaterial().SetRate(8);
	p1rightdragonfly.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;
    
	p1sprite = p1leftidle;
	p1nextsprite = p1leftidle;
	p1face = 0;
	p1nextface = 0;
	p1state = STATE_Idle;
	p1nextstate = STATE_Idle;
	p1sprite.SetLocation(p1x, p1y);
	p1sprite.ShowWindow(true);
	-- why no p1RiseSpeed = -1?
   
	bonepit.SetLocation(3, 411);
	bonepit.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;
	bonepit.ShowWindow(true);


	   -- fireball    
	leftfbsprite.GetMaterial().SetRate(8);
	leftfbsprite.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;

	rightfbsprite.GetMaterial().SetRate(8);
	rightfbsprite.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;

	leftsr1sprite.GetMaterial().SetRate(8);
	leftsr1sprite.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;

	rightsr1sprite.GetMaterial().SetRate(8);
	rightsr1sprite.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;

	leftsr2sprite.GetMaterial().SetRate(8);
	leftsr2sprite.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;

	rightsr2sprite.GetMaterial().SetRate(8);
	rightsr2sprite.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;

	p1text.SetLocation(108,557);
	p1text.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;


	p1gameovertext.SetLocation(314, 250);
	p1gameovertext.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;

	p1level = 1; 
	p1levelindicator.SetLocation(630, 565);
	p1levelindicator.SetStyle(0x900);
   p1levelindicator.SetText("<string;MinigamesCommon_LEVEL></string> "..p1level);

	p1gameoverscore.SetLocation(350,270);
	p1gameoverscore.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;

	p1gameoverlevel.SetLocation(342,290);
	p1gameoverlevel.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;

	p1exittext.SetLocation(314,310);
	p1exittext.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;

	p1score = 0;
	p1scoredisplay.SetLocation(160,557);
	p1scoredisplay.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;
	p1scoredisplay.SetText(string.format("%i",p1score));

   --exitbutton.SetButtonMaterial( CreateTileMaterialClass( "CreateCharacter/Button_Exit2.dds", 1, 2 ) );
	--exitbutton.SetColor( "FFFFFFFF" );
	--exitbutton.SetStyle("EFFECT_SCALE|HAS_NO_BORDER");
	--exitbutton.SetLocation(733,544);x

	PlaySoundOnce(string.format("MiniGames/SkullRiders/game_start.wav"));

   GameTimer = Timer();
   GameTimer:Reset();
end


function UpdateTime(elapsedTime)

	for index = 0, (numSkullRiders - 1) do 
		if (skullriderlist[index].state == STATE_WraithIdle) then
			if (skullriderlist[index].face == 0) then
				skullriderlist[index].vultureflyright.ShowWindow(true);
			else
				skullriderlist[index].vultureflyleft.ShowWindow(true);
			end
		end

		if (skullriderlist[index].state >= STATE_Death2 and skullriderlist[index].state <= STATE_Death6) then
			skullriderlist[index].sprite.GetMaterial().SetCurrentFrame(skullriderlist[index].sprite.GetMaterial().GetCurrentFrame() + 1);
		end
		if (skullriderlist[index].state >= STATE_Hatch2 and skullriderlist[index].state <= STATE_Hatch10) then
			skullriderlist[index].sprite.GetMaterial().SetCurrentFrame(skullriderlist[index].sprite.GetMaterial().GetCurrentFrame() + 1);
		end
		if (skullriderlist[index].state == STATE_Egg) then
			-- rotate the egg
         if(skullriderlist[index].sprite) then
            if (skullriderlist[index].face == 0) then
               skullriderlist[index].sprite.SetRotation(skullriderlist[index].sprite.GetRotation() - SKULL_ROTATE);
            else
               skullriderlist[index].sprite.SetRotation(skullriderlist[index].sprite.GetRotation() + SKULL_ROTATE);
            end
         end
		end
		if (skullriderlist[index].state == STATE_HatchWait) then
			-- upright the egg
			if (skullriderlist[index].face == 0) then
				if (skullriderlist[index].sprite.GetRotation() % 360 ~= -0 and skullriderlist[index].sprite.GetRotation() % 360 ~= 0) then
					skullriderlist[index].sprite.SetRotation(skullriderlist[index].sprite.GetRotation() - SKULL_ROTATE);
				end
			else
				if (skullriderlist[index].sprite.GetRotation() % 360 ~= 0) then
					skullriderlist[index].sprite.SetRotation(skullriderlist[index].sprite.GetRotation() + SKULL_ROTATE);
				end
			end
		end
	end


	if (p1state == STATE_Stop2) then
		p1sprite.GetMaterial().SetCurrentFrame(1);
	end
	

	if (p1state == STATE_Shoot2) then
		p1sprite.GetMaterial().SetCurrentFrame(1);
	end
	if (p1state == STATE_Shoot3) then
		p1sprite.GetMaterial().SetCurrentFrame(2);
		if (p1face == 0) then
			leftfbsprite.ShowWindow(true);			
			fbleft = 1;
		else
			rightfbsprite.ShowWindow(true);
			fbright = 1;
		end
      fbeffect = spawnEmbersEffect();
	end


	if (p1state >= STATE_Death2 and p1state <= STATE_Death4) then
		p1sprite.GetMaterial().SetCurrentFrame(p1sprite.GetMaterial().GetCurrentFrame() + 1);
	end


	if (l2p1state == PLATFORM_Crumble1) then
		l2p1sprite.GetMaterial().SetCurrentFrame(0);
		l2p1sprite.ShowWindow(true);
	elseif (l2p1state == PLATFORM_Crumble2) then
		l2p1sprite.GetMaterial().SetCurrentFrame(1);
	elseif (l2p1state == PLATFORM_Crumble3) then
		l2p1sprite.GetMaterial().SetCurrentFrame(2);
	end

	if (l2p1crumblestate == 0) then
		l2p1crumble.ShowWindow(false);
	elseif (l2p1crumblestate == 1) then
		l2p1crumble.GetMaterial().SetCurrentFrame(0);
		l2p1crumble.ShowWindow(true);
		l2p1crumblestate = 2;
	elseif (l2p1crumblestate == 2) then
		l2p1crumble.GetMaterial().SetCurrentFrame(1);
		l2p1crumblestate = 3;
	elseif (l2p1crumblestate == 3) then
		l2p1crumble.GetMaterial().SetCurrentFrame(2);
		l2p1crumblestate = 4;
	elseif (l2p1crumblestate == 4) then
		l2p1crumble.GetMaterial().SetCurrentFrame(3);
		l2p1crumblestate = 5;
	elseif (l2p1crumblestate == 5) then
		l2p1crumble.GetMaterial().SetCurrentFrame(4);
		l2p1crumblestate = 0;
	end


	if (l2p2state == PLATFORM_Crumble1) then
		l2p2sprite.GetMaterial().SetCurrentFrame(0);
		l2p2sprite.ShowWindow(true);
	elseif (l2p2state == PLATFORM_Crumble2) then
		l2p2sprite.GetMaterial().SetCurrentFrame(1);
	elseif (l2p2state == PLATFORM_Crumble3) then
		l2p2sprite.GetMaterial().SetCurrentFrame(2);
	end

	if (l2p2crumblestate == 0) then
		l2p2crumble.ShowWindow(false);
	elseif (l2p2crumblestate == 1) then
		l2p2crumble.GetMaterial().SetCurrentFrame(0);
		l2p2crumble.ShowWindow(true);
		l2p2crumblestate = 2;
	elseif (l2p2crumblestate == 2) then
		l2p2crumble.GetMaterial().SetCurrentFrame(1);
		l2p2crumblestate = 3;
	elseif (l2p2crumblestate == 3) then
		l2p2crumble.GetMaterial().SetCurrentFrame(2);
		l2p2crumblestate = 4;
	elseif (l2p2crumblestate == 4) then
		l2p2crumble.GetMaterial().SetCurrentFrame(3);
		l2p2crumblestate = 5;
	elseif (l2p2crumblestate == 5) then
		l2p2crumble.GetMaterial().SetCurrentFrame(4);
		l2p2crumblestate = 0;
	end

	if (l3p1state == PLATFORM_Crumble1) then
		l3p1sprite.GetMaterial().SetCurrentFrame(0);
		l3p1sprite.ShowWindow(true);
	elseif (l3p1state == PLATFORM_Crumble2) then
		l3p1sprite.GetMaterial().SetCurrentFrame(1);
	elseif (l3p1state == PLATFORM_Crumble3) then
		l3p1sprite.GetMaterial().SetCurrentFrame(2);
	end

	if (l3p1crumblestate == 0) then
		l3p1crumble.ShowWindow(false);
	elseif (l3p1crumblestate == 1) then
		l3p1crumble.GetMaterial().SetCurrentFrame(0);
		l3p1crumble.ShowWindow(true);
		l3p1crumblestate = 2;
	elseif (l3p1crumblestate == 2) then
		l3p1crumble.GetMaterial().SetCurrentFrame(1);
		l3p1crumblestate = 3;
	elseif (l3p1crumblestate == 3) then
		l3p1crumble.GetMaterial().SetCurrentFrame(2);
		l3p1crumblestate = 4;
	elseif (l3p1crumblestate == 4) then
		l3p1crumble.GetMaterial().SetCurrentFrame(3);
		l3p1crumblestate = 5;
	elseif (l3p1crumblestate == 5) then
		l3p1crumble.GetMaterial().SetCurrentFrame(4);
		l3p1crumblestate = 0;
	end


	if (l3p2state == PLATFORM_Crumble1) then
		l3p2sprite.GetMaterial().SetCurrentFrame(0);
		l3p2sprite.ShowWindow(true);
	elseif (l3p2state == PLATFORM_Crumble2) then
		l3p2sprite.GetMaterial().SetCurrentFrame(1);
	elseif (l3p2state == PLATFORM_Crumble3) then
		l3p2sprite.GetMaterial().SetCurrentFrame(2);
	end

	if (l3p2crumblestate == 0) then
		l3p2crumble.ShowWindow(false);
	elseif (l3p2crumblestate == 1) then
		l3p2crumble.GetMaterial().SetCurrentFrame(0);
		l3p2crumble.ShowWindow(true);
		l3p2crumblestate = 2;
	elseif (l3p2crumblestate == 2) then
		l3p2crumble.GetMaterial().SetCurrentFrame(1);
		l3p2crumblestate = 3;
	elseif (l3p2crumblestate == 3) then
		l3p2crumble.GetMaterial().SetCurrentFrame(2);
		l3p2crumblestate = 4;
	elseif (l3p2crumblestate == 4) then
		l3p2crumble.GetMaterial().SetCurrentFrame(3);
		l3p2crumblestate = 5;
	elseif (l3p2crumblestate == 5) then
		l3p2crumble.GetMaterial().SetCurrentFrame(4);
		l3p2crumblestate = 0;
	end

	if (l3p3state == PLATFORM_Crumble1) then
		l3p3sprite.GetMaterial().SetCurrentFrame(0);
		l3p3sprite.ShowWindow(true);
	elseif (l3p3state == PLATFORM_Crumble2) then
		l3p3sprite.GetMaterial().SetCurrentFrame(1);
	elseif (l3p3state == PLATFORM_Crumble3) then
		l3p3sprite.GetMaterial().SetCurrentFrame(2);
	end

	if (l3p3crumblestate == 0) then
		l3p3crumble.ShowWindow(false);
	elseif (l3p3crumblestate == 1) then
		l3p3crumble.GetMaterial().SetCurrentFrame(0);
		l3p3crumble.ShowWindow(true);
		l3p3crumblestate = 2;
	elseif (l3p3crumblestate == 2) then
		l3p3crumble.GetMaterial().SetCurrentFrame(1);
		l3p3crumblestate = 3;
	elseif (l3p3crumblestate == 3) then
		l3p3crumble.GetMaterial().SetCurrentFrame(2);
		l3p3crumblestate = 4;
	elseif (l3p3crumblestate == 4) then
		l3p3crumble.GetMaterial().SetCurrentFrame(3);
		l3p3crumblestate = 5;
	elseif (l3p3crumblestate == 5) then
		l3p3crumble.GetMaterial().SetCurrentFrame(4);
		l3p3crumblestate = 0;
	end
end


function Exit()
    UnfreezePlayer();
	Log("SkullRiders score="..p1score);
	Kill( GetProcessID());
end

function MoveSkullRiders(index)

		localrank = skullriderlist[index].rank;

		if ((skullriderlist[index].state == STATE_Fly or skullriderlist[index].state == STATE_Idle) and (CurrentTime > skullriderlist[index].waitfly)) then
			--if (localrank < BLACK) then
				skullriderfly(index);
			--elseif (p1y <= skullriderlist[index].y) then
			--	skullriderfly(index);
			--end

			if (skullriderlist[index].destinationCeiling > skullriderlist[index].ceiling) then
				if (skullriderlist[index].y < skullriderlist[index].destinationCeiling) then
					skullriderlist[index].waitfly = CurrentTime + (0.1 * math.random(12,16));
				else
					skullriderlist[index].ceiling = skullriderlist[index].destinationCeiling;
					skullriderlist[index].waitfly = CurrentTime + (0.1 * math.random(6,8));
				end
			else
				skullriderlist[index].waitfly = CurrentTime + (0.1 * math.random(6,8));
			end
			



			--if (localrank < BLACK) then
			--	skullriderlist[index].waitfly = CurrentTime + (0.1 * math.random(6,8));
			--elseif (p1y > skullriderlist[index].y) then
			--	skullriderlist[index].waitfly = CurrentTime + (0.1 * math.random(12,16));
			--else
			--	skullriderlist[index].waitfly = CurrentTime + (0.1 * math.random(6,8));
			--end
		end


		if ((skullriderlist[index].state == STATE_Fly) and (CurrentTime > skullriderlist[index].wait)) then


			if (localrank == BLUE) then
				times = math.random(1,1);
			elseif (localrank == GREEN) then
				times = math.random(2,2);
			elseif (localrank == BLACK) then
				times = math.random(2,3);
			elseif (localrank == RED) then
				times = math.random(2,3);
			end

			local direction = 0;
			if (localrank == BLUE) then
				direction = skullriderlist[index].face;
			elseif (localrank == RED) then
				if (p1x <= skullriderlist[index].x) then
					direction = 0; -- face left
				else
					direction = 1;
				end
			else
				direction = math.random(0,1);
			end




				if (times == 1) then	
					skullriderGo(direction,index);
				elseif (times == 2) then
					skullriderGo(direction,index);
					skullriderGo(direction,index);
				elseif (times == 3) then
					skullriderGo(direction,index);
					skullriderGo(direction,index);
					skullriderGo(direction,index);
				elseif (times == 4) then
					skullriderGo(direction,index);
					skullriderGo(direction,index);
					skullriderGo(direction,index);
					skullriderGo(direction,index);
				end
			skullriderlist[index].wait = CurrentTime + math.random(0,2);
		end
      
      local state = skullriderlist[index].state;
      if(skullriderlist[index].effect) then         
         if(state < STATE_Death or state > STATE_Hatch10) then
            local x = math.floor(skullriderlist[index].x+38);
            local y = math.floor(skullriderlist[index].y + 20);            
            local effectPos = MakePointString(x, y);           
            local x, y = GetPointFromString(InnerWindow.WindowToScreen(effectPos));
            skullriderlist[index].effect.SetEmitterPosition(x, y);              
          else
            killEffect(skullriderlist[index].effect);
            skullriderlist[index].effect = nil;
          end
      elseif((localrank == RED) and (state < STATE_Death or state > STATE_Hatch10)) then
         skullriderlist[index].effect = spawnSparkEffect();
      end
end



function InitLevel(level)

   for index = 0, (numSkullRiders -1) do
      DestroySkullRiderSprites(index);
      skullriderlist[index] = {};
   end

   if(level == LEVEL1) then
      l2p1sprite.SetLocation(l2p1x,l2p1y);
      l2p1crumble.SetLocation(l2p1x + CRUMBLEX,l2p1y + CRUMBLEY);
      l2p2sprite.SetLocation(l2p2x,l2p2y);
      l2p2crumble.SetLocation(l2p2x + CRUMBLEX,l2p2y + CRUMBLEY);
      l3p2sprite.SetLocation(l3p2x,l3p2y);
      l3p2crumble.SetLocation(l3p2x + CRUMBLEX,l3p2y + CRUMBLEY);
      l3p1sprite.SetLocation(l3p1x,l3p1y);
      l3p1crumble.SetLocation(l3p1x + CRUMBLEXSMALL,l3p1y + CRUMBLEYSMALL);
      l3p3sprite.SetLocation(l3p3x,l3p3y);
      l3p3crumble.SetLocation(l3p3x + CRUMBLEXSMALL,l3p3y + CRUMBLEYSMALL);
   else
      l2p1crumble.ShowWindow(false);
      l2p2crumble.ShowWindow(false);
      l3p1crumble.ShowWindow(false);
      l3p2crumble.ShowWindow(false);
      l3p3crumble.ShowWindow(false);

      RespawnAllPlatformsForLevel(level);
   end

      for index = 0, (numSkullRiders -1) do
         skullriderlist[index].vultureState = VSTATE_DontRun;
      end

	-- can't make this a loop because TOPMIDDLE does not equal 2.
	thisLevelNumSpawnLocs = 0;
        if (LevelConfigs[PLATFORMS][level][BOTTOMLEFT] == 1) then

	      thisLevelSpawnLocs[thisLevelNumSpawnLocs] = 0;
	      thisLevelNumSpawnLocs = thisLevelNumSpawnLocs + 1;

	end
	if (LevelConfigs[PLATFORMS][level][BOTTOMRIGHT] == 1) then

	      thisLevelSpawnLocs[thisLevelNumSpawnLocs] = 1;
	      thisLevelNumSpawnLocs = thisLevelNumSpawnLocs + 1;

	end
	if (LevelConfigs[PLATFORMS][level][TOPMIDDLE] == 1) then

	      thisLevelSpawnLocs[thisLevelNumSpawnLocs] = 2;
	      thisLevelNumSpawnLocs = thisLevelNumSpawnLocs + 1;

	end


	thisLevelNumSkullRiders = LevelConfigs[BADGUYS][level][NUMBADGUYS];

--	Log("SkullRiders ---- InitLevel="..level);
--	Log("SkullRiders ---- numSkullRiders="..numSkullRiders);
--	Log("SkullRiders ---- thisLevelNumSkullRiders="..thisLevelNumSkullRiders);

	index = 0;
	thisLevelSpawnIncrementer = 0;
	numSkullRiders = 0;
	
	if ((l2p1state ~= PLATFORM_Respawn)
	and (l2p2state ~= PLATFORM_Respawn)
	and (l3p1state ~= PLATFORM_Respawn)
	and (l3p2state ~= PLATFORM_Respawn)
	and (l3p3state ~= PLATFORM_Respawn)
	) then

	   numSkullRiders = thisLevelNumSpawnLocs;

	   for badguys = 1, numSkullRiders do 

		-- index, color, spawnNum
		CreateSkullRider(index, LevelConfigs[BADGUYS][level][badguys], thisLevelSpawnLocs[thisLevelSpawnIncrementer]);
		index = index + 1;

		if (thisLevelSpawnIncrementer == (thisLevelNumSpawnLocs - 1)) then
			thisLevelSpawnIncrementer = 0;
		else
			thisLevelSpawnIncrementer = thisLevelSpawnIncrementer + 1;
		end

		skullRiderSpawnTimer = 0; 

	   end

	   for index = 0, (numSkullRiders - 1) do 
		skullriderlist[index].sprite.ShowWindow(true);
	   end
   end
end

function RespawnAllPlatformsForLevel(level)

      if (level > FINALLEVEL) then
         level = FINALLEVEL;
      end

      if (l2p1state == PLATFORM_Fall and LevelConfigs[PLATFORMS][level][BOTTOMLEFT] == 1) then
         l2p1state = PLATFORM_Respawn;
         l2p1y = -100;
         l2p1sprite.GetMaterial().SetCurrentFrame(0);
         l2p1sprite.SetLocation(l2p1x, l2p1y);
         l2p1crumblestate = 0;

      elseif (l2p1state ~= PLATFORM_Fall and LevelConfigs[PLATFORMS][level][BOTTOMLEFT] == 0) then
         l2p1state = PLATFORM_Fall;
      end
      if (l2p2state == PLATFORM_Fall and LevelConfigs[PLATFORMS][level][BOTTOMRIGHT] == 1) then
         l2p2state = PLATFORM_Respawn;
         l2p2y = -100;
         l2p2sprite.GetMaterial().SetCurrentFrame(0);
         l2p2sprite.SetLocation(l2p2x, l2p2y);
         l2p2crumblestate = 0;

      elseif (l2p2state ~= PLATFORM_Fall and LevelConfigs[PLATFORMS][level][BOTTOMRIGHT] == 0) then
         l2p2state = PLATFORM_Fall;
      end
      if (l3p1state == PLATFORM_Fall and LevelConfigs[PLATFORMS][level][TOPLEFT] == 1) then
         l3p1state = PLATFORM_Respawn;
         l3p1y = -100;
         l3p1sprite.GetMaterial().SetCurrentFrame(0);
         l3p1sprite.SetLocation(l3p1x, l3p1y);
         l3p1crumblestate = 0;

      elseif (l3p1state ~= PLATFORM_Fall and LevelConfigs[PLATFORMS][level][TOPLEFT] == 0) then
         l3p1state = PLATFORM_Fall;
      end
      if (l3p2state == PLATFORM_Fall and LevelConfigs[PLATFORMS][level][TOPMIDDLE] == 1) then
         l3p2state = PLATFORM_Respawn;
         l3p2y = -100;
         l3p2sprite.GetMaterial().SetCurrentFrame(0);
         l3p2sprite.SetLocation(l3p2x, l3p2y);
         l3p2crumblestate = 0;

      elseif (l3p2state ~= PLATFORM_Fall and LevelConfigs[PLATFORMS][level][TOPMIDDLE] == 0) then
         l3p2state = PLATFORM_Fall;
      end
      if (l3p3state == PLATFORM_Fall and LevelConfigs[PLATFORMS][level][TOPRIGHT] == 1) then
         l3p3state = PLATFORM_Respawn;
         l3p3y = -100;
         l3p3sprite.GetMaterial().SetCurrentFrame(0);
         l3p3sprite.SetLocation(l3p3x, l3p3y);
         l3p3crumblestate = 0;

      elseif (l3p3state ~= PLATFORM_Fall and LevelConfigs[PLATFORMS][level][TOPRIGHT] == 0) then
         l3p3state = PLATFORM_Fall;
      end
      
end


function IncreaseRank(index)

   color = skullriderlist[index].rank + 1;   
   
   local leftfly = CreateSpriteClass(CreateTileMaterialClass(Filenames[color][LEFTFLY], 3, 1),MakeRectString(0,0,76,76),false,InnerWindow);   
   leftfly.GetMaterial().SetRate(8);
   leftfly.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;

   local rightfly = CreateSpriteClass(CreateTileMaterialClass(Filenames[color][RIGHTFLY], 3, 1),MakeRectString(0,0,76,76),false,InnerWindow);
   rightfly.GetMaterial().SetRate(8);
   rightfly.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;
   
   local leftdeath = CreateSpriteClass(CreateTileMaterialClass(Filenames[color][LEFTDEATH], 3, 2),MakeRectString(0,0,76,76),false,InnerWindow);
   leftdeath.GetMaterial().SetRate(0);
   leftdeath.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;
   
   local rightdeath = CreateSpriteClass(CreateTileMaterialClass(Filenames[color][RIGHTDEATH], 3, 2),MakeRectString(0,0,76,76),false,InnerWindow);
   rightdeath.GetMaterial().SetRate(0);
   rightdeath.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;

   local leftidle = CreateSpriteClass(CreateTileMaterialClass(Filenames[color][LEFTIDLE], 3, 1),MakeRectString(0,0,76,76),false,InnerWindow);
   leftidle.GetMaterial().SetRate(8);
   leftidle.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;

   local rightidle = CreateSpriteClass(CreateTileMaterialClass(Filenames[color][RIGHTIDLE], 3, 1),MakeRectString(0,0,76,76),false,InnerWindow);
   rightidle.GetMaterial().SetRate(8);
   rightidle.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;

   local hatch = CreateSpriteClass(CreateTileMaterialClass(Filenames[color][HATCH], 4, 3),MakeRectString(0,0,76,76),false,InnerWindow);
   hatch.GetMaterial().SetRate(0);
   hatch.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;

   local wraithidle = CreateSpriteClass(CreateTileMaterialClass(Filenames[color][WRAITHIDLE], 2, 1),MakeRectString(0,0,76,76),false,InnerWindow);
   wraithidle.GetMaterial().SetRate(8);
   wraithidle.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;

   local leftshoot = CreateSpriteClass(CreateTileMaterialClass(Filenames[color][LEFTSHOOT], 3, 1),MakeRectString(0,0,76,76),false,InnerWindow);
   leftshoot.GetMaterial().SetRate(0);
   leftshoot.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;

   local rightshoot = CreateSpriteClass(CreateTileMaterialClass(Filenames[color][RIGHTSHOOT], 3, 1),MakeRectString(0,0,76,76),false,InnerWindow);
   rightshoot.GetMaterial().SetRate(0);
   rightshoot.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;

   skullriderlist[index].rank = color;
   DestroySpriteClass(skullriderlist[index].leftfly);
   skullriderlist[index].leftfly = leftfly;
   DestroySpriteClass(skullriderlist[index].rightfly);
   skullriderlist[index].rightfly = rightfly;
   DestroySpriteClass(skullriderlist[index].leftidle);
   skullriderlist[index].leftidle = leftidle;
   DestroySpriteClass(skullriderlist[index].rightidle);
   skullriderlist[index].rightidle = rightidle;
   DestroySpriteClass(skullriderlist[index].leftdeath);
   skullriderlist[index].leftdeath = leftdeath;
   DestroySpriteClass(skullriderlist[index].rightdeath);
   skullriderlist[index].rightdeath = rightdeath;
   DestroySpriteClass(skullriderlist[index].leftshoot);
   skullriderlist[index].leftshoot = leftshoot;
   DestroySpriteClass(skullriderlist[index].rightshoot);
   skullriderlist[index].rightshoot = rightshoot;
   DestroySpriteClass(skullriderlist[index].hatch);
   skullriderlist[index].hatch = hatch;
   DestroySpriteClass(skullriderlist[index].wraithidle);
   skullriderlist[index].wraithidle = wraithidle;
end

function CreateSkullRider(index, color, spawnNum)

   Log("Creating Skull Rider #"..index);
--	Log("SkullRiders ---- CreateSkullRider ---- index="..index);
--	Log("SkullRiders ---- CreateSkullRider ---- color="..color);
--	Log("SkullRiders ---- CreateSkullRider ---- spawnNum="..spawnNum);

      local leftfly = CreateSpriteClass(CreateTileMaterialClass(Filenames[color][LEFTFLY], 3, 1),MakeRectString(0,0,76,76),false,InnerWindow);
		leftfly.GetMaterial().SetRate(8);
		leftfly.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;

      local rightfly = CreateSpriteClass(CreateTileMaterialClass(Filenames[color][RIGHTFLY], 3, 1),MakeRectString(0,0,76,76),false,InnerWindow);
		rightfly.GetMaterial().SetRate(8);
		rightfly.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;

      local leftdeath = CreateSpriteClass(CreateTileMaterialClass(Filenames[color][LEFTDEATH], 3, 2),MakeRectString(0,0,76,76),false,InnerWindow);
		leftdeath.GetMaterial().SetRate(0);
		leftdeath.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;

      local rightdeath = CreateSpriteClass(CreateTileMaterialClass(Filenames[color][RIGHTDEATH], 3, 2),MakeRectString(0,0,76,76),false,InnerWindow);
		rightdeath.GetMaterial().SetRate(0);
		rightdeath.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;

      local leftidle = CreateSpriteClass(CreateTileMaterialClass(Filenames[color][LEFTIDLE], 3, 1),MakeRectString(0,0,76,76),false,InnerWindow);
		leftidle.GetMaterial().SetRate(8);
		leftidle.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;

      local rightidle = CreateSpriteClass(CreateTileMaterialClass(Filenames[color][RIGHTIDLE], 3, 1),MakeRectString(0,0,76,76),false,InnerWindow);
		rightidle.GetMaterial().SetRate(8);
		rightidle.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;

      local hatch = CreateSpriteClass(CreateTileMaterialClass(Filenames[color][HATCH], 4, 3),MakeRectString(0,0,76,76),false,InnerWindow);
		hatch.GetMaterial().SetRate(0);
		hatch.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;

      local skull = CreateSpriteClass(Filenames[color][SKULL],MakeRectString(0,0,26,26),false,InnerWindow);
		skull.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;

      local wraithidle = CreateSpriteClass(CreateTileMaterialClass(Filenames[color][WRAITHIDLE], 2, 1),MakeRectString(0,0,76,76),false,InnerWindow);
		wraithidle.GetMaterial().SetRate(8);
		wraithidle.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;

      local vultureflyleft = CreateSpriteClass(CreateTileMaterialClass("SkullRiders/Vulture_Fly_Left.dds", 3, 1),MakeRectString(0,0,76,76),false,InnerWindow);
		vultureflyleft.GetMaterial().SetRate(8);
		vultureflyleft.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;

      local vultureflyright = CreateSpriteClass(CreateTileMaterialClass("SkullRiders/Vulture_Fly_Right.dds", 3, 1),MakeRectString(0,0,76,76),false,InnerWindow);
		vultureflyright.GetMaterial().SetRate(8);
		vultureflyright.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;

      local vultureidleleft = CreateSpriteClass(CreateTileMaterialClass("SkullRiders/Vulture_Idle_Left.dds", 3, 1),MakeRectString(0,0,76,76),false,InnerWindow);
		vultureidleleft.GetMaterial().SetRate(8);
		vultureidleleft.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;

      local vultureidleright = CreateSpriteClass(CreateTileMaterialClass("SkullRiders/Vulture_Idle_Right.dds", 3, 1),MakeRectString(0,0,76,76),false,InnerWindow);
		vultureidleright.GetMaterial().SetRate(8);
		vultureidleright.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;

      local vulturerunleft = CreateSpriteClass(CreateTileMaterialClass("SkullRiders/Vulture_Run_Left.dds", 2, 2),MakeRectString(0,0,76,76),false,InnerWindow);
		vulturerunleft.GetMaterial().SetRate(8);
		vulturerunleft.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;

      local vulturerunright = CreateSpriteClass(CreateTileMaterialClass("SkullRiders/Vulture_Run_Right.dds", 2, 2),MakeRectString(0,0,76,76),false,InnerWindow);
		vulturerunright.GetMaterial().SetRate(8);
		vulturerunright.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;

      local leftshoot = CreateSpriteClass(CreateTileMaterialClass(Filenames[color][LEFTSHOOT], 3, 1),MakeRectString(0,0,76,76),false,InnerWindow);
		leftshoot.GetMaterial().SetRate(0);
		leftshoot.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;

		local rightshoot = CreateSpriteClass(CreateTileMaterialClass(Filenames[color][RIGHTSHOOT], 3, 1),MakeRectString(0,0,76,76),false,InnerWindow);
		rightshoot.GetMaterial().SetRate(0);
		rightshoot.SetStyle(0x900); -- HAS_NO_BORDER | PASS_ON_MOUSE_CLICKS | PASS_ON_MOUSE_MOVES ;

      --DestroySkullRiderSprites(index);
      skullriderlist[index] = {};      
		skullriderlist[index].rank = color;
      
		skullriderlist[index].leftfly = leftfly;
		skullriderlist[index].rightfly = rightfly;
		skullriderlist[index].leftidle = leftidle;
		skullriderlist[index].rightidle = rightidle;
		skullriderlist[index].leftdeath = leftdeath;
		skullriderlist[index].rightdeath = rightdeath;
		skullriderlist[index].leftshoot = leftshoot;
		skullriderlist[index].rightshoot = rightshoot;
		skullriderlist[index].hatch = hatch;
		skullriderlist[index].skull = skull;
		skullriderlist[index].wraithidle = wraithidle;
		skullriderlist[index].vultureflyleft = vultureflyleft;
		skullriderlist[index].vultureflyright = vultureflyright;
		skullriderlist[index].vultureidleleft = vultureidleleft;
		skullriderlist[index].vultureidleright = vultureidleright;
		skullriderlist[index].vulturerunleft = vulturerunleft;
		skullriderlist[index].vulturerunright = vulturerunright;

		skullriderlist[index].state = STATE_Idle;
		skullriderlist[index].nextstate = STATE_Idle;
		skullriderlist[index].vultureState = VSTATE_DontRun;
		skullriderlist[index].RiseSpeed = -1;
		skullriderlist[index].FallSpeed = -1;
		skullriderlist[index].LeftSpeed = 0;
		skullriderlist[index].RightSpeed = 0;
		skullriderlist[index].shootsave =nil;
		skullriderlist[index].wait = 0;
		skullriderlist[index].waitfly = 0;
		skullriderlist[index].hatchtimer = 0;
		skullriderlist[index].vulturex = 0;
		skullriderlist[index].vulturey = 0;

		skullriderlist[index].startx = spawnlocations[spawnNum].x;
		skullriderlist[index].starty = spawnlocations[spawnNum].y;
		skullriderlist[index].x = spawnlocations[spawnNum].x;
		skullriderlist[index].y = spawnlocations[spawnNum].y;
		skullriderlist[index].nextx = spawnlocations[spawnNum].x;
		skullriderlist[index].nexty = spawnlocations[spawnNum].y;

		skullriderlist[index].currentplatformleft = spawnlocations[spawnNum].platformleft;
		skullriderlist[index].currentplatformright = spawnlocations[spawnNum].platformright;

		faceDirection = math.random(0,1);
		skullriderlist[index].face = faceDirection;
		skullriderlist[index].nextface = faceDirection;

		-- if the skull rider to spawn is on the middle level,
		if ((spawnNum == 0) or (spawnNum == 1)) then
			-- some will have a ceiling lower so they're confined to the middle area.
			-- i'm just reusing the faceDirection because it was random.
			skullriderlist[index].ceiling = spawnlocations[faceDirection].ceiling;
			skullriderlist[index].destinationCeiling = spawnlocations[faceDirection].ceiling;
		else
			skullriderlist[index].ceiling = spawnlocations[spawnNum].ceiling;
			skullriderlist[index].destinationCeiling = spawnlocations[spawnNum].ceiling;
		end


		if (faceDirection == 0) then -- left face
			skullriderlist[index].sprite = leftidle;
			skullriderlist[index].nextsprite = leftidle;
		else
			skullriderlist[index].sprite = rightidle;
			skullriderlist[index].nextsprite = rightidle;
		end

		skullriderlist[index].sprite.SetLocation(skullriderlist[index].startx,skullriderlist[index].starty);
end

function DestroySkullRiderSprites(a_index)
   if(skullriderlist[a_index]) then
      Log("Destroying Skull Rider #"..a_index);
      DestroySpriteClass(skullriderlist[a_index].leftfly);
      DestroySpriteClass(skullriderlist[a_index].rightfly);
      DestroySpriteClass(skullriderlist[a_index].leftidle);
      DestroySpriteClass(skullriderlist[a_index].rightidle);
      DestroySpriteClass(skullriderlist[a_index].leftdeath);
      DestroySpriteClass(skullriderlist[a_index].rightdeath);
      DestroySpriteClass(skullriderlist[a_index].leftshoot);
      DestroySpriteClass(skullriderlist[a_index].rightshoot);
      DestroySpriteClass(skullriderlist[a_index].hatch);
      DestroySpriteClass(skullriderlist[a_index].skull);
      DestroySpriteClass(skullriderlist[a_index].wraithidle);
      DestroySpriteClass(skullriderlist[a_index].vultureflyleft);
      DestroySpriteClass(skullriderlist[a_index].vultureflyright);
      DestroySpriteClass(skullriderlist[a_index].vultureidleleft);
      DestroySpriteClass(skullriderlist[a_index].vultureidleright);
      DestroySpriteClass(skullriderlist[a_index].vulturerunleft);
      DestroySpriteClass(skullriderlist[a_index].vulturerunright);
   end
end

function GameOver()
   -- Shut down any running particle effects
   if(fbeffect) then
      killEffect(fbeffect);
      fbeffect = nil;
   end
   for index = 0, (numSkullRiders - 1) do 
      killEffect(skullriderlist[index].effect);
      skullriderlist[index].effect = nil;
   end
   
   -- remove the skullriders sprites
   for index = 0, (numSkullRiders -1) do
      DestroySkullRiderSprites(index);
      skullriderlist[index] = {};
   end
   
   -- hide the platforms
   --l1p1sprite.ShowWindow(false);
   l1p2sprite.ShowWindow(false);
   l1p3sprite.ShowWindow(false);  
   
   DebugEndCriticalSection();
	p1sprite.ShowWindow(false);
	leftfbsprite.ShowWindow(false); 
   	rightfbsprite.ShowWindow(false);
   
	--p1gameovertext.SetText("Game Over, Good Try!");
	--p1gameoverscore.SetText("    Level "..p1level);
	--p1gameoverlevel.SetText("    Score "..p1score);
	--p1exittext.SetText(" Click the Exit Button!");

	rewardInfo = {};
	rewardInfo.gameName = Script_Name;
	rewardInfo.score = p1score;
	--rewardInfo.score = 500;

	--Log("send process message rewards");

   -- Hide the GUI while the MG Interface is up   
   GameWindow.ShowWindow( false );
   if(DoPostGameInterface(Script_Name, rewardInfo) == false) then
      Exit();
   end
   GameWindow.ShowWindow( true );

   Log("Restart the minigame");
   
   DebugBeginCriticalSection();
	Init();	
	PlayGame();
   DebugEndCriticalSection();   
end


function spawnEmbersEffect()
   if(ParticleSystem) then
      local effect = CreateClass("class ParticleEmitter2D");
      effect.SetEmitterLife(-1);
      effect.SetParticleRate(19, 11);
      effect.SetParticleStartColor(255, 0, 0, 255);
      effect.SetParticleEndColor(255, 255, 0, 100);
      effect.SetParticleLife(1.0, 0.5);
      effect.SetEmitterInitialParticleCount(1);
      effect.SetParticleDispersionRadius(15);
      effect.SetParticleStartSize(3, 2);
      effect.SetParticleEndSize(2, 1);
      effect.SetParticleBlendingType(1);
      effect.SetParticleMaterialName("GUI/Particles/point.dds");
      effect.SetParticleGravity(0.0, 0.5);
      effect.SetEmitterPosition(0, 0);     
      local winWidth = InnerWindow.GetWindowWidth();
      local winHeight = InnerWindow.GetWindowHeight();
      local clipUL = InnerWindow.WindowToScreen("0,0");
      local clipLR = InnerWindow.WindowToScreen(MakePointString(winWidth,winHeight));
      effect.SetEmitterClipFrame(clipUL..","..clipLR);
      ParticleSystem.AttachEmitter(effect);
      return effect;
   end
   Log("No particle system");
   return nil;
end

function spawnSparkEffect()
   if(ParticleSystem) then
      local effect = CreateClass("class ParticleEmitter2D");
      effect.SetEmitterLife(-1);
      effect.SetParticleRate(7.0, 3.0);
      effect.SetParticleStartColor(255, 0, 0, 255);
      effect.SetParticleEndColor(255, 255, 0, 100);
      effect.SetParticleLife(0.30, 0.25);
      effect.SetEmitterInitialParticleCount(1);
      effect.SetParticleStartSize(2, 1);
      effect.SetParticleEndSize(1, 1);
      effect.SetParticleBlendingType(1);
      effect.SetParticleMaterialName("GUI/Particles/point.dds");
      effect.SetParticleGravity(0.0, 5);
      effect.SetParticleSpeed(2.0, 1.5);
      effect.SetParticleDirection(0.0, 90.0);
      effect.SetEmitterPosition(0, 0);     
      local winWidth = InnerWindow.GetWindowWidth();
      local winHeight = InnerWindow.GetWindowHeight();
      local clipUL = InnerWindow.WindowToScreen("0,0");
      local clipLR = InnerWindow.WindowToScreen(MakePointString(winWidth,winHeight));
      effect.SetEmitterClipFrame(clipUL..","..clipLR);
      ParticleSystem.AttachEmitter(effect);
      return effect;
   end
   Log("No particle system");
   return nil;
end

function killEffect(a_effect)
   if(a_effect) then
      a_effect.SetEmitterLife(0);
      DestroyClass(a_effect);
      a_effect = nil;
   end
end

function enemyDeathEffect(a_x, a_y)
   if(ParticleSystem) then 
      local emitter = CreateClass("class ParticleEmitter2D")
      emitter.SetParticleRate(20.0, 5.0)
      emitter.SetParticleStartColor(255, 255, 255, 100)
      emitter.SetParticleEndColor(255, 255, 255, 0)
      emitter.SetParticleLife(2.0, 0.75)
      emitter.SetEmitterInitialParticleCount(1)
      emitter.SetParticleDispersionRadius(25)
      emitter.SetParticleStartSize(20, 10)
      emitter.SetParticleEndSize(45, 15)
      emitter.SetParticleBlendingType(1)
      emitter.SetParticleMaterialName("GUI/Particles/cloud.dds")       
      emitter.SetParticleDirection(0.0, 120.0)      
      emitter.SetParticleGravity(0.0, -0.25)
      emitter.SetParticleSpeed(0.35, 0.15)
      emitter.SetEmitterLife(8)
      emitter.SetEmitterPosition(a_x, a_y)
      ParticleSystem.AttachEmitter(emitter)
   end
   Log("No particle system");
   return nil;
end

function addCaption(a_banner, a_x, a_y)
   if(a_banner.GetAnimationCount() == 0) then    

      local captionWidth = 20;
      local captionHeight = 20;
      local captionTime = 1.0; -- in seconds      
      local riseAmount = 50;
      
      RiseAnim.SetTargetLocation(a_x, a_y - riseAmount);
      RiseAnim.SetTime(captionTime);           
      GrowAnim.SetSize(captionWidth*5, captionHeight*5);
      GrowAnim.SetTime(captionTime);
      FadeAnim.SetCycleTime(captionTime);
      FadeAnim.SetCycle(false);
      CaptionAnim.AddAnimation(GrowAnim);
      CaptionAnim.AddAnimation(RiseAnim);
      CaptionAnim.AddAnimation(FadeAnim);
      
      a_banner.SetWindow("0,0,"..captionWidth..","..captionHeight);
      a_banner.SetLocation(a_x + BannerOffset.x, a_y + BannerOffset.y);
      a_banner.SetAlpha(1.0, false);
      a_banner.ShowWindow(true);
      a_banner.PushAnimation(CaptionAnim);
   end
end

function DestroySpriteClass(a_sprite)
   if(a_sprite) then
      a_sprite.DetachSelf();
      DestroyClass(a_sprite);
      a_sprite = nil;
   end
end
