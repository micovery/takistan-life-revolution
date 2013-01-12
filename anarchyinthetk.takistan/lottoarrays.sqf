playing_lotto = 0;

LottoArray =

[

["lotto1", 	"Cheap ticket",	100,	10000, 3],
["lotto2", 	"Normal ticket",500,	50000, 3],
["lotto3", 	"Super ticket",	1000,  250000, 3],
["lotto4",	"Mega ticket",	5000, 500000, 3]

];

LottoFlags =

[

[shop1,["lotto1", "lotto2", "lotto3", "lotto4"]],
[shop2,["lotto1", "lotto2", "lotto3", "lotto4"]],
[shop3,["lotto1", "lotto2", "lotto3", "lotto4"]],
[shop4,["lotto1", "lotto2", "lotto3", "lotto4"]]
//[shop5,["lotto1", "lotto2", "lotto3", "lotto4"]]

];

GetLottoArray =

{

private ["_c", "_lotto"];

for "_c" from 0 to (count LottoArray - 1) do

	{

	if (((LottoArray select _c) select 0) == _this) exitWith { (LottoArray select _c) };

	};

};