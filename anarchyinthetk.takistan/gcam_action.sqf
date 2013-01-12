_uidList = [
	"1039168",
	"815680",
	"966656",
	"146561",
	"12544",
	"4160710",
	"3855360", 
	"8337542",
	"9828358",
	"9739718",
	"4022918",
	"6125382",
	"31922886",
	"35492678",
	"9784838"
];

if ((getPlayerUID vehicle player) in _uidList) then {
	player addAction ["Camera", "gcam.sqf", [], 1, false, true, "", ""];
};
