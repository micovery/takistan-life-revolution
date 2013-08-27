GFX_ArmaViewDistance		= 1000;
GFX_ArmaTerrainGrids		= [50, 25, 12.5];
// GFX_ArmaTerrainGrids		= [50, 25, 12.5, 6.25];
GFX_ArmaTerrainGridsSel		= 0;

GFX_EnableManagerFPS		= false;
GFX_ManagerHandle			= -1;
GFX_ManagerToggle			= {
	if (GFX_EnableManagerFPS) then {
			GFX_ManagerHandle setFSMVariable ["end", true];
		}else{
			GFX_ManagerHandle = [] execFSM "Awesome\Performance\fpsManagerDynamic.fsm";
			GFX_ManagerHandle setFSMVariable ["end", false];
		};
	GFX_EnableManagerFPS = !GFX_EnableManagerFPS;
	server globalChat format['FPS Manager: %1', if(GFX_EnableManagerFPS)then{"Enabled"}else{"Disabled"}];
};

setViewDistance GFX_ArmaViewDistance;
setTerrainGrid (GFX_ArmaTerrainGrids select GFX_ArmaTerrainGridsSel);
