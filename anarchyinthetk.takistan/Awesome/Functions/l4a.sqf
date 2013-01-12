if (!isNil "l4a_functions_defined") exitWith {};

//la4 - log 4 arma

l4a_file = toArray "l4a.log";

if (isServer) then {
	l4a_print = {
		_value = _this select 0;
		/* player groupChat format["Printing: %1", _value]; */
		"stdio" callExtension format["append(%1)%2%3", toString l4a_file, _value, toString [10]];
	};

    l4a_recv = {
		_name = _this select 0;
		_value = _this select 1;
		[_value] call l4a_print;
	};
	
	l4a_value = " ";
	"l4a_value" addPublicVariableEventHandler {_this call l4a_recv;};
};

l4a = {
	/* player groupChat format["l4a: %1", _this]; */
	if (isNil "_this") exitWith { /*player groupChat format["l4a: exit _this is nil"]*/ };
	if (typeName _this != "ARRAY") exitWith { /*player groupChat format["l4a: exit _this is not ARRAY, %1", typeName _this]*/ };
	private ["_line"];
	
	_line = _this select 0;
	
	if (isNil "_line") exitWith { /*player groupChat format["l4a: exit _line is nil"]*/};
	if (typeName _line != "STRING") exitWith { /*player groupChat format["l4a: exit _line is not STRING, %1", typeName _line]*/};
	
	
	if (isServer) then {
		[_line] call l4a_print;
	}
	else {
		l4a_value = _line;
		publicVariable "l4a_value";
	};
};

l4a_functions_defined = true;