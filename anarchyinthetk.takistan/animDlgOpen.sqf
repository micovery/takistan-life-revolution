//  Animations Dialogue
// animDlgOpen.sqf
if (!(createDialog "animationsdialog")) exitWith
{
	tlr_hud_array set [(count tlr_hud_array), ["DialogError",(time+5)]];
};

{
	_index = lbAdd [1, (_x select 3)];
	lbSetData [1, _index, (_x select 1)];
} forEach ANIM_AllAnimationArray;

buttonSetAction [2, "[lbCurSel 1, (lbData [1, (lbCurSel 1)])] execVM ""animplay.sqf""; closedialog 0;"];