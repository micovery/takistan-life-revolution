#include "constants.h"

class STEXT {
	type = CT_STRUCTURED_TEXT;
	idc = -1;
	style = ST_MULTI;
	x = 0.50; y = 0.47;
	w = 0.3; h = 0.2;
	font = "Zeppelin33Italic";
	sizeEx = 0.025;
	colorText[] = {0, 1, 0, 0.8};
	colorBackground[] = {0,0,0,0.0};
	text = "";
	lineSpacing = 1;
	size = 0.02;
	class Attributes {
		font = FontM_R;
		color = "#ffffff";
		align = "left";
		shadow = false;
	};
};


class MAP {
	type = CT_MAP;
	scaleDefault = 0.5;
	scaleMax = 0;
	scaleMin = 0;
	period = 0.001;
	style = ST_PIRCURE;
	x = 0; y = 0;
	w = 0; h = 0;
	
	colorBackground[] = {1, 1, 1, 1};
	colorText[] = {0, 0, 0, 1};
	sizeEx = 0.04;
	colorSea[] = {0.56, 0.80, 0.98, 0.50};
	colorForest[] = {0.60, 0.80, 0.20, 0.50};
	colorRocks[] = {0.60, 0.45, 0.27, 0.40};
	colorCountlines[] = {0.70, 0.55, 0.30, 0.60};
	colorMainCountlines[] = {0.65, 0.45, 0.27, 1};
	colorCountlinesWater[] = {0, 0.53, 1, 0.30};
	colorMainCountlinesWater[] = {0, 0.53, 1, 0.50};
	colorForestBorder[] = {0.40, 0.80, 0, 1};
	colorRocksBorder[] = {0.60, 0.45, 0.27, 0.40};
	colorPowerLines[] = {0, 0, 0, 1};
	colorBuildings[] = {0, 0, 0, 0.50};
	colorRailway[] = {0, 0, 0, 1};
	colorNames[] = {0, 0, 0, 1};
	colorInactive[] = {1, 1, 1, 0.50};
	colorLevels[] = {0.65, 0.45, 0.27, 1};
	colorOutside[] = {0.65, 0.45, 0.27, 1};
	colorInside[] = {0.65, 0.45, 0.27, 1};

	stickX[] = {0.2, {"Gamma", 1, 1.5}};
	stickY[] = {0.2, {"Gamma", 1, 1.5}};
	
	fontLabel = "Zeppelin32";
	sizeExLabel = 0.028646;
	text = "#(argb,8,8,3)color(1,1,1,1,co)";
	font = "Zeppelin32";
	size = "1.25*0.022";
	fontGrid = "Zeppelin32";
	sizeExGrid = 0.0180;
	fontUnits = "Zeppelin32";
	sizeExUnits = 0.04;
	fontNames = "Zeppelin32";
	sizeExNames = 0.04;
	fontInfo = "Zeppelin32";
	sizeExInfo = 0.04;
	fontLevel = "Zeppelin32";
	sizeExLevel = 0.0180;
	
	//@{ coefficients which determine rendering density / threshold
	ptsPerSquareSea = 0.1; // seas
	ptsPerSquareTxt = 8;   // textures
	ptsPerSquareCLn = 8;   // count-lines
	ptsPerSquareExp = 8;   // exposure
	ptsPerSquareCost = 8;  // cost
	//@}

	//@{ coefficients which determine when rendering of given type is done
	ptsPerSquareFor = 1;           // forests
	ptsPerSquareForEdge = "10.0f"; // forest edges
	ptsPerSquareRoad = "0.1f";     // roads
	ptsPerSquareObj = 5;           // other objects
	//@}

	showCountourInterval = "true"; // legend in upper right corner, with scaling information
	
	
	moveOnEdges = 1;
	maxSatelliteAlpha = 0;
	alphaFadeStartScale = 0.150000;
	alphaFadeEndScale = 0.290000;


	class Legend {
		colorBackground[] = {0.906,0.901,0.88,0};
		color[] = {0,0,0,1};
		x = "SafeZoneX";
		y = "SafeZoneY";
		w = 0.34;
		h = 0.152;
		font = "Zeppelin32";
		sizeEx = 0.03921;
	};
	
	class ActiveMarker {
		color[] = {0.3,0.1,0.9,1};
		size = 50;
	};
	class Command {
		color[] = {0,0.9,0,1};
		icon = "\ca\ui\data\map_waypoint_ca.paa";
		size = 18;
		importance = 1;
		coefMin = 1;
		coefMax = 1;
	};
	class Task {
		colorCreated[] = {0.95,0.95,0.95,1};
		colorCanceled[] = {0.606,0.606,0.606,1};
		colorDone[] = {0.424,0.651,0.247,1};
		colorFailed[] = {0.706,0.0745,0.0196,1};
		color[] = {0.863,0.584,0,1};
		icon = "\ca\ui\data\ui_taskstate_current_CA.paa";
		iconCreated = "\ca\ui\data\ui_taskstate_new_CA.paa";
		iconCanceled = "#(argb,8,8,3)color(0,0,0,0)";
		iconDone = "\ca\ui\data\ui_taskstate_done_CA.paa";
		iconFailed = "\ca\ui\data\ui_taskstate_failed_CA.paa";
		size = 27;
		importance = 1;
		coefMin = 1;
		coefMax = 1;
	};
	class CustomMark {
		color[] = {0.6471,0.6706,0.6235,1};
		icon = "\ca\ui\data\map_waypoint_ca.paa";
		size = 18;
		importance = 1;
		coefMin = 1;
		coefMax = 1;
	};
	class Tree {
		color[] = {0.45,0.64,0.33,0.4};
		icon = "\ca\ui\data\map_tree_ca.paa";
		size = 12;
		importance = "0.9 * 16 * 0.05";
		coefMin = 0.25;
		coefMax = 4;
	};
	class SmallTree {
		color[] = {0.45,0.64,0.33,0.4};
		icon = "\ca\ui\data\map_smalltree_ca.paa";
		size = 12;
		importance = "0.6 * 12 * 0.05";
		coefMin = 0.25;
		coefMax = 4;
	};
	class Bush {
		color[] = {0.45,0.64,0.33,0.4};
		icon = "\ca\ui\data\map_bush_ca.paa";
		size = 14;
		importance = "0.2 * 14 * 0.05";
		coefMin = 0.25;
		coefMax = 4;
	};
	class Church {
		color[] = {0,0.9,0,1};
		icon = "\ca\ui\data\map_church_ca.paa";
		size = 16;
		importance = "2 * 16 * 0.05";
		coefMin = 0.9;
		coefMax = 4;
	};
	class Chapel {
		color[] = {0,0,0,1};
		icon = "\ca\ui\data\map_chapel_ca.paa";
		size = 16;
		importance = "1 * 16 * 0.05";
		coefMin = 0.9;
		coefMax = 4;
	};
	class Cross {
		color[] = {0,0.9,0,1};
		icon = "\ca\ui\data\map_cross_ca.paa";
		size = 16;
		importance = "0.7 * 16 * 0.05";
		coefMin = 0.25;
		coefMax = 4;
	};
	class Rock {
		color[] = {0.1,0.1,0.1,0.8};
		icon = "\ca\ui\data\map_rock_ca.paa";
		size = 12;
		importance = "0.5 * 12 * 0.05";
		coefMin = 0.25;
		coefMax = 4;
	};
	class Bunker {
		color[] = {0,0,0,1};
		icon = "\ca\ui\data\map_bunker_ca.paa";
		size = 14;
		importance = "1.5 * 14 * 0.05";
		coefMin = 0.25;
		coefMax = 4;
	};
	class Fortress {
		color[] = {0,0.9,0,1};
		icon = "\ca\ui\data\map_bunker_ca.paa";
		size = 16;
		importance = "2 * 16 * 0.05";
		coefMin = 0.25;
		coefMax = 4;
	};
	class Fountain {
		color[] = {0.2,0.45,0.7,1};
		icon = "\ca\ui\data\map_fountain_ca.paa";
		size = 11;
		importance = "1 * 12 * 0.05";
		coefMin = 0.25;
		coefMax = 4;
	};
	class ViewTower {
		color[] = {0,0.9,0,1};
		icon = "\ca\ui\data\map_viewtower_ca.paa";
		size = 16;
		importance = "2.5 * 16 * 0.05";
		coefMin = 0.5;
		coefMax = 4;
	};
	class Lighthouse {
		color[] = {0,0.9,0,1};
		icon = "\ca\ui\data\map_lighthouse_ca.paa";
		size = 14;
		importance = "3 * 16 * 0.05";
		coefMin = 0.9;
		coefMax = 4;
	};
	class Quay {
		color[] = {0,0.9,0,1};
		icon = "\ca\ui\data\map_quay_ca.paa";
		size = 16;
		importance = "2 * 16 * 0.05";
		coefMin = 0.5;
		coefMax = 4;
	};
	class Fuelstation {
		color[] = {0,0.9,0,1};
		icon = "\ca\ui\data\map_fuelstation_ca.paa";
		size = 16;
		importance = "2 * 16 * 0.05";
		coefMin = 0.75;
		coefMax = 4;
	};
	class Hospital {
		color[] = {0.78,0,0.05,1};
		icon = "\ca\ui\data\map_hospital_ca.paa";
		size = 16;
		importance = "2 * 16 * 0.05";
		coefMin = 0.5;
		coefMax = 4;
	};
	class BusStop {
		color[] = {0.15,0.26,0.87,1};
		icon = "\ca\ui\data\map_busstop_ca.paa";
		size = 12;
		importance = "1 * 10 * 0.05";
		coefMin = 0.25;
		coefMax = 4;
	};
	class Transmitter {
		color[] = {0,0.9,0,1};
		icon = "\ca\ui\data\map_transmitter_ca.paa";
		size = 20;
		importance = "2 * 16 * 0.05";
		coefMin = 0.9;
		coefMax = 4;
	};
	class Stack {
		color[] = {0,0.9,0,1};
		icon = "\ca\ui\data\map_stack_ca.paa";
		size = 20;
		importance = "2 * 16 * 0.05";
		coefMin = 0.9;
		coefMax = 4;
	};
	class Ruin {
		color[] = {0,0.9,0,1};
		icon = "\ca\ui\data\map_ruin_ca.paa";
		size = 16;
		importance = "1.2 * 16 * 0.05";
		coefMin = 1;
		coefMax = 4;
	};
	class Tourism {
		color[] = {0,0,1,1};
		icon = "\ca\ui\data\map_tourism_ca.paa";
		size = 16;
		importance = "1 * 16 * 0.05";
		coefMin = 0.7;
		coefMax = 4;
	};
	class Watertower {
		color[] = {0.2,0.45,0.7,1};
		icon = "\ca\ui\data\map_watertower_ca.paa";
		size = 20;
		importance = "1.2 * 16 * 0.05";
		coefMin = 0.9;
		coefMax = 4;
	};
	class Waypoint {
		color[] = {0,0,0,1};
		size = 24;
		importance = 1;
		coefMin = 1;
		coefMax = 1;
		icon = "\ca\ui\data\map_waypoint_ca.paa";
	};
	class WaypointCompleted {
		color[] = {0,0,0,1};
		size = 24;
		importance = 1;
		coefMin = 1;
		coefMax = 1;
		icon = "\ca\ui\data\map_waypoint_completed_ca.paa";
	};
};

class RscTitles {
	class Rtags {
		idd=tags_id;
		movingEnable = true;
		fadein = 0;
		fadeout = 0;
		duration = 0.1;
		name="TAGS_HUD";
		
		controlsBackground[] = {"onEachFrameHack"};
		controls[]={
					"marker_01", "marker_02", "marker_03", "marker_04", "marker_05",
					"marker_06", "marker_07", "marker_08", "marker_09", "marker_10",
					"marker_11", "marker_12", "marker_13", "marker_14", "marker_15",
					"marker_16", "marker_17", "marker_18", "marker_19", "marker_20",
					"marker_31", "marker_32", "marker_33", "marker_34", "marker_35",
					"marker_36", "marker_37", "marker_38", "marker_39", "marker_40",
					"marker_41", "marker_42", "marker_43", "marker_44", "marker_45",
					"marker_46", "marker_47", "marker_48", "marker_49", "marker_50",
					"marker_51", "marker_52", "marker_53", "marker_54", "marker_55",
					"marker_56", "marker_57", "marker_58", "marker_59", "marker_50",
					"marker_61", "marker_62", "marker_63", "marker_64", "marker_65",
					"marker_66", "marker_67", "marker_68", "marker_69", "marker_70",
					"marker_71", "marker_72", "marker_73", "marker_74", "marker_75",
					"marker_76", "marker_77", "marker_78", "marker_79", "marker_70",
					"marker_81", "marker_82", "marker_83", "marker_84", "marker_85",
					"marker_86", "marker_87", "marker_88", "marker_89", "marker_90",
					"marker_91", "marker_92", "marker_93", "marker_94", "marker_95",
					"marker_96", "marker_97", "marker_98", "marker_99", "marker_100",
					"name_text"
					};
					
		onLoad="uiNamespace setVariable ['TAGS_HUD', _this select 0]";

		class onEachFrameHack : MAP{ 
			idc = tags_map_id; 
			onDraw = "_this call onEachFrameHack;";
		};
		
		class marker_01 : STEXT{ idc = tags_marker_01;};
		class marker_02 : STEXT{ idc = tags_marker_02;};
		class marker_03 : STEXT{ idc = tags_marker_03;};
		class marker_04 : STEXT{ idc = tags_marker_04;};
		class marker_05 : STEXT{ idc = tags_marker_05;};
		class marker_06 : STEXT{ idc = tags_marker_06;};
		class marker_07 : STEXT{ idc = tags_marker_07;};
		class marker_08 : STEXT{ idc = tags_marker_08;};
		class marker_09 : STEXT{ idc = tags_marker_09;};
		class marker_10 : STEXT{ idc = tags_marker_10;};
		class marker_11 : STEXT{ idc = tags_marker_11;};
		class marker_12 : STEXT{ idc = tags_marker_12;};
		class marker_13 : STEXT{ idc = tags_marker_13;};
		class marker_14 : STEXT{ idc = tags_marker_14;};
		class marker_15 : STEXT{ idc = tags_marker_15;};
		class marker_16 : STEXT{ idc = tags_marker_16;};
		class marker_17 : STEXT{ idc = tags_marker_17;};
		class marker_18 : STEXT{ idc = tags_marker_18;};
		class marker_19 : STEXT{ idc = tags_marker_19;};
		class marker_20 : STEXT{ idc = tags_marker_20;};
		class marker_21 : STEXT{ idc = tags_marker_21;};
		class marker_22 : STEXT{ idc = tags_marker_22;};
		class marker_23 : STEXT{ idc = tags_marker_23;};
		class marker_24 : STEXT{ idc = tags_marker_24;};
		class marker_25 : STEXT{ idc = tags_marker_25;};
		class marker_26 : STEXT{ idc = tags_marker_26;};
		class marker_27 : STEXT{ idc = tags_marker_27;};
		class marker_28 : STEXT{ idc = tags_marker_28;};
		class marker_29 : STEXT{ idc = tags_marker_29;};
		class marker_30 : STEXT{ idc = tags_marker_30;};
		class marker_31 : STEXT{ idc = tags_marker_31;};
		class marker_32 : STEXT{ idc = tags_marker_32;};
		class marker_33 : STEXT{ idc = tags_marker_33;};
		class marker_34 : STEXT{ idc = tags_marker_34;};
		class marker_35 : STEXT{ idc = tags_marker_35;};
		class marker_36 : STEXT{ idc = tags_marker_36;};
		class marker_37 : STEXT{ idc = tags_marker_37;};
		class marker_38 : STEXT{ idc = tags_marker_38;};
		class marker_39 : STEXT{ idc = tags_marker_39;};
		class marker_40 : STEXT{ idc = tags_marker_40;};
		class marker_41 : STEXT{ idc = tags_marker_41;};
		class marker_42 : STEXT{ idc = tags_marker_42;};
		class marker_43 : STEXT{ idc = tags_marker_43;};
		class marker_44 : STEXT{ idc = tags_marker_44;};
		class marker_45 : STEXT{ idc = tags_marker_45;};
		class marker_46 : STEXT{ idc = tags_marker_46;};
		class marker_47 : STEXT{ idc = tags_marker_47;};
		class marker_48 : STEXT{ idc = tags_marker_48;};
		class marker_49 : STEXT{ idc = tags_marker_49;};
		class marker_50 : STEXT{ idc = tags_marker_50;};
		class marker_51 : STEXT{ idc = tags_marker_51;};
		class marker_52 : STEXT{ idc = tags_marker_52;};
		class marker_53 : STEXT{ idc = tags_marker_53;};
		class marker_54 : STEXT{ idc = tags_marker_54;};
		class marker_55 : STEXT{ idc = tags_marker_55;};
		class marker_56 : STEXT{ idc = tags_marker_56;};
		class marker_57 : STEXT{ idc = tags_marker_57;};
		class marker_58 : STEXT{ idc = tags_marker_58;};
		class marker_59 : STEXT{ idc = tags_marker_59;};
		class marker_60 : STEXT{ idc = tags_marker_60;};
		class marker_61 : STEXT{ idc = tags_marker_61;};
		class marker_62 : STEXT{ idc = tags_marker_62;};
		class marker_63 : STEXT{ idc = tags_marker_63;};
		class marker_64 : STEXT{ idc = tags_marker_64;};
		class marker_65 : STEXT{ idc = tags_marker_65;};
		class marker_66 : STEXT{ idc = tags_marker_66;};
		class marker_67 : STEXT{ idc = tags_marker_67;};
		class marker_68 : STEXT{ idc = tags_marker_68;};
		class marker_69 : STEXT{ idc = tags_marker_69;};
		class marker_70 : STEXT{ idc = tags_marker_70;};
		class marker_71 : STEXT{ idc = tags_marker_71;};
		class marker_72 : STEXT{ idc = tags_marker_72;};
		class marker_73 : STEXT{ idc = tags_marker_73;};
		class marker_74 : STEXT{ idc = tags_marker_74;};
		class marker_75 : STEXT{ idc = tags_marker_75;};
		class marker_76 : STEXT{ idc = tags_marker_76;};
		class marker_77 : STEXT{ idc = tags_marker_77;};
		class marker_78 : STEXT{ idc = tags_marker_78;};
		class marker_79 : STEXT{ idc = tags_marker_79;};
		class marker_80 : STEXT{ idc = tags_marker_80;};
		class marker_81 : STEXT{ idc = tags_marker_81;};
		class marker_82 : STEXT{ idc = tags_marker_82;};
		class marker_83 : STEXT{ idc = tags_marker_83;};
		class marker_84 : STEXT{ idc = tags_marker_84;};
		class marker_85 : STEXT{ idc = tags_marker_85;};
		class marker_86 : STEXT{ idc = tags_marker_86;};
		class marker_87 : STEXT{ idc = tags_marker_87;};
		class marker_88 : STEXT{ idc = tags_marker_88;};
		class marker_89 : STEXT{ idc = tags_marker_89;};
		class marker_90 : STEXT{ idc = tags_marker_90;};
		class marker_91 : STEXT{ idc = tags_marker_91;};
		class marker_92 : STEXT{ idc = tags_marker_92;};
		class marker_93 : STEXT{ idc = tags_marker_93;};
		class marker_94 : STEXT{ idc = tags_marker_94;};
		class marker_95 : STEXT{ idc = tags_marker_95;};
		class marker_96 : STEXT{ idc = tags_marker_96;};
		class marker_97 : STEXT{ idc = tags_marker_97;};
		class marker_98 : STEXT{ idc = tags_marker_98;};
		class marker_99 : STEXT{ idc = tags_marker_99;};
		class marker_100 : STEXT{ idc = tags_marker_100;};
		class name_text : STEXT{ idc = tags_name_id;};
	};
};