if (!(createDialog "GFX_GrafikEinstellungenDialog")) exitWith {
tlr_hud_array set [(count tlr_hud_array), ["DialogError",(time+5)]];
};
if ((count _this) > 0) then {buttonSetAction [10, _this select 0];};