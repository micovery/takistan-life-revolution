if (!(createDialog "lotto")) exitWith {hint "Dialog Error!";};
_lottoScheine = (_this select 3);
buttonSetAction [2, "[ lbData[1, (lbCurSel 1)] ] execVM ""lotto.sqf""; closeDialog 0"];

{

_lottoArray = _x call GetLottoArray;
_index = lbAdd [1, format["%1 ($%2)", (_lottoArray select 1), (_lottoArray select 2)]];
lbSetData [1, _index, (_lottoArray select 0)];

} forEach _lottoScheine;

lbSetCurSel [1, 0];