if (not(isNil "quicksort_functions_defined")) exitWith {};

sort_key = 0;
sort_data = 1;

qsort_swap = {
	private["_left", "_right", "_temp", "_array"];
	_array = _this select 0;
	_left = _this select 1;
	_right = _this select 2;
	_temp = _array select _left;
	_array set [_left, (_array select _right)];
	_array set [_right, _temp];
};

qsort_partition = {
   private["_left", "_right", "_pivot", "_pivot_value", "_i", "_store_index", "_array"];
   _array =  _this select 0;
   _left = _this select 1;
   _right = _this select 2;
   _pivot = _this select 3;
   
   _pivot_value = (_array select _pivot) select sort_key;
   
	[_array, _pivot, _right] call qsort_swap;
	_store_index = _left;
	_i = _left;
	while { _i <= (_right - 1) } do {
		if (((_array select _i) select sort_key) < _pivot_value) then {
			[_array, _i, _store_index] call qsort_swap;
			_store_index = _store_index + 1;
		};
		_i = _i + 1;
	};
	
	[_array, _store_index, _right] call qsort_swap;
	_store_index
};

qsort = {
	private["_left", "_right", "_pivot", "_array"];

	_array = _this select 0;
	_left  = _this select 1;
	_right = _this select 2;
	
	if (not(_left < _right)) exitWith { _array };
	  		  
	_pivot = floor((_left + _right)/2);
	_pivot = ([_array, _left, _right, _pivot] call qsort_partition);
 
	[_array, _left, (_pivot - 1)] call qsort;
	[_array, (_pivot + 1), _right] call qsort;
};

quicksort = {
	[_this, 0, ((count _this) - 1)] call qsort;
};

quicksort_functions_defined = true;