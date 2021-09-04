{_x setWaypointVisible false} forEach waypoints group Adams;

{
	_x allowDamage false;
	_x setCaptive true;
	_x enableSimulation false;
	_x hideObjectGlobal true;
} forEach [plane1, plane2, bomber, plane3];

{
	_x allowDamage false;
	_x setCaptive true;
	_x enableSimulation false;
	_x hideObjectGlobal true;

	_x setVariable ["pos", getPosATL _x];
	_x setVariable ["dir", direction _x];
	_x setPos [position _x select 0, position _x select 1, 1000];
} forEach [enemyHeli1, enemyTruck1, enemyHeli2, enemyHeli3];

rangeAmbient = [];
evacTeam = [evac1, evac2, evac3, evac4];
evacAttack = (units evacAttack1 + units evacAttack2 + units evacDefend1 + units evacDefend2);
evacRestrict1 = (units evacDefend1 + units evacDefend2);
evacRestrict2 = (units evacAttack1 + units evacAttack2);

{
	private _i = 1;
	private _array = missionNamespace getVariable _x;

	while {!(isNil {missionNamespace getVariable format ["%1%2", _x, _i]})} do {
		private _unit = missionNamespace getVariable format ["%1%2", _x, _i];
		_array set [count _array, _unit];
		_i = _i + 1;
	};
} forEach ["rangeAmbient"];

{
	private _unit = _x;

	if !(_unit in rangeAmbient) then {
		_unit hideObjectGlobal true;
	} else {
		_unit switchMove "AmovPercMstpSlowWrflDnon";
	};

	_unit allowDamage false;
	_unit setCaptive true;
	_unit enableSimulation false;
	{_unit disableAI _x} forEach ["ANIM", "AUTOTARGET", "FSM", "MOVE", "TARGET"];

	if (vehicle _unit == _unit && !(_unit in rangeAmbient)) then {
		_unit setVariable ["pos", getPosATL _unit];
		_unit setVariable ["dir", direction _unit];
	};

	_unit setPos [position _unit select 0, position _unit select 1, 1000];
} forEach ([campAmbient1, campAmbient2, campAmbient6, campAmbient8, plane1D, plane2D, bomberD, plane3D] + units group enemyHeli1D + rangeAmbient + units group enemyHeli2D + units AA1Group1 + units AA1Group2 + units rangeAttackGrp + evacAttack + evacTeam + units retreatGrp1 + units group enemyHeli3D + units retreatGrp2);

// landing = compile preprocessFile "unitPlay\landing.sqf";
// flight = compile preprocessFile "unitPlay\flight.sqf";
// truckMove = compile preprocessFile "unitPlay\truckMove.sqf";
// distantBombing = compile preprocessFile "unitPlay\distantBombing.sqf";
// planeAttack = compile preprocessFile "unitPlay\planeAttack.sqf";
// might need these if execVM doesn't work out.

enemyHeli1D assignAsDriver enemyHeli1;
enemyHeli1D moveInDriver enemyHeli1;
plane1D assignAsDriver plane1;
plane1D moveInDriver plane1;

campSetup = {
	params ["_unit", "_marker"];

	if !(alive _unit) exitWith {};
	if !(isNil {_unit getVariable "animEH"}) then {_unit removeEventHandler ["AnimDone", _unit getVariable "animEH"]};
	if !(isNil {_unit getVariable "killedEH"}) then {_unit removeEventHandler ["Killed", _unit getVariable "killedEH"]};

	{_unit enableAI _x} forEach ["ANIM", "AUTOTARGET", "FSM", "MOVE", "TARGET"];
	_unit switchMove "";

	private _pos = markerPos _marker;
	private _dir = markerDir _marker;

	while {position _unit distance _pos > 1 && round (direction _unit) != round _dir} do {
		sleep 0.5;
		_unit setPos _pos;
		_unit setVelocity [0, 0, 0];
		_unit setDir _dir;
	};

	_unit setBehaviour "AWARE";
	_unit enableAI "MOVE";
	_unit setCaptive false;

	if (side _unit == WEST) then {
		private _group = createGroup EAST;
		_group copyWaypoints group _unit;
		while {count waypoints _group > 1} do {
			sleep 0.5;
			deleteWaypoint (waypoints _group select 0);
		};

		[_unit] joinSilent _group;
		_unit allowFleeing 0;
	};
};

AA1setup = {
	params ["_unit", "_marker", "_anim"];

	if !(alive _unit) exitWith {};
	if (!(isNil {_unit getVariable "animEH"})) then {_unit removeEventHandler ["AnimDone", _unit getVariable "animEH"]};
	if (!(isNil {_unit getVariable "killedEH"})) then {_unit removeEventHandler ["Killed", _unit getVariable "killedEH"]};
	
	{_unit enableAI _x} forEach ["ANIM", "AUTOTARGET", "FSM", "MOVE", "TARGET"];
	_unit switchMove "";
	private _pos = markerPos _marker;
	private _dir = markerDir _marker;
	_unit setDamage 1;
	while {position _unit distance _pos > 1 && round (direction _unit) != round _dir && animationState _unit != _anim} do {
		sleep 0.5;
		_unit setPos _pos;
		_unit setVelocity [0, 0, 0];
		_unit setDir _dir;
		_unit switchMove _anim;
	};
};

AA2setup = {
	params ["_unit", "_marker"];

	if !(alive _unit) exitWith {};
	if (!(isNil {_unit getVariable "animEH"})) then {_unit removeEventHandler ["AnimDone", _unit getVariable "animEH"]};
	if (!(isNil {_unit getVariable "killedEH"})) then {_unit removeEventHandler ["Killed", _unit getVariable "killedEH"]};

	{_unit enableAI _x} forEach ["ANIM", "AUTOTARGET", "FSM", "MOVE", "TARGET"];
	_unit switchMove "";

	private _pos = markerPos _marker;
	private _dir = markerDir _marker;

	while {position _unit distance _pos > 1 && round (direction _unit) != round _dir} do {
		sleep 0.5;
		_unit setPos _pos;
		_unit setVelocity [0, 0, 0];
		_unit setDir _dir;
	};

	_unit setBehaviour "AWARE";
	_unit enableAI "MOVE";
	_unit setCaptive false;

	if (side _unit == WEST) then {
		private _group = createGroup EAST;
		_group copyWaypoints group _unit;
		while {count waypoints _group > 1} do {
			sleep 0.5;
			deleteWaypoint (waypoints _group select 0);
		};

		[_unit] joinSilent _group;
		_unit allowFleeing 0;
	};
};

evacSetup = {
	private _unit = _this;

	private _spot = selectRandom ([1, 2, 3, 4] - evacTaken);
	evacTaken = evacTaken + [_spot];

	[_unit, _spot] spawn {
		params ["_unit", "_spot"];

		private _pos = markerPos format ["mrk_evac_move%1", _spot];
		private _target = markerPos format ["mrk_evac_target%1", _spot];

		waitUntil {vehicle _unit == _unit && unitReady _unit};
		_unit doMove _pos;
		_unit doWatch _target;

		waitUntil {!(unitReady _unit)};
		waitUntil {unitReady _unit};

		if (alive _unit) then {
			_unit setBehaviour "COMBAT";
			_unit setUnitPos "MIDDLE";
		};
	};
};

{
	private _unit = _x;

	if ({_unit == _x} count allPlayers == 0) then {
		_unit allowFleeing 0;

		{
			private _type = getNumber (configFile >> "CfgWeapons" >> _x >> "type");

			if (_type == 2) then {
				{_unit removeMagazines _x} forEach ([_x] call bis_fnc_compatibleMagazines);
				_unit removeWeapon _x;
			};
		} forEach weapons _unit;

		{
			private _type = getNumber (configFile >> "CfgWeapons" >> _x >> "ItemInfo" >> "type");

			if (_type == 101) then {_unit removePrimaryWeaponItem _x};
		} forEach primaryWeaponItems _unit;
	};
} forEach allUnits;

private _damageEH = Adams addEventHandler ["HandleDamage", {
	private _damage = _this select 2;
	private _source = _this select 3;

	if !(driver _source in allPlayers) then {0};
}];
Adams setVariable ["_damageEH", _damageEH];
{
	_x addEventHandler ["Killed", {
		Adams removeEventHandler ["HandleDamage", Adams getVariable "_damageEH"];
	}];
} forEach allPlayers;

{
	_x addEventHandler ["Killed", {
		private _unit = _this select 0;
		private _source = _this select 1;
		
		detach _unit;

		if (driver _source in allPlayers) then {
			if (isNil "toCamp" || _unit == Adams) then {
				hint "court martialed >:(";
			};
		};
	}];
} forEach (allUnits - allPlayers);

{
	_x addEventHandler ["HandleDamage", {
		private _unit = _this select 0;
		private _damage = _this select 2;
		private _source = _this select 3;

		if (driver _source in allPlayers) then {
			if (damage _unit > 0.1 || !(canMove _unit)) then {hint "court martialed >:("};
		};
	}];
} forEach ([transportHeli] + units group November);

{
	_x addEventHandler ["HandleDamage", {
		private _damage = _this select 2;
		private _source = _this select 3;

		if (driver _source in allPlayers) then {checkDamaged = true};
		_damage
	}];
} forEach units group checkOff;

{
	private _damageEH = _x addEventHandler ["HandleDamage", {
		private _damage = _this select 2;
		private _source = _this select 3;

		if (driver _source in allPlayers) then {hint "court martialed <:("};
		_damage
	}];

	_x setVariable ["damageEH", _damageEH];
} forEach ([goatHerder, goatWatcher] + units forestGroup);

{
	private _array = missionNamespace getVariable _x;

	{
		_x addEventHandler ["HandleDamage", format [
			"
				private _damage = _this select 2;
				private _source = _this select 3;

				if (!(_source in %1)) then {_damage} else {0};
			",
			_array
			]
		];
	} forEach _array;
} forEach ["rangeAmbient"];

{
	_x addEventHandler ["HandleDamage", {
		private _damage = _this select 2;
		private _source = _this select 3;

		if (_source in evacRestrict1) then {0} else {_damage};
	}];
} forEach evacRestrict2;

{
	_x addEventHandler ["HandleDamage", {
		private _damage = _this select 2;
		private _source = _this select 3;

		if (_source in evacRestrict2) then {_damage / 2} else {_damage};
	}];
} forEach units evacDefend1;

{
	_x addEventHandler ["HandleDamage", {
		private _damage = _this select 2;
		private _source = _this select 3;

		if (_source in evacRestrict2) then {1} else {_damage};
	}];
} forEach units evacDefend2;