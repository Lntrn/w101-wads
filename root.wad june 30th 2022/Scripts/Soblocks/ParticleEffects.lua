Include("Soblocks/Config.lua");

function CreatePop(x, y, index)
	local emitter = CreateClass("class ParticleEmitter2D");

	emitter.SetEmitterPosition(x, y);
	emitter.SetParticleGravity(0, 0);

	emitter.SetParticleStartColor(255, 255, 255, 255);
	emitter.SetParticleEndColor(255, 255, 255, 0);

	emitter.SetParticleDispersionRadius(HALF_TILE_SIZE);
	emitter.SetParticleDirection(0, 360);

	emitter.SetParticleLife(REMOVE_TIME_SECONDS, 0);
	emitter.SetParticleRate(0, 0);
	
	emitter.SetEmitterLife(0);

	emitter.SetParticleSpeed(0.5, 2.5);

	emitter.SetParticleBlendingType(1);
	
	emitter.SetParticleStartSize(24, 16);
	emitter.SetParticleRotation(200, 200);
	emitter.CalculateParticleRotationFromDirection();
   
	emitter.SetParticleEndSize(8, 8);   
	emitter.SetEmitterInitialParticleCount(10);

   if (index > NUM_TILES and index <= LAST_BOMB) then
      emitter.SetParticleMaterialName(DEFAULT_FILES[index-NUM_TILES]);
      emitter.SetParticleDispersionRadius(TILE_SIZE * 1.5);
      emitter.SetParticleSpeed(1.5, 3.5);
      emitter.SetEmitterInitialParticleCount(50);
   elseif (index <= NUM_TILES and index > 0) then
      emitter.SetParticleMaterialName(DEFAULT_FILES[index]);
   elseif (index == CLOCK_BLOCK) then
      emitter.SetParticleMaterialName("Soblocks/Clock.dds");
   elseif (index == ICECUBE_BLOCK) then
      emitter.SetParticleMaterialName("Soblocks/IceCube.dds");
   elseif (index == STONE_BLOCK) then
      emitter.SetParticleMaterialName("Soblocks/Stone.dds");
   else
      emitter.SetParticleMaterialName("Soblocks/Remove.dds");
	end
   
	return emitter;
end

function CreateFirework(x, y)
	local emitter = CreateClass("class ParticleEmitter2D");

	emitter.SetEmitterPosition(x, y);
	emitter.SetParticleGravity(0, 10);
	emitter.SetParticleStartColor(255, 255, 255, 255);
	emitter.SetParticleEndColor(255, 255, 255, 0);
	
	emitter.SetParticleDispersionRadius(HALF_TILE_SIZE);
	emitter.SetParticleDirection(0, 60);

	emitter.SetParticleLife(1.6, 0);
	emitter.SetParticleRate(0, 0);
	emitter.SetParticleMaterialName("Soblocks/Remove.dds");


	emitter.SetEmitterLife(0);

	emitter.SetParticleSpeed(3, 5);

	emitter.SetEmitterInitialParticleCount(5);
	emitter.SetParticleStartSize(12, 12);
   emitter.SetParticleEndSize(2, 4);
	emitter.SetParticleRotation(200, 200);
	emitter.SetParticleBlendingType(1);

	return emitter;
end

function CreateBlockAway(x, y)
	local emitter = CreateFirework(x, y);
	emitter.SetParticleStartSize(36, 0);
	emitter.SetParticleLife(0.8, 0);
   emitter.CalculateParticleRotationFromDirection();
	emitter.SetEmitterInitialParticleCount(1);
	return emitter;
end

function CreateLevelAttractor(x, y)
	local emitter = CreateClass("class ParticleEmitter2D");
	emitter.EnableDebug(false);
	-- set center point of the emitter
	emitter.SetEmitterPosition(x, y);
	-- set the gravity rate of the particles created with emitter
	emitter.SetParticleGravity(0, 0);
	-- set starting color of particles from this emitter

	emitter.EmitterAddColorPalette(255,0,0);
	emitter.EmitterAddColorPalette(0,255,0);
	emitter.EmitterAddColorPalette(0,0,255);
	emitter.EmitterAddColorPalette(255,0,255);
	emitter.SetParticleStartColorPalette(1, 4, 255);
	emitter.SetParticleEndColorPalette(1, 4, 0);
	
   -- set the radius of particles created 
	emitter.SetParticleDispersionRadius(0);
	-- set direction of this particle
	emitter.SetParticleDirection(0, 360);

	-- how long particle will live
	emitter.SetParticleLife(1, 0.5);
	-- how many new particles are created per update
   emitter.SetParticleRate(250, 0);
	
	-- how long will this emitter live
	emitter.SetEmitterLife(-1);
	emitter.SetEmitterGravity(0, 0);
	emitter.SetEmitterDirection(0, 360);
	-- how fast are these particles
	emitter.SetParticleSpeed(1, 0);
	-- set blending mode of particles
	emitter.SetParticleBlendingType(1);
	-- set start and end sizes of particles
	emitter.SetParticleStartSize(10, 10);
	emitter.SetParticleEndSize(4, 4);
	
	-- set the texture used by particles
	emitter.SetParticleMaterialName("Soblocks/Particles.dds");
	-- set the particle rotations
	emitter.CalculateParticleRotationFromDirection();
	
	emitter.SetParticleRotation(200, 200);
	-- how many particles will we initailly create
	emitter.SetEmitterInitialParticleCount(0);
	
	emitter.SetEmitterViscosity(0.1);

	emitter.EmitterAddAttractor(BOARD_LEFT + PO.leveltext_offsetx, BOARD_TOP + PO.leveltext_offsety, 5, 5);
	emitter.SetEmitterUseAttractor(0, 1, false);
	
	explosionEmitter = CreateExplosion(1, 100);
	emitter.SetNextEmitter(explosionEmitter);
	
   DestroyClass(explosionEmitter);
   explosionEmitter = nil;
   
	return emitter;
end

function CreatePointAttractor(x, y, weight)
	local emitter = CreateClass("class ParticleEmitter2D");
	emitter.EnableDebug(false);
	-- set center point of the emitter
	emitter.SetEmitterPosition(x, y);
	-- set the gravity rate of the particles created with emitter
	emitter.SetParticleGravity(0, 0);
	-- set starting color of particles from this emitter1

	emitter.EmitterAddColorPalette(255,0,0);
	emitter.EmitterAddColorPalette(0,255,0);
	emitter.EmitterAddColorPalette(0,0,255);
	emitter.EmitterAddColorPalette(255,0,255);
	emitter.SetParticleStartColorPalette(1, 4, 255);
	emitter.SetParticleEndColorPalette(1, 4, 0);
	
   -- set the radius of particles created 
	emitter.SetParticleDispersionRadius(0);
	-- set direction of this particle
	emitter.SetParticleDirection(0, 360);

	-- how long particle will live
	emitter.SetParticleLife(1, 0.5);
	-- how many new particles are created per update
   if (weight == 3) then
      emitter.SetParticleRate(100, 0);
   elseif (weight < 10) then
      emitter.SetParticleRate(50 * weight, 0);
   else
      emitter.SetParticleRate(500, 0);
   end
	
	-- how long will this emitter live
	emitter.SetEmitterLife(-1);
	emitter.SetEmitterGravity(0, 0);
	emitter.SetEmitterDirection(0, 360);
	-- how fast are these particles
	emitter.SetParticleSpeed(1, 0);
	-- set blending mode of particles
	emitter.SetParticleBlendingType(1);
	-- set start and end sizes of particles
	emitter.SetParticleStartSize(10, 10);
	emitter.SetParticleEndSize(4, 4);
	
	-- set the texture used by particles
	emitter.SetParticleMaterialName("Soblocks/Particles.dds");
	-- set the particle rotations
	emitter.CalculateParticleRotationFromDirection();
	
	emitter.SetParticleRotation(200, 200);
	-- how many particles will we initailly create
	emitter.SetEmitterInitialParticleCount(0);
	
		
	emitter.SetEmitterViscosity(0.1);

	emitter.EmitterAddAttractor(BOARD_LEFT + PO.points_offsetx, BOARD_TOP + PO.points_offsety, 5, 5);
	emitter.SetEmitterUseAttractor(0, 1, false);
	
	explosionEmitter = CreateExplosion(1, weight);
	emitter.SetNextEmitter(explosionEmitter);
	
   DestroyClass(explosionEmitter);
   explosionEmitter = nil;
   
	return emitter;
end

function CreateBashAttractor(x, y)
   local emitter = CreatePointAttractor(x, y, 3);
   return emitter;
end

function CreateExplosion(which, weight)
	local emitter = CreateClass( "class ParticleEmitter2D" );

	emitter.SetEmitterPosition(0,0);
	emitter.SetParticleGravity(0,3);
	local color = math.random(100)+155;
	if(which == 1) then
		emitter.SetParticleStartColor(color,70,11,255);
		emitter.SetParticleEndColor(color,70,11,0);
	elseif(which == 2) then
		emitter.SetParticleStartColor(11,color,11,255);
		emitter.SetParticleEndColor(11,color,11,0);
	else
		emitter.SetParticleStartColor(11,70,color,255);
		emitter.SetParticleEndColor(11,70,color,0);
	end
	emitter.SetParticleDispersionRadius(1);
	emitter.SetParticleDirection(0,360);

	emitter.SetParticleLife(.5,1);
	emitter.SetParticleRate(5,0);
	
	emitter.SetEmitterLife(1);


	emitter.SetParticleSpeed(3,3);

	emitter.SetParticleBlendingType(1);
	
	emitter.SetParticleStartSize(10,10);
	emitter.SetParticleEndSize(4,4);
	emitter.SetParticleMaterialName("Soblocks/Particles.dds");
	
   if (weight < 10) then
      emitter.SetEmitterInitialParticleCount(25 * weight);
   else
      emitter.SetEmitterInitialParticleCount(250);
   end
	return emitter;
end

function CreateSpark(x, y)
	local emitter = CreateClass("class ParticleEmitter2D");

	emitter.SetEmitterPosition(x, y);
	emitter.SetParticleGravity(0, 20);
	emitter.SetParticleStartColor(255, 255, 255, 255);
	emitter.SetParticleEndColor(255, 255, 255, 64);
	
	emitter.SetParticleDispersionRadius(HALF_TILE_SIZE);
	emitter.SetParticleDirection(0,45);

	emitter.SetParticleLife(0.7, 0);
	emitter.SetParticleRate(0, 0);
	emitter.SetParticleMaterialName("Soblocks/Spark.dds");


	emitter.SetEmitterLife(0);

	emitter.SetParticleSpeed(3, 6);

	emitter.SetEmitterInitialParticleCount(20);	
	emitter.SetParticleRotation(200,200);
	emitter.CalculateParticleRotationFromDirection();
   emitter.SetParticleStartSize(18, 18);
   emitter.SetParticleEndSize(8, 8);
	emitter.SetParticleBlendingType(1);
	
	return emitter;
end

function CreateLightSpark(x, y)
   local emitter = CreateSpark(x, y);
	emitter.SetParticleGravity(0, 15);
   emitter.SetParticleStartSize(26, 18);
	emitter.SetParticleEndColor(255, 255, 255, 128);
	emitter.SetEmitterInitialParticleCount(40);	
   return emitter;
end

function CreateSnow()
	local emitter = CreateClass("class ParticleEmitter2D");

	emitter.SetEmitterPosition(GameSubWindow.GetLeft(), -50);
	emitter.SetParticleGravity(0, 0);

	emitter.SetParticleStartColor(255, 255, 255, 255);
	emitter.SetParticleEndColor(255, 255, 255, 0);

	emitter.SetParticleDispersionRadius(HALF_TILE_SIZE);
	emitter.SetParticleDirection(180, 45);

	emitter.SetParticleLife(SNOW_TIME, 0);
	emitter.SetParticleRate(100, 25);
	
	emitter.SetEmitterLife(-1);
 	emitter.SetEmitterViscosity(0.1);

	emitter.EmitterAddAttractor(660, -50, 5, 25);
	emitter.SetEmitterUseAttractor(0, 1, false);

	emitter.SetParticleSpeed(6, 12);

	emitter.SetParticleBlendingType(0);
	
	emitter.SetParticleStartSize(24, 16);
	emitter.SetParticleRotation(200, 200);
	emitter.CalculateParticleRotationFromDirection();
   
	emitter.SetParticleEndSize(8, 8);   
	emitter.SetEmitterInitialParticleCount(0);

   emitter.SetParticleMaterialName("Soblocks/Snowflakes.dds");
   
	return emitter;
end

function CreateWarning()
   local emitter = CreateCombo();
	emitter.SetParticleMaterialName("Soblocks/Warning.dds");
	emitter.SetEmitterPosition(BOARD_LEFT + PO.warning_offsetx, BOARD_TOP + PO.warning_offsety);
	emitter.SetParticleSpeed(0, 0);
   return emitter;
end

function CreateCombo()
	local emitter = CreateClass("class ParticleEmitter2D");

	emitter.SetEmitterPosition(BOARD_LEFT + PO.combo_offsetx, BOARD_TOP + PO.combo_offsety);
	emitter.SetParticleGravity(0, 0);
	emitter.SetParticleStartColor(255, 255, 255, 255);
	emitter.SetParticleEndColor(255, 255, 255, 0);
	
	emitter.SetParticleDispersionRadius(0);
	emitter.SetParticleDirection(0,0);

	emitter.SetParticleLife(1.5, 0);
	emitter.SetParticleRate(0, 0);
	emitter.SetParticleMaterialName("Soblocks/combo.dds");


	emitter.SetEmitterLife(2);

	emitter.SetParticleSpeed(2, 0);

	emitter.SetEmitterInitialParticleCount(1);	
	emitter.SetParticleStartSize(168, 0);
	emitter.SetParticleEndSize(168, 0);
	emitter.SetParticleBlendingType(1);
	
	return emitter;
end

function CreateLevelUp()
	local emitter = CreateClass("class ParticleEmitter2D");

	emitter.SetEmitterPosition(BOARD_LEFT + PO.level_offsetx, BOARD_TOP + PO.level_offsety);
	emitter.SetParticleGravity(0, 0);
	emitter.SetParticleStartColor(255, 255, 255, 255);
	emitter.SetParticleEndColor(255, 255, 255, 0);
	
	emitter.SetParticleDispersionRadius(0);
	emitter.SetParticleDirection(0,0);

	emitter.SetParticleLife(1.5, 0);
	emitter.SetParticleRate(0, 0);
	emitter.SetParticleMaterialName("Soblocks/LevelUp.dds");


	emitter.SetEmitterLife(2);

	emitter.SetParticleSpeed(2, 0);

	emitter.SetEmitterInitialParticleCount(1);	
	emitter.SetParticleStartSize(192, 0);
	emitter.SetParticleEndSize(192, 0);
	emitter.SetParticleBlendingType(2);
	
	return emitter;
end
