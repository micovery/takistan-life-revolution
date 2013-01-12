_a1 = 0; _f1 = 0;

while {true} do {

for [{_i=0}, {_i < (count LottoFlags)}, {_i=_i+1}] do

	{

	_flag = ((LottoFlags select _i) select 0);
	_arr  = ((LottoFlags select _i) select 1);
	if ((player distance _flag <= 5) and (_a1 == 0)) then

		{

		action_lotto = player addAction [format [localize "STRS_lotto_action"], "lottodialog.sqf", _arr];
		_a1 = 1;
		_f1 = _i;

		};

	if ((player distance _flag > 5) and (_i == _f1) and (_a1 == 1)) then

		{

		player removeAction action_lotto;
		_a1 = 0;

		};

	};

sleep 3;

};
