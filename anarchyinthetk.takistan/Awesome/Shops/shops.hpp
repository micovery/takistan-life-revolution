#include "constants.h"

class SBgFrame {
	type=0;
	idc=-1;
	style=64;
	colorBackground[]={0.4, 0.4, 0.4, 0.75};
	colorText[]={1, 1, 1, 1};
	font="TahomaB";
	SizeEX=0.025;
	text="";
};

class SCheckBox {
	idc = -1;
	type = 7;
	style = 2;
	
	colorText[] = {1, 1, 1, 1};
	color[] = {0, 1, 0, 1};
	colorTextSelect[] = {0, 0.8, 0, 1};
	coloSelectedBg[] = {1, 1, 1, 0};
	colorSelect[] = {0, 0, 0, 1};
	colorTextDisable[] = {0.4, 0.4, 0.4, 1};
	colorDisable[] = {0.4, 0.4, 0.4, 1};
	font = "TahomaB";
	SizeEX=0.025;
	rows = 1;
	columns = 1;
	strings[] = {""};
};

class ShopVehicles {
	idd = shopVehicles_idd;
	movingEnable = true;
	controlsBackground[] = {background, frame};
	objects[] = { };
	controls[] = {  
					selectButton, cancelButton,
					selectVehicle_list
					
				 };
				 
	class selectVehicle_list : RscListBox {
		idc = selectVehicle_list_idc;
		x = 0.44; y = -0.0905;
		w = 0.418; h = 0.36;
	};
	
	class frame : SBgFrame {
		moving = 1;
		x = 0.42; y = -0.13;
		w = 0.4607; h = 0.50;
		text = "Vehicles";
	};
	
	class background: RscBackground {
		moving = 1;
		x = 0.42; y = -0.13;
		w = 0.4607; h = 0.50;
	};
	
	class selectButton : RscButton {
		idc = selectButton_idc;
		x = 0.44; y = 0.3;
		w = 0.20; h = 0.04;
		text = "Select";
		colorBackgroundDisabled[] = DISABLED_BUTTON_BACKGROUND;
		colorDisabled[] = DISABLED_BUTTON_TEXT;
	};

	class cancelButton : RscButton {
		x = 0.6605; y = 0.3;
		w = 0.20; h = 0.04;
		text = "Cancel";
		action = "closedialog 0";
	};
};

class Shops {
	idd = shopDialog_idd;
	movingEnable = true;
	controlsBackground[] = {buyBackground, sellBackground, buyFrame, sellFrame};
	objects[] = { };
	controls[] = {  
					showAllSellItems_label, showAllSellItems_cbox,
					put_gear_label_idc, cbox, shopControl,
					
					
					sellItem_list, 
					sellButton, sellCancelButton,
					demand_label, demand_box,
					itemsToSell_label, itemsToSell_box, itemsToSell_box_bg,
					marketAdjustSell_label, marketAdjustSell_box,
					salesTaxSell_label, salesTaxSell_box,
					totalReturn_label, totalReturn_box,
					
					buyItem_list,
					buyButton, buyCancelButton,
					supply_label, supply_box,
					itemsToBuy_label, itemsToBuy_box, itemsToBuy_box_bg,
					marketAdjustBuy_label, marketAdjustBuy_box,
					salesTaxBuy_label, salesTaxBuy_box,
					totalDue_label, totalDue_box,
					
					statusBackground, statusFrame, statusLabel 
					
					};

	onUnload = "call trunk_close;";
	
	
	

	class buyItem_list : RscListBox {
		idc = buyItem_list_idc;
		moving = 1;
		x = 0.44; y = -0.10;
		w = 0.42; h = 0.48;
		onLBSelChanged = "_this call shop_update_buy_item;";
	};
	
	class itemsToBuy_label : RscText {
		x = 0.44; y = 0.40;
		w = 0.20; h = 0.04;
		SizeEX=0.026;
		text = "Items to buy: ";
	};
	
	class itemsToBuy_box : RscEdit {
		idc = itemsToBuy_box_idc;
		x = 0.65; y = 0.40;
		w = 0.2105; h = 0.04;
		text = "1";
		onKeyUp = "_this call shop_update_buy_item;";
	};
	
	class itemsToBuy_box_bg : RscText {
		x = 0.65; y = 0.40;
		w = 0.2105; h = 0.04;
		colorBackground[] = BOX_BACKGROUND;
	};
	
	class supply_label : RscText {
		x = 0.44; y = 0.45;
		w = 0.20; h = 0.04;
		SizeEX=0.026;
		text = "Supply:";
	};
	
	class supply_box : RscText {
		idc = supply_box_idc;
		x = 0.65; y = 0.45;
		w = 0.2105; h = 0.04;
		colorBackground[] = BOX_BACKGROUND;
		text = "0";
	};
	
	class marketAdjustBuy_label : RscText {
		x = 0.44; y = 0.50;
		w = 0.20; h = 0.04;
		SizeEX=0.026;
		text = "Market adjustment:";
	};
	
	class marketAdjustBuy_box : RscText {
		idc = marketAdjustBuy_box_idc;
		x = 0.65; y = 0.50;
		w = 0.2105; h = 0.04;
		colorBackground[] = BOX_BACKGROUND;
		text = "$0";
	};
	
	class salesTaxBuy_label : RscText {
		x = 0.44; y = 0.55;
		w = 0.20; h = 0.04;
		SizeEX=0.026;
		text = "Sales tax:";
	};
	
	class salesTaxBuy_box : RscText {
		idc = salesTaxBuy_box_idc;
		x = 0.65; y = 0.55;
		w = 0.2105; h = 0.04;
		colorBackground[] = BOX_BACKGROUND;
		text = "$0";
	};
	
	class totalDue_label : RscText {
		x = 0.44; y = 0.60;
		w = 0.20; h = 0.04;
		SizeEX=0.026;
		text = "Total due:";
	};
	
	class totalDue_box : RscText {
		idc = totalDue_box_idc;
		x = 0.65; y = 0.60;
		w = 0.2105; h = 0.04;
		colorBackground[] = BOX_BACKGROUND;
		text = "$0";
	};
	
	class put_gear_label_idc : RscText {
		idc = put_gear_label_idc;
		x = 0.44; y = 0.65;
		w = 0.30; h = 0.04;
		SizeEX=0.026;
	};
	
	class cbox: SCheckBox {
		x = 0.44; y = 0.65;
		w = 0.30; h = 0.04;
		onCheckBoxesSelChanged = "call shop_toggle_put_gear_cb; call shop_update_buy_item;";
	};

	class buyFrame : SBgFrame {
		x = 0.42; y = -0.13;
		w = 0.46; h = 0.90;
		text = "Buy Items";
	};
	
	class buyBackground: RscBackground {
		moving = 1;
		x = 0.42; y = -0.13;
		w = 0.46; h = 0.90;
	};
	
	class buyButton : RscButton {
		idc = buyButton_idc;
		x = 0.44; y = 0.70;
		w = 0.20; h = 0.04;
		text = "Buy";
		colorBackgroundDisabled[] = DISABLED_BUTTON_BACKGROUND;
		colorDisabled[] = DISABLED_BUTTON_TEXT;
	};

	class buyCancelButton : RscButton {
		x = 0.6605; y = 0.70;
		w = 0.20; h = 0.04;
		text = "Cancel";
		action = "closedialog 0";
	};
	
	class sellItem_list : RscListBox 	{
		idc = sellItem_list_idc;
		moving = 1;
		x = 0.93; y = -0.10;
		w = 0.42; h = 0.48;
		onLBSelChanged = "_this call shop_update_sell_item;";
	};
	
	class itemsToSell_label : RscText {
		x = 0.93; y = 0.40;
		w = 0.20; h = 0.04;
		SizeEX=0.026;
		text = "Items to sell: ";
	};
	
	class itemsToSell_box : RscEdit {
		idc = itemsToSell_box_idc;
		x = 1.14; y = 0.40;
		w = 0.2105; h = 0.04;
		text = "1";
		onKeyUp = "_this call shop_update_sell_item;";
	};
	
	class itemsToSell_box_bg : RscText {
		x = 1.14; y = 0.40;
		w = 0.2105; h = 0.04;
		colorBackground[] = BOX_BACKGROUND;
	};
	
	class demand_label : RscText {
		x = 0.93; y = 0.45;
		w = 0.20; h = 0.04;
		SizeEX=0.026;
		text = "Demand:";
	};
	
	class demand_box : RscText {
		idc = demand_box_idc;
		x = 1.14; y = 0.45;
		w = 0.2105; h = 0.04;
		colorBackground[] = BOX_BACKGROUND;
		text = "0";
	};
	
	
	
	class marketAdjustSell_label : RscText {
		x = 0.93; y = 0.50;
		w = 0.20; h = 0.04;
		SizeEX=0.026;
		text = "Market adjustment:";
	};
	
	class marketAdjustSell_box : RscText {
		idc = marketAdjustSell_box_idc;
		x = 1.14; y = 0.50;
		w = 0.2105; h = 0.04;
		colorBackground[] = BOX_BACKGROUND;
		text = "$0";
	};
	
	class salesTaxSell_label : RscText {
		x = 0.93; y = 0.55;
		w = 0.20; h = 0.04;
		SizeEX=0.026;
		text = "Sales tax:";
	};
	
	class salesTaxSell_box : RscText {
		idc = salesTaxSell_box_idc;
		x = 1.14; y = 0.55;
		w = 0.2105; h = 0.04;
		colorBackground[] = BOX_BACKGROUND;
		text = "$0";
	};
	
	class totalReturn_label : RscText {
		x = 0.93; y = 0.60;
		w = 0.20; h = 0.04;
		SizeEX=0.026;
		text = "Total return:";
	};
	
	class showAllSellItems_label : RscText {
		idc = showAllSellItems_label_idc;
		x = 0.93; y = 0.65;
		w = 0.30; h = 0.04;
		SizeEX=0.026;
	};
	
	class showAllSellItems_cbox: SCheckBox {
		x = 0.93; y = 0.65;
		w = 0.30; h = 0.04;
		onCheckBoxesSelChanged = "call shop_toggle_sell_cb; [] spawn shop_update_sell_list;";
	};
	
	class totalReturn_box : RscText {
		idc = totalReturn_box_idc;
		x = 1.14; y = 0.60;
		w = 0.2105; h = 0.04;
		colorBackground[] = BOX_BACKGROUND;
		text = "$0";
	};
	
	class sellFrame : SBgFrame {
		x = 0.91; y = -0.13;
		w = 0.46; h = 0.90;
		text = "Sell Items";
	};
	
	class sellBackground: RscBackground {
		moving = 1;
		x = 0.91; y = -0.13;
		w = 0.46; h = 0.90;
	};

	
	class sellButton : RscButton {
		idc = sellButton_idc;
		x = 0.93; y = 0.70;
		w = 0.20; h = 0.04;
		text = "Sell";
		colorBackgroundDisabled[] = DISABLED_BUTTON_BACKGROUND;
		colorDisabled[] = DISABLED_BUTTON_TEXT;
	};

	class sellCancelButton : RscButton {
		x = 1.1505; y = 0.70;
		w = 0.20; h = 0.04;
		text = "Cancel";
		action = "closedialog 0;";
	};
	
	class statusLabel : RscText {
		idc = statusLabel_idc;
		x = 0.42; y = 0.80;
		w = 0.949; h =  0.05;
		SizeEX=0.024;
		text = "";
	};
	

	
	class statusFrame : SBgFrame {
		x = 0.42; y = 0.80;
		w = 0.949; h = 0.05;
	};
	
	class statusBackground: RscBackground {
		moving = 1;
		x = 0.42; y = 0.80;
		w = 0.949; h = 0.05;
	};


	class shopControl : RscDummy {
		idc = shopControl_idc;
	};
};
