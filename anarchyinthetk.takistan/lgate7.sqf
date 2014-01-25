#define SleepWait(timeA) private["_waittt"]; _waittt = time + timeA; waitUntil {time >= _waittt};

rgate1 setPosATL [(getPosATL rgate1 select 0),(getPosATL rgate1 select 1),-5];
SleepWait(20)
rgate1 setPosATL [(getPosATL rgate1 select 0),(getPosATL rgate1 select 1),0];
