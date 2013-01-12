class MainMenu{
    idd = -1;
    movingEnable = true;
    controlsBackground[] = {
        DLG_BACK1, background
    };
	
    objects[] = { };

    controls[] = {
        button_graphics, button_texts, button_tutorial, button_faq, button_about, button_iteminfo, button_cancel, dummybutton
    };

    class DLG_BACK1: Rscbackground {
        x = 0.35;
        y = 0.20;
        w = 0.30;
        h = 0.50;
    };

    class background : RscBgRahmen {
        x = 0.35;
        y = 0.20;
        w = 0.30;
        h = 0.50;
        text = "Main Menu";
    };

    class button_graphics : RscButton {
        x = 0.40;
        y = 0.25;
        w = 0.20;
        h = 0.04;
        text = "Graphics";
        action = "closedialog 0;[""GrafikEinstellungen""] spawn A_SCRIPT_SETTINGS;";
    };

    class button_texts : RscButton {
        x = 0.40;
        y = 0.30;
        w = 0.20;
        h = 0.04;
        text = "Say Texts";
        action = "closedialog 0;[""TextEinstellungen"", ""oeffnen""] spawn A_SCRIPT_SETTINGS;";
    };

    class button_tutorial : RscButton {
        x = 0.40;
        y = 0.35;
        w = 0.20;
        h = 0.04;
        text = "Tutorial";
        action = "closedialog 0;[""Tutorial""] spawn A_SCRIPT_SETTINGS;";
    };

    class button_faq : RscButton {
        x = 0.40;
        y = 0.40;
        w = 0.20;
        h = 0.04;
        text = "FAQ";
        action = "closedialog 0;[""FAQ""] spawn A_SCRIPT_SETTINGS;";
    };

    class button_about : RscButton {
        x = 0.40;
        y = 0.45;
        w = 0.20;
        h = 0.04;
        text = "About";
        action = "closedialog 0;[""About""] spawn A_SCRIPT_SETTINGS;";
    };

    class button_iteminfo : RscButton {
        x = 0.40;
        y = 0.50;
        w = 0.20;
        h = 0.04;
        text = "Item info";
        action = "closedialog 0;[""ItemList""] spawn A_SCRIPT_SETTINGS;";
    };

    class button_cancel : RscButton {
        x = 0.40;
        y = 0.60;
        w = 0.20;
        h = 0.04;
        text = "Close";
        action = "closedialog 0;";
    };

    class dummybutton : RscDummy {
        idc = 1033;
    };
    
};

class TextEinstellungenDialog{
    idd = -1;
    movingEnable = true;
    controlsBackground[] = {
        DLG_BACK1, background
    };
	
    objects[] = {};

    controls[] = {
        eingabefenster_1, eingabelist_1, eingabefenster_2, eingabelist_2, eingabefenster_3, eingabelist_3, eingabefenster_4, eingabelist_4, button_save, button_cancel, dummybutton
    };

    class DLG_BACK1: Rscbackground {
        x = 0.15;
        y = 0.20;
        w = 0.80;
        h = 0.50;
    };

    class background : RscBgRahmen {
        x = 0.15;
        y = 0.20;
        w = 0.80;
        h = 0.50;
        text = "Text Options";
    };

    class eingabefenster_1 : RscEdit {
        idc = 1;
        x = 0.20;
        y = 0.30;
        w = 0.50;
        h = 0.04;
        onChar = "[_this, 1] call KeyPressHandler;";
    };

    class eingabelist_1 : RscCombo {
        idc = 11;
        x = 0.73;
        y = 0.30;
        w = 0.17;
        h = 0.04;
    };

    class eingabefenster_2 : RscEdit {
        idc = 2;
        x = 0.20;
        y = 0.35;
        w = 0.50;
        h = 0.04;
        onChar = "[_this, 1] call KeyPressHandler;";
    };

    class eingabelist_2 : RscCombo {
        idc = 12;
        x = 0.73;
        y = 0.35;
        w = 0.17;
        h = 0.04;
    };

    class eingabefenster_3 : RscEdit {
        idc = 3;
        x = 0.20;
        y = 0.40;
        w = 0.50;
        h = 0.04;
        onChar = "[_this, 1] call KeyPressHandler;";
    };

    class eingabelist_3 : RscCombo {
        idc = 13;
        x = 0.73;
        y = 0.40;
        w = 0.17;
        h = 0.04;
    };

    class eingabefenster_4 : RscEdit {
        idc = 4;
        x = 0.20;
        y = 0.45;
        w = 0.50;
        h = 0.04;
        onChar = "[_this, 1] call KeyPressHandler;";
    };

    class eingabelist_4 : RscCombo {
        idc = 14;
        x = 0.73;
        y = 0.45;
        w = 0.17;
        h = 0.04;
    };

    class button_cancel : RscButton {
        x = 0.52;
        y = 0.58;
        w = 0.21;
        h = 0.04;
        text = "Back";
        action = "closedialog 0;[""Einstellungen""] spawn A_SCRIPT_SETTINGS;";
    };

    class button_save : RscButton {
        x = 0.27;
        y = 0.58;
        w = 0.21;
        h = 0.04;
        text = "Save";
        action = "[""TextEinstellungen"", ""speichern""] spawn A_SCRIPT_SETTINGS;";
    };

    class dummybutton : RscDummy {
        idc = 1034;
    };
    
};

class TutorialDialog{
    idd = -1;
    movingEnable = true;
    controlsBackground[] = {
        DLG_BACK1, background
    };
	
    objects[] = {};

    controls[] = {
        InfoText, button_cancel, dummybutton
    };

    class DLG_BACK1: Rscbackground {
        x = 0.05;
        y = 0.05;
        w = 0.90;
        h = 0.90;
    };

    class background : RscBgRahmen {
        x = 0.05;
        y = 0.05;
        w = 0.90;
        h = 0.90;
        text = "Tutorial";
    };

    class InfoText : RscText {
        idc = 1;
        x = 0.08;
        y = 0.08;
        w = 0.84;
        h = 0.80;
        style = ST_MULTI;
        lineSpacing = 1;
    };

    class button_cancel : RscButton {
        x = 0.40;
        y = 0.90;
        w = 0.20;
        h = 0.04;
        text = "Back";
        action = "closedialog 0;[""Einstellungen""] spawn A_SCRIPT_SETTINGS;";
    };

    class dummybutton : RscDummy {
        idc = 1035;
    };
    
};

class FAQDialog{
    idd = -1;
    movingEnable = true;
    controlsBackground[] = {
        DLG_BACK1, background
    };
	
    objects[] = {};

    controls[] = {
        InfoText, button_cancel, dummybutton
    };

    class DLG_BACK1: Rscbackground {
        x = 0.05;
        y = 0.05;
        w = 0.90;
        h = 0.90;
    };

    class background : RscBgRahmen {
        x = 0.05;
        y = 0.05;
        w = 0.90;
        h = 0.90;
        text = "FAQ";
    };

    class InfoText : RscText {
        idc = 1;
        x = 0.08;
        y = 0.08;
        w = 0.84;
        h = 0.80;
        style = ST_MULTI;
        lineSpacing = 1;
    };

    class button_cancel : RscButton {
        x = 0.40;
        y = 0.90;
        w = 0.20;
        h = 0.04;
        text = "Back";
        action = "closedialog 0;[""Einstellungen""] spawn A_SCRIPT_SETTINGS;";
    };

    class dummybutton : RscDummy {
        idc = 1036;
    };
    
};

class AboutDialog{
    idd = -1;
    movingEnable = true;
    controlsBackground[] = {
        DLG_BACK1, background
    };
	
    objects[] = {};

    controls[] = {
        InfoText, button_cancel, dummybutton
    };

    class DLG_BACK1: Rscbackground {
        x = 0.05;
        y = 0.05;
        w = 0.90;
        h = 0.90;
    };

    class background : RscBgRahmen {
        x = 0.05;
        y = 0.05;
        w = 0.90;
        h = 0.90;
        text = "About";
    };

    class InfoText : RscText {
        idc = 1;
        x = 0.08;
        y = 0.08;
        w = 0.84;
        h = 0.80;
        style = ST_MULTI;
        lineSpacing = 1;
    };

    class button_cancel : RscButton {
        x = 0.40;
        y = 0.90;
        w = 0.20;
        h = 0.04;
        text = "Back";
        action = "closedialog 0;[""Einstellungen""] spawn A_SCRIPT_SETTINGS;";
    };

    class dummybutton : RscDummy {
        idc = 1037;
    };
    
};