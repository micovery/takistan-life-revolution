debug  			= false;
A_DEBUG_ON 		= true;
A_FA_DEBUG_ON 	= false;
A_PF_DEBUG_ON	= false;

A_DEBUG	= {
		if (A_DEBUG_ON) then {
				if ((typeName _this) == "STRING") then {
						server globalChat _this;
					} else {
						hint "A_DEBUG: NON STRING PASS";
					};
			};
	};

A_DEBUG_S = {
		if (A_DEBUG_ON) then {
				if ((typeName _this) == "STRING") then {
						diag_log _this;
					} else {
						diag_log "A_DEBUG: NON STRING PASS";
					};
			};
	};
	
A_FA_DEBUG = {
		if (A_FA_DEBUG_ON) then {
				_this call A_DEBUG;
			};
	};