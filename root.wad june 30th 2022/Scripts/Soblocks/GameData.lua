SERVER_ROW_BUFFER_MAX = 25;

--Timers and related
FallTimer = nil;
SwapFallTimer = nil;
RemoveTimer = nil;
AddTimer = nil;
ComboTimer = nil;
atrest = true;
addcounter = nil;
advance = false;
combotime = nil;

--Configured by level
FALL_TIME = nil;
REMOVE_TIME = nil;
REMOVE_TIME_SECONDS = nil;
ADD_TIME_STEP = nil;
ADD_TIME = nil;
MULTIPLIER = nil;
MULTI_TIME = nil;
COMBO_TIME = nil;
INTERVAL = nil;
LEVEL_TIME = nil;

--Scoring
combo = 0;
score = 0;
blocksdestroyed = 0;
lastcombo = 0;
level = 0;
levels = {};

--Types
NUM_TILES = 10; --Regular blocks are 1-10, bombs are 11-20, blank is 0
LAST_BOMB = 20;
PINWHEEL_BLOCK = 21;
JEWEL_BLOCK = 22;
REMOVE_BLOCK = 23; --This MUST be the first non-block, non-bomb, non-empty tile
PLACEHOLDER = 24;
GAMEOVER_BLOCK = 25;
REINFORCED_ALT = 100;
FROZEN_ALT = 200;

--Bash-only types
ICECUBE_BLOCK = 26;
CLOCK_BLOCK = 27;
TIMED_BLOCK = 28;
STONE_BLOCK = 29;
ROCK = 30;
TIMED_FRAMES = 27;

VERTICAL = 0;		--For matches
HORIZONTAL = 1;
MATERIALS = {  "Soblocks/Blue.dds",
               "Soblocks/Orange.dds",
               "Soblocks/Green.dds",
               "Soblocks/Brown.dds",
               "Soblocks/Black.dds",
               "Soblocks/Red.dds",
               "Soblocks/Pink.dds",
               "Soblocks/Teal.dds",
               "Soblocks/White.dds",
               "Soblocks/Yellow.dds"
};
DEFAULT_FILES = { "Soblocks/Blue.dds",
                  "Soblocks/Orange.dds",
                  "Soblocks/Green.dds",
                  "Soblocks/Brown.dds",
                  "Soblocks/Black.dds",
                  "Soblocks/Red.dds",
                  "Soblocks/Pink.dds",
                  "Soblocks/Teal.dds",
                  "Soblocks/White.dds",
                  "Soblocks/Yellow.dds"
};
SHINE_FILES = {   "Soblocks/Blue_shine.dds",
                  "Soblocks/Orange_shine.dds",
                  "Soblocks/Green_shine.dds",
                  "Soblocks/Brown_shine.dds",
                  "Soblocks/Black_shine.dds",
                  "Soblocks/Red_shine.dds",
                  "Soblocks/Pink_shine.dds",
                  "Soblocks/Teal_shine.dds",
                  "Soblocks/White_shine.dds",
                  "Soblocks/Yellow_shine.dds"
};

TILES = {   blue   =  1,
            orange =  2,
            green  =  3,
            brown  =  4,
            black  =  5,
            red    =  6,
            pink   =  7,
            teal   =  8,
            white  =  9,
            yellow = 10
};
BOMBS = { 11,12,13,14,15,16,17,18,19,20
}; --This is in the same order as TILES and MATERIALS

--Points per block, starting with a match of 3
POINTS   = {100, 125, 150, 150, 175, 175, 200};
ITEMADD  = {1.0,  2.0,  4.0};
BUCKSADD = {3.0,  6.0,  1.2};

LEVELUP_COMBO = 0.2; --Score multiplier for blank blocks at level up

function resetPlayTiles()
   playtiles = {  TILES.blue,
                  TILES.red,
                  TILES.green,
                  TILES.yellow,
                  TILES.pink,
                  TILES.black
   };
   addtiles = {   TILES.brown,
                  TILES.teal,
                  TILES.white,
                  TILES.orange
   };
end

function AddLevels()                                                            --192     64        32       32      64
   AddLevel(levels,       0,  0,  0,    0, false, 9000, 20, 200, 750, 750, 500, 000, 000, 000, 00, 00, 1);       --Level 1
   AddLevel(levels,   10000,  1,  3,  100, false, 8000, 19, 175, 750, 650, 400, 000, 000, 032, 00, 00, 1.1);     --2
   AddLevel(levels,   22500,  2,  6,  220, true,  7500, 18, 175, 750, 600, 300, 000, 064, 032, 00, 00, 1.25);    --3
   AddLevel(levels,   40000,  3,  9,  360, false, 6500, 17, 160, 750, 600, 300, 128, 064, 032, 64, 00, 1.375);   --4
   AddLevel(levels,   60000,  4, 12,  520, false, 5750, 16, 150, 700, 575, 250, 128, 064, 032, 64, 64, 1.5);     --5
   AddLevel(levels,   90000,  5, 15,  700, false, 5000, 15, 140, 700, 550, 250, 160, 096, 048, 48, 56, 1.625);   --6
   AddLevel(levels,  125000,  6, 18,  900, true,  4750, 14, 140, 700, 550, 250, 160, 096, 048, 48, 56, 1.8);     --7
   AddLevel(levels,  165000,  7, 21, 1120, false, 4250, 13, 130, 700, 525, 200, 192, 096, 048, 32, 48, 2);       --8
   AddLevel(levels,  225000,  8, 24, 1360, false, 3750, 12, 120, 650, 500, 200, 192, 112, 064, 32, 48, 2.25);    --9
   AddLevel(levels,  300000,  9, 27, 1620, false, 3250, 11, 110, 650, 475, 200, 208, 112, 064, 32, 40, 2.5);     --10

   AddLevel(levels,  385000, 10, 30, 1900, false, 2900, 10, 100, 600, 450, 175, 224, 128, 064, 32, 40, 2.75);    --11
   AddLevel(levels,  500000, 11, 33, 2200, true,  2750, 10, 100, 600, 450, 175, 240, 128, 080, 24, 32, 3);       --12
   AddLevel(levels,  625000, 12, 36, 2520, false, 2550,  9,  90, 600, 425, 175, 256, 144, 080, 24, 32, 3.25);    --13
   AddLevel(levels,  800000, 13, 39, 2860, false, 2250,  9,  80, 550, 400, 150, 272, 144, 080, 24, 24, 3.5);     --14
   AddLevel(levels, 1000000, 14, 42, 3220, false, 1950,  8,  70, 550, 350, 150, 288, 160, 096, 16, 24, 3.75);    --15
   AddLevel(levels, 1350000, 15, 45, 3600, false, 1700,  8,  60, 500, 300, 125, 304, 160, 096, 16, 16, 4);       --16
   AddLevel(levels, 1850000, 16, 48, 4000, false, 1450,  7,  50, 450, 250, 100, 320, 160, 096, 16, 16, 4.25);    --17
   AddLevel(levels, 2500000, 17, 51, 4420, true,  1350,  7,  50, 450, 250,  75, 336, 160, 112, 08, 12, 4.5);     --18
   AddLevel(levels, 3500000, 18, 54, 4860, false, 1200,  6,  35, 400, 200,  50, 000, 192, 112, 04, 08, 4.75);    --19
   AddLevel(levels, 5000000, 19, 57, 5320, false, 1050, 15,  10, 300,  10,   5, 000, 256, 128, 04, 04, 5);       --20
end

function AddLevel(data, score, itemscore, buckscore, blocks, newblock, speed, speedup, fallspeed, removespeed, combotime, multitime, 
         jewel, bomb, pinwheel, reinforced, frozen, bonus)
   local thislevel = {};
   thislevel.score = score;               --Score required to get to this level
   thislevel.itemscore = itemscore;       --Item score required to get to this level
   thislevel.buckscore = buckscore;       --Socia Buck score required to get to this level
   thislevel.blocks = blocks;             --The number of blocks that need to be destroyed to get to this level
   thislevel.newblock = newblock;         --True/false: Does a new block appear at this level?
   thislevel.speed = speed;               --How many milliseconds for a new row to fully appear at the bottom
   thislevel.speedup = speedup;           --Every row appearance gets faster by this amount
   thislevel.fallspeed = fallspeed;       --How long the blocks take to fall one space
   thislevel.removespeed = removespeed;   --How long the blocks take to be destroyed
   thislevel.combotime = combotime;       --The amount of resting time granted for a combo
   thislevel.multitime = multitime;       --The amount of resting time granted for a match of more than 3 blocks
   thislevel.jewel = jewel;               --The chance for jewels to appear this level
   thislevel.bomb = bomb;                 --The chance for bombs to appear this level
   thislevel.pinwheel = pinwheel;         --The chance for pinwheels to appear this level
   thislevel.reinforced = reinforced;     --The chance for reinforced blocks to appear this level
   thislevel.frozen = frozen;             --The chance for frozen blocks to appear this level
   thislevel.bonus = bonus;               --The global score multiplier for this level
   table.insert(data, thislevel);
end

function AddBashLevels() 
   AddBashLevel(levels, 120, false, 7500, 10, 100, 175, 750, 600, 300); --Level 1
   AddBashLevel(levels, 120,  true, 6000, 10,  90, 150, 700, 550, 250); --2
   AddBashLevel(levels, 120, false, 4750, 10,  75, 140, 700, 500, 200); --3
   AddBashLevel(levels, 120,  true, 3750, 10,  55, 125, 650, 400, 175); --4
   AddBashLevel(levels, 120, false, 3000, 10,  38, 115, 650, 400, 175); --5
   AddBashLevel(levels, 120,  true, 2500, 10,  28, 100, 550, 300, 150); --6
   AddBashLevel(levels, 120, false, 2100, 10,  18,  90, 550, 300, 150); --7
   AddBashLevel(levels, 120,  true, 1850, 10,  18,  75, 450, 350, 125); --8
   AddBashLevel(levels, 120, false, 1600, 10,  15,  70, 450, 350, 125); --9
   AddBashLevel(levels,   0, false, 1400, 10,  15,  50, 300, 200, 100); --10
end

function AddBashLevel(data, leveltime, newblock, speed, interval, speedup, fallspeed, removespeed, combotime, multitime)
   local thislevel = {};
   thislevel.leveltime = leveltime * 1000;   --How long does this level last in seconds (0 for no end, is not cumulative)
   thislevel.newblock = newblock;            --True/false: Does a new block appear at this level?
   thislevel.speed = speed;                  --How many milliseconds for a new row to fully appear at the bottom
   thislevel.interval = interval * 1000;     --Game gets faster every *this* amount of seconds
   thislevel.speedup = speedup;              --Every X seconds fall speed gets this much faster
   thislevel.fallspeed = fallspeed;          --How long the blocks take to fall one space
   thislevel.removespeed = removespeed;      --How long the blocks take to be destroyed
   thislevel.combotime = combotime;          --The amount of resting time granted for a combo
   thislevel.multitime = multitime;          --The amount of resting time granted for a match of more than 3 blocks
   thislevel.jewel = 0;
   thislevel.bomb = 0;
   thislevel.pinwheel = 0;
   thislevel.reinforced = 0;
   thislevel.frozen = 0;
   table.insert(data, thislevel);
end
