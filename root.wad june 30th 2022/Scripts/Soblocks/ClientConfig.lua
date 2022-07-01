Include("Soblocks/Config.lua");
SCORE_TIME = 0.75;
MAX_SCORE_FPS = 60;
FRAMES_PER_NUM = 3;
MAX_REVOLUTIONS = SCORE_TIME * MAX_SCORE_FPS / FRAMES_PER_NUM;
JERK_FRAMES = 6;
JERK_FRAMES_MINUS_ONE = JERK_FRAMES - 1;
JERK_FPS = 15.0;
BLUR_FRAMES = 6;
BLUR_FPS = {};
table.insert(BLUR_FPS, 15.0); --FPS of leftmost digit
table.insert(BLUR_FPS, 16.5);
table.insert(BLUR_FPS, 20.0);
table.insert(BLUR_FPS, 23.0);
table.insert(BLUR_FPS, 26.0);
table.insert(BLUR_FPS, 30.0);
table.insert(BLUR_FPS, 35.0);
table.insert(BLUR_FPS, 40.0); --FPS of rightmost digit
SHINE_FRAMES = 9;
SHINE_FRAMES_MINUS_ONE = SHINE_FRAMES - 1;
SHINE_FPS = 30;
OPPONENT_SHAKE = 1000;
FROZEN_FRAMES = 10;
SNOW_TIME = 1.5;

LEVEL_GOOD = 3;
LEVEL_GREAT = 8;

--Timers
ScoreTimer = nil;
ShineTimer = nil;
InfoTimer = nil;
SHINE_INTERVAL = 10000;
INFO_INTERVAL = 5000;

--Sounds
sounds = {};
sounds.background = {};
sounds.background.filename = "Soblocks/Background.wav";
sounds.background.volume = 0.75;
sounds.background.pan = 0.0; --Need pan so loop will work
sounds.background.loopcount = -1;
sounds.danger = {};
sounds.danger.filename = "Soblocks/Danger.wav";
sounds.danger.volume = 0.75;
sounds.danger.pan = 0.0;
sounds.danger.loopcount = -1;

sounds.swap = {};
sounds.swap.filename = "Soblocks/Swap.wav";
sounds.swap.volume = 0.75
sounds.land = {};
sounds.land.filename = "Soblocks/Land.wav";
sounds.land.volume = 0.75;
sounds.glass = {};
sounds.glass.filename = "Soblocks/Break.wav";
sounds.glass.volume = 0.75;
sounds.levelup = {};
sounds.levelup.filename = "Soblocks/LevelUp.wav";
sounds.levelup.volume = 0.75;
sounds.aw = {};
sounds.aw.filename = "Soblocks/Aw.wav";
sounds.aw.volume = 0.75;
sounds.clap = {};
sounds.clap.filename = "Soblocks/Clap.wav";
sounds.clap.volume = 1.0;
sounds.applause = {};
sounds.applause.filename = "Soblocks/Applause.wav";
sounds.applause.volume = 1.0;
sounds.whip = {};
sounds.whip.filename = "Soblocks/Whip.wav";
sounds.whip.volume = 0.65
sounds.bulb = {};
sounds.bulb.filename = "Soblocks/Bulb.wav";
sounds.bulb.volume = 0.75
sounds.pop = {};
sounds.pop.filename = "Soblocks/Pop.wav";
sounds.pop.volume = 0.75
sounds.crash = {};
sounds.crash.filename = "Soblocks/Crash.wav";
sounds.crash.volume = 0.75
sounds.comboA = {};
sounds.comboA.filename = "Soblocks/ComboA.wav";
sounds.comboA.volume = 0.75;
sounds.comboB = {};
sounds.comboB.filename = "Soblocks/ComboB.wav";
sounds.comboB.volume = 0.75;
sounds.comboC = {};
sounds.comboC.filename = "Soblocks/ComboC.wav";
sounds.comboC.volume = 0.75;
sounds.comboD = {};
sounds.comboD.filename = "Soblocks/ComboD.wav";
sounds.comboD.volume = 0.75;
sounds.comboE = {};
sounds.comboE.filename = "Soblocks/ComboE.wav";
sounds.comboE.volume = 0.75;
sounds.shoot = {};
sounds.shoot.filename = "Soblocks/Shoot.wav";
sounds.shoot.volume = 0.75;
sounds.explosion = {};
sounds.explosion.filename = "Soblocks/Explosion.wav";
sounds.explosion.volume = 0.65;
sounds.lever = {};
sounds.lever.filename = "Soblocks/Lever.wav";
sounds.lever.volume = 0.75;
sounds.spin = {};
sounds.spin.filename = "Soblocks/Spin.wav";
sounds.spin.volume = 0.75;
sounds.spin.pan = 0.0;
sounds.spin.loopcount = -1;
sounds.jerk = {};
sounds.jerk.filename = "Soblocks/Jerk.wav";
sounds.jerk.volume = 0.75;
sounds.count = {};
sounds.count.filename = "Soblocks/Count.wav";
sounds.count.volume = 0.65;
sounds.begin = {};
sounds.begin.filename = "Soblocks/Begin.wav";
sounds.begin.volume = 0.65;

info = {};
INITINFO_FUNC();
bashInfo = {};
table.insert(bashInfo, "<center>Make special matches to attack your opponent!</center>");
table.insert(bashInfo, "<center>Press Z to speed up block advancement.</center>");

--Help text
help = {};
help.title = {};
help.page = {};
table.insert(help.title, "Basic Rules:");
table.insert(help.page, string.format("-Use the mouse to move the cursor. Press either mouse button to swap the two blocks the cursor covers.\n\n-Make matches of three of the same block either horizontally or vertically to get points. Matching more than three blocks at once yields more points.\n\n-Making matches causes blocks to be destroyed. After a while those destroyed blocks will disappear and the blocks above them will fall."));
table.insert(help.title, "Basic Rules 2:");
table.insert(help.page, string.format("-As time passes rows of new blocks will rise from the bottom of the playfield. If this causes any column of blocks to go above the playfield the game will end.\n\n-When blocks are successfully matched the bottom row will stop advancing. Matching more than three blocks at once will cause the bottom row to stop for a longer period of time."));
table.insert(help.title, "Combos:");
table.insert(help.page, string.format("-If a falling block causes a match your combo multiplier increases and you will get more points for matches.\n\n-Making combos will temporarily stop the stack of blocks from rising. The larger the combo the more time you get.\n\n-Press Z or press the fast forward button to make the blocks advance more quickly. This will also make the stack move again instantly if it has stopped due to a chain of combos.\n\n-When all of the blocks have fallen as far as they can and all the destroyed blocks are gone your combo multiplier goes back to x1."));
table.insert(help.title, "Levels:");
table.insert(help.page, string.format("-Once you destroy enough blocks by matching you will go up a level. Each new level will provide different difficulties, such as faster block advancement, faster falling and disappearing blocks, a new normal block of a different color, or different types and likelihoods of special blocks appearing.\n\n-Higher levels also give higher rewards, in the form of a global multiplier which makes your score go even higher!"));
table.insert(help.title, "Special Blocks:");
table.insert(help.page, string.format("-In addition to normal blocks, special blocks will appear depending on the level:\n\n-Pinwheels: These blocks will match with any other block.\n\n-Bombs: Matching a bomb with blocks of the same color will cause nearby blocks to be destroyed (which do not count toward the next level). Matching a bomb with four other blocks will cause a huge explosion.\n\n-Jewels: Jewels match with any block like pinwheels do, but they also destroy all blocks with the same color as the ones they match with (not counting toward the next level)."));
table.insert(help.title, "Special Blocks 2:");
table.insert(help.page, string.format("-Reinforced blocks: These are normal blocks except they are reinforced by a steel frame. They must be matched once to destroy their reinforcement (not counting toward the next level), then they become normal blocks and must be matched again to disappear as normal.\n\n-Frozen blocks: These are normal blocks but they are incased in ice and cannot be swapped around. They are effectively immobile and other blocks must be moved carefully to match and destroy it. They melt when too close to the top.\n\n-Note: Bomb blasts instantly destroy any blocks around them, including good and bad special blocks."));
table.insert(help.title, "Additional Controls:");
table.insert(help.page, string.format("-Press P or the pause button to pause or unpause the game.\n\n-Press Q or the stop button to end the game and see the results screen.\n\n-Press Z or press the fast forward button to make the blocks advance more quickly. It might seem dangerous, but advancing the blocks to a high level means many more chances for combos and matches!"));
table.insert(help.title, "Additional Notes and Hints:");
table.insert(help.page, string.format("-Destroyed blocks do not fall-- instead they will hover in place until they disappear.\n\n-Blocks you move yourself fall faster than other blocks and do not add to your combo multiplier.\n\n-You cannot swap falling blocks.\n\n- As long as blocks are disappearing or falling there is no danger of game over. Keep matching blocks at all times... When you have a combo going you can make much more points with a multiplier, and if you're about to lose the game a few matches can slow down the oncoming blocks!" ));
help.current = 1;
help.max = table.getn(help.page);
help.bashTitle = {};
help.bashPage = {};
table.insert(help.bashTitle, "Basic Rules:");
table.insert(help.bashPage, string.format("-The object is to make your opponent lose by making their stack reach the top before yours.\n\n-As time passes rows of new blocks will rise from the bottom of the playfield.\n\n-Use the mouse to move the cursor. Press either mouse button to swap the two blocks the cursor covers.\n\n-Make matches of three of the same block either horizontally or vertically to make them disappear. Any blocks above them will fall.\n\n-Matching more than three blocks at once will send blocks to fall on your opponent's screen."));
table.insert(help.bashTitle, "Combos:");
table.insert(help.bashPage, string.format("-If a falling block causes a match your combo multiplier increases and you will send blocks to fall on your opponent. A series of combos can make a powerful attack.\n\n-When all of the blocks have fallen as far as they can and all the destroyed blocks are gone your combo multiplier goes back to x1.\n\n-Press Z or press the fast forward button to make the blocks advance more quickly. More blocks on the screen means more opportunities for combo attacks."));
table.insert(help.bashTitle, "Special Blocks:");
table.insert(help.bashPage, string.format("-In addition to normal blocks, some special ones will appear:\n\n-Clocks: Matching three of these will send timed blocks to your opponent. These timed blocks will not match until their timer has counted down, at which point they turn into normal blocks.\n\n-Ice cubes: Matching three of these will randomly freeze a few of your opponent's blocks, preventing them from moving those blocks. They melt when they get too close to the top.\n\n-Stone blocks: Matching three of these will send a rock to your opponent. This rock can never be matched or destroyed, and it must be moved around effectively or it will just get in the way."));
table.insert(help.bashTitle, "Additional Notes and Hints:");
table.insert(help.bashPage, string.format("-Destroyed blocks do not fall-- instead they will hover in place until they disappear.\n\n-Blocks that you push off a ledge yourself fall faster than other blocks and do not add to your combo multiplier. Making matches with stationary blocks also does not increase the combo multiplier.\n\n-You cannot swap falling blocks.\n\n-Keep matching blocks at all times, and if you run low on blocks don't hesitate to advance the stack with Z or fast forward. It's often better to keep on the offensive than to just wait for attacks!"));
help.bashMax = table.getn(help.bashPage);
