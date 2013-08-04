#define SleepWait(timeA) private["_waittt"]; _waittt = time + timeA; waitUntil {time >= _waittt};

A_RESTART_CHECK = {server getVariable ["RESTART", false]};

A_RESTART = [] call A_RESTART_CHECK;

A_RESTART_S = {
		server setVariable ["RESTART", true, true];
	};

A_RESTART_C = {
		if !([] call A_RESTART_CHECK) exitwith {};
		private["_messageString", "_TL"];
		_messageString = "YOU HAVE %1 SECONDS TO LEAVE BEFORE BEING KICKED TO ENSURE SAVING OF STATS FOR SERVER RESTART";
		_TL = 0;
		for [{_TL = 60}, {_TL > 0}, {_TL = _TL - 5}] do {
				server globalChat format[_messageString, _TL];
				SleepWait(5)
			};
		failMission "END1";
	};






