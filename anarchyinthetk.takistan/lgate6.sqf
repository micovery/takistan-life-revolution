#define SleepWait(timeA) private["_waittt"]; _waittt = time + timeA; waitUntil {time >= _waittt};

terrgate setPosATL [(getPosATL terrgate select 0),(getPosATL terrgate select 1),-5];
SleepWait(20)
terrgate setPosATL [(getPosATL terrgate select 0),(getPosATL terrgate select 1),0];
