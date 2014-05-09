waitUntil{not(isNil "BIS_Effects_Init")};
sleep 5;

//player groupChat "Loading Fixes";

BIS_Effects_AirDestructionStage2=compile preprocessFileLineNumbers "Fixes\ca\Data\ParticleEffects\SCRIPTS\destruction\AirDestructionStage2.sqf";