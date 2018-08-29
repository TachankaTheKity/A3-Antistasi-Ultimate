if (count hcSelected player == 0) exitWith {hint "You must select one group on the HC bar"};

private ["_grupo","_veh","_texto"];

/*
_esStatic = false;
{if (vehicle _x isKindOf "StaticWeapon") exitWith {_esStatic = true}} forEach units _grupo;
if (_esStatic) exitWith {hint "Static Weapon squad vehicles cannot be managed"};
*/

if (_this select 0 == "mount") exitWith
	{
	_texto = "";
	{
	_grupo = _x;
	_veh = objNull;
	{
	_owner = _x getVariable "owner";
	if (!isNil "_owner") then {if (_owner == _grupo) exitWith {_veh = _x}};
	} forEach vehicles;
	if !(isNull _veh) then
		{
		_transporte = true;
		if (count allTurrets [_veh, false] > 0) then {_transporte = false};
		if (_transporte) then
			{
			if (leader _grupo in _veh) then
				{
				_texto = format ["%2%1 dismounting\n",groupID _grupo,_texto];
				{[_x] orderGetIn false; [_x] allowGetIn false} forEach units _grupo;
				}
			else
				{
				_texto = format ["%2%1 boarding\n",groupID _grupo,_texto];
				{[_x] orderGetIn true; [_x] allowGetIn true} forEach units _grupo;
				};
			}
		else
			{
			if (leader _grupo in _veh) then
				{
				_texto = format ["%2%1 dismounting\n",groupID _grupo,_texto];
				if (canMove _veh) then
					{
					{[_x] orderGetIn false; [_x] allowGetIn false} forEach assignedCargo _veh;
					}
				else
					{
					_veh allowCrewInImmobile false;
					{[_x] orderGetIn false; [_x] allowGetIn false} forEach units _grupo;
					}
				}
			else
				{
				_texto = format ["%2%1 boarding\n",groupID _grupo,_texto];
				{[_x] orderGetIn true; [_x] allowGetIn true} forEach units _grupo;
				};
			};
		};
	} forEach hcSelected player;
	if (_texto != "") then {hint format ["%1",_texto]};
	};

_grupo = (hcSelected player select 0);
_veh = objNull;
{
_owner = _x getVariable "owner";
if (!isNil "_owner") then {if (_owner == _grupo) exitWith {_veh = _x}};
} forEach vehicles;
if (isNull _veh) exitWith {hint "The group has no vehicle assigned"};

if (_this select 0 == "stats") then
	{
	_texto = format ["Squad %1 Vehicle Stats\n\n%2",groupID _grupo,getText (configFile >> "CfgVehicles" >> (typeOf _veh) >> "displayName")];
	if (!alive _veh) then
		{
		_texto = format ["%1\n\nDESTROYED",_texto];
		}
	else
		{
		if (!canMove _veh) then {_texto = format ["%1\n\nDISABLED",_texto]};
		if (count allTurrets [_veh, false] > 0) then
			{
			if (!canFire _veh) then {_texto = format ["%1\n\nWEAPON DISABLED",_texto]};
			if (someAmmo _veh) then {_texto = format ["%1\n\nMunitioned",_texto]};
			};
		};
	hint format ["%1",_texto];
	};
