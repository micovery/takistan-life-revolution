
class RscText1
{
  type = CT_STATIC;
  idc = -1;
  style = ST_LEFT;
  
  x = 0.0;
  y = 0.0;
  w = 0.3;
  h = Dlg_CONTROLHGT;
  sizeEx = Dlg_TEXTHGT;
  
	colorBackground[] = Dlg_ColorAttribute_Clear;
  //colorBackground[] = {Dlg_ColorScheme_3DControlBackground, 1};
  colorText[] = {Dlg_ColorScheme_DialogText, 1};
  font = FontM_R;
  
  text = "";

};

//-------------------------------------

class RscLine: RscText1
{
  style = ST_LINE;
  
  text = "";
  x = 0.0;
  y = 0.0;
  w = 0.0;
  h = 0.0;
};

//-------------------------------------

class RscFrame
{
  type = CT_STATIC;
  idc = -1;
  style = ST_FRAME;

  x = 0.0;
  y = 0.0;
  w = 1.0;
  h = 1.0;
  sizeEx = Dlg_TEXTHGT;
  
  colorBackground[] = {Dlg_ColorScheme_Red, 1}; // unused?
  colorText[] = {Dlg_ColorScheme_Yellow, 1}; // unused?
  font = FontM_R;

  text = "";
};

//-------------------------------------

class RscActiveText
{
  type = CT_ACTIVETEXT;
  idc = -1;
  style = ST_LEFT;
  
  sizeEx = Dlg_TEXTHGT;
  x = 0.1;
  y = 0.1;
  w = 0.2;
  h = Dlg_CONTROLHGT;  
  
  color[] = {Dlg_ColorScheme_WindowText,1};
  colorActive[] = {Dlg_ColorScheme_3DControlFocus,1};
  font = FontM_R;
  
  soundEnter[] = {"\ca\ui\data\sound\mouse2", 0.2, 1};
  soundPush[] = {"\ca\ui\data\sound\new1", 0.2, 1};
  soundClick[] = {"\ca\ui\data\sound\mouse3", 0.2, 1};
  soundEscape[] = {"\ca\ui\data\sound\mouse1", 0.2, 1};
  
  text = "";
  default = false;
};

//-------------------------------------

class RscButton1
{
  type = CT_BUTTON;
  idc = -1;
  style = ST_CENTER;
  
  x = 0.0;
  y = 0.0;
  w = 0.1;
  h = Dlg_CONTROLHGT;
  sizeEx = Dlg_TEXTHGT;
  offsetX = 0;
  offsetY = 0;
  offsetPressedX = 0;
  offsetPressedY = 0;
  borderSize = 0.001;
  
  colorText[] = {Dlg_ColorScheme_3DControlText,1};
  colorBackground[] = {Dlg_ColorScheme_3DControlBackground, 1};
  colorFocused[] = {Dlg_ColorScheme_3DControlFocus,1};

  colorShadow[] = {Dlg_Color_Pink,0.2};
  colorBorder[] = {Dlg_Color_White,0.2};
  colorBackgroundActive[] = {Dlg_ColorScheme_3DControlFocus /* Dlg_ColorScheme_HighlightBackground */ , 1.0};
  colorDisabled[] = {Dlg_Color_Gray_7, 0.7};
  colorBackgroundDisabled[] = {Dlg_ColorScheme_3DControlBackground,0.3};
  font = FontM_R;

  soundEnter[] = {"\ca\ui\data\sound\mouse2", 0.2, 1};
  soundPush[] = {"\ca\ui\data\sound\new1", 0.2, 1};
  soundClick[] = {"\ca\ui\data\sound\mouse3", 0.2, 1};
  soundEscape[] = {"\ca\ui\data\sound\mouse1", 0.2, 1};

  default = false;
  text = "";
  action = "";

  // events
  onButtonClicked = "";
 	onButtonDown = "";
 	onButtonUp = "";
};

//-------------------------------------

class RscShortcutButton: RscButton1
{
  type = CT_SHORTCUT_BUTTON;

  h = 1.5*Dlg_CONTROLHGT;
  sizeEx = Dlg_CONTROLHGT;
  size = Dlg_CONTROLHGT;

	period = 0.4;
	periodFocus = 0.6;
	periodOver = 0.4;

	color[] = {0.95, 0.95, 0.95, 1};
	color2[] = {1, 1, 1, 0.4};
	colorBackground[] = {1, 1, 1, 1};
	colorbackground2[] = {1, 1, 1, 0.4};
	colorDisabled[] = {1, 1, 1, 0.25};

	class HitZone {
		left = 0.002;
		top = 0.003;
		right = 0.002;
		bottom = 0.003; //0.016;
	};
	
	class ShortcutPos {
		left = -0.006;
		top = -0.007;
		w = 0.0392157;
		h = 2*Dlg_CONTROLHGT; //0.0522876;
	};
	
	class TextPos {
		left = 0.008; // indent
		top = 0.002;
		right = 0.002;
		bottom = 0.002; //0.016;
	};

	class Attributes {
		font = "Zeppelin32";
		color = "#E5E5E5";
		align = "center";
		shadow = "true";
	};
	
	class AttributesImage {
		font = "Zeppelin32";
		color = "#E5E5E5";
		align = "left";
	};

	animTextureNormal = "\ca\ui\data\igui_button_normal_ca.paa";
	animTextureDisabled = "\ca\ui\data\igui_button_disabled_ca.paa";
	animTextureOver = "\ca\ui\data\igui_button_over_ca.paa";
	animTextureFocused = "\ca\ui\data\igui_button_focus_ca.paa";
	animTexturePressed = "\ca\ui\data\igui_button_down_ca.paa";
	animTextureDefault = "\ca\ui\data\igui_button_normal_ca.paa";
	animTextureNoShortcut = "\ca\ui\data\igui_button_normal_ca.paa";
	textureNoShortcut = "";
};

class RscEdit1
{
  type = CT_EDIT;
  idc = -1;
  style = ST_LEFT;

  w = 0.1;
  h = Dlg_CONTROLHGT;
  sizeEx = Dlg_TEXTHGT;

  colorText[] = {Dlg_ColorScheme_WindowText,1};
  colorSelection[] = {Dlg_ColorScheme_HighlightBackground,1};
  colorBackground[] = {Dlg_ColorScheme_3DControlBackground, 1}; // unused?
  font = FontM_R;

  autocomplete = false;
  text = "";
};

class RscLB_LIST
{
  // type = defined in derived class
  idc = -1;
  style = LB_TEXTURES; //ST_LEFT; // LB_TEXTURES sets scrollbar to texture instead of box outline

  h = Dlg_CONTROLHGT;
  sizeEx = Dlg_TEXTHGT;
  rowHeight = Dlg_CONTROLHGT;
	//wholeHeight = 0.30;

  color[] = {Dlg_Color_White,1};
  colorText[] = {Dlg_ColorScheme_WindowText,1};
  colorBackground[] = {Dlg_ColorScheme_3DControlBackground, 1}; // always clear?
  colorSelect[] = {Dlg_ColorScheme_WindowText,1};
  colorSelect2[] = {Dlg_ColorScheme_WindowText,1};
  colorScrollbar[] = {Dlg_Color_Maroon,1};
  colorSelectBackground[] = {Dlg_ColorScheme_HighlightBackground,1};
  colorSelectBackground2[] = {Dlg_ColorScheme_3DControlFocus,1};
  font = FontM_R;
  
	arrowEmpty = "\ca\ui\data\ui_arrow_combo_ca.paa";
	arrowFull = "\ca\ui\data\ui_arrow_combo_active_ca.paa";
  soundSelect[] = {"\ca\ui\data\sound\mouse3", 0.2, 1};
  soundExpand[] = {"\ca\ui\data\sound\mouse2", 0.2, 1};
  soundCollapse[] = {"\ca\ui\data\sound\mouse1", 0.2, 1};

  maxHistoryDelay = 1.0;

  // events
 	onLBSelChanged = "";
 	onLBListSelChanged = "";
 	onLBDblClick = "";
 	onLBDrag = "";
 	onLBDragging = "";
 	onLBDrop = "";

	class ScrollBar {
		color[] = {1, 1, 1, 0.6};
		colorActive[] = {1, 1, 1, 1};
		colorDisabled[] = {1, 1, 1, 0.3};
		thumb = "\ca\ui\data\ui_scrollbar_thumb_ca.paa";
		arrowFull = "\ca\ui\data\ui_arrow_top_active_ca.paa";
		arrowEmpty = "\ca\ui\data\ui_arrow_top_ca.paa";
		border = "\ca\ui\data\ui_border_scroll_ca.paa";
	};
};

class RscListBox1: RscLB_LIST
{
  type = CT_LISTBOX;

	autoScrollSpeed = -1;
	autoScrollDelay = 5;
	autoScrollRewind = 0;
};


class RscCombo1: RscLB_LIST
{
  type = CT_COMBO;

  wholeHeight = 0.3;

  colorSelectBackground[] = {Dlg_ColorScheme_3DControlFocus,1};
};


class RscToolbox // RscCheckboxes // actually more like "toggle buttons"
{
  idc = -1;
	type = CT_CHECKBOXES;
	style = ST_LEFT;

  rows = 3;
  columns = 2;
  strings[] = {"Blank"}; // array of strings
  values[] = {0}; // array of numbers (0/1)

  sizeEx = Dlg_TEXTHGT; // text hgt
  x = 0.1;
  y = 0.18;
  w = 0.15;
  h = Dlg_CONTROLHGT; // surrounding box + row gaps

  coloSelectedBg[] = {Dlg_ColorScheme_3DControlFocus,1};
  //colorSelectedBg[] = {Dlg_ColorScheme_3DControlFocus,1}; // was coloSelectedBG in v1.02
  //colorSelectedBG[] = {Dlg_ColorScheme_3DControlFocus,1};
  color[] = {Dlg_Color_White,1}; // required but unused
  colorText[] = {Dlg_Color_Gray_8, 0.7};
  colorTextSelect[] = {Dlg_ColorScheme_WindowText,1};
  colorSelect[] = {Dlg_ColorScheme_3DControlFocus, 1};
  colorTextDisable[] = {Dlg_Color_Gray_5, 0.7};
  colorDisable[] = {Dlg_Color_Gray_4, 0.5};
  font = FontM_R;
  
  onCheckBoxesSelChanged = ""; // params: [control, elementIndex, newState]
};


class RscObject
{
	type = CT_OBJECT;

	scale = 1.0;
	direction[] = {0, 0, 1};
	up[] = {0, 1, 0};
};


class Rsc3DStatic
{
	type = CT_3DSTATIC;
	style = ST_LEFT;

	size = Dlg_TEXTHGT;
	angle = 0;

	color[] = {Dlg_Color_Black,1};
	font = FontM_R;

	selection = "display";
};


class RscPicture1
{
	type = CT_STATIC;
	idc = -1;
	style = ST_PICTURE;

	sizeEx = Dlg_TEXTHGT;

	colorBackground[] = Dlg_ColorAttribute_Clear;
	colorText[] = {Dlg_ColorScheme_WindowText, 1};
	font = FontM_R;

  text = "";
};


class RscHTML
{
  type = CT_HTML;
  idc = -1;
  style = ST_LEFT;
  
	colorText[] = {Dlg_ColorScheme_WindowText,1};
	colorLink[] = {0.05, 0.2, 0.05, 1};
	colorBold[] = {0, 1, 1, 1};
	colorBackground[] = {Dlg_ColorScheme_3DControlBackground, 1};
	colorLinkActive[] = {0, 0, 0.2, 1};


	prevPage = "\ca\ui\data\arrow_left_ca.paa";
	nextPage = "\ca\ui\data\arrow_right_ca.paa";
	filename = "";
	
  // events
  onHTMLLink = "";

	class HeadingStyle {
		font = "Zeppelin32";
		fontBold = "Zeppelin33";
		sizeEx = Dlg_TEXTHGT;
	};
	
	class H1: HeadingStyle {
		sizeEx = Dlg_TEXTHGT * 1.5;
	};
	
	class H2: HeadingStyle {
		sizeEx = Dlg_TEXTHGT * 1.4;
	};
	
	class H3: HeadingStyle {
		sizeEx = Dlg_TEXTHGT * 1.3;
	};
	
	class H4: HeadingStyle {
		sizeEx = Dlg_TEXTHGT * 1.2;
	};
	
	class H5: HeadingStyle {
		sizeEx = Dlg_TEXTHGT * 1.1;
	};
	
	class H6: HeadingStyle {
		sizeEx = Dlg_TEXTHGT;
	};
	
	class P: HeadingStyle {
		sizeEx = Dlg_TEXTHGT;
	};
};

class RscStructuredText
{
	//access = ReadAndWrite;
  type = CT_STRUCTURED_TEXT;
	idc = -1;
  style = ST_MULTI;
  
	lineSpacing = 1;
	w = 0.1;
	h = 0.05;
	sizeEx = Dlg_CONTROLHGT; // Dlg_TEXTHGT ?
  size = Dlg_TEXTHGT;

	colorBackground[] = Dlg_ColorAttribute_Clear;
	//colorBackground[] = {Dlg_ColorScheme_3DControlBackground, 1};
	colorText[] = {Dlg_ColorScheme_DialogText, 1};

	text = "";

  class Attributes
  {
     font = FontM_R;
     color = "#ffffff";
     align = "left";
     shadow = false;
  };
};


class RscMapControl 
{
  type = CT_MAP_MAIN;
  idc = -1;
  style = ST_PICTURE;

  x = 0.1;
  y = 0.1;
  w = 0.3;
  h = 0.3;

  colorSea[] = {0.56, 0.8, 0.98, 0.5};
	colorForest[] = {0.6, 0.8, 0.2, 0.5};
	colorRocks[] = {0.6, 0.45, 0.27, 0.4};
	colorCountlines[] = {0.7, 0.55, 0.3, 0.6};
	colorCountlinesWater[] = {0, 0.53, 1, 0.5};
  colorMainCountlines[] = {0.65, 0.45, 0.27, 1};
  colorMainCountlinesWater[] = {0, 0.53, 1, 1};
  colorPowerLines[] = {Dlg_Color_Black, 1};
	colorRailWay[] = {0.8, 0.2, 0, 1};
  colorLevels[] = {Dlg_Color_Black, 1};
	colorForestBorder[] = {0.4, 0.8, 0, 1};
	colorRocksBorder[] = {0.6, 0.45, 0.27, 0.4};
	colorNames[] = {Dlg_Color_Black, 1};
	colorInactive[] = {Dlg_Color_White, 0.5};
	colorOutside[] = {0, 0, 0, 1};
  colorBackground[] = {Dlg_Color_White, 1};
  colorText[] = {Dlg_Color_White, 1};
  
  font = "Zeppelin32";
  sizeEx = 0.05;
  
  fontLabel = "Zeppelin32";
	sizeExLabel = 0.0286458;
	fontGrid = "Zeppelin32";
	sizeExGrid = 0.0286458;
	fontUnits = "Zeppelin32";
	sizeExUnits = 0.0286458;
	fontNames = "Zeppelin32";
	sizeExNames = 0.0286458;
	fontInfo = "Zeppelin32";
	sizeExInfo = 0.0286458;
	fontLevel = "Zeppelin32";
	sizeExLevel = 0.0286458;
  
  ptsPerSquareSea	= 6;
  ptsPerSquareTxt	= 8;
  ptsPerSquareCLn	= 8;
  ptsPerSquareExp	= 8;
  ptsPerSquareCost = 8;
  ptsPerSquareFor = "4.0f";
  ptsPerSquareForEdge = "10.0f";
  ptsPerSquareRoad = 2;
  ptsPerSquareObj = 10;
	
	text = "\ca\ui\data\map_background2_co.paa";
  ShowCountourInterval = 0;
	maxSatelliteAlpha = 0.75;
	alphaFadeStartScale = 0.15;
	alphaFadeEndScale = 0.29;
  scaleDefault = 0.1;
  onMouseButtonClick = "";
  onMouseButtonDblClick = "";
	
	class Task {
		icon = "\ca\ui\data\ui_taskstate_current_CA.paa";
		iconCreated = "\ca\ui\data\ui_taskstate_new_CA.paa";
		iconCanceled = "#(argb,8,8,3)color(0,0,0,0)";
		iconDone = "\ca\ui\data\ui_taskstate_done_CA.paa";
		iconFailed = "\ca\ui\data\ui_taskstate_failed_CA.paa";
		color[] = {0.863, 0.584, 0.0, 1};
		colorCreated[] = {0.95, 0.95, 0.95, 1};
		colorCanceled[] = {0.606, 0.606, 0.606, 1};
		colorDone[] = {0.424, 0.651, 0.247, 1};
		colorFailed[] = {0.706, 0.0745, 0.0196, 1};
		size = 27;
		importance = 1;
		coefMin = 1;
		coefMax = 1;
	};
	
  class ActiveMarker {
    color[] = {0.3, 0.1, 0.9, 1};
    size	= 50;
  };

	class Legend {
		x = 0.729;
		y = 0.05;
		w = 0.237;
		h = 0.127;
		font = "Zeppelin32";
		sizeEx = 0.0208333;
		colorBackground[] = {0.906, 0.901, 0.88, 0.8};
		color[] = {Dlg_Color_Black, 1};
	};
	
	class Bunker {
    color[] = {0, 0.35, 0.7, 1};
		icon = "\ca\ui\data\map_bunker_ca.paa";
		size = 14;
		importance = 1.5 * 14 * 0.05;
		coefMin = 0.25;
		coefMax = 4;
	};
	
	class Bush {
		icon = "\ca\ui\data\map_bush_ca.paa";
		color[] = {0.55, 0.64, 0.43, 1};
		size = 14;
		importance = 0.2 * 14 * 0.05;
		coefMin = 0.25;
		coefMax = 4;
	};
	
	class BusStop {
		icon = "\ca\ui\data\map_busstop_ca.paa";
		color[] = {0, 0, 1, 1};
		size = 10;
		importance = 1 * 10 * 0.05;
		coefMin = 0.25;
		coefMax = 4;
	};
	
	class Command {
		icon = "#(argb,8,8,3)color(1,1,1,1)";
		color[] = {0, 0.9, 0, 1};
		size = 18;
		importance = 1;
		coefMin = 1;
		coefMax = 1;
	};
	
	class Cross {
	color[] = {0, 0.35, 0.7, 1};
		icon = "\ca\ui\data\map_cross_ca.paa";
		size = 16;
		importance = 0.7 * 16 * 0.05;
		coefMin = 0.25;
		coefMax = 4;
	};
	
	class CustomMark {
		icon = "\ca\ui\data\map_waypoint_ca.paa";
		color[] = {0.6471, 0.6706, 0.6235, 1.0};
		size = 18;
		importance = 1;
		coefMin = 1;
		coefMax = 1;
	};
	
	class Fortress {
		icon = "\ca\ui\data\map_bunker_ca.paa";
	color[] = {0, 0.35, 0.7, 1};
		size = 16;
		importance = 2 * 16 * 0.05;
		coefMin = 0.25;
		coefMax = 4;
	};
	
	class Fuelstation {
		icon = "\ca\ui\data\map_fuelstation_ca.paa";
	color[] = {1.0, 0.35, 0.35, 1};
		size = 16;
		importance = 2 * 16 * 0.05;
		coefMin = 0.75;
		coefMax = 4;
	};
	
	class Fountain {
		icon = "\ca\ui\data\map_fountain_ca.paa";
		color[] = {0, 0.35, 0.7, 1};
		size = 12;
		importance = 1 * 12 * 0.05;
		coefMin = 0.25;
		coefMax = 4;
	};
	
	class Hospital {
		icon = "\ca\ui\data\map_hospital_ca.paa";
		color[] = {0.78, 0, 0.05, 1};
		size = 16;
		importance = 2 * 16 * 0.05;
		coefMin = 0.5;
		coefMax = 4;
	};
	
	class Chapel {
		icon = "\ca\ui\data\map_chapel_ca.paa";
	color[] = {0, 0.35, 0.7, 1};
		size = 16;
		importance = 1 * 16 * 0.05;
		coefMin = 0.9;
		coefMax = 4;
	};
	
	class Church {
		icon = "\ca\ui\data\map_church_ca.paa";
	color[] = {0, 0.35, 0.7, 1};
		size = 16;
		importance = 2 * 16 * 0.05;
		coefMin = 0.9;
		coefMax = 4;
	};
	
	class Lighthouse {
		icon = "\ca\ui\data\map_lighthouse_ca.paa";
		color[] = {0.78, 0, 0.05, 1};
		size = 20;
		importance = 3 * 16 * 0.05;
		coefMin = 0.9;
		coefMax = 4;
	};
	
	class Quay {
		icon = "\ca\ui\data\map_quay_ca.paa";
	color[] = {0, 0.35, 0.7, 1};
		size = 16;
		importance = 2 * 16 * 0.05;
		coefMin = 0.5;
		coefMax = 4;
	};
	
	class Rock {
	color[] = {0.35, 0.35, 0.35, 1};
		icon = "\ca\ui\data\map_rock_ca.paa";
		size = 12;
		importance = 0.5 * 12 * 0.05;
		coefMin = 0.25;
		coefMax = 4;
	};
	
	class Ruin {
		icon = "\ca\ui\data\map_ruin_ca.paa";
		color[] = {0.78, 0, 0.05, 1};
		size = 16;
		importance = 1.2 * 16 * 0.05;
		coefMin = 1;
		coefMax = 4;
	};
	
	class SmallTree {
		icon = "\ca\ui\data\map_smalltree_ca.paa";
		color[] = {0.55, 0.64, 0.43, 1};
		size = 12;
		importance = 0.6 * 12 * 0.05;
		coefMin = 0.25;
		coefMax = 4;
	};
	
	class Stack {
		icon = "\ca\ui\data\map_stack_ca.paa";
  color[] = {0, 0.35, 0.7, 1};
		size = 20;
		importance = 2 * 16 * 0.05;
		coefMin = 0.9;
		coefMax = 4;
	};
	
	class Tree {
		icon = "\ca\ui\data\map_tree_ca.paa";
		color[] = {0.55, 0.64, 0.43, 1};
		size = 12;
		importance = 0.9 * 16 * 0.05;
		coefMin = 0.25;
		coefMax = 4;
	};
	
	class Tourism {
		icon = "\ca\ui\data\map_tourism_ca.paa";
		color[] = {0.78, 0, 0.05, 1};
		size = 16;
		importance = 1 * 16 * 0.05;
		coefMin = 0.7;
		coefMax = 4;
	};
	
	class Transmitter {
		icon = "\ca\ui\data\map_transmitter_ca.paa";
	color[] = {0, 0.35, 0.7, 1};
		size = 20;
		importance = 2 * 16 * 0.05;
		coefMin = 0.9;
		coefMax = 4;
	};
	
	class ViewTower {
		icon = "\ca\ui\data\map_viewtower_ca.paa";
	color[] = {0, 0.35, 0.7, 1};
		size = 16;
		importance = 2.5 * 16 * 0.05;
		coefMin = 0.5;
		coefMax = 4;
	};
	
	class Watertower {
		icon = "\ca\ui\data\map_watertower_ca.paa";
		color[] = {0, 0.35, 0.7, 1};
		size = 32;
		importance = 1.2 * 16 * 0.05;
		coefMin = 0.9;
		coefMax = 4;
	};
	
	class Waypoint {
		icon = "\ca\ui\data\map_waypoint_ca.paa";
  	color[] = {0, 0.35, 0.7, 1};
  	size = 32;
  	coefMin = 1.00;
  	coefMax = 1.00;
  	importance = 1.00;
	};
	
	class WaypointCompleted {
		icon = "\ca\ui\data\map_waypoint_completed_ca.paa";
  	color[] = {Dlg_Color_Black, 1};
  	size = 24;
  	importance = 1.00;
  	coefMin = 1.00;
  	coefMax = 1.00;
	};
};

//-------------------------------------

class RscMap 
{
	//access = ReadAndWrite;
	
	class controls {
		class Map : RscMapControl {
			moveOnEdges = 0;
			x = 0;
			y = 0;
			w = 0.83;
			h = 1;
		};
	};
};

//=============================================================================
// Some common class definitions - most dialogs need a background, frame, etc

class Dlg_FullBackground: RscText1
{
  x = 0.0;
  y = 0.0;
  w = 1.0;
  h = 1.0;

  colorBackground[] = {Dlg_ColorScheme_DialogBackground,0.7};
};

//-------------------------------------

class Dlg_FullBackgroundFrame: RscFrame
{
  x = 0.0;
  y = 0.0;
  w = 1.0;
  h = 1.0;

  text = " Selection Dialog ";
};

//-------------------------------------

class Dlg_Caption: RscText1
{
  //TODO style = ST_HUD_BACKGROUND+ST_LEFT;
  x = 0.0;
  y = 0.0;
  w = 0.3;

  colorBackground[] = {Dlg_ColorScheme_CaptionBackground, 1};
  colorText[] = {Dlg_ColorScheme_CaptionText, 1};
};

//-------------------------------------

class Dlg_WindowCaption: Dlg_Caption
{
  x = 0.0;
  y = 0.0;
  w = 1.0;
};

//-------------------------------------

class Dlg_BG: RscText1
{
  colorBackground[] = {Dlg_ColorScheme_3DControlBackground, 1};
};

//-------------------------------------

class Dlg_GroupBox: RscText1
{
  colorBackground[] = {Dlg_ColorScheme_WindowBackground, 1};
  colorText[] = {Dlg_ColorScheme_CaptionText, 1};
};

//-------------------------------------

class Dlg_CloseIcon: RscPicture1
{
  x = 0.00;
  y = 0.00;
  w = Dlg_ICONWIDTH;
  h = Dlg_CONTROLHGT;

  text = "\ca\ui\textures\mission_locked.paa"; // "X" close icon
};

//-------------------------------------

class Dlg_IconButton: RscButton1
{
  x = 0.00;
  y = 0.00;
  w = Dlg_ICONWIDTH;
  h = Dlg_CONTROLHGT;

  colorBackground[] = Dlg_ColorAttribute_Clear;
  colorBackgroundActive[] = {Dlg_ColorScheme_HighlightBackground,0.3};
};

//-------------------------------------

class RscMemo: RscStructuredText
{
	type = CT_STATIC;
	style = ST_LEFT + ST_MULTI;

  font = FontM_R;
};

//-------------------------------------

class RscControlsGroup
{
	type = CT_CONTROLS_GROUP;
	idc = -1;
  style = ST_LEFT;
  
  x = 0.1;
  y = 0.1;
  w = 0.3;
  h = 0.3;
  
  class VScrollbar
  {
    color[] = {1, 1, 1, 1};
    width = 0.021;
  };

  class HScrollbar
  {
    color[] = {1, 1, 1, 1};
    height = 0.028;
  };

  class Controls {};
};


// Recruit script classes
class HW_RscPicture {
	idc = -1; 
	type = CT_STATIC;
	style = ST_PICTURE;
	colorBackground[] = { };
	colorText[] = { };
	font = FontM;
	sizeEx = 0.023;
	text = "\ca\ui\data\ui_background_controlers_ca.paa";
}; 

