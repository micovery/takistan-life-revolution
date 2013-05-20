_this = _this select 3;
_art  = _this select 0;
_moneh = [player, 'money'] call INV_GetItemAmount;

if (_art == "ClientWahlc") then {
	if (isNil("WahlChief")) then { WahlChief = false;};
	if (WahlChief) exitWith { player groupChat "You just voted."; };
	_spielernum   = call compile (_this select 1);
	format["if (isServer) then {[0,1,2,[""ServerChief"", %1, %2]] execVM ""chief.sqf"";};", _spielernum, rolenumber] call broadcast;
	player groupChat format[localize "STRS_chief_votedfor", (playerstringarray select _spielernum)];
	WahlChief = true;
	sleep 15;
	WahlChief = false;
};

if (_art == "ServerChief") then {
	_kandidatnum = (_this select 1);
	_waehlernum  = ((_this select 2)-1);

	for [{_i=0}, {_i < count(WahlArrayc)}, {_i=_i+1}] do {
		_arr = (WahlArrayc select _i);
		if (_waehlernum in _arr) exitWith {_arr = _arr - [_waehlernum];	WahlArrayc SET [_i, _arr];};
	};

	WahlArrayc SET [_kandidatnum, ((WahlArrayc select _kandidatnum )+ [_waehlernum])];
};


if (_art == "steuernchief") then {
	_item = _this select 1;
	_mag  = _this select 2;
	_weap = _this select 3;
	_vcl  = _this select 4;
	_bank = _this select 5;
	format ["(INV_ItemTypeArray select 0) SET [2, %1]; (INV_ItemTypeArray select 1) SET [2, %2]; (INV_ItemTypeArray select 2) SET [2, %3]; (INV_ItemTypeArray select 3) SET [2, %4];bank_tax = %5; hint ""The President has changed the tax rates!"";", _item, _vcl, _mag, _weap, _bank] call broadcast;
};

