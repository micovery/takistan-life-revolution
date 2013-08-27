class GFX_GrafikEinstellungenDialog {

	idd = -1;
	movingEnable = true;
	controlsBackground[] = {DLG_BACK1, background};
	objects[] = { };
	controls[] = {
		sichtweite_text, 
		sichtweite_button1, 
		Sichtweite_button2, 
		terrain_text, 
		terrain_button1, 
		terrain_button2,
		button_close,
		manager_title,
		manager_button1,
		dummybutton
	};

	class DLG_BACK1: Rscbackground {
		x = 0.38; y = 0.17;
		w = 0.24; h = 0.50;
	};

	class background : RscBgRahmen {
		x = 0.38; y = 0.17;
		w = 0.24; h = 0.50;
		text = $STRD_grafikeinstellungen_header;
	};

	class sichtweite_text : RscText {
		x = 0.40; y = 0.21;
		w = 0.20; h = 0.04;
		style = ST_CENTER;
		SizeEX = 0.04;
		text = $STRD_grafikeinstellungen_header_viewdistance;
	};

	class sichtweite_button1 : RscButton {
		x = 0.41; y = 0.27;
		w = 0.07; h = 0.04;
		text = "-100";
		action = "if (GFX_ArmaViewDistance >= 100) then {GFX_ArmaViewDistance = GFX_ArmaViewDistance - 100; setViewDistance GFX_ArmaViewDistance; player groupChat format['Viewdistance: %1', GFX_ArmaViewDistance];};";
	};

	class Sichtweite_button2 : RscButton {
		x = 0.51; y = 0.27;
		w = 0.07; h = 0.04;
		text = "+100";
		action = "if (GFX_ArmaViewDistance <= 5000) then {GFX_ArmaViewDistance = GFX_ArmaViewDistance + 100; setViewDistance GFX_ArmaViewDistance; player groupChat format['Viewdistance: %1', GFX_ArmaViewDistance];};";
	};

	class terrain_text : RscText {
		x = 0.40; y = 0.33;
		w = 0.20; h = 0.04;
		style = ST_CENTER;
		SizeEX = 0.04;
		text = $STRD_grafikeinstellungen_header_terrain;
	};

	class terrain_button1 : RscButton {
		x = 0.45; y = 0.38;
		w = 0.03; h = 0.04;
		text = "-";
		action = "if (GFX_ArmaTerrainGridsSel > 0) then {GFX_ArmaTerrainGridsSel = GFX_ArmaTerrainGridsSel - 1; setTerrainGrid(GFX_ArmaTerrainGrids select GFX_ArmaTerrainGridsSel); player groupChat format['Terrain Detail: %1/%2.', (GFX_ArmaTerrainGridsSel+1), (count GFX_ArmaTerrainGrids)];};";
	};

	class terrain_button2 : RscButton {
		x = 0.51; y = 0.38;
		w = 0.03; h = 0.04;
		text = "+";
		action = "if (GFX_ArmaTerrainGridsSel < ((count GFX_ArmaTerrainGrids)-1)) then {GFX_ArmaTerrainGridsSel = GFX_ArmaTerrainGridsSel + 1; setTerrainGrid(GFX_ArmaTerrainGrids select GFX_ArmaTerrainGridsSel); player groupChat format['Terrain Detail: %1/%2.', (GFX_ArmaTerrainGridsSel+1), (count GFX_ArmaTerrainGrids)];};";
	};
	
	class manager_title : RscText {
		x = 0.40; y = 0.45;
		w = 0.20; h = 0.04;
		style = ST_CENTER;
		SizeEX = 0.04;
		text = "FPS Manager";
	};
	
	class manager_button1 : RscButton {
		x = 0.40; y = 0.50;
		w = 0.2; h = 0.04;
		text = "Toggle";
		action = "if !(isNil 'GFX_ManagerToggle') then {[] call GFX_ManagerToggle};";
	};
	
	class button_close : RscButton {
		x = 0.40; y = 0.60;
		w = 0.20; h = 0.04;
		idc = 10;
		text = $STRD_grafikeinstellungen_close;
		action = "closedialog 0;";
	};
	class dummybutton : RscDummy {idc = 1004;};
};