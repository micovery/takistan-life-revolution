class RBgFrame
{
	type=0;
	idc=-1;
	style=64;
	colorBackground[]={0.4, 0.4, 0.4, 0.75};
	colorText[]={0, 0, 0, 1};
	font="TahomaB";
	SizeEX=0.025;
	text="";
};


class Retribution
{
	idd = 5001;
	movingEnable = true;
	controlsBackground[] = {background};
	objects[] = { };
	controls[] = {frame, title, kvlist, punish, forgive, compensate, close};
	
	class frame:RBgFrame
	{
		idc=-1;
		x=0.28;
		y=0.18;
		w=0.50;
		h=0.76;
	};

	class background:RscBackground
	{
		idc=-1;
		x=0.28;
		y=0.18;
		w=0.50;
		h=0.76;
	};

	class title : RscText
	{
        idc = 5002;																				
        x = 0.25; y = 0.22;						
        w = 0.55; h = 0.04;												
        style = ST_CENTER;																								
        SizeEX = 0.03;														
        text = "Retributions";				
	};	

	class kvlist : RscListBox
	{
        idc = 5003;
        x = 0.32;
        y = 0.30;
        w = 0.42;
        h = 0.30;
	};
	
	class punish : RscButton
	{
        idc = 5004;
        x = 0.32;
        y = 0.63;
        w = 0.42;
        h = 0.06;
        text = "Punish";
        action="[""punish""] call retributions_main;";
	};
	
	class forgive : RscButton
	{
        idc = 5005;
        x = 0.32;
        y = 0.70;
        w = 0.42;
        h = 0.06;
        text = "Forgive";
        action="[""forgive""] call retributions_main;";
	};
	
	class compensate : RscButton
	{
        idc = 5006;
        x = 0.32;
        y = 0.77;
        w = 0.42;
        h = 0.06;
        text = "Compensate";
        action="[""compensate""] call retributions_main;";
	};


	class close : RscButton
	{
		idc = 5007;
        x = 0.32;
        y = 0.84;
        w = 0.42;
        h = 0.06;
        text = "Close";
        action = "closeDialog 0;";
	};
};