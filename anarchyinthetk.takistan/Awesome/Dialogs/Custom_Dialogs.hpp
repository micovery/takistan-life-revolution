class Option_Window_2 {
	idd = 3002;
	movingEnable = true;
	controlsBackground[] = {DLG_BACK1};
	objects[] = { };
	controls[] = {TEXT, OPTION1, OPTION2, close, dummybutton};

	class DLG_BACK1: HW_RscPicture {
		x = 0.31; y = 0.09;
		w = 0.43; h = 0.35;
	};
	
	class TEXT : RscText {
		idc	=	1;
		x	=	0.32; y	=	0.15;
		w	=	0.30; h	=	0.04;
		text = "";
	};
	
	class OPTION1 : RscShortcutButton {
		idc = 2;
		x = 0.32; y = 0.20;
		w = 0.30; h = 0.04;
		text = "";
		action = "";
	};

	class OPTION2 : RscShortcutButton {
		idc = 3;
		x = 0.32; y = 0.25;
		w = 0.30; h = 0.04;
		text = "";
		action = "";
	};

	class close : RscShortcutButton {
		idc = 4;
		x = 0.32; y = 0.32;
		w = 0.30; h = 0.04;
		text = "Close";
		action = "closeDialog 0;";
	};

	class dummybutton : RscDummy {idc = 1030;};
};


class Change_Clothes {
	idd = 3001;
	movingEnable = true;
	controlsBackground[] = {DLG_BACK1};
	objects[] = { };
	controls[] = {original_clothes, change_original, Clothes_List, change_new, close, dummybutton};


	class DLG_BACK1: HW_RscPicture {
		x = 0.31; y = 0.09;
		w = 0.60; h = 0.90;
	};

	class original_clothes : RscText {
		idc	=	1;
		x	=	0.32; y	=	0.20;
		w	=	0.42; h	=	0.04;
		text = "WIP";
	};

	class change_original : RscShortcutButton {
		idc = 2;
		x = 0.32; y = 0.25;
		w = 0.42; h = 0.04;
		text = "Original Clothes";
	};

	class Clothes_List : RscListBox {
		idc = 3;
		x = 0.32; y = 0.30;
		w = 0.42; h = 0.30;
	};

	class change_new : RscShortcutButton {
		idc = 4;
		x = 0.32; y = 0.63;
		w = 0.42; h = 0.04;
		text = "Switch Clothes";
		action = "";
	};

	class close : RscShortcutButton {
		x = 0.32; y = 0.81;
		w = 0.42; h = 0.04;
		text = "Close";
		action = "closeDialog 0;";
	};

	class dummybutton : RscDummy {idc = 1030;};
};


class Clothes_Dialog {
	idd = 3003;
	movingEnable = true;
	controlsBackground[] = {
		Clothes_Frame,			// IDC: 1800
		Texture_Frame,			// IDC: 1804
		Camera_Frame,			// IDC: 1803
		Main_PICTURE,
		Texture_PICTURE,
		Camera_PICTURE
	};	
	
	objects[] = { };
	
	controls[] = {
		// Clothes Buttons
		Buy_Change_Button,		// IDC: 1702
		Buy_Button,				// IDC: 1701
		Preview_Button,			// IDC: 1700
		Stores_Button,			// IDC: 1704
		Cancel_Button,			// IDC: 1703
		
		// Camera Buttons
		Camera_Zoom_In,			// IDC: 1706
		Camera_Zoom_Out,		// IDC: 1707
		Camera_Front,			// IDC: 1708
		Camera_Back,			// IDC: 1709
		Camera_Left,			// IDC: 1710
		Camera_Right,			// IDC: 1711
		
		// Texture Buttons
		Reset_Apply,			// IDC: 1713
		Reset_Slot_Button,		// IDC: 1712
		Reset_All_Button,		// IDC: 1705
		
		// Clothes Titles
		Clothes_Title,			// IDC: 1000
		
		// Camera Titles
		Camera_Title,			// IDC: 1001
		
		// Texture Titles
		Texture_Title,			// IDC: 1002
		Custom_Text,			// IDC: 1008
		Style_Text,				// IDC: 1003
		Format_Text,			// IDC: 1004
		Width_Text,				// IDC: 1005
		Height_Text,			// IDC: 1006
		Minimaps_Text,			// IDC: 1007
		Custom_Text1,			// IDC: 1009
		Custom_Text2,			// IDC: 1010
		Custom_Text3,			// IDC: 1011
		Custom_Text4,			// IDC: 1012
		Custom_Text5,			// IDC: 1013
		
		// Clothes Lists
		Clothes_List_1,			// IDC: 1500
		Clothes_List_2,			// IDC: 1501
		
		// Texture Lists
		Texture_List,			// IDC: 1502
		
		// Combo lists
		Style_Box,				// IDC: 2100
		Format_Drop,			// IDC: 2101
		Width_Box,				// IDC: 2102
		Height_Box,				// IDC: 2103
		Minimaps_Drop,			// IDC: 2104
		Custom_Drop,			// IDC: 2105
		
		// Edit lists
		Edit_1,					// IDC: 1400
		Edit_2,					// IDC: 1401
		Edit_3,					// IDC: 1402					
		Edit_4,					// IDC: 1403
		Edit_5					// IDC: 1404
	};


	// Backgrounds

	class Clothes_Frame: RscFrame {
		idc = 1800;
		x = 0.015625 * safezoneW + safezoneX;
		y = 0.025 * safezoneH + safezoneY;
		w = 0.328125 * safezoneW;
		h = 0.65 * safezoneH;
	};
			
	class Texture_Frame: RscFrame {
		idc = 1804;
		x = 0.75 * safezoneW + safezoneX;
		y = 0.025 * safezoneH + safezoneY;
		w = 0.234375 * safezoneW;
		h = 0.95 * safezoneH;
	};
			
	class Camera_Frame: RscFrame {
		idc = 1803;
		x = 0.359375 * safezoneW + safezoneX;
		y = 0.025 * safezoneH + safezoneY;
		w = 0.34375 * safezoneW;
		h = 0.175 * safezoneH;
	};
			
	class Main_PICTURE: RscBackground {
		x = 0.015625 * safezoneW + safezoneX;
		y = 0.025 * safezoneH + safezoneY;
		w = 0.328125 * safezoneW;
		h = 0.65 * safezoneH;
	};
			
	class Texture_PICTURE: RscBackground {
		x = 0.75 * safezoneW + safezoneX;
		y = 0.025 * safezoneH + safezoneY;
		w = 0.234375 * safezoneW;
		h = 0.95 * safezoneH;
	};
	
	class Camera_PICTURE: RscBackground {
		x = 0.359375 * safezoneW + safezoneX;
		y = 0.025 * safezoneH + safezoneY;
		w = 0.34375 * safezoneW;
		h = 0.175 * safezoneH;
	};
	

	// Buttons - Clothes
	
	class Cancel_Button: RscShortcutButton {
		idc = 1703;
		text = "Cancel";
		x = 0.03125 * safezoneW + safezoneX;
		y = 0.575 * safezoneH + safezoneY;
		w = 0.140625 * safezoneW;
		h = 0.022 * safezoneH;
	};
	
	class Stores_Button: RscShortcutButton {
		idc = 1704;
		text = "";
		x = 0.171875 * safezoneW + safezoneX;
		y = 0.575 * safezoneH + safezoneY;
		w = 0.140625 * safezoneW;
		h = 0.022 * safezoneH;
	};
	
	class Preview_Button: RscShortcutButton {
		idc = 1700;
		text = "Preview";
		x = 0.03125 * safezoneW + safezoneX;
		y = 0.425 * safezoneH + safezoneY;
		w = 0.140625 * safezoneW;
		h = 0.022 * safezoneH;
	};
	
	class Buy_Button: RscShortcutButton {
		idc = 1701;
		text = "Buy";
		x = 0.03125 * safezoneW + safezoneX;
		y = 0.475 * safezoneH + safezoneY;
		w = 0.140625 * safezoneW;
		h = 0.022 * safezoneH;
	};
	
	class Buy_Change_Button: RscShortcutButton {
		idc = 1702;
		text = "Buy and Change";
		x = 0.171875 * safezoneW + safezoneX;
		y = 0.475 * safezoneH + safezoneY;
		w = 0.140625 * safezoneW;
		h = 0.022 * safezoneH;
	};
	
	
	// Buttons - Camera
	
	class Camera_Zoom_In: RscShortcutButton {
		idc = 1706;
		text = "Zoom +";
		x = 0.359375 * safezoneW + safezoneX;
		y = 0.075 * safezoneH + safezoneY;
		w = 0.109375 * safezoneW;
		h = 0.022 * safezoneH;
	};
	
	class Camera_Zoom_Out: RscShortcutButton {
		idc = 1707;
		text = "Zoom -";
		x = 0.359375 * safezoneW + safezoneX;
		y = 0.125 * safezoneH + safezoneY;
		w = 0.109375 * safezoneW;
		h = 0.022 * safezoneH;
	};
	
	class Camera_Front: RscShortcutButton {
		idc = 1708;
		text = "Front";
		x = 0.484375 * safezoneW + safezoneX;
		y = 0.075 * safezoneH + safezoneY;
		w = 0.109375 * safezoneW;
		h = 0.022 * safezoneH;
	};
	
	class Camera_Back: RscShortcutButton {
		idc = 1709;
		text = "Back";
		x = 0.59375 * safezoneW + safezoneX;
		y = 0.075 * safezoneH + safezoneY;
		w = 0.109375 * safezoneW;
		h = 0.022 * safezoneH;
	};
		
	class Camera_Left: RscShortcutButton {
		idc = 1710;
		text = "Left";
		x = 0.484375 * safezoneW + safezoneX;
		y = 0.125 * safezoneH + safezoneY;
		w = 0.109375 * safezoneW;
		h = 0.022 * safezoneH;
	};
	
	class Camera_Right: RscShortcutButton {
		idc = 1711;
		text = "Right";
		x = 0.59375 * safezoneW + safezoneX;
		y = 0.125 * safezoneH + safezoneY;
		w = 0.109375 * safezoneW;
		h = 0.022 * safezoneH;
	};
	
	// Buttons - Textures
	
	class Reset_All_Button: RscShortcutButton {
		idc = 1705;
		text = "Reset All";
		x = 0.765625 * safezoneW + safezoneX;
		y = 0.9 * safezoneH + safezoneY;
		w = 0.140625 * safezoneW;
		h = 0.022 * safezoneH;
	};
	
	class Reset_Slot_Button: RscShortcutButton {
		idc = 1712;
		text = "Reset Slot";
		x = 0.765625 * safezoneW + safezoneX;
		y = 0.85 * safezoneH + safezoneY;
		w = 0.140625 * safezoneW;
		h = 0.022 * safezoneH;
	};
	
	class Reset_Apply: RscShortcutButton {
		idc = 1713;
		text = "Apply";
		x = 0.765625 * safezoneW + safezoneX;
		y = 0.8 * safezoneH + safezoneY;
		w = 0.140625 * safezoneW;
		h = 0.022 * safezoneH;
	};
	
	// Titles - Clothes
	
	class Clothes_Title: RscText {
		idc = 1000;
		text = "Title";
		x = 0.03125 * safezoneW + safezoneX;
		y = 0.05 * safezoneH + safezoneY;
		w = 0.042 * safezoneW;
		h = 0.055 * safezoneH;
	};
	
	// Titles - Camera
	
	class Camera_Title: RscText {
		idc = 1001;
		text = "Camera";
		x = 0.359375 * safezoneW + safezoneX;
		y = 0.025 * safezoneH + safezoneY;
		w = 0.09375 * safezoneW;
		h = 0.05 * safezoneH;
	};
	

	// Titles - Textures
	
	class Texture_Title: RscText {
		idc = 1002;
		text = "Textures";
		x = 0.765625 * safezoneW + safezoneX;
		y = 0.05 * safezoneH + safezoneY;
		w = 0.09375 * safezoneW;
		h = 0.05 * safezoneH;
	};
	
	class Custom_Text: RscText {
		idc = 1008;
		text = "Custom Textures";
		x = 0.765625 * safezoneW + safezoneX;
		y = 0.725 * safezoneH + safezoneY;
		w = 0.09375 * safezoneW;
		h = 0.025 * safezoneH;
	};
	
	class Style_Text: RscText {
		idc = 1003;
		text = "Style";
		x = 0.765625 * safezoneW + safezoneX;
		y = 0.3 * safezoneH + safezoneY;
		w = 0.09375 * safezoneW;
		h = 0.025 * safezoneH;
	};
		
	class Format_Text: RscText {
		idc = 1004;
		text = "Format";
		x = 0.765625 * safezoneW + safezoneX;
		y = 0.35 * safezoneH + safezoneY;
		w = 0.09375 * safezoneW;
		h = 0.025 * safezoneH;
	};
	
	class Width_Text: RscText {
		idc = 1005;
		text = "Width";
		x = 0.765625 * safezoneW + safezoneX;
		y = 0.4 * safezoneH + safezoneY;
		w = 0.09375 * safezoneW;
		h = 0.025 * safezoneH;
	};
		
	class Height_Text: RscText {
		idc = 1006;
		text = "Height";
		x = 0.765625 * safezoneW + safezoneX;
		y = 0.45 * safezoneH + safezoneY;
		w = 0.09375 * safezoneW;
		h = 0.025 * safezoneH;
	};
		
	class Minimaps_Text: RscText {
		idc = 1007;
		text = "Minimaps";
		x = 0.765625 * safezoneW + safezoneX;
		y = 0.5 * safezoneH + safezoneY;
		w = 0.09375 * safezoneW;
		h = 0.025 * safezoneH;
	};
	
	class Custom_Text1: RscText {
		idc = 1009;
		text = "Custom1";
		x = 0.765625 * safezoneW + safezoneX;
		y = 0.575 * safezoneH + safezoneY;
		w = 0.0625 * safezoneW;
		h = 0.025 * safezoneH;
	};
		
	class Custom_Text2: RscText {
		idc = 1010;
		text = "Custom2";
		x = 0.765625 * safezoneW + safezoneX;
		y = 0.6 * safezoneH + safezoneY;
		w = 0.0625 * safezoneW;
		h = 0.025 * safezoneH;
	};
		
	class Custom_Text3: RscText {
		idc = 1011;
		text = "Custom3";
		x = 0.765625 * safezoneW + safezoneX;
		y = 0.625 * safezoneH + safezoneY;
		w = 0.0625 * safezoneW;
		h = 0.025 * safezoneH;
	};
	
	class Custom_Text4: RscText {
		idc = 1012;
		text = "Custom4";
		x = 0.765625 * safezoneW + safezoneX;
		y = 0.65 * safezoneH + safezoneY;
		w = 0.0625 * safezoneW;
		h = 0.025 * safezoneH;
	};
	
	class Custom_Text5: RscText {
		idc = 1013;
		text = "Custom5";
		x = 0.765625 * safezoneW + safezoneX;
		y = 0.675 * safezoneH + safezoneY;
		w = 0.0625 * safezoneW;
		h = 0.025 * safezoneH;
	};
	
	// ListBox - Clothes
	
	class Clothes_List_1: RscListbox {
		idc = 1500;
		x = 0.03125 * safezoneW + safezoneX;
		y = 0.125 * safezoneH + safezoneY;
		w = 0.296875 * safezoneW;
		h = 0.15 * safezoneH;
	};
		
	class Clothes_List_2: RscListbox {
		idc = 1501;
		x = 0.03125 * safezoneW + safezoneX;
		y = 0.3 * safezoneH + safezoneY;
		w = 0.296875 * safezoneW;
		h = 0.125 * safezoneH;
	};
	

	// ListBox - Textures
		
	class Texture_List: RscListbox {
		idc = 1502;
		x = 0.765625 * safezoneW + safezoneX;
		y = 0.125 * safezoneH + safezoneY;
		w = 0.203125 * safezoneW;
		h = 0.15 * safezoneH;
	};
	
	// Combo - Textures
	
	class Style_Box: RscCombo {
		idc = 2100;
		x = 0.765625 * safezoneW + safezoneX;
		y = 0.325 * safezoneH + safezoneY;
		w = 0.204687 * safezoneW;
		h = 0.025 * safezoneH;
	};
	
	class Format_Drop: RscCombo {
		idc = 2101;
		x = 0.765625 * safezoneW + safezoneX;
		y = 0.375 * safezoneH + safezoneY;
		w = 0.203125 * safezoneW;
		h = 0.025 * safezoneH;
	};
		
	class Width_Box: RscCombo {
		idc = 2102;
		x = 0.765625 * safezoneW + safezoneX;
		y = 0.425 * safezoneH + safezoneY;
		w = 0.203125 * safezoneW;
		h = 0.025 * safezoneH;
	};
	
	class Height_Box: RscCombo {
		idc = 2103;
		x = 0.765625 * safezoneW + safezoneX;
		y = 0.475 * safezoneH + safezoneY;
		w = 0.203125 * safezoneW;
		h = 0.025 * safezoneH;
	};
	
	class Minimaps_Drop: RscCombo {
		idc = 2104;
		x = 0.765625 * safezoneW + safezoneX;
		y = 0.525 * safezoneH + safezoneY;
		w = 0.203125 * safezoneW;
		h = 0.025 * safezoneH;
	};

	class Custom_Drop: RscCombo {
		idc = 2105;
		x = 0.765625 * safezoneW + safezoneX;
		y = 0.75 * safezoneH + safezoneY;
		w = 0.203125 * safezoneW;
		h = 0.025 * safezoneH;
	};
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Edit - Textures
	
	class Edit_1: RscEdit {
		idc = 1400;
		x = 0.828125 * safezoneW + safezoneX;
		y = 0.575 * safezoneH + safezoneY;
		w = 0.078125 * safezoneW;
		h = 0.025 * safezoneH;
	};
	
	class Edit_2: RscEdit {
		idc = 1401;
		x = 0.828125 * safezoneW + safezoneX;
		y = 0.6 * safezoneH + safezoneY;
		w = 0.078125 * safezoneW;
		h = 0.025 * safezoneH;
	};
	
	class Edit_3: RscEdit {
		idc = 1402;
		x = 0.828125 * safezoneW + safezoneX;
		y = 0.625 * safezoneH + safezoneY;
		w = 0.078125 * safezoneW;
		h = 0.025 * safezoneH;
	};
	
	class Edit_4: RscEdit {
		idc = 1403;
		x = 0.828125 * safezoneW + safezoneX;
		y = 0.65 * safezoneH + safezoneY;
		w = 0.078125 * safezoneW;
		h = 0.025 * safezoneH;
	};
	
	class Edit_5: RscEdit {
		idc = 1404;
		x = 0.828125 * safezoneW + safezoneX;
		y = 0.675 * safezoneH + safezoneY;
		w = 0.078125 * safezoneW;
		h = 0.025 * safezoneH;
	};
};


class Paint_Dialog {
	idd = 3004;
	movingEnable = true;
	controlsBackground[] = {
		Main_Frame,				// IDC: 1800
		Texture_Frame,			// IDC: 1804
		Camera_Frame,			// IDC: 1803
		Main_PICTURE,
		Texture_PICTURE,
		Camera_PICTURE
	};	
	
	objects[] = { };
	
	controls[] = {
		// Main Buttons
		Buy_Button,				// IDC: 1700
		BuyR_Button,			// IDC: 1702
		Cancel_Button,			// IDC: 1701
		
		// Camera Buttons
		Camera_Zoom_In,			// IDC: 1706
		Camera_Zoom_Out,		// IDC: 1707
		Camera_Front,			// IDC: 1708
		Camera_Back,			// IDC: 1709
		Camera_Left,			// IDC: 1710
		Camera_Right,			// IDC: 1711
		
		// Texture Buttons
		Reset_Apply,			// IDC: 1713
		Reset_Slot_Button,		// IDC: 1712
		Reset_All_Button,		// IDC: 1705
		
		// Camera Titles
		Camera_Title,			// IDC: 1001
		
		// Texture Titles
		Texture_Title,			// IDC: 1002
		Custom_Text,			// IDC: 1008
		Style_Text,				// IDC: 1003
		Format_Text,			// IDC: 1004
		Width_Text,				// IDC: 1005
		Height_Text,			// IDC: 1006
		Minimaps_Text,			// IDC: 1007
		Custom_Text1,			// IDC: 1009
		Custom_Text2,			// IDC: 1010
		Custom_Text3,			// IDC: 1011
		Custom_Text4,			// IDC: 1012
		Custom_Text5,			// IDC: 1013
		
		// Texture Lists
		Texture_List,			// IDC: 1502
		
		// Combo lists
		Style_Box,				// IDC: 2100
		Format_Drop,			// IDC: 2101
		Width_Box,				// IDC: 2102
		Height_Box,				// IDC: 2103
		Minimaps_Drop,			// IDC: 2104
		Custom_Drop,			// IDC: 2105
		
		// Edit lists
		Edit_1,					// IDC: 1400
		Edit_2,					// IDC: 1401
		Edit_3,					// IDC: 1402					
		Edit_4,					// IDC: 1403
		Edit_5					// IDC: 1404
	};


	// Backgrounds

	class Main_Frame: RscFrame {
		idc = 1800;
		x = 0.015625 * safezoneW + safezoneX;
		y = 0.025 * safezoneH + safezoneY;
		w = 0.125 * safezoneW;
		h = 0.2 * safezoneH;
	};
	
	class Texture_Frame: RscFrame {
		idc = 1804;
		x = 0.75 * safezoneW + safezoneX;
		y = 0.025 * safezoneH + safezoneY;
		w = 0.234375 * safezoneW;
		h = 0.95 * safezoneH;
	};
	
	class Camera_Frame: RscFrame {
		idc = 1803;
		x = 0.359375 * safezoneW + safezoneX;
		y = 0.025 * safezoneH + safezoneY;
		w = 0.34375 * safezoneW;
		h = 0.175 * safezoneH;
	};
	
	class Main_PICTURE: RscBackground {
		x = 0.015625 * safezoneW + safezoneX;
		y = 0.025 * safezoneH + safezoneY;
		w = 0.125 * safezoneW;
		h = 0.2 * safezoneH;
	};
	
	class Texture_PICTURE: RscBackground {
		x = 0.75 * safezoneW + safezoneX;
		y = 0.025 * safezoneH + safezoneY;
		w = 0.234375 * safezoneW;
		h = 0.95 * safezoneH;
	};
	
	class Camera_PICTURE: RscBackground {
		x = 0.359375 * safezoneW + safezoneX;
		y = 0.025 * safezoneH + safezoneY;
		w = 0.34375 * safezoneW;
		h = 0.175 * safezoneH;
	};

	
	// Buttons - Clothes
	
	class Buy_Button: RscShortcutButton {
		idc = 1700;
		text = "Cancel";
		x = 0.03125 * safezoneW + safezoneX;
		y = 0.035 * safezoneH + safezoneY;
		w = 0.09375 * safezoneW;
		h = 0.025 * safezoneH;
	};
	
	class BuyR_Button: RscShortcutButton {
		idc = 1702;
		text = "Cancel";
		x = 0.03125 * safezoneW + safezoneX;
		y = 0.075 * safezoneH + safezoneY;
		w = 0.09375 * safezoneW;
		h = 0.025 * safezoneH;
	};
	
	class Cancel_Button: RscShortcutButton {
		idc = 1701;
		text = "Cancel";
		x = 0.03125 * safezoneW + safezoneX;
		y = 0.15 * safezoneH + safezoneY;
		w = 0.09375 * safezoneW;
		h = 0.025 * safezoneH;
	};
	
	
	// Buttons - Camera
	
	class Camera_Zoom_In: RscShortcutButton {
		idc = 1706;
		text = "Zoom +";
		x = 0.359375 * safezoneW + safezoneX;
		y = 0.075 * safezoneH + safezoneY;
		w = 0.109375 * safezoneW;
		h = 0.022 * safezoneH;
	};
	
	class Camera_Zoom_Out: RscShortcutButton {
		idc = 1707;
		text = "Zoom -";
		x = 0.359375 * safezoneW + safezoneX;
		y = 0.125 * safezoneH + safezoneY;
		w = 0.109375 * safezoneW;
		h = 0.022 * safezoneH;
	};
	
	class Camera_Front: RscShortcutButton {
		idc = 1708;
		text = "Front";
		x = 0.484375 * safezoneW + safezoneX;
		y = 0.075 * safezoneH + safezoneY;
		w = 0.109375 * safezoneW;
		h = 0.022 * safezoneH;
	};
	
	class Camera_Back: RscShortcutButton {
		idc = 1709;
		text = "Back";
		x = 0.59375 * safezoneW + safezoneX;
		y = 0.075 * safezoneH + safezoneY;
		w = 0.109375 * safezoneW;
		h = 0.022 * safezoneH;
	};
		
	class Camera_Left: RscShortcutButton {
		idc = 1710;
		text = "Left";
		x = 0.484375 * safezoneW + safezoneX;
		y = 0.125 * safezoneH + safezoneY;
		w = 0.109375 * safezoneW;
		h = 0.022 * safezoneH;
	};
	
	class Camera_Right: RscShortcutButton {
		idc = 1711;
		text = "Right";
		x = 0.59375 * safezoneW + safezoneX;
		y = 0.125 * safezoneH + safezoneY;
		w = 0.109375 * safezoneW;
		h = 0.022 * safezoneH;
	};
	
	
	// Buttons - Textures
	
	class Reset_All_Button: RscShortcutButton {
		idc = 1705;
		text = "Reset All";
		x = 0.765625 * safezoneW + safezoneX;
		y = 0.9 * safezoneH + safezoneY;
		w = 0.140625 * safezoneW;
		h = 0.022 * safezoneH;
	};
	
	class Reset_Slot_Button: RscShortcutButton {
		idc = 1712;
		text = "Reset Slot";
		x = 0.765625 * safezoneW + safezoneX;
		y = 0.85 * safezoneH + safezoneY;
		w = 0.140625 * safezoneW;
		h = 0.022 * safezoneH;
	};
	
	class Reset_Apply: RscShortcutButton {
		idc = 1713;
		text = "Apply";
		x = 0.765625 * safezoneW + safezoneX;
		y = 0.8 * safezoneH + safezoneY;
		w = 0.140625 * safezoneW;
		h = 0.022 * safezoneH;
	};

	// Titles - Camera
	
	class Camera_Title: RscText {
		idc = 1001;
		text = "Camera";
		x = 0.359375 * safezoneW + safezoneX;
		y = 0.025 * safezoneH + safezoneY;
		w = 0.09375 * safezoneW;
		h = 0.05 * safezoneH;
	};
	
	// Titles - Textures
	
	class Texture_Title: RscText {
		idc = 1002;
		text = "Textures";
		x = 0.765625 * safezoneW + safezoneX;
		y = 0.05 * safezoneH + safezoneY;
		w = 0.09375 * safezoneW;
		h = 0.05 * safezoneH;
	};
	
	class Custom_Text: RscText {
		idc = 1008;
		text = "Custom Textures";
		x = 0.765625 * safezoneW + safezoneX;
		y = 0.725 * safezoneH + safezoneY;
		w = 0.09375 * safezoneW;
		h = 0.025 * safezoneH;
	};
	
	class Style_Text: RscText {
		idc = 1003;
		text = "Style";
		x = 0.765625 * safezoneW + safezoneX;
		y = 0.3 * safezoneH + safezoneY;
		w = 0.09375 * safezoneW;
		h = 0.025 * safezoneH;
	};
		
	class Format_Text: RscText {
		idc = 1004;
		text = "Format";
		x = 0.765625 * safezoneW + safezoneX;
		y = 0.35 * safezoneH + safezoneY;
		w = 0.09375 * safezoneW;
		h = 0.025 * safezoneH;
	};
	
	class Width_Text: RscText {
		idc = 1005;
		text = "Width";
		x = 0.765625 * safezoneW + safezoneX;
		y = 0.4 * safezoneH + safezoneY;
		w = 0.09375 * safezoneW;
		h = 0.025 * safezoneH;
	};
		
	class Height_Text: RscText {
		idc = 1006;
		text = "Height";
		x = 0.765625 * safezoneW + safezoneX;
		y = 0.45 * safezoneH + safezoneY;
		w = 0.09375 * safezoneW;
		h = 0.025 * safezoneH;
	};
		
	class Minimaps_Text: RscText {
		idc = 1007;
		text = "Minimaps";
		x = 0.765625 * safezoneW + safezoneX;
		y = 0.5 * safezoneH + safezoneY;
		w = 0.09375 * safezoneW;
		h = 0.025 * safezoneH;
	};

	class Custom_Text1: RscText {
		idc = 1009;
		text = "Custom1";
		x = 0.765625 * safezoneW + safezoneX;
		y = 0.575 * safezoneH + safezoneY;
		w = 0.0625 * safezoneW;
		h = 0.025 * safezoneH;
	};
		
	class Custom_Text2: RscText {
		idc = 1010;
		text = "Custom2";
		x = 0.765625 * safezoneW + safezoneX;
		y = 0.6 * safezoneH + safezoneY;
		w = 0.0625 * safezoneW;
		h = 0.025 * safezoneH;
	};
	
	class Custom_Text3: RscText {
		idc = 1011;
		text = "Custom3";
		x = 0.765625 * safezoneW + safezoneX;
		y = 0.625 * safezoneH + safezoneY;
		w = 0.0625 * safezoneW;
		h = 0.025 * safezoneH;
	};
	
	class Custom_Text4: RscText {
		idc = 1012;
		text = "Custom4";
		x = 0.765625 * safezoneW + safezoneX;
		y = 0.65 * safezoneH + safezoneY;
		w = 0.0625 * safezoneW;
		h = 0.025 * safezoneH;
	};
	
	class Custom_Text5: RscText {
		idc = 1013;
		text = "Custom5";
		x = 0.765625 * safezoneW + safezoneX;
		y = 0.675 * safezoneH + safezoneY;
		w = 0.0625 * safezoneW;
		h = 0.025 * safezoneH;
	};
	
	// ListBox - Textures
		
	class Texture_List: RscListbox {
		idc = 1502;
		x = 0.765625 * safezoneW + safezoneX;
		y = 0.125 * safezoneH + safezoneY;
		w = 0.203125 * safezoneW;
		h = 0.15 * safezoneH;
	};
	
	// Combo - Textures
	
	class Style_Box: RscCombo {
		idc = 2100;
		x = 0.765625 * safezoneW + safezoneX;
		y = 0.325 * safezoneH + safezoneY;
		w = 0.204687 * safezoneW;
		h = 0.025 * safezoneH;
	};

	class Format_Drop: RscCombo {
		idc = 2101;
		x = 0.765625 * safezoneW + safezoneX;
		y = 0.375 * safezoneH + safezoneY;
		w = 0.203125 * safezoneW;
		h = 0.025 * safezoneH;
	};
		
	class Width_Box: RscCombo {
		idc = 2102;
		x = 0.765625 * safezoneW + safezoneX;
		y = 0.425 * safezoneH + safezoneY;
		w = 0.203125 * safezoneW;
		h = 0.025 * safezoneH;
	};

	class Height_Box: RscCombo {
		idc = 2103;
		x = 0.765625 * safezoneW + safezoneX;
		y = 0.475 * safezoneH + safezoneY;
		w = 0.203125 * safezoneW;
		h = 0.025 * safezoneH;
	};
	
	class Minimaps_Drop: RscCombo {
		idc = 2104;
		x = 0.765625 * safezoneW + safezoneX;
		y = 0.525 * safezoneH + safezoneY;
		w = 0.203125 * safezoneW;
		h = 0.025 * safezoneH;
	};

	class Custom_Drop: RscCombo {
		idc = 2105;
		x = 0.765625 * safezoneW + safezoneX;
		y = 0.75 * safezoneH + safezoneY;
		w = 0.203125 * safezoneW;
		h = 0.025 * safezoneH;
	};

	// Edit - Textures
	
	class Edit_1: RscEdit {
		idc = 1400;
		x = 0.828125 * safezoneW + safezoneX;
		y = 0.575 * safezoneH + safezoneY;
		w = 0.078125 * safezoneW;
		h = 0.025 * safezoneH;
	};
		
	class Edit_2: RscEdit {
		idc = 1401;
		x = 0.828125 * safezoneW + safezoneX;
		y = 0.6 * safezoneH + safezoneY;
		w = 0.078125 * safezoneW;
		h = 0.025 * safezoneH;
	};
	
	class Edit_3: RscEdit {
		idc = 1402;
		x = 0.828125 * safezoneW + safezoneX;
		y = 0.625 * safezoneH + safezoneY;
		w = 0.078125 * safezoneW;
		h = 0.025 * safezoneH;
	};
	
	class Edit_4: RscEdit {
		idc = 1403;
		x = 0.828125 * safezoneW + safezoneX;
		y = 0.65 * safezoneH + safezoneY;
		w = 0.078125 * safezoneW;
		h = 0.025 * safezoneH;
	};
	
	class Edit_5: RscEdit {
		idc = 1404;
		x = 0.828125 * safezoneW + safezoneX;
		y = 0.675 * safezoneH + safezoneY;
		w = 0.078125 * safezoneW;
		h = 0.025 * safezoneH;
	};
};

class white_black_list {
	idd = 3005;
	movingEnable = true;
	controlsBackground[] = {
		FRAME_BACK,				// IDC: 1800
		PICTURE_BACK			// IDC: 1804
	};	
	
	objects[] = { };
	
	controls[] = {
		// Lists
		LIST1,					// IDC: 1500
		LIST2,					// IDC: 1501
		LIST3,					// IDC: 1502

		// Buttons
		BUTTON_B_1,				// IDC: 1700
		BUTTON_B_2,				// IDC: 1701
		BUTTON_B_3,				// IDC: 1705
		BUTTON_B_4,				// IDC: 1707
		
		BUTTON_W_1,				// IDC: 1702
		BUTTON_W_2,				// IDC: 1703
		BUTTON_W_3,				// IDC: 1706
		BUTTON_W_4,				// IDC: 1708
		
		// Titles
		TITLE1,					// IDC: 1000
		TITLE2,					// IDC: 1001
		TITLE3,					// IDC: 1002
		TITLE1_DESC,			// IDC: 1003
		TITLE2_DESC,			// IDC: 1004
		TITLE3_DESC				// IDC: 1005
	};

	// Backgrounds

	class FRAME_BACK: RscFrame {
		idc = 1800;
		x = 0.09375 * safezoneW + safezoneX;
		y = 0.025 * safezoneH + safezoneY;
		w = 0.734375 * safezoneW;
		h = 0.9 * safezoneH;
	};
	
	class PICTURE_BACK: RscBackground {
		idc = 1801;
		x = 0.09375 * safezoneW + safezoneX;
		y = 0.025 * safezoneH + safezoneY;
		w = 0.734375 * safezoneW;
		h = 0.9 * safezoneH;
	};
	
	//  Frames
	
	class FRAME1: RscFrame {
		idc = 1802;
		x = 0.109375 * safezoneW + safezoneX;
		y = 0.15 * safezoneH + safezoneY;
		w = 0.1875 * safezoneW;
		h = 0.3 * safezoneH;
	};
	
	class FRAME2: RscFrame {
		idc = 1803;
		x = 0.109375 * safezoneW + safezoneX;
		y = 0.6 * safezoneH + safezoneY;
		w = 0.1875 * safezoneW;
		h = 0.3 * safezoneH;
	};
	
	class FRAME3: RscFrame {
		idc = 1804;
		x = 0.5 * safezoneW + safezoneX;
		y = 0.175 * safezoneH + safezoneY;
		w = 0.28125 * safezoneW;
		h = 0.725 * safezoneH;
	};
	
	//  Lists
	
	class LIST1: RscListbox {
		idc = 1500;
		x = 0.109375 * safezoneW + safezoneX;
		y = 0.15 * safezoneH + safezoneY;
		w = 0.1875 * safezoneW;
		h = 0.3 * safezoneH;
	};
	
	class LIST2: RscListbox {
		idc = 1501;
		x = 0.109375 * safezoneW + safezoneX;
		y = 0.6 * safezoneH + safezoneY;
		w = 0.1875 * safezoneW;
		h = 0.3 * safezoneH;
	};
	
	class LIST3: RscListbox {
		idc = 1502;
		x = 0.5 * safezoneW + safezoneX;
		y = 0.175 * safezoneH + safezoneY;
		w = 0.28125 * safezoneW;
		h = 0.725 * safezoneH;
	};
	
	//  Buttons
	
	class BUTTON_B_1: RscShortcutButton {
		idc = 1700;
		x = 0.3125 * safezoneW + safezoneX;
		y = 0.6 * safezoneH + safezoneY;
		w = 0.125 * safezoneW;
		h = 0.04 * safezoneH;
	};
	
	class BUTTON_B_2: RscShortcutButton {
		idc = 1701;
		x = 0.3125 * safezoneW + safezoneX;
		y = 0.65 * safezoneH + safezoneY;
		w = 0.125 * safezoneW;
		h = 0.04 * safezoneH;
	};
	
	class BUTTON_B_3: RscShortcutButton {
		idc = 1705;
		x = 0.3125 * safezoneW + safezoneX;
		y = 0.7 * safezoneH + safezoneY;
		w = 0.125 * safezoneW;
		h = 0.04 * safezoneH;
	};
	
	class BUTTON_B_4: RscShortcutButton {
		idc = 1707;
		x = 0.3125 * safezoneW + safezoneX;
		y = 0.75 * safezoneH + safezoneY;
		w = 0.125 * safezoneW;
		h = 0.04 * safezoneH;
	};
	
	class BUTTON_W_1: RscShortcutButton {
		idc = 1702;
		x = 0.3125 * safezoneW + safezoneX;
		y = 0.15 * safezoneH + safezoneY;
		w = 0.125 * safezoneW;
		h = 0.04 * safezoneH;
	};
	
	class BUTTON_W_2: RscShortcutButton {
		idc = 1703;
		x = 0.3125 * safezoneW + safezoneX;
		y = 0.2 * safezoneH + safezoneY;
		w = 0.125 * safezoneW;
		h = 0.04 * safezoneH;
	};
	
	class BUTTON_W_3: RscShortcutButton {
		idc = 1706;
		x = 0.3125 * safezoneW + safezoneX;
		y = 0.25 * safezoneH + safezoneY;
		w = 0.125 * safezoneW;
		h = 0.04 * safezoneH;
	};
	
	class BUTTON_W_4: RscShortcutButton {
		idc = 1708;
		x = 0.3125 * safezoneW + safezoneX;
		y = 0.30 * safezoneH + safezoneY;
		w = 0.125 * safezoneW;
		h = 0.04 * safezoneH;
	};
	
	//  Texts
	
	class TITLE1: RscText {
		idc = 1000;
		text = "WHITELIST";
		x = 0.109375 * safezoneW + safezoneX;
		y = 0.05 * safezoneH + safezoneY;
		w = 0.1875 * safezoneW;
		h = 0.025 * safezoneH;
	};
	
	class TITLE2: RscText {
		idc = 1001;
		text = "BLACKLIST";
		x = 0.109375 * safezoneW + safezoneX;
		y = 0.5 * safezoneH + safezoneY;
		w = 0.1875 * safezoneW;
		h = 0.025 * safezoneH;
	};
	
	class TITLE3: RscText {
		idc = 1002;
		text = "PLAYER LIST";
		x = 0.5 * safezoneW + safezoneX;
		y = 0.075 * safezoneH + safezoneY;
		w = 0.28125 * safezoneW;
		h = 0.025 * safezoneH;
	};
	
	class TITLE1_DESC: RscText {
		idc = 1003;
		text = "UID - TYPE";
		x = 0.109375 * safezoneW + safezoneX;
		y = 0.1 * safezoneH + safezoneY;
		w = 0.1875 * safezoneW;
		h = 0.025 * safezoneH;
	};
	
	class TITLE2_DESC: RscText {
		idc = 1004;
		text = "UID - TYPE";
		x = 0.109375 * safezoneW + safezoneX;
		y = 0.55 * safezoneH + safezoneY;
		w = 0.1875 * safezoneW;
		h = 0.025 * safezoneH;
	};
	
	class TITLE3_DESC: RscText {
		idc = 1005;
		text = "UID - NAME - SLOT";
		x = 0.5 * safezoneW + safezoneX;
		y = 0.125 * safezoneH + safezoneY;
		w = 0.28125 * safezoneW;
		h = 0.025 * safezoneH;
	};
};