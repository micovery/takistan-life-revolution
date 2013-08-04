#define SleepWait(timeA) private["_waittt"]; _waittt = time + timeA; waitUntil {time >= _waittt};


pmcgate setPosATL [(getPosATL pmcgate select 0),(getPosATL pmcgate select 1), -5];
SleepWait(20)
pmcgate setPosATL [(getPosATL pmcgate select 0),(getPosATL pmcgate select 1), 0];


/*	pmcgate1 setPosATL [(getPosATL pmcgate1 select 0),(getPosATL pmcgate1 select 1),-5];
	pmcgate2 setPosATL [(getPosATL pmcgate2 select 0),(getPosATL pmcgate2 select 1),-5];

	pmcgate1 setPosATL [(getPosATL pmcgate1 select 0),(getPosATL pmcgate1 select 1),0];
	pmcgate2 setPosATL [(getPosATL pmcgate2 select 0),(getPosATL pmcgate2 select 1),0];
*/