private["_arr","_i","_item","_anzahl","_anzeigename"];
_arr = _this select 0;
if (!(isNil "_arr")) then {_arr = (missionNamespace getVariable [_arr, []]);} else {_arr = [];};
if (!(createDialog "INV_list")) exitWith {hint "Dialog Error!";};
lbAdd [1, "Items in the Storage:"];
lbAdd [1, "---------------------"];

for [{_i=0}, {_i < (count _arr)}, {_i=_i+1}] do {
		_item        = (_arr select _i) select 0;
		_anzahl      = [(_arr select _i) select 1] call decode_number;
		_anzeigename = _item call INV_GetItemName;

		if (_anzahl > 0) then {
				lbAdd [1, format ["%1 - %2x", _anzeigename, _anzahl]];
			};

	};

