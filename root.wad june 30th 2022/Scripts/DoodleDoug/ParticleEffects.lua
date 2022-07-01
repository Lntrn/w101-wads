
function addParticleEffects()
   local digEmitter = CreateClass("class ParticleEmitter2D");
   digEmitter.SetParticleSpeed(1.25, 0.70);
   digEmitter.SetParticleGravity(0, 9);   
   digEmitter.SetParticleDispersionRadius(32);
   digEmitter.SetParticleStartColor(233, 165, 97, 100);
   digEmitter.SetParticleEndColor(233, 165, 97, 50);
   digEmitter.SetParticleLife(0.5, 0);
   digEmitter.SetParticleRate(0, 0);
   digEmitter.SetEmitterLife(0);
   digEmitter.SetEmitterInitialParticleCount(3);    
   digEmitter.SetParticleStartSize(4, 3);
   digEmitter.SetParticleEndSize(2, 1);
   digEmitter.SetParticleBlendingType(1);
   digEmitter.SetParticleMaterialName("DoodleDoug/dirt_particle.dds");           
   Board.AddEmitter(digEmitter);
   
   local explosionEmitter = CreateClass("class ParticleEmitter2D");
   explosionEmitter.SetParticleSpeed(8, 4);
   explosionEmitter.SetParticleGravity(0, 0);   
   --explosionEmitter.SetParticleStartColor(255, 0, 0, 128);
   explosionEmitter.SetParticleStartColor(255, 159, 64, 128);
   explosionEmitter.SetParticleEndColor(191, 119, 48, 0);
   explosionEmitter.SetParticleLife(.5, 1);
   explosionEmitter.SetParticleRate(0, 0);
   explosionEmitter.SetEmitterLife(0);
   explosionEmitter.SetEmitterInitialParticleCount(250);
   explosionEmitter.SetParticleStartSize(5, 2);
   explosionEmitter.SetParticleEndSize(2, 1);
   explosionEmitter.SetParticleBlendingType(1);
   explosionEmitter.SetParticleMaterialName("DoodleDoug/dirt_particle.dds");       
   explosionEmitter.SetParticleDirection(360.0,360.0); 
   Board.AddEmitter(explosionEmitter);
   
   local timeBonusEmitter = CreateClass("class ParticleEmitter2D"); 
   timeBonusEmitter.EmitterAddColorPalette(255,0,0);
   timeBonusEmitter.EmitterAddColorPalette(0,255,0);
   timeBonusEmitter.EmitterAddColorPalette(0,0,255);
   timeBonusEmitter.EmitterAddColorPalette(255,0,255);
   timeBonusEmitter.SetParticleStartColorPalette(1, 4, 30);
   timeBonusEmitter.SetParticleEndColorPalette(1, 4, 255);
   timeBonusEmitter.SetParticleLife(3, 0);
   timeBonusEmitter.SetEmitterInitialParticleCount(5);
   timeBonusEmitter.SetParticleDispersionRadius(0)
   timeBonusEmitter.SetParticleRotation(200,200);
   timeBonusEmitter.SetParticleStartSize(10, 10);
   timeBonusEmitter.SetParticleEndSize(4, 4);
   timeBonusEmitter.SetParticleBlendingType(1);
   timeBonusEmitter.SetParticleDirection(0, 360);
   timeBonusEmitter.SetParticleSpeed(2, 0);
   timeBonusEmitter.SetParticleGravity(0.0, 10.0);
   timeBonusEmitter.SetParticleMaterialName("Soblocks/Particles.dds");           
   Board.AddEmitter(timeBonusEmitter);   
   
   local bombBonusEmitter = CreateClass("class ParticleEmitter2D"); 
   bombBonusEmitter.EmitterAddColorPalette(255,0,0);
   bombBonusEmitter.EmitterAddColorPalette(255,255,0);
   bombBonusEmitter.SetParticleStartColorPalette(1, 1, 100);
   bombBonusEmitter.SetParticleEndColorPalette(2, 2, 0);
   bombBonusEmitter.SetParticleStartColor(255, 255, 255, 255);
   bombBonusEmitter.SetParticleEndColor(255, 255, 255, 0);   
   bombBonusEmitter.SetParticleLife(0.1, 0);   
   bombBonusEmitter.SetParticleRate(65, 0);
   bombBonusEmitter.SetParticleRotation(400,200);
   bombBonusEmitter.SetEmitterLife(5);
   bombBonusEmitter.SetParticleStartSize(50, 0);
   bombBonusEmitter.SetParticleEndSize(200, 70);
   bombBonusEmitter.SetParticleBlendingType(1);
   bombBonusEmitter.SetParticleMaterialName("DoodleDoug/Sparkle.dds");     
   Board.AddEmitter(bombBonusEmitter); 
end