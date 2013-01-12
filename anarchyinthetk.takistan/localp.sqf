_trgobj = createTrigger ["EmptyDetector", position player ];
_trgobj setTriggerText "Fix head bug";
_trgobj setTriggerActivation ["JULIET", "PRESENT", true];
_trgobj setTriggerStatements ["this", "fixme = [] execVM ""headbug.sqf""",""];
