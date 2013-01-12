if (!isNil "bank_functions_defined") exitWith {};

bank_get_value =
{
	private ["_value"];
	_value = ([bankaccount] call decode_number);
	//player groupChat format["bank_get_value: bankaccount = %1, _value = %2", bankaccount, _value];
	_value
};

bank_set_value = 
{
	private ["_value"];
	_value = _this select 0;
	bankaccount = ([_value] call encode_number);
	_value
};


bank_transaction = 
{
	private["_value", "_cvalue"];
	_value = _this select 0;
	
	if (isNil "_value") exitWith {};
	if (typeName _value != "SCALAR") exitWith { player groupChat format["ERROR: bank_transaction: _value = %1, not SCALAR", _value]; 0};
	
	//player groupChat format["Bank Tnx: %1", _value ];
	
	
	_cvalue = call bank_get_value;
	_cvalue = _cvalue + _value;
	[_cvalue] call bank_set_value;
	_cvalue
};

bank_functions_defined = true;