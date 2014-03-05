#define macroSub(VALUE, NUMBER) VALUE = VALUE - NUMBER;
#define macroSub1(VALUE) macroSub(VALUE, 1)
#define SleepWait(timeA) private["_waittt"]; _waittt = time + timeA; waitUntil {time >= _waittt};

private["_display", "_ctrl_1", "_ctrl_2", "_stext_1", "_stext_2", "_delayR", "_delayA", "_EML"];
disableSerialization;

// findDisplay 49
_display = _this select 0;

_ctrl_1 = _display displayCtrl 1010;
_ctrl_1 ctrlEnable false;
				
_ctrl_2 = _display displayCtrl 104;
_ctrl_2 ctrlEnable false;
		
_stext_1 = ctrlText _ctrl_1;
_stext_2 = ctrlText _ctrl_2;
		
_ctrl_1 buttonSetAction "respawnButtonPressed = time;";
		
_delayR = 30;
_delayA = [] call player_escape_menu_abortCheck;

if (_delayA > _delayR) then {
	_delayR = _delayA;
};
		
_EML = if (_delayA > _delayR)then{_delayA}else{_delayR};
		
while { _EML > 0 } do {
		if (isnull (findDisplay 49)) exitWith {};
				
		if (_delayR > 0) then {
				_ctrl_1 ctrlSetText format["%1(%2)", _stext_1, _delayR];	
				macroSub1(_delayR)
			}else{
				_ctrl_1 ctrlSetText _stext_1; 	
				_ctrl_1 ctrlEnable !(player getVariable ["restrained", false]);
			};
				
		if (_delayA > 0) then {
				_ctrl_2 ctrlSetText format["%1(%2)", _stext_2, _delayA];	
				macroSub1(_delayA)
			}else{
				_ctrl_2 ctrlSetText _stext_2; 	
				_ctrl_2 ctrlEnable !(player getVariable ["restrained", false]);
			};
				
		macroSub1(_EML)
		SleepWait(1)
	};
					
if (!isnull (findDisplay 49)) then {
		_ctrl_1 ctrlSetText _stext_1; 	_ctrl_1 ctrlEnable true;
		_ctrl_2 ctrlSetText _stext_2; 	_ctrl_2 ctrlEnable true;
	};