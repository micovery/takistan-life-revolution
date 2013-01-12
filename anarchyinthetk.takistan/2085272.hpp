class lotto {
    idd = -1;
    movingEnable = true;
    controlsBackground[] = {
        DLG_BACK1, background
    };
    objects[] = {  };
	
    controls[] = {
        ticketlist, submit, cancel, dummybutton
    };
	
    class DLG_BACK1: RscBackground  {
        x = 0.40;
        y = 0.35;
        w = 0.30;
        h = 0.20;
        
    };
	
    class background : RscBgRahmen {
        x = 0.40;
        y = 0.35;
        w = 0.30;
        h = 0.20;
        text = $STRD_lotto_title;
    };
	
    class ticketlist : RscCombo {
        idc = 1;
        x = 0.42;
        y = 0.40;
        w = 0.26;
        h = 0.04;
    };
	
    class submit : RscButton {
        idc = 2;
        x = 0.42;
        y = 0.45;
        w = 0.26;
        h = 0.04;
        text = $STRD_lotto_buyticket;
    };
	
    class cancel : RscButton {
        x = 0.42;
        y = 0.50;
        w = 0.26;
        h = 0.04;
        text = $STRD_lotto_cancel;
        action = "closedialog 0";
    };
	
    class dummybutton : RscDummy {
        idc = 1005;
    };
};