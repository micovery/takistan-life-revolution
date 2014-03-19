// Functions for donator and admin lists on the server

listFile_Dir = "server\";
listFile_Admins = listFile_Dir + "admins.log";

listFile_RunFile = {
	private["_file","_fileLoad"];
	_file = _this select 0;
	
	_fileLoad = preProcessFileLineNumbers _file;
	if (_fileLoad != "") then {
		[] call (compile _fileLoad);
	};
};

listFile_loadFile = {
	private["_file","_variable","_i","_true","_text","_array","_out"];
	_file = _this select 0;
	_variable = _this select 1;
					
	_i = 0;
	_true = true;
	_text = "";
	_array = [];
			
	_out = "stdio" callExtension format["read(%1,%2)", _file, _i];
				
	if (_out == "") then {
		_true = false;
		_text = "[]";
	};
	while {_true} do {
		_text = _text + _out;
		_i = _i + 1;
		_out = "stdio" callExtension format["read(%1,%2)", _file, _i];
		_true = (_out != "");
	};
				
	_array = [] call compile _text;
	missionNamespace setVariable [_variable, _array];
};


ListAdmins 	= [];
isAdmin = false;

listFile_loadAdmins = {
	[listFile_Admins, "ListAdmins"] call listFile_loadFile;
};

listFile_refreshAdmins_S = {
	private["_oldArray","_refresh"];
	_oldArray = + ListAdmins;
	[] call listFile_loadAdmins;
	
	if ((count _oldArray) != (count listAdmins)) exitwith {
		server setVariable ["listAdmins",listAdmins,true];
	};
	
	_refresh = false;
	{
		if !(_x in ListAdmins) exitwith {_refresh = true;};
	} forEach _oldArray;
	{
		if !(_x in _oldArray) exitwith {_refresh = true;};
	} forEach listAdmins;
	
	if _refresh then {
		server setVariable ["listAdmins",listAdmins,true];
	};
};

listFile_refreshAdmins_C = {
	listAdmins = server getVariable ["listAdmins", []];
	isAdmin = (getPlayerUID player) in listAdmins;
};

