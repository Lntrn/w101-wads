-- Constants file for SkullRiders

STATE_Invisible = 0;
STATE_Idle 	= 1;
STATE_Run	= 2;
STATE_Stop	= 3;
STATE_Stop2     = 4;
STATE_Fly	= 5;
STATE_Shoot	= 6;
STATE_Shoot2	= 7;
STATE_Shoot3	= 8;
STATE_Death	= 9;
STATE_Death2    = 10;
STATE_Death3    = 11;
STATE_Death4    = 12;
STATE_Death5    = 13; -- for player, this means the dragon/pig flies back to spawning point.
STATE_Death6    = 14; -- death 5 means go to center (change in x).  death 6 means drop down (change in y). 
STATE_Egg	= 15;
STATE_HatchWait	= 16;
STATE_Hatch	= 17;
STATE_Hatch2	= 18;
STATE_Hatch3	= 19;
STATE_Hatch4	= 20;
STATE_Hatch5	= 21;
STATE_Hatch6	= 22;
STATE_Hatch7	= 23;
STATE_Hatch8	= 24;
STATE_Hatch9	= 25;
STATE_Hatch10	= 26;
STATE_WraithIdle = 27;
STATE_JustVulture = 28;
STATE_Mount	= 29;
STATE_BonePit   = 30;
STATE_BonePit2  = 31;
STATE_BonePit3	= 32;

VSTATE_DontRun  = 0;
VSTATE_Run	= 1;

PLATFORM_Invisible = 0;
PLATFORM_Crumble1  = 1;
PLATFORM_Crumble2  = 2;
PLATFORM_Crumble3  = 3;
PLATFORM_Fall	   = 4;
PLATFORM_Respawn   = 5;

ARROWSTATE_Up	   = 0;
ARROWSTATE_Down    = 1;

Floor = 376;  -- was 363.  lowered floor to 430.
LeftWall = -37
RightWall = 562;
Ceiling = -16;

ChangeThisSkullRiderCorridor = 0;

CORRIDOR1 = 270;
CORRIDOR2 = 135;
CORRIDOR3 = -16;
TIME_IN_CORRIDOR = 5;

CORRIDOR_HEIGHTS = {};
CORRIDOR_HEIGHTS[1] = CORRIDOR1;
CORRIDOR_HEIGHTS[2] = CORRIDOR2;
CORRIDOR_HEIGHTS[3] = CORRIDOR3;

-- constants
NOPLATFORM_left = LeftWall;
NOPLATFORM_right = RightWall;
HATCH_TIME = 15;
RESPAWN_TIME = 10;
SKULLRIDER_SPAWNDELAY = 30;
SKULLRIDER_SPAWNCHANGERATE = 20;
SKULL_OFFSETtop = 40;
SKULL_OFFSETleft = 32;
SKULL_OFFSETright = 16;
SKULL_X_INIT = 24;
SKULL_Y_INIT = 24;
SKULL_HATCH_CORRECT = 16;
SKULL_ROTATE = 45;
VULTURE_DIST = 17;
COLLISION_LEFT = 44;
COLLISION_RIGHT = 30;
COLLISION_TOP = 26;
COLLISION_BOTTOM = 36;
SKULL_COLLISION_LEFT = 57;
SKULL_COLLISION_RIGHT = 5;
SKULL_COLLISION_TOP = 40;
SKULL_COLLISION_BOTTOM = 2;
PLATFORM_FALLRATE = 10;
POINTS_EGG = 20;
POINTS_WRAITH = 30;
POINTS_SHOOT = 10;
DRAGON_MOVE = 15;
CRUMBLEX = 47;
CRUMBLEY = 29;
CRUMBLEXSMALL = 0;
CRUMBLEYSMALL = 28;
PLAYER_FALLRATE = 5; -- per second
PLAYER_RISESLOWRATE = 30; -- per second
SKULLRIDER_FALLRATE = 4;
SKULLRIDER_RISESLOWRATE = 20;
SLOWDOWN_SPEED = 2;
VULTURE_SPEED = 50;
FIREBALLSPEED = 200;
LRARROW_TIME = 0.5;
UPARROW_TIME = 0.5; -- every so much time if the key is depressed, fire off another event
DNARROW_TIME = 0.5;
HATCH_RATE = 1;
ONESHOTANIMS_RATE = 1;
SKULL_ON_PLATFORM_DIST = 16;
SKULL_FLOOR_OFFSET = 39;
BLUE  = 0;
GREEN = 1;
BLACK = 2;
RED   = 3;
BADGUYS = 0;
PLATFORMS = 1;
BOTTOMLEFT  = 0;
BOTTOMRIGHT = 1;
TOPLEFT     = 2;
TOPMIDDLE   = 3;
TOPRIGHT    = 4;
NUMBADGUYS = 0;
LEVEL1 = 0;
LEVEL2 = 1;
LEVEL3 = 2;
LEVEL4 = 3;
LEVEL5 = 4;
LEVEL6 = 5;
LEVEL7 = 6;
LEVEL8 = 7;
LEVEL9 = 8;
LEVEL10 = 9;
LEVEL11 = 10;
LEVEL12 = 11;
LEVEL13 = 12;
LEVEL14 = 13;
LEVEL15 = 14;
LEVEL16 = 15;
LEVEL17 = 16;
LEVEL18 = 17;
LEVEL19 = 18;
LEVEL20 = 19;
LEVEL21 = 20;
LEVEL22 = 21;
LEVEL23 = 22;
LEVEL24 = 23;
LEVEL25 = 24;
LEVEL26 = 25;

FINALLEVEL = LEVEL26;

LEFTFLY    = 0;
RIGHTFLY   = 1;
LEFTDEATH  = 2;
RIGHTDEATH = 3;
LEFTIDLE   = 4;
RIGHTIDLE  = 5;
LEFTSHOOT  = 6;
RIGHTSHOOT = 7;
HATCH      = 8;
SKULL      = 9;
WRAITHIDLE = 10;

spawn1x = 256;
spawn1y = 326;
spawn2x = 85;
spawn2y = 186;
spawn3x = 448;
spawn3y = 186;


SKULL_OFFSET_LEFT_WALL = 20; -- was 16
SKULL_OFFSET_RIGHT_WALL = 25;  -- was 34
SEESKULL_LEFT = 0;
SEESKULL_RIGHT = 576;


LevelConfigs = {};
LevelConfigs[BADGUYS] = {};
LevelConfigs[PLATFORMS] = {};
-- 10 levels
LevelConfigs[BADGUYS][LEVEL1] = {};
LevelConfigs[BADGUYS][LEVEL2] = {};
LevelConfigs[BADGUYS][LEVEL3] = {};
LevelConfigs[BADGUYS][LEVEL4] = {};
LevelConfigs[BADGUYS][LEVEL5] = {};
LevelConfigs[BADGUYS][LEVEL6] = {};
LevelConfigs[BADGUYS][LEVEL7] = {};
LevelConfigs[BADGUYS][LEVEL8] = {};
LevelConfigs[BADGUYS][LEVEL9] = {};
LevelConfigs[BADGUYS][LEVEL10] = {};
LevelConfigs[BADGUYS][LEVEL11] = {};
LevelConfigs[BADGUYS][LEVEL12] = {};
LevelConfigs[BADGUYS][LEVEL13] = {};
LevelConfigs[BADGUYS][LEVEL14] = {};
LevelConfigs[BADGUYS][LEVEL15] = {};
LevelConfigs[BADGUYS][LEVEL16] = {};
LevelConfigs[BADGUYS][LEVEL17] = {};
LevelConfigs[BADGUYS][LEVEL18] = {};
LevelConfigs[BADGUYS][LEVEL19] = {};
LevelConfigs[BADGUYS][LEVEL20] = {};
LevelConfigs[BADGUYS][LEVEL21] = {};
LevelConfigs[BADGUYS][LEVEL22] = {};
LevelConfigs[BADGUYS][LEVEL23] = {};
LevelConfigs[BADGUYS][LEVEL24] = {};
LevelConfigs[BADGUYS][LEVEL25] = {};
LevelConfigs[BADGUYS][LEVEL26] = {};
-- 10 levels
LevelConfigs[PLATFORMS][LEVEL1] = {};
LevelConfigs[PLATFORMS][LEVEL2] = {};
LevelConfigs[PLATFORMS][LEVEL3] = {};
LevelConfigs[PLATFORMS][LEVEL4] = {};
LevelConfigs[PLATFORMS][LEVEL5] = {};
LevelConfigs[PLATFORMS][LEVEL6] = {};
LevelConfigs[PLATFORMS][LEVEL7] = {};
LevelConfigs[PLATFORMS][LEVEL8] = {};
LevelConfigs[PLATFORMS][LEVEL9] = {};
LevelConfigs[PLATFORMS][LEVEL10] = {};
LevelConfigs[PLATFORMS][LEVEL11] = {};
LevelConfigs[PLATFORMS][LEVEL12] = {};
LevelConfigs[PLATFORMS][LEVEL13] = {};
LevelConfigs[PLATFORMS][LEVEL14] = {};
LevelConfigs[PLATFORMS][LEVEL15] = {};
LevelConfigs[PLATFORMS][LEVEL16] = {};
LevelConfigs[PLATFORMS][LEVEL17] = {};
LevelConfigs[PLATFORMS][LEVEL18] = {};
LevelConfigs[PLATFORMS][LEVEL19] = {};
LevelConfigs[PLATFORMS][LEVEL20] = {};
LevelConfigs[PLATFORMS][LEVEL21] = {};
LevelConfigs[PLATFORMS][LEVEL22] = {};
LevelConfigs[PLATFORMS][LEVEL23] = {};
LevelConfigs[PLATFORMS][LEVEL24] = {};
LevelConfigs[PLATFORMS][LEVEL25] = {};
LevelConfigs[PLATFORMS][LEVEL26] = {};

LevelConfigs[BADGUYS][LEVEL1][NUMBADGUYS] = 3;
LevelConfigs[BADGUYS][LEVEL1][1] = BLUE;
LevelConfigs[BADGUYS][LEVEL1][2] = BLUE;
LevelConfigs[BADGUYS][LEVEL1][3] = BLUE;

LevelConfigs[BADGUYS][LEVEL2][NUMBADGUYS] = 4;
LevelConfigs[BADGUYS][LEVEL2][1] = BLUE;
LevelConfigs[BADGUYS][LEVEL2][2] = BLUE;
LevelConfigs[BADGUYS][LEVEL2][3] = BLUE;
LevelConfigs[BADGUYS][LEVEL2][4] = GREEN;

LevelConfigs[BADGUYS][LEVEL3][NUMBADGUYS] = 5;
LevelConfigs[BADGUYS][LEVEL3][1] = BLUE;
LevelConfigs[BADGUYS][LEVEL3][2] = BLUE;
LevelConfigs[BADGUYS][LEVEL3][3] = BLUE;
LevelConfigs[BADGUYS][LEVEL3][4] = GREEN;
LevelConfigs[BADGUYS][LEVEL3][5] = GREEN;

LevelConfigs[BADGUYS][LEVEL4][NUMBADGUYS] = 5;
LevelConfigs[BADGUYS][LEVEL4][1] = BLUE;
LevelConfigs[BADGUYS][LEVEL4][2] = GREEN;
LevelConfigs[BADGUYS][LEVEL4][3] = GREEN;
LevelConfigs[BADGUYS][LEVEL4][4] = GREEN;
LevelConfigs[BADGUYS][LEVEL4][5] = BLACK;

LevelConfigs[BADGUYS][LEVEL5][NUMBADGUYS] = 6;
LevelConfigs[BADGUYS][LEVEL5][1] = BLUE;
LevelConfigs[BADGUYS][LEVEL5][2] = GREEN;
LevelConfigs[BADGUYS][LEVEL5][3] = GREEN;
LevelConfigs[BADGUYS][LEVEL5][4] = GREEN;
LevelConfigs[BADGUYS][LEVEL5][5] = BLACK;
LevelConfigs[BADGUYS][LEVEL5][6] = BLACK;

LevelConfigs[BADGUYS][LEVEL6][NUMBADGUYS] = 8;
LevelConfigs[BADGUYS][LEVEL6][1] = BLUE;
LevelConfigs[BADGUYS][LEVEL6][2] = BLUE;
LevelConfigs[BADGUYS][LEVEL6][3] = GREEN;
LevelConfigs[BADGUYS][LEVEL6][4] = GREEN;
LevelConfigs[BADGUYS][LEVEL6][5] = GREEN;
LevelConfigs[BADGUYS][LEVEL6][6] = BLACK;
LevelConfigs[BADGUYS][LEVEL6][7] = BLACK;
LevelConfigs[BADGUYS][LEVEL6][8] = BLACK;

LevelConfigs[BADGUYS][LEVEL7][NUMBADGUYS] = 8;
LevelConfigs[BADGUYS][LEVEL7][1] = BLUE;
LevelConfigs[BADGUYS][LEVEL7][2] = GREEN;
LevelConfigs[BADGUYS][LEVEL7][3] = GREEN;
LevelConfigs[BADGUYS][LEVEL7][4] = GREEN;
LevelConfigs[BADGUYS][LEVEL7][5] = BLACK;
LevelConfigs[BADGUYS][LEVEL7][6] = BLACK;
LevelConfigs[BADGUYS][LEVEL7][7] = BLACK;
LevelConfigs[BADGUYS][LEVEL7][8] = RED;

LevelConfigs[BADGUYS][LEVEL8][NUMBADGUYS] = 8;
LevelConfigs[BADGUYS][LEVEL8][1] = BLUE;
LevelConfigs[BADGUYS][LEVEL8][2] = GREEN;
LevelConfigs[BADGUYS][LEVEL8][3] = GREEN;
LevelConfigs[BADGUYS][LEVEL8][4] = BLACK;
LevelConfigs[BADGUYS][LEVEL8][5] = BLACK;
LevelConfigs[BADGUYS][LEVEL8][6] = BLACK;
LevelConfigs[BADGUYS][LEVEL8][7] = RED;
LevelConfigs[BADGUYS][LEVEL8][8] = RED;

LevelConfigs[BADGUYS][LEVEL9][NUMBADGUYS] = 8;
LevelConfigs[BADGUYS][LEVEL9][1] = GREEN;
LevelConfigs[BADGUYS][LEVEL9][2] = GREEN;
LevelConfigs[BADGUYS][LEVEL9][3] = BLACK;
LevelConfigs[BADGUYS][LEVEL9][4] = BLACK;
LevelConfigs[BADGUYS][LEVEL9][5] = BLACK;
LevelConfigs[BADGUYS][LEVEL9][6] = RED;
LevelConfigs[BADGUYS][LEVEL9][7] = RED;
LevelConfigs[BADGUYS][LEVEL9][8] = RED;

LevelConfigs[BADGUYS][LEVEL10][NUMBADGUYS] = 10;
LevelConfigs[BADGUYS][LEVEL10][1] = GREEN;
LevelConfigs[BADGUYS][LEVEL10][2] = GREEN;
LevelConfigs[BADGUYS][LEVEL10][3] = BLACK;
LevelConfigs[BADGUYS][LEVEL10][4] = BLACK;
LevelConfigs[BADGUYS][LEVEL10][5] = BLACK;
LevelConfigs[BADGUYS][LEVEL10][6] = BLACK;
LevelConfigs[BADGUYS][LEVEL10][7] = RED;
LevelConfigs[BADGUYS][LEVEL10][8] = RED;
LevelConfigs[BADGUYS][LEVEL10][9] = RED;
LevelConfigs[BADGUYS][LEVEL10][10] = RED;

LevelConfigs[BADGUYS][LEVEL11][NUMBADGUYS] = 10;
LevelConfigs[BADGUYS][LEVEL11][1] = GREEN;
LevelConfigs[BADGUYS][LEVEL11][2] = BLACK;
LevelConfigs[BADGUYS][LEVEL11][3] = BLACK;
LevelConfigs[BADGUYS][LEVEL11][4] = BLACK;
LevelConfigs[BADGUYS][LEVEL11][5] = BLACK;
LevelConfigs[BADGUYS][LEVEL11][6] = BLACK;
LevelConfigs[BADGUYS][LEVEL11][7] = RED;
LevelConfigs[BADGUYS][LEVEL11][8] = RED;
LevelConfigs[BADGUYS][LEVEL11][9] = RED;
LevelConfigs[BADGUYS][LEVEL11][10] = RED;

LevelConfigs[BADGUYS][LEVEL12][NUMBADGUYS] = 10;
LevelConfigs[BADGUYS][LEVEL12][1] = BLACK;
LevelConfigs[BADGUYS][LEVEL12][2] = BLACK;
LevelConfigs[BADGUYS][LEVEL12][3] = BLACK;
LevelConfigs[BADGUYS][LEVEL12][4] = BLACK;
LevelConfigs[BADGUYS][LEVEL12][5] = BLACK;
LevelConfigs[BADGUYS][LEVEL12][6] = BLACK;
LevelConfigs[BADGUYS][LEVEL12][7] = RED;
LevelConfigs[BADGUYS][LEVEL12][8] = RED;
LevelConfigs[BADGUYS][LEVEL12][9] = RED;
LevelConfigs[BADGUYS][LEVEL12][10] = RED;

LevelConfigs[BADGUYS][LEVEL13][NUMBADGUYS] = 10;
LevelConfigs[BADGUYS][LEVEL13][1] = BLACK;
LevelConfigs[BADGUYS][LEVEL13][2] = BLACK;
LevelConfigs[BADGUYS][LEVEL13][3] = BLACK;
LevelConfigs[BADGUYS][LEVEL13][4] = BLACK;
LevelConfigs[BADGUYS][LEVEL13][5] = BLACK;
LevelConfigs[BADGUYS][LEVEL13][6] = RED;
LevelConfigs[BADGUYS][LEVEL13][7] = RED;
LevelConfigs[BADGUYS][LEVEL13][8] = RED;
LevelConfigs[BADGUYS][LEVEL13][9] = RED;
LevelConfigs[BADGUYS][LEVEL13][10] = RED;

LevelConfigs[BADGUYS][LEVEL14][NUMBADGUYS] = 10;
LevelConfigs[BADGUYS][LEVEL14][1] = BLACK;
LevelConfigs[BADGUYS][LEVEL14][2] = BLACK;
LevelConfigs[BADGUYS][LEVEL14][3] = BLACK;
LevelConfigs[BADGUYS][LEVEL14][4] = BLACK;
LevelConfigs[BADGUYS][LEVEL14][5] = RED;
LevelConfigs[BADGUYS][LEVEL14][6] = RED;
LevelConfigs[BADGUYS][LEVEL14][7] = RED;
LevelConfigs[BADGUYS][LEVEL14][8] = RED;
LevelConfigs[BADGUYS][LEVEL14][9] = RED;
LevelConfigs[BADGUYS][LEVEL14][10] = RED;

LevelConfigs[BADGUYS][LEVEL15][NUMBADGUYS] = 10;
LevelConfigs[BADGUYS][LEVEL15][1] = BLACK;
LevelConfigs[BADGUYS][LEVEL15][2] = BLACK;
LevelConfigs[BADGUYS][LEVEL15][3] = BLACK;
LevelConfigs[BADGUYS][LEVEL15][4] = RED;
LevelConfigs[BADGUYS][LEVEL15][5] = RED;
LevelConfigs[BADGUYS][LEVEL15][6] = RED;
LevelConfigs[BADGUYS][LEVEL15][7] = RED;
LevelConfigs[BADGUYS][LEVEL15][8] = RED;
LevelConfigs[BADGUYS][LEVEL15][9] = RED;
LevelConfigs[BADGUYS][LEVEL15][10] = RED;

LevelConfigs[BADGUYS][LEVEL16][NUMBADGUYS] = 10;
LevelConfigs[BADGUYS][LEVEL16][1] = BLACK;
LevelConfigs[BADGUYS][LEVEL16][2] = BLACK;
LevelConfigs[BADGUYS][LEVEL16][3] = RED;
LevelConfigs[BADGUYS][LEVEL16][4] = RED;
LevelConfigs[BADGUYS][LEVEL16][5] = RED;
LevelConfigs[BADGUYS][LEVEL16][6] = RED;
LevelConfigs[BADGUYS][LEVEL16][7] = RED;
LevelConfigs[BADGUYS][LEVEL16][8] = RED;
LevelConfigs[BADGUYS][LEVEL16][9] = RED;
LevelConfigs[BADGUYS][LEVEL16][10] = RED;

LevelConfigs[BADGUYS][LEVEL17][NUMBADGUYS] = 10;
LevelConfigs[BADGUYS][LEVEL17][1] = BLACK;
LevelConfigs[BADGUYS][LEVEL17][2] = RED;
LevelConfigs[BADGUYS][LEVEL17][3] = RED;
LevelConfigs[BADGUYS][LEVEL17][4] = RED;
LevelConfigs[BADGUYS][LEVEL17][5] = RED;
LevelConfigs[BADGUYS][LEVEL17][6] = RED;
LevelConfigs[BADGUYS][LEVEL17][7] = RED;
LevelConfigs[BADGUYS][LEVEL17][8] = RED;
LevelConfigs[BADGUYS][LEVEL17][9] = RED;
LevelConfigs[BADGUYS][LEVEL17][10] = RED;

LevelConfigs[BADGUYS][LEVEL18][NUMBADGUYS] = 10;
LevelConfigs[BADGUYS][LEVEL18][1] = RED;
LevelConfigs[BADGUYS][LEVEL18][2] = RED;
LevelConfigs[BADGUYS][LEVEL18][3] = RED;
LevelConfigs[BADGUYS][LEVEL18][4] = RED;
LevelConfigs[BADGUYS][LEVEL18][5] = RED;
LevelConfigs[BADGUYS][LEVEL18][6] = RED;
LevelConfigs[BADGUYS][LEVEL18][7] = RED;
LevelConfigs[BADGUYS][LEVEL18][8] = RED;
LevelConfigs[BADGUYS][LEVEL18][9] = RED;
LevelConfigs[BADGUYS][LEVEL18][10] = RED;

LevelConfigs[BADGUYS][LEVEL19][NUMBADGUYS] = 10;
LevelConfigs[BADGUYS][LEVEL19][1] = RED;
LevelConfigs[BADGUYS][LEVEL19][2] = RED;
LevelConfigs[BADGUYS][LEVEL19][3] = BLUE;
LevelConfigs[BADGUYS][LEVEL19][4] = RED;
LevelConfigs[BADGUYS][LEVEL19][5] = RED;
LevelConfigs[BADGUYS][LEVEL19][6] = BLUE;
LevelConfigs[BADGUYS][LEVEL19][7] = RED;
LevelConfigs[BADGUYS][LEVEL19][8] = RED;
LevelConfigs[BADGUYS][LEVEL19][9] = BLUE;
LevelConfigs[BADGUYS][LEVEL19][10] = RED;

LevelConfigs[BADGUYS][LEVEL20][NUMBADGUYS] = 10;
LevelConfigs[BADGUYS][LEVEL20][1] = RED;
LevelConfigs[BADGUYS][LEVEL20][2] = RED;
LevelConfigs[BADGUYS][LEVEL20][3] = GREEN;
LevelConfigs[BADGUYS][LEVEL20][4] = RED;
LevelConfigs[BADGUYS][LEVEL20][5] = RED;
LevelConfigs[BADGUYS][LEVEL20][6] = GREEN;
LevelConfigs[BADGUYS][LEVEL20][7] = RED;
LevelConfigs[BADGUYS][LEVEL20][8] = RED;
LevelConfigs[BADGUYS][LEVEL20][9] = BLUE;
LevelConfigs[BADGUYS][LEVEL20][10] = RED;

LevelConfigs[BADGUYS][LEVEL21][NUMBADGUYS] = 10;
LevelConfigs[BADGUYS][LEVEL21][1] = BLUE;
LevelConfigs[BADGUYS][LEVEL21][2] = GREEN;
LevelConfigs[BADGUYS][LEVEL21][3] = RED;
LevelConfigs[BADGUYS][LEVEL21][4] = BLUE;
LevelConfigs[BADGUYS][LEVEL21][5] = GREEN;
LevelConfigs[BADGUYS][LEVEL21][6] = RED;
LevelConfigs[BADGUYS][LEVEL21][7] = BLUE;
LevelConfigs[BADGUYS][LEVEL21][8] = GREEN;
LevelConfigs[BADGUYS][LEVEL21][9] = RED;
LevelConfigs[BADGUYS][LEVEL21][10] = BLACK;

LevelConfigs[BADGUYS][LEVEL22][NUMBADGUYS] = 10;
LevelConfigs[BADGUYS][LEVEL22][1] = BLUE;
LevelConfigs[BADGUYS][LEVEL22][2] = BLACK;
LevelConfigs[BADGUYS][LEVEL22][3] = BLUE;
LevelConfigs[BADGUYS][LEVEL22][4] = BLACK;
LevelConfigs[BADGUYS][LEVEL22][5] = BLUE;
LevelConfigs[BADGUYS][LEVEL22][6] = BLACK;
LevelConfigs[BADGUYS][LEVEL22][7] = BLUE;
LevelConfigs[BADGUYS][LEVEL22][8] = BLACK;
LevelConfigs[BADGUYS][LEVEL22][9] = BLUE;
LevelConfigs[BADGUYS][LEVEL22][10] = BLACK;

LevelConfigs[BADGUYS][LEVEL23][NUMBADGUYS] = 10;
LevelConfigs[BADGUYS][LEVEL23][1] = GREEN;
LevelConfigs[BADGUYS][LEVEL23][2] = RED;
LevelConfigs[BADGUYS][LEVEL23][3] = GREEN;
LevelConfigs[BADGUYS][LEVEL23][4] = RED;
LevelConfigs[BADGUYS][LEVEL23][5] = GREEN;
LevelConfigs[BADGUYS][LEVEL23][6] = RED;
LevelConfigs[BADGUYS][LEVEL23][7] = GREEN;
LevelConfigs[BADGUYS][LEVEL23][8] = RED;
LevelConfigs[BADGUYS][LEVEL23][9] = GREEN;
LevelConfigs[BADGUYS][LEVEL23][10] = RED;

LevelConfigs[BADGUYS][LEVEL24][NUMBADGUYS] = 10;
LevelConfigs[BADGUYS][LEVEL24][1] = RED;
LevelConfigs[BADGUYS][LEVEL24][2] = RED;
LevelConfigs[BADGUYS][LEVEL24][3] = BLACK;
LevelConfigs[BADGUYS][LEVEL24][4] = RED;
LevelConfigs[BADGUYS][LEVEL24][5] = RED;
LevelConfigs[BADGUYS][LEVEL24][6] = GREEN;
LevelConfigs[BADGUYS][LEVEL24][7] = RED;
LevelConfigs[BADGUYS][LEVEL24][8] = RED;
LevelConfigs[BADGUYS][LEVEL24][9] = BLUE;
LevelConfigs[BADGUYS][LEVEL24][10] = RED;

LevelConfigs[BADGUYS][LEVEL25][NUMBADGUYS] = 10;
LevelConfigs[BADGUYS][LEVEL25][1] = RED;
LevelConfigs[BADGUYS][LEVEL25][2] = GREEN;
LevelConfigs[BADGUYS][LEVEL25][3] = BLACK;
LevelConfigs[BADGUYS][LEVEL25][4] = RED;
LevelConfigs[BADGUYS][LEVEL25][5] = BLUE;
LevelConfigs[BADGUYS][LEVEL25][6] = GREEN;
LevelConfigs[BADGUYS][LEVEL25][7] = RED;
LevelConfigs[BADGUYS][LEVEL25][8] = BLACK;
LevelConfigs[BADGUYS][LEVEL25][9] = BLUE;
LevelConfigs[BADGUYS][LEVEL25][10] = BLUE;

LevelConfigs[BADGUYS][LEVEL26][NUMBADGUYS] = 10;
LevelConfigs[BADGUYS][LEVEL26][1] = BLUE;
LevelConfigs[BADGUYS][LEVEL26][2] = GREEN;
LevelConfigs[BADGUYS][LEVEL26][3] = BLACK;
LevelConfigs[BADGUYS][LEVEL26][4] = RED;
LevelConfigs[BADGUYS][LEVEL26][5] = BLACK;
LevelConfigs[BADGUYS][LEVEL26][6] = GREEN;
LevelConfigs[BADGUYS][LEVEL26][7] = BLUE;
LevelConfigs[BADGUYS][LEVEL26][8] = GREEN;
LevelConfigs[BADGUYS][LEVEL26][9] = BLACK;
LevelConfigs[BADGUYS][LEVEL26][10] = RED;

LevelConfigs[PLATFORMS][LEVEL1][BOTTOMLEFT]  = 1;
LevelConfigs[PLATFORMS][LEVEL1][BOTTOMRIGHT] = 1;
LevelConfigs[PLATFORMS][LEVEL1][TOPLEFT]     = 1;
LevelConfigs[PLATFORMS][LEVEL1][TOPMIDDLE]   = 1;
LevelConfigs[PLATFORMS][LEVEL1][TOPRIGHT]    = 1;

LevelConfigs[PLATFORMS][LEVEL2][BOTTOMLEFT]  = 1;
LevelConfigs[PLATFORMS][LEVEL2][BOTTOMRIGHT] = 1;
LevelConfigs[PLATFORMS][LEVEL2][TOPLEFT]     = 1;
LevelConfigs[PLATFORMS][LEVEL2][TOPMIDDLE]   = 1;
LevelConfigs[PLATFORMS][LEVEL2][TOPRIGHT]    = 1;

LevelConfigs[PLATFORMS][LEVEL3][BOTTOMLEFT]  = 1;
LevelConfigs[PLATFORMS][LEVEL3][BOTTOMRIGHT] = 1;
LevelConfigs[PLATFORMS][LEVEL3][TOPLEFT]     = 1;
LevelConfigs[PLATFORMS][LEVEL3][TOPMIDDLE]   = 0;
LevelConfigs[PLATFORMS][LEVEL3][TOPRIGHT]    = 1;

LevelConfigs[PLATFORMS][LEVEL4][BOTTOMLEFT]  = 1;
LevelConfigs[PLATFORMS][LEVEL4][BOTTOMRIGHT] = 1;
LevelConfigs[PLATFORMS][LEVEL4][TOPLEFT]     = 1;
LevelConfigs[PLATFORMS][LEVEL4][TOPMIDDLE]   = 0;
LevelConfigs[PLATFORMS][LEVEL4][TOPRIGHT]    = 1;

LevelConfigs[PLATFORMS][LEVEL5][BOTTOMLEFT]  = 0;
LevelConfigs[PLATFORMS][LEVEL5][BOTTOMRIGHT] = 0;
LevelConfigs[PLATFORMS][LEVEL5][TOPLEFT]     = 1;
LevelConfigs[PLATFORMS][LEVEL5][TOPMIDDLE]   = 1;
LevelConfigs[PLATFORMS][LEVEL5][TOPRIGHT]    = 1;

LevelConfigs[PLATFORMS][LEVEL6][BOTTOMLEFT]  = 0;
LevelConfigs[PLATFORMS][LEVEL6][BOTTOMRIGHT] = 0;
LevelConfigs[PLATFORMS][LEVEL6][TOPLEFT]     = 1;
LevelConfigs[PLATFORMS][LEVEL6][TOPMIDDLE]   = 1;
LevelConfigs[PLATFORMS][LEVEL6][TOPRIGHT]    = 1;

LevelConfigs[PLATFORMS][LEVEL7][BOTTOMLEFT]  = 1;
LevelConfigs[PLATFORMS][LEVEL7][BOTTOMRIGHT] = 1;
LevelConfigs[PLATFORMS][LEVEL7][TOPLEFT]     = 0;
LevelConfigs[PLATFORMS][LEVEL7][TOPMIDDLE]   = 0;
LevelConfigs[PLATFORMS][LEVEL7][TOPRIGHT]    = 0;

LevelConfigs[PLATFORMS][LEVEL8][BOTTOMLEFT]  = 1;
LevelConfigs[PLATFORMS][LEVEL8][BOTTOMRIGHT] = 1;
LevelConfigs[PLATFORMS][LEVEL8][TOPLEFT]     = 0;
LevelConfigs[PLATFORMS][LEVEL8][TOPMIDDLE]   = 0;
LevelConfigs[PLATFORMS][LEVEL8][TOPRIGHT]    = 0;

LevelConfigs[PLATFORMS][LEVEL9][BOTTOMLEFT]  = 0;
LevelConfigs[PLATFORMS][LEVEL9][BOTTOMRIGHT] = 0;
LevelConfigs[PLATFORMS][LEVEL9][TOPLEFT]     = 0;
LevelConfigs[PLATFORMS][LEVEL9][TOPMIDDLE]   = 1;
LevelConfigs[PLATFORMS][LEVEL9][TOPRIGHT]    = 0;

LevelConfigs[PLATFORMS][LEVEL10][BOTTOMLEFT]  = 0;
LevelConfigs[PLATFORMS][LEVEL10][BOTTOMRIGHT] = 0;
LevelConfigs[PLATFORMS][LEVEL10][TOPLEFT]     = 0;
LevelConfigs[PLATFORMS][LEVEL10][TOPMIDDLE]   = 1;
LevelConfigs[PLATFORMS][LEVEL10][TOPRIGHT]    = 0;

LevelConfigs[PLATFORMS][LEVEL11][BOTTOMLEFT]  = 1;
LevelConfigs[PLATFORMS][LEVEL11][BOTTOMRIGHT] = 0;
LevelConfigs[PLATFORMS][LEVEL11][TOPLEFT]     = 1;
LevelConfigs[PLATFORMS][LEVEL11][TOPMIDDLE]   = 1;
LevelConfigs[PLATFORMS][LEVEL11][TOPRIGHT]    = 1;

LevelConfigs[PLATFORMS][LEVEL12][BOTTOMLEFT]  = 1;
LevelConfigs[PLATFORMS][LEVEL12][BOTTOMRIGHT] = 0;
LevelConfigs[PLATFORMS][LEVEL12][TOPLEFT]     = 1;
LevelConfigs[PLATFORMS][LEVEL12][TOPMIDDLE]   = 1;
LevelConfigs[PLATFORMS][LEVEL12][TOPRIGHT]    = 1;

LevelConfigs[PLATFORMS][LEVEL13][BOTTOMLEFT]  = 0;
LevelConfigs[PLATFORMS][LEVEL13][BOTTOMRIGHT] = 1;
LevelConfigs[PLATFORMS][LEVEL13][TOPLEFT]     = 1;
LevelConfigs[PLATFORMS][LEVEL13][TOPMIDDLE]   = 1;
LevelConfigs[PLATFORMS][LEVEL13][TOPRIGHT]    = 1;

LevelConfigs[PLATFORMS][LEVEL14][BOTTOMLEFT]  = 0;
LevelConfigs[PLATFORMS][LEVEL14][BOTTOMRIGHT] = 1;
LevelConfigs[PLATFORMS][LEVEL14][TOPLEFT]     = 1;
LevelConfigs[PLATFORMS][LEVEL14][TOPMIDDLE]   = 1;
LevelConfigs[PLATFORMS][LEVEL14][TOPRIGHT]    = 1;

LevelConfigs[PLATFORMS][LEVEL15][BOTTOMLEFT]  = 1;
LevelConfigs[PLATFORMS][LEVEL15][BOTTOMRIGHT] = 0;
LevelConfigs[PLATFORMS][LEVEL15][TOPLEFT]     = 1;
LevelConfigs[PLATFORMS][LEVEL15][TOPMIDDLE]   = 0;
LevelConfigs[PLATFORMS][LEVEL15][TOPRIGHT]    = 1;

LevelConfigs[PLATFORMS][LEVEL16][BOTTOMLEFT]  = 1;
LevelConfigs[PLATFORMS][LEVEL16][BOTTOMRIGHT] = 0;
LevelConfigs[PLATFORMS][LEVEL16][TOPLEFT]     = 1;
LevelConfigs[PLATFORMS][LEVEL16][TOPMIDDLE]   = 0;
LevelConfigs[PLATFORMS][LEVEL16][TOPRIGHT]    = 1;

LevelConfigs[PLATFORMS][LEVEL17][BOTTOMLEFT]  = 0;
LevelConfigs[PLATFORMS][LEVEL17][BOTTOMRIGHT] = 1;
LevelConfigs[PLATFORMS][LEVEL17][TOPLEFT]     = 1;
LevelConfigs[PLATFORMS][LEVEL17][TOPMIDDLE]   = 0;
LevelConfigs[PLATFORMS][LEVEL17][TOPRIGHT]    = 1;

LevelConfigs[PLATFORMS][LEVEL18][BOTTOMLEFT]  = 0;
LevelConfigs[PLATFORMS][LEVEL18][BOTTOMRIGHT] = 1;
LevelConfigs[PLATFORMS][LEVEL18][TOPLEFT]     = 1;
LevelConfigs[PLATFORMS][LEVEL18][TOPMIDDLE]   = 0;
LevelConfigs[PLATFORMS][LEVEL18][TOPRIGHT]    = 1;

LevelConfigs[PLATFORMS][LEVEL19][BOTTOMLEFT]  = 1;
LevelConfigs[PLATFORMS][LEVEL19][BOTTOMRIGHT] = 0;
LevelConfigs[PLATFORMS][LEVEL19][TOPLEFT]     = 0;
LevelConfigs[PLATFORMS][LEVEL19][TOPMIDDLE]   = 1;
LevelConfigs[PLATFORMS][LEVEL19][TOPRIGHT]    = 0;

LevelConfigs[PLATFORMS][LEVEL20][BOTTOMLEFT]  = 1;
LevelConfigs[PLATFORMS][LEVEL20][BOTTOMRIGHT] = 0;
LevelConfigs[PLATFORMS][LEVEL20][TOPLEFT]     = 0;
LevelConfigs[PLATFORMS][LEVEL20][TOPMIDDLE]   = 1;
LevelConfigs[PLATFORMS][LEVEL20][TOPRIGHT]    = 0;

LevelConfigs[PLATFORMS][LEVEL21][BOTTOMLEFT]  = 0;
LevelConfigs[PLATFORMS][LEVEL21][BOTTOMRIGHT] = 1;
LevelConfigs[PLATFORMS][LEVEL21][TOPLEFT]     = 0;
LevelConfigs[PLATFORMS][LEVEL21][TOPMIDDLE]   = 1;
LevelConfigs[PLATFORMS][LEVEL21][TOPRIGHT]    = 0;

LevelConfigs[PLATFORMS][LEVEL22][BOTTOMLEFT]  = 0;
LevelConfigs[PLATFORMS][LEVEL22][BOTTOMRIGHT] = 1;
LevelConfigs[PLATFORMS][LEVEL22][TOPLEFT]     = 0;
LevelConfigs[PLATFORMS][LEVEL22][TOPMIDDLE]   = 1;
LevelConfigs[PLATFORMS][LEVEL22][TOPRIGHT]    = 0;

LevelConfigs[PLATFORMS][LEVEL23][BOTTOMLEFT]  = 1;
LevelConfigs[PLATFORMS][LEVEL23][BOTTOMRIGHT] = 0;
LevelConfigs[PLATFORMS][LEVEL23][TOPLEFT]     = 0;
LevelConfigs[PLATFORMS][LEVEL23][TOPMIDDLE]   = 0;
LevelConfigs[PLATFORMS][LEVEL23][TOPRIGHT]    = 0;

LevelConfigs[PLATFORMS][LEVEL24][BOTTOMLEFT]  = 1;
LevelConfigs[PLATFORMS][LEVEL24][BOTTOMRIGHT] = 0;
LevelConfigs[PLATFORMS][LEVEL24][TOPLEFT]     = 0;
LevelConfigs[PLATFORMS][LEVEL24][TOPMIDDLE]   = 0;
LevelConfigs[PLATFORMS][LEVEL24][TOPRIGHT]    = 0;

LevelConfigs[PLATFORMS][LEVEL25][BOTTOMLEFT]  = 0;
LevelConfigs[PLATFORMS][LEVEL25][BOTTOMRIGHT] = 1;
LevelConfigs[PLATFORMS][LEVEL25][TOPLEFT]     = 0;
LevelConfigs[PLATFORMS][LEVEL25][TOPMIDDLE]   = 0;
LevelConfigs[PLATFORMS][LEVEL25][TOPRIGHT]    = 0;

LevelConfigs[PLATFORMS][LEVEL26][BOTTOMLEFT]  = 0;
LevelConfigs[PLATFORMS][LEVEL26][BOTTOMRIGHT] = 1;
LevelConfigs[PLATFORMS][LEVEL26][TOPLEFT]     = 0;
LevelConfigs[PLATFORMS][LEVEL26][TOPMIDDLE]   = 0;
LevelConfigs[PLATFORMS][LEVEL26][TOPRIGHT]    = 0;

Filenames = {};
Filenames[BLUE] = {};
Filenames[GREEN] = {};
Filenames[BLACK] = {};
Filenames[RED] = {};

Filenames[BLUE][LEFTFLY] = "SkullRiders/Skull_Rider_Blue_Fly_Left.dds";
Filenames[BLUE][RIGHTFLY] = "SkullRiders/Skull_Rider_Blue_Fly_Right.dds";
Filenames[BLUE][LEFTDEATH] = "SkullRiders/Skull_Rider_Blue_Death_Left.dds";
Filenames[BLUE][RIGHTDEATH] = "SkullRiders/Skull_Rider_Blue_Death_Right.dds";
Filenames[BLUE][LEFTIDLE] = "SkullRiders/Skull_Rider_Blue_Idle_Left.dds";
Filenames[BLUE][RIGHTIDLE] = "SkullRiders/Skull_Rider_Blue_Idle_Right.dds";
Filenames[BLUE][LEFTSHOOT] = "SkullRiders/Skull_Rider_Blue_Shoot_Left.dds";
Filenames[BLUE][RIGHTSHOOT] = "SkullRiders/Skull_Rider_Blue_Shoot_Right.dds";
Filenames[BLUE][HATCH] = "SkullRiders/Skull_Blue_Hatch.dds";
Filenames[BLUE][SKULL] = "SkullRiders/Skull.dds";
Filenames[BLUE][WRAITHIDLE] = "SkullRiders/Wraith_Blue_Idle_Left.dds";

Filenames[GREEN][LEFTFLY] = "SkullRiders/Skull_Rider_Green_Fly_Left.dds";
Filenames[GREEN][RIGHTFLY] = "SkullRiders/Skull_Rider_Green_Fly_Right.dds";
Filenames[GREEN][LEFTDEATH] = "SkullRiders/Skull_Rider_Green_Death_Left.dds";
Filenames[GREEN][RIGHTDEATH] = "SkullRiders/Skull_Rider_Green_Death_Right.dds";
Filenames[GREEN][LEFTIDLE] = "SkullRiders/Skull_Rider_Green_Idle_Left.dds";
Filenames[GREEN][RIGHTIDLE] = "SkullRiders/Skull_Rider_Green_Idle_Right.dds";
Filenames[GREEN][LEFTSHOOT] = "SkullRiders/Skull_Rider_Green_Shoot_Left.dds";
Filenames[GREEN][RIGHTSHOOT] = "SkullRiders/Skull_Rider_Green_Shoot_Right.dds";
Filenames[GREEN][HATCH] = "SkullRiders/Skull_Green_Hatch.dds";
Filenames[GREEN][SKULL] = "SkullRiders/Skull.dds";
Filenames[GREEN][WRAITHIDLE] = "SkullRiders/Wraith_Green_Idle_Left.dds";

Filenames[BLACK][LEFTFLY] = "SkullRiders/Skull_Rider_Black_Fly_Left.dds";
Filenames[BLACK][RIGHTFLY] = "SkullRiders/Skull_Rider_Black_Fly_Right.dds";
Filenames[BLACK][LEFTDEATH] = "SkullRiders/Skull_Rider_Black_Death_Left.dds";
Filenames[BLACK][RIGHTDEATH] = "SkullRiders/Skull_Rider_Black_Death_Right.dds";
Filenames[BLACK][LEFTIDLE] = "SkullRiders/Skull_Rider_Black_Idle_Left.dds";
Filenames[BLACK][RIGHTIDLE] = "SkullRiders/Skull_Rider_Black_Idle_Right.dds";
Filenames[BLACK][LEFTSHOOT] = "SkullRiders/Skull_Rider_Black_Shoot_Left.dds";
Filenames[BLACK][RIGHTSHOOT] = "SkullRiders/Skull_Rider_Black_Shoot_Right.dds";
Filenames[BLACK][HATCH] = "SkullRiders/Skull_Black_Hatch.dds";
Filenames[BLACK][SKULL] = "SkullRiders/Skull.dds";
Filenames[BLACK][WRAITHIDLE] = "SkullRiders/Wraith_Black_Idle_Left.dds";

Filenames[RED][LEFTFLY] = "SkullRiders/Skull_Rider_Red_Fly_Left.dds";
Filenames[RED][RIGHTFLY] = "SkullRiders/Skull_Rider_Red_Fly_Right.dds";
Filenames[RED][LEFTDEATH] = "SkullRiders/Skull_Rider_Red_Death_Left.dds";
Filenames[RED][RIGHTDEATH] = "SkullRiders/Skull_Rider_Red_Death_Right.dds";
Filenames[RED][LEFTIDLE] = "SkullRiders/Skull_Rider_Red_Idle_Left.dds";
Filenames[RED][RIGHTIDLE] = "SkullRiders/Skull_Rider_Red_Idle_Right.dds";
Filenames[RED][LEFTSHOOT] = "SkullRiders/Skull_Rider_Red_Shoot_Left.dds";
Filenames[RED][RIGHTSHOOT] = "SkullRiders/Skull_Rider_Red_Shoot_Right.dds";
Filenames[RED][HATCH] = "SkullRiders/Skull_Red_Hatch.dds";
Filenames[RED][SKULL] = "SkullRiders/Skull.dds";
Filenames[RED][WRAITHIDLE] = "SkullRiders/Wraith_Red_Idle_Left.dds";
