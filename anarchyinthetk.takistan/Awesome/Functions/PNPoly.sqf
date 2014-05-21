/*

Copyright (c) 1970-2003, Wm. Randolph Franklin (http://www.ecse.rpi.edu/~wrf/Research/Short_Notes/pnpoly.html)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimers.
    2. Redistributions in binary form must reproduce the above copyright notice in the documentation and/or other materials provided with the distribution.
    3. The name of W. Randolph Franklin may not be used to endorse or promote products derived from this Software without specific prior written permission. 

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. 

Ported to ArmA script by chill0r (www.takistanliferevolution.com)

*/

if (not(isNil "PNPoly")) exitWith {};

PNPoly = {
	
	/*
		Call:
		[polygon, pointx, pointy] call PNPoly;
		polygon in format: [[x1, y1], [x2,y2], [x3, y3]...]
		pointx = the point in x position to check
		pointy = the point in y position to check
	
	*/
	
	private["_nv", "_vx", "_vy", "_tx", "_ty", "_gp", "_tmp"];
	_gp = _this select 0;
	_tx = _this select 1;
	_ty = _this select 2;
	_nv = count _gp;
	_tmp = 0;
	_vy = [];
	_vx = [];
	{
		_vx set [_tmp, (_x select 0)];
		_vy set [_tmp, (_x select 1)];
		_tmp = _tmp + 1;
	} foreach _gp;
	private["_i", "_j", "_c"];
	_i = 0;
	_j = _nv - 1;
	_c = false;
	private["_t1", "_t2", "_t3"];
	for [{_i = 0}, {_i < _nv}, {_i = _i + 1}] do {
		//ArmA can't check boolean for not equal so we have to use integers...
		if ((_vy select _i) > _ty) then {_t1 = 1;} else {_t1=0;};
		_t2 = if ((_vy select _j) > _ty) then {1} else {0};
		_t4 = ((_vy select _j) - (_vy select _i));
		//Close to 0 or we could get a divided by zero error (DO NOT DIVIDE BY ZERO!)
		if (_t4 == 0) then {_t4 = 0.00000000000000001;};
		_t3 = (_tx < (((_vx select _j) - (_vx select _i)) * (_ty - (_vy select _i)) / _t4 + (_vx select _i)));
		if ((_t1 != _t2) and _t3) then {
			_c = !_c;
		};
		_j = _i;
	};
	_c
};

/*
For testing:
private["_poly", "_px", "_py"];
_poly = [[0,0],[0,2],[2,2],[2,0]];
_px = 1.999;
_py = 1.75;

player groupChat format["%1",[_poly, _px, _py] call PNPoly];

*/