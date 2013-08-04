music_array = [];
music_arrayCount = 0;

music_compileList = {
		private["_config", "_i", "_count"];
		_config = configFile >> "cfgMusic";
		_count = count _config;
		for [{_i = 0}, {_i < _count}, {_i = _i + 1}] do {
				_trackTitle = configName(_config select _i);
				music_array set[_i, _trackTitle];
			};
		music_arrayCount = _count - 1;
	};

music_play_random = {
		[(music_array select (round(random music_arrayCount)))] call music_play;
	};
	
music_stop = {
		playMusic ["Short01_Defcon_Three", 37];
	};
	
music_play = {
		playMusic (_this select 0);
	};


[] call music_compileList;