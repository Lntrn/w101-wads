GAMETYPES = {SCORE = 0, ITEM = 1, BUCKS = 2, BASH = 3};

--Timing and gameplay config
BASH_LEVEL = 1;
STARTING_LEVEL = 1;
STARTING_HEIGHT = 5;
DANGER_HEIGHT = 2; --At actual height of 12 blocks
BOMB_CHANCE = 64; --64
PINWHEEL_CHANCE = 32; --32
JEWEL_CHANCE = 192; --192
FROZEN_CHANCE = 64; --64
REINFORCED_CHANCE = 32; --32
BLOCKS_GAME = true;
MIN_ADD = 250;
MAX_STOP_TIME = 5; --This is multiplied by the level's combo stop time amount, so if it's 500 then 500 x 5 = 2500 = 2.5 sec.
FRAME_THROTTLE = 16;
SWAP_TIME = 100;
GAMEOVER_WAIT = 1000;
ROW_BUFFER = 20; --Number of rows in reserve to maintain
ROW_BUFFER_WARN = 5;
ROWINFO_INTERVAL = 1000;
ATTACK_WAIT = 1000;
FROZEN_FPS = 9;
MELT_ROW = 4;

--Board sizes
MAP_WIDTH = 7;
MAP_WIDTH_MINUS_ONE = 6;
MAP_WIDTH_MINUS_TWO = 5;
MAP_HEIGHT = 15;
MAP_HEIGHT_MINUS_ONE = 14;
MAP_HEIGHT_MINUS_TWO = 13;

cursor = {};
--Temporary gamestates shared (to be split up for security)
cursor.swap = nil;
cursor.swapx = nil;
cursor.swapy = nil;
cursor.index1 = nil;
cursor.index2 = nil;
cursor.pause = false;
cursor.help = false;
cursor.levelup = false;
cursor.newlevel = nil;
cursor.newblock = nil;
cursor.blankblocks = nil;
cursor.startingheight = nil;

fall = {}; --Blocks falling due to matching
swapfall = {}; --Blocks falling due to swapping, these fall more quickly
removal = {}; --Blocks that are destroyed and will be removed later
playtiles = nil;
addtiles = nil;

--Item to play for
item = {};
item.name = "Stain"
item.id = 80055987;
item.icon = "Objects/Misc/Renders/WoodStain.dds"
item.count = 0;
item.fraction = 0;
item.rollover = 100;

--Socia Bucks
bucks = {};
bucks.count = 0;
bucks.fraction = 0;
bucks.icon = "Soblocks/Pink.dds";
