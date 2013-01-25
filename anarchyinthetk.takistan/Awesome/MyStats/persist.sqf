invoke_java_method = {
	if (isNil "_this") exitWith{""};
	if (typeName _this != "ARRAY") exitWith {""};
	if (count _this == 0) exitWith {""};
	
	private["_i", "_count", "_arguments", "_method"];
	_method = _this select 0;
	if (typeName _method != "STRING") exitWith {};
	
	_count = count _this;
	_arguments = [];
	
	_i = 1;
	while { _i < _count } do {
		private["_argument"];
		_argument = _this select _i;
		_argument = if (typeName _argument != "STRING") then { format["%1", _argument] } else {_argument};
		_arguments set [(_i - 1), _argument];
		_i = _i + 1;
	};
		
	private["_argument_str", "_method_str", "_invoke_str"];
	_argument_str = "";
	
	_i = 0;
	_count = count _arguments;
	while { _i < _count } do {
		_argument_str = _argument_str + "<A>" + (_arguments select _i)  + "</A>";
		_i = _i + 1;
	};
	
	_argument_str = "<AL>" + _argument_str + "</AL>";
	_method_str = "<M>" + _method + "</M>";
	_invoke_str = "<MI>" + _method_str + _argument_str + "</MI>";
	
	//diag_log _invoke_str;
	private["_result"];
	_result = "jni" callExtension _invoke_str;
	
	_result
};

parseResult = {
	private["_result"];
	_result = _this select 0;
	if (isNil "_result") exitWith {-1};
	if (typeName "_result" != "STRING") exitWith {-1};
	
	_result = parseNumber(_result);
	if (isNil "_result") exitWith {-1};
	if (typeName _result != "SCALAR") exitWith {-1};
	_result
};

updatePlayerVariable = {
	private["_uid", "_variable_name", "_variable_value"];
	
	_uid = _this select 0;
	_variable_name = _this select 1;
	_variable_value = _this select 2;
	
	if (isNil "_uid") exitWith{};
	if (isNil "_variable_name") exitWith{};
	if (isNil "_variable_value") exitWith {};
	
	if (typeName _uid != "STRING") exitWith {};
	if (typeName _variable_name != "STRING") exitWith {};
	
	_variable_value = if (typeName _variable_value != "STRING") then {format["%1", _variable_value]} else {_variable_value};
	
	private["_result"];
	_result = ["updatePlayerVariable", _uid, _variable_name, _variable_value] call invoke_java_method;
	([_result] call parseResult)
};

getPlayerVariable = {
	private["_uid", "_variable_name"];
	
	_uid = _this select 0;
	_variable_name = _this select 1;
	
	if (isNil "_uid") exitWith{""};
	if (isNil "_variable_name") exitWith {""};
	if (typeName _uid != "STRING") exitWith {""};
	if (typeName _variable_name != "STRING") exitWith {""};
	
	private["_result"];
	_result = ["getPlayerVariable", _uid, _variable_name] call invoke_java_method;
	_result
};

removePlayerVariable = {
	private["_uid", "_variable_name"];
	
	_uid = _this select 0;
	_variable_name = _this select 1;
	
	if (isNil "_uid") exitWith{-1};
	if (isNil "_variable_name") exitWith {-1};
	if (typeName _uid != "STRING") exitWith {-1};
	if (typeName _variable_name != "STRING") exitWith {-1};
	
	private["_result"];
	_result = ["removePlayerVariable", _uid, _variable_name] call invoke_java_method;
	([_result] call parseResult)
};

getPlayerVariablesCount = {
	private["_uid"];
	
	_uid = _this select 0;
	if (isNil "_uid") exitWith{-1};

	private["_result"];
	_result = ["getPlayerVariablesCount", _uid] call invoke_java_method;
	([_result] call parseResult)
};

getPlayerVariableNameByIndex = {
	private["_uid", "_index"];
	
	_uid = _this select 0;
	_index = _this select 1;
	
	if (isNil "_uid") exitWith{-1};
	if (isNil "_index") exitWith {-1};
	if (typeName _uid != "STRING") exitWith {-1};
	if (typeName _index != "SCALAR") exitWith {-1};
	
	private["_result"];
	_result = ["getPlayerVariableNameByIndex", _uid, _index] call invoke_java_method;
	_result
};

getAllPlayerVariables = {
	private["_uid", "_result"];
	
	_uid = _this select 0;
	if (isNil "_uid") exitWith{[]};
	if (typeName _uid != "STRING") exitWith {[]};
	
	private["_i", "_count"];
	_count = [_uid] call getPlayerVariablesCount;
	if (_count <= 0) exitWith {[]};
	_i = 0;
	_result = [];
	while {_i < _count } do {
		 private["_variable_name", "_variable_value"];
		 _variable_name = [_uid, _i] call getPlayerVariableNameByIndex;
		 _variable_value = [_uid, _variable_name] call getPlayerVariable;
		 _result = _result + [[_variable_name, _variable_value]];
		 _i = _i + 1;
	};
	_result
};

wipePlayerVariables = {
	private["_uid"];
	
	_uid = _this select 0;
	if (isNil "_uid") exitWith{[]};
	if (typeName _uid != "STRING") exitWith {[]};
	
	private["_result"];
	_result = ["wipePlayerVariables", _uid] call invoke_java_method;
	([_result] call parseResult)
};

wipeAllPlayerVariables = {
	private["_result"];
	_result = ["wipeAllPlayerVariables"] call invoke_java_method;
	([_result] call parseResult)
};

unloadPlayerVariables = {
	private["_uid"];
	
	_uid = _this select 0;
	if (isNil "_uid") exitWith{[]};
	if (typeName _uid != "STRING") exitWith {[]};
	
	private["_result"];
	_result = ["unloadPlayerVariables", _uid] call invoke_java_method;
	([_result] call parseResult)
};

reloadPlayerVariables = {
	private["_uid"];
	
	_uid = _this select 0;
	if (isNil "_uid") exitWith{[]};
	if (typeName _uid != "STRING") exitWith {[]};
	
	private["_result"];
	_result = ["reloadPlayerVariables", _uid] call invoke_java_method;
	([_result] call parseResult)
};

getenv = {
	private["_key"];
	
	_key = _this select 0;
	if (isNil "_key") exitWith{[]};
	if (typeName _key != "STRING") exitWith {[]};
	
	private["_result"];
	_result = ["getenv", _key] call invoke_java_method;
	if (isNil "_result") exitWith { "" };
	if (typeName _result != "STRING") exitWith {""};
	_result
};

setLocation = {
	private["_location"];
	
	_location = _this select 0;
	if (isNil "_location") exitWith{[]};
	if (typeName _location != "STRING") exitWith {[]};
	
	private["_result"];
	_result = ["setLocation", _location] call invoke_java_method;
	if (isNil "_result") exitWith { "" };
	if (typeName _result != "STRING") exitWith {""};
	_result
};

logThis_request_receive = {
	diag_log format["logThis_request_receive %1", _this];
	private["_variable", "_request"];
	_variable = _this select 0;
	_request = _this select 1;

	if (isNil "_request") exitWith {};
	if (typeName _request != "ARRAY") exitWith {};

	private["_text"];
	_text = _request select 0;
	if (isNil "_text") exitWith{};
	if (typeName _text != "STRING") exitWith {};
	
	private["_result"];
	_result = ["logThis", _text] call invoke_java_method;
	if (isNil "_result") exitWith { "" };
	if (typeName _result != "STRING") exitWith {""};
	_result
};

logThis_setup = {
	if (not(isServer)) exitWith {};
	diag_log format["logThis_setup %1", _this];
	
	logThis_request_buffer =  " ";
	publicVariableServer "logThis_request_buffer";
	"logThis_request_buffer" addPublicVariableEventHandler { _this call logThis_request_receive;};
};

logThis = {
	private["_text"];
	_text = _this select 0;
	if (isNil "_text") exitWith{[]};
	if (typeName _text != "STRING") exitWith {[]};

	logThis_request_buffer = [_text];
	if (isServer) then {
		["", logThis_request_buffer] call logThis_request_receive;
	}
	else {
		publicVariableServer "logThis_request_buffer";
	};
};

logError = {
	private["_text"];
	_text = _this select 0;
	if (isNil "_text") exitWith{[]};
	if (typeName _text != "STRING") exitWith {[]};
	
	_text = "ERROR: " + _text + toString[13,10];
	[_text] call logThis;
};

logWarning = {
	private["_text"];
	_text = _this select 0;
	if (isNil "_text") exitWith{[]};
	if (typeName _text != "STRING") exitWith {[]};
	
	_text = "WARNING: " + _text + toString[13,10];
	[_text] call logThis;
};

logInfo = {
	private["_text"];
	_text = _this select 0;
	if (isNil "_text") exitWith{[]};
	if (typeName _text != "STRING") exitWith {[]};
	
	_text = "INFO: " + _text + toString[13,10];
	[_text] call logThis;
};

[] call logThis_setup;
