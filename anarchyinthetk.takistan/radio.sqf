_a = 0;
_t = 0;
_r = _this select 0;
_s = _this select 1;
_l = _this select 2;
_d = _this select 3;

while{alive HQ}do

{

if(player distance _r <= _d and _a == 0)then{playmusic _s; _a = 1; _t = time};

if(time > _t + _l and _a == 1)then{_a = 0};

_dplayer = player distance _r;

_v = 1 - (_dplayer/_d);

if(_v >= 0)then{0 fademusic _v};
if(musicvolume > 0 and _v < 0 and _a == 1)then{0 fademusic 0};

sleep 0.5;

};
