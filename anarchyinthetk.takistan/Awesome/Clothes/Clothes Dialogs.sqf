private["_group", "_side", "_fac"];

_group = group player;
_side = playerSide;
_fac = faction player;

C_shopnum 		= ((_this select 3) select 0);
C_shoparray		= Clothing_Shops select C_shopnum;
C_ShopList		= [];
C_ShopList		= C_shoparray select 1;

private["_shopaside", "_shopabool", "_shopalic"];
_shopaside		= C_shoparray select 2;
_shopabool		= C_shoparray select 3;
_shopalic		= C_shoparray select 4;

C_List = [];
C_tstorage = [];

if (isciv) then { C_tstorage = C_storage_civ; };
if (iscop) then { C_tstorage = C_storage_west; };
if (isopf) then { C_tstorage = C_storage_east; };
if (isins) then { C_tstorage = C_storage_guer; };

private["_exit", "_haslic"];

_exit = false;
_haslic = true;

if (C_Side != _shopaside) then {
	player groupchat format["This shop is not for your side: %1", C_Side];
	_exit = true;
};

private["_i"];
_i = 0;
while { _i < (count _shopalic) } do {
	_license = (_shopalic select _i);
	_haslic_i = _license call INV_HasLicense;
	
	if (not(_haslic_i)) then {
		player groupchat format ['You require the license: %1',(_license call INV_GetLicenseName)];
		_haslic = false;
	};
	_i = _i + 1;
};

if (!(_haslic)) exitwith {};
if (_exit) exitwith {};

C_exit = false;
C_choice = "";

[] call C_Dialog_Choice;

if (C_exit) exitwith {};
if ((C_choice == "")) exitwith {};

if ((C_choice != "store") && (C_choice != "storage")) exitwith {};

player groupchat "For easy Textures select the following options:";
player groupchat "Top right box: Select a numbered slot for the textures";
player groupchat "*WARNING SOME VEHICLES DO NOT HAVE TEXTURE SLOTS*";
player groupchat "Styles dropbox: Custom";
player groupchat "Custom dropbox: Whatever color you want";
player groupchat "Then select apply and buy!";

tlr_hud_array set [(count tlr_hud_array), ["For easy Textures select the following options:",(time+5)]];
tlr_hud_array set [(count tlr_hud_array), ["Top right box: Select a numbered slot for the textures",(time+5)]];
tlr_hud_array set [(count tlr_hud_array), ["*WARNING SOME VEHICLES DO NOT HAVE TEXTURE SLOTS*",(time+5)]];
tlr_hud_array set [(count tlr_hud_array), ["Styles dropbox: Custom",(time+5)]];
tlr_hud_array set [(count tlr_hud_array), ["Custom dropbox: Whatever color you want",(time+5)]];
tlr_hud_array set [(count tlr_hud_array), ["Then select apply and buy!",(time+5)]];

if (C_choice == "store") exitwith {
		C_List = C_ShopList;
		[] call C_Dialog_Full;
	};
	
if (C_choice == "storage") exitwith {
		C_List = C_tstorage + [format["%1",([C_original_c] call C_array_c) select 0]];
		[] call C_Dialog_Full;	
	};









