#define SleepWait(timeA) private["_waittt"]; _waittt = time + timeA; waitUntil {time >= _waittt};

private["_randomamount", "_newAmount", "_money", "_stringVariable", "_i"];

for [{_i = 1}, {_i <= 9}, {_i = _i + 1}] do {
			_stringVariable = format["station%1money", _i];
			missionNamespace setVariable [_stringVariable, 5000];
			publicVariable _stringVariable;
		};

while {true} do {
	_randomamount = ceil ((random 250) + 250);
	_newAmount = 0;
	_money = 0;
	_stringVariable = "";
	
	for [{_i = 1}, {_i <= 9}, {_i = _i + 1}] do {
			_stringVariable = format["station%1money", _i];
			
			_money = missionNamespace getVariable [_stringVariable, 0];
			
			_newAmount = if ( (_money + _randomamount) > maxstationmoney) then {
					maxstationmoney
				}else{
					(_money + _randomamount)
				};
			
			missionNamespace setVariable [_stringVariable, _newAmount];
			publicVariable _stringVariable;
		};
	
	SleepWait(5 * 60)
};