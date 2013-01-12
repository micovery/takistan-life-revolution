// Namecheck.sqf

player groupchat "checking name";

_name = name player;
_namearray = toArray _name;

//player groupchat format['%1', _namearray];

for [{_i = 0}, {_i < (count _namearray)}, {_i = _i + 1}] do
	{
		_check = _namearray select _i;
		if (_check == 39) then
			{
				_invalid = format["Invalid character:  "];
				player groupchat "Invalid character in name, please rejoin with a different name";
				player groupchat (_invalid + toString _check);
				
			};
	};