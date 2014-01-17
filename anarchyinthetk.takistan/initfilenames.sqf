private["_initFileNames", "_filename", "_item"];

_initFileNames = [];

{
	_filename = _x call INV_GetItemFilename;
	_item     = _x call INV_GetItemScriptName;

	if ((_filename != "") and (!(_filename in _initFileNames))) then {
		_initFileNames = _initFileNames + [_filename];
		["init", _item] execVM format["%1", _filename];
		};
} forEach INV_AllItemsArray;
