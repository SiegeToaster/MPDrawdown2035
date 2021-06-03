player createDiaryRecord ["Diary", [localize "STR_A3_Diary_Situation_title", 
	format [
		localize "STR_A3_A_in_Briefing_Situation_text",
		"<br/><br/>",
		"<marker name = 'mrk_camp'>",
		"</marker>",
		"<marker name = 'mrk_range'>",
		"</marker>",
		"<br/><br/>",
		"<br/><br/>"]]];

goats = [goat1, goat2, goat3, goat4, goat5, goat6, goat7, goat8, goat9];
evacTeam = [evac1, evac2, evac3, evac4];
maxwellHeloMove = false;

execVM "ambientConversations\00.sqf"; // adds ambient conversations between two people near whiteboard at LZ connor
{_x kbAddTopic ["kb", "kb.bikb"]} forEach [Adams, November, Lacey, Edwards, checkOff, checkInspector, xray, BHQ, range, player]; // setup

enableEnvironment false; //disables environment as to not make wind/leave noises in cutscene.

_introVideo = ["A3\Missions_F_EPA\video\A_in_intro.ogv"] spawn BIS_fnc_playVideo; // plays the cutscene
waitUntil {scriptDone _introVideo || !(isNil "skipIntro")};

if !(isNil "skipIntro") then {
	{
		hint "intro skipped";
		[""] spawn BIS_fnc_playVideo; // skips intro video if skipIntro is made true in debug.
	} forEach allPlayers;
};

if (isServer) then {
	execVM "unitPlay\landing.sqf";
}; // helicopter landing sequence.

sleep 1;
player enableSimulation true;
enableEnvironment true;
{_x enableAI "MOVE"} forEach [LzCnrAmbient1, LzCnrAmbient2, CnrTruck1D, CnrTruck2D, CnrTruck3D]; // starts up the ambient stuff and lets the players look around.

[0, 0, false] spawn BIS_fnc_cinemaBorder; // spawns fake cinema borders
player setPos [2918.682, 1852.432, 0];
player setDir 84.851; // teleports player to LZ Connor, they start on some random island because the noise of heli disrupts immurshun in video

playMusic "LeadTrack01_F_EPA";
0 fadeMusic 1;
// hint "LeadTrack_1_F_EPA - Playing";
_video = ["A3\Missions_F_EPA\video\A_in_quotation.ogv"] spawn BIS_fnc_playVideo;
player switchMove "Acts_PercMwlkSlowWrflDf2"; // plays the quote video and music while player is walking

waitUntil {scriptDone _video};
sleep 2; // wait until 2 seconds after quote video is done.

[ 
	[
		["2035-07-07 05:55", "align = 'right' size='1.0'"],
		["", "<br/>"],
		["LZ CONNOR", "align = 'right' size='1.0'"],
		["", "<br/>"],
		["South-west Stratis", "align = 'right' size='1.0'"]
	], 
	safeZoneX - 0.01, 
	safeZoneY + 0.875 * safeZoneH,
	true
] spawn BIS_fnc_typeText2; // displays intro text in bottom right

musicEH = addMusicEventHandler ["MusicStop", {
	removeMusicEventHandler ["MusicStop", musicEH];
	playMusic "LeadTrack02_F_EPA";
	// hint "LeadTrack_2_F_EPA - Playing";
}]; // music event handler

waitUntil {triggerActivated t_enterConnor}; // waits until player is in the base
if (isServer) then {
	Adams playMove "acts_percmstpslowwrfldnon_handup1";
};
Adams kbTell [player, "kb", "a_in_01_wave_ICO_0", "SIDE"]; // makes SSG Adams wave and say, "Over here, Kerry!"
sleep 0.5;

[1, nil, false] spawn BIS_fnc_cinemaBorder;
showHUD true; // turns off fake cinema borders
player switchMove "AmovPercMstpSlowWrflDnon"; // makes players stop walking

sleep 1;
player hideObjectGlobal false; // players originally hidden becuase walk cutscene is in the same place and players would clip this makes players visible for each other again.

waitUntil {Adams kbWasSaid [player, "kb", "a_in_01_wave_ICO_0", 9999]};
sleep 2;
Adams kbTell [player, "kb", "a_in_05_load_up_ICO_0", "SIDE"];
if (isServer) then {
	Adams assignAsCargoIndex [transportHeli, 3];
	[Adams] orderGetIn true;
	Adams doWatch objNull;
};
loadUp = true; // makes SSG Adams tell kerry to get in and gets in himself.

waitUntil {vehicle Adams == transportHeli};
if (isServer) then {
	transportHeli lock false;
};

waitUntil {{_x in transportHeli} count (call BIS_fnc_listPlayers) == count (call BIS_fnc_listPlayers)};
if (isServer) then {
	transportHeli lock true;
	heliFull = true;
};
if (vehicle player != transportHeli) then {
	player moveInAny transportHeli;
}; //unlocks helicopter, waits until players are in, locks helicopter.  If anyone isn't in, it moves them in too.
30 fadeSound 0.6;

sleep 1;
Adams kbTell [player, "kb", "a_in_10_all_in_ICO_0", "SIDE"]; // SSG Adams says that they are ready.
waitUntil {Adams kbWasSaid [player, "kb", "a_in_10_all_in_ICO_0", 9999]}; // waits until SSG says his thing
November kbTell [player, "kb", "a_in_10_all_in_NOV_0", "SIDE"]; // November says that they are leaving

sleep 1;
if (isServer) then {
	execVM "unitPlay\flight.sqf";
	leftLZConnor = true;
};

sleep 4;
[0, 1, false] spawn BIS_fnc_cinemaBorder; // spawns fake cinema borders
clearRadio; // clears the chat

sleep 4;
// total time from player getting in to BI Presents supposed to be 11, is actually only 7.5
titleText ["<t size='3'>BOHEMIA INTERACTIVE<br></br><t size = '2'>PRESENTS", "PLAIN", 0.5, false, true];
sleep 4;
titleFadeOut 0.5;
sleep 5;
titleText ["<t size='3'>ARMA 3", "PLAIN", 1, false, true];
sleep 5;
titleFadeOut 0.5;
execVM "credits.sqf"; // credits

sleep 1; // beginning of heli flight commentary
Lacey kbTell [player, "kb", "a_in_15_roads_BRA_0", "SIDE"]; // roads start; should be pretty much over first road
waitUntil {Lacey kbWasSaid [player, "kb", "a_in_15_roads_BRA_0", 9999]};
Adams kbTell [player, "kb", "a_in_15_roads_ICO_0", "SIDE"];
waitUntil {Adams kbWasSaid [player, "kb", "a_in_15_roads_ICO_0", 9999]};

if (isServer) then {
	[] spawn {
		{
			sleep 0.5;
			_x switchMove (selectRandom ["AmovPercMwlkSlowWrflDf_v1", "AmovPercMwlkSlowWrflDf_v2", "AmovPercMwlkSlowWrflDf_v3"]);
		} forEach [Miller, max1, max2, max3, max4];

		sleep 25;

		{deleteVehicle _x} forEach [Miller, max1, max2, max3, max4];
	};
};

Adams kbTell [player, "kb", "a_in_15_roads_ICO_1", "SIDE"];
waitUntil {Adams kbWasSaid [player, "kb", "a_in_15_roads_ICO_1", 9999]};
Lacey kbTell [player, "kb", "a_in_15_roads_BRA_1", "SIDE"];
waitUntil {Lacey kbWasSaid [player, "kb", "a_in_15_roads_BRA_1", 9999]};
Adams kbTell [player, "kb", "a_in_15_roads_ICO_2", "SIDE"];
waitUntil {Adams kbWasSaid [player, "kb", "a_in_15_roads_ICO_2", 9999]};// roads end

Lacey kbTell [player, "kb", "a_in_20_maxwell_BRA_0", "SIDE"]; // maxwell start should be coming right up on Maxwell
waitUntil {Lacey kbWasSaid [player, "kb", "a_in_20_maxwell_BRA_0", 9999]};
maxwellHeloMove = true; // helicopter at Camp Maxwell flies away // somehow also makes the transportHeli spool up
Adams kbTell [player, "kb", "a_in_20_maxwell_ICO_0", "SIDE"];
waitUntil {Adams kbWasSaid [player, "kb", "a_in_20_maxwell_ICO_0", 9999]};
Adams kbTell [player, "kb", "a_in_20_maxwell_ICO_1", "SIDE"];
waitUntil {Adams kbWasSaid [player, "kb", "a_in_20_maxwell_ICO_1", 9999]}; // maxwell end

sleep 14;
Lacey kbTell [player, "kb", "a_in_25_mike26_BRA_0", "SIDE"]; // mike-26 start
waitUntil {Lacey kbWasSaid [player, "kb", "a_in_25_mike26_BRA_0", 9999]};
Adams kbTell [player, "kb", "a_in_25_mike26_ICO_0", "SIDE"];
waitUntil {Adams kbWasSaid [player, "kb", "a_in_25_mike26_ICO_0", 9999]};
Lacey kbTell [player, "kb", "a_in_25_mike26_BRA_1", "SIDE"];
waitUntil {Lacey kbWasSaid [player, "kb", "a_in_25_mike26_BRA_1", 9999]};
Adams kbTell [player, "kb", "a_in_25_mike26_ICO_1", "SIDE"];
waitUntil {Adams kbWasSaid [player, "kb", "a_in_25_mike26_ICO_1", 9999]};
Lacey kbTell [player, "kb", "a_in_25_mike26_BRA_2", "SIDE"];
waitUntil {Lacey kbWasSaid [player, "kb", "a_in_25_mike26_BRA_2", 9999]}; // mike-26 end

if (isServer) then {
	execVM "unitPlay\truckMove.sqf";
}; // still needs to be earlier
sleep 12;

Adams kbTell [player, "kb", "a_in_30_baldy_ICO_0", "SIDE"]; // LZ Baldy start
waitUntil {Adams kbWasSaid [player, "kb", "a_in_30_baldy_ICO_0", 9999]};
Lacey kbTell [player, "kb", "a_in_30_baldy_BRA_0", "SIDE"];
waitUntil {Lacey kbWasSaid [player, "kb", "a_in_30_baldy_BRA_0", 9999]};
Adams kbTell [player, "kb", "a_in_30_baldy_ICO_1", "SIDE"];
waitUntil {Adams kbWasSaid [player, "kb", "a_in_30_baldy_ICO_1", 9999]};
Lacey kbTell [player, "kb", "a_in_30_baldy_BRA_1", "SIDE"];
waitUntil {Lacey kbWasSaid [player, "kb", "a_in_30_baldy_BRA_1", 9999]};
Lacey kbTell [player, "kb", "a_in_30_baldy_BRA_2", "SIDE"];
waitUntil {Lacey kbWasSaid [player, "kb", "a_in_30_baldy_BRA_2", 9999]};
Adams kbTell [player, "kb", "a_in_30_baldy_ICO_2", "SIDE"];
waitUntil {Adams kbWasSaid [player, "kb", "a_in_30_baldy_ICO_2", 9999]}; // LZ Baldy end

Lacey kbTell [player, "kb", "a_in_35_lock_down_BRA_0", "SIDE"]; // roads closed start
waitUntil {Lacey kbWasSaid [player, "kb", "a_in_35_lock_down_BRA_0", 9999]};
Adams kbTell [player, "kb", "a_in_35_lock_down_ICO_0", "SIDE"];
waitUntil {Adams kbWasSaid [player, "kb", "a_in_35_lock_down_ICO_0", 9999]};
Lacey kbTell [player, "kb", "a_in_35_lock_down_BRA_1", "SIDE"];
waitUntil {Lacey kbWasSaid [player, "kb", "a_in_35_lock_down_BRA_1", 9999]};
Adams kbTell [player, "kb", "a_in_35_lock_down_ICO_1", "SIDE"];
waitUntil {Adams kbWasSaid [player, "kb", "a_in_35_lock_down_ICO_1", 9999]}; // roads closed end

sleep 6; // maybe 7?
November kbTell [player, "kb", "a_in_40_landing_NOV_0", "SIDE"]; // landed start
waitUntil {November kbWasSaid [player, "kb", "a_in_40_landing_NOV_0", 9999]};
sleep 2;
November kbTell [player, "kb", "a_in_40_landing_NOV_1", "SIDE"];
waitUntil {November kbWasSaid [player, "kb", "a_in_40_landing_NOV_1", 9999]}; // landed end

if (isServer) then {
	rgnHeliGuide disableAI "ANIM";
	rgnHeliGuide playMove "Acts_NavigatingChopper_Loop";
};
sleep 18.5;
if (isServer) then {
	rgnHeliGuide playMove "Acts_NavigatingChopper_Out";
};

sleep 1.5;
November kbTell [player, "kb", "a_in_40_landed_NOV_0", "SIDE"]; // end of heli flight commentary
sleep 0.5;
transportHeli lock false; // unlock heli
transportHeli action ["EngineOff", transportHeli]; // turn off heli engine
showHUD true;// remove fake cinema borders

// Fix animations (ToDo: remove when fixed) // (no idea how this works)
{
	_x spawn {
		private _unit = _this;
		
		scriptName format ["BIS_flight: animation fix - [%1]", _unit];
		
		waitUntil {!(_unit in transportHeli)};
		
		_unit switchMove "";
	};
} forEach [Adams, Lacey];

// Make SSG Adams disembark
if (isServer) then {
	{rgnHeliGuide enableAI _x} forEach ["ANIM", "AUTOTARGET", "FSM", "MOVE", "TARGET"];
	unassignVehicle Adams;
	doGetOut Adams;
	[Adams] orderGetIn false;
	Adams doWatch objNull; // make Adams disembark
	sleep 2;

	unassignVehicle Lacey;
	doGetOut Lacey;
	[Lacey] orderGetIn false; // make Lacey disembark
	sleep 2;
} else {
	sleep 4; // sleep for the same amount of time
};

unassignVehicle player;
player action ["GetOut", vehicle player];
[player] orderGetIn false;
[1, nil, false] spawn BIS_fnc_cinemaBorder;
sleep 0.25;
player action ["WeaponOnBack", player]; // make players lower weapons
sleep 0.75;
transportHeli lock true;
atRgn = true; // Make players get out & remove cinematic borders & locks heli

if (isServer) then {
	{_x setDamage 1} forEach [officer, officerTruckD];
	officerTruck enableSimulation false;
	officerTruck setPos [5690.8989,5313.7993,-0.8];
	officerTruck setDir 125;
	[officerTruck, 2, 265] call BIS_fnc_setPitchBank;
	officerTruck setDamage 0.7;
	{officerTruck setHitPointDamage [_x, 1]} forEach ["HitRFWheel", "HitRF2Wheel", "HitLF2Wheel"];
	officerTruck allowDamage false;
	officerTruck engineOn false;

	truckSmoke = "#particlesource" createVehicle [10, 10, 10];
	truckSmoke setParticleClass "WreckSmokeSmall";
	truckSmoke attachTo [smokeLogic, [-1.4, -0.4, 1.6]];
	truckSmokeSound = createSoundSource ["Sound_SmokeWreck1", [10, 10, 10], [], 0];
	truckSmokeSound attachTo [smokeLogic, [-1.4, -0.4, 1.6]];

	officer hideObject false;
	officer enableSimulation true;

	truckMine = "ATMine_Range_Ammo" createVehicle [5680.392,5314.729,0.000];
}; // sets up crash site

waitUntil {!(isNil "atRgn")};
1 fadeMusic 0.2;
playMusic "EventTrack01_F_EPA";// makes sure players are at camp rogain and plays music quietly

Adams kbTell [player, "kb", "a_in_50_report_ICO_0", "SIDE"];
waitUntil {Adams kbWasSaid [player, "kb", "a_in_50_report_ICO_0", 9999]};
Adams kbTell [player, "kb", "a_in_50_report_ICO_1", "SIDE"];
waitUntil {Adams kbWasSaid [player, "kb", "a_in_50_report_ICO_1", 9999]}; // SSG Adams tells kerry to report to logi officer and Lacey to make himself useful

p0 = (call BIS_fnc_listPlayers) select 0;
if (isServer) then {
	[] spawn {
		waitUntil {!(isNil "readyToPiss")};
		Adams doWatch [5050.879,5917.915,0.000];
		sleep 2; // waits until waypoint activates variable, watches ground, and waits 2 seconds.
		
		{Adams disableAI _x} forEach ["ANIM", "AUTOTARGET", "FSM", "MOVE", "TARGET"];
		Adams playMoveNow "Acts_AidlPercMstpSlowWrflDnon_pissing"; // disables AI and starts pissing animation
		
		{Adams enableAI _x} forEach ["ANIM", "AUTOTARGET", "FSM", "MOVE", "TARGET"];
		Adams reveal p0;
		Adams doWatch p0;
		backToTruck = true; // enables AI again, watches a random player, and moves near the truck
	};
};

waitUntil {{_x distance Edwards < 5} forEach allPlayers}; // waits until p0 are within 5 meters of logi dude
{
	if (_x in allPlayers) then {
		p0 = _x;
		publicVariable "p0";
	};
} forEach (nearestObjects [Edwards, ["man"], 5]);

p0 kbTell [player, "kb", "a_in_55_orders_KER_0", "DIRECT"]; // orders start
// sleep 1;
Edwards playMoveNow "Acts_SittingJumpingSaluting_out";
Edwards say3D "Acts_SittingJumpingSaluting_out";
{Edwards enableAI _x} forEach ["ANIM", "FSM"];
detach Edwards; //makes logi dude jump down and salute

waitUntil {player kbWasSaid [player, "kb", "a_in_55_orders_KER_0", 9999]};
Edwards kbTell [player, "kb", "a_in_55_orders_LOG_0", "DIRECT"];
waitUntil {Edwards kbWasSaid [player, "kb", "a_in_55_orders_LOG_0", 9999]};
Edwards kbTell [player, "kb", "a_in_55_orders_LOG_1", "DIRECT"];
waitUntil {Edwards kbWasSaid [player, "kb", "a_in_55_orders_LOG_1", 9999]};
Edwards kbTell [player, "kb", "a_in_55_orders_LOG_2", "DIRECT"];
waitUntil {Edwards kbWasSaid [player, "kb", "a_in_55_orders_LOG_2", 9999]};
p0 kbTell [player, "kb", "a_in_55_orders_KER_1", "DIRECT"];
waitUntil {p0 kbWasSaid [player, "kb", "a_in_55_orders_KER_1", 9999]};
Edwards kbTell [player, "kb", "a_in_55_orders_LOG_3", "DIRECT"];
waitUntil {Edwards kbWasSaid [player, "kb", "a_in_55_orders_LOG_3", 9999]}; // orders end
ordersRecieved = true;
p0 kbTell [player, "kb", "a_in_60_understood_KER_0", "DIRECT"];

waitUntil {(p0 distance Adams <= 10) || p0 distance truck <= 10};
if (isServer) then {
	truck lock false;
};

[] spawn {
	Adams kbTell [player, "kb", "a_in_65_get_in_ICO_0",
		if (player in truck && Adams in truck) then {"VEHICLE"} else {
			if (player distance Adams > 5) then {
				"SIDE"
			} else {"DIRECT"}}];
	waitUntil {Adams kbWasSaid [player, "kb", "a_in_65_get_in_ICO_0", 9999]};
	p0 kbTell [player, "kb", "a_in_65_get_in_KER_0",
		if (player in truck && p0 in truck) then {"VEHICLE"} else {
			if (player distance p0 > 5) then {
				"SIDE"
			} else {"DIRECT"}}];
	waitUntil {p0 kbWasSaid [player, "kb", "a_in_65_get_in_KER_0", 9999]};
	Adams kbTell [player, "kb", "a_in_65_get_in_ICO_1",
		if (player in truck && Adams in truck) then {"VEHICLE"} else {
			if (player distance Adams > 5) then {
				"SIDE"
			} else {"DIRECT"}}];
	waitUntil {Adams kbWasSaid [player, "kb", "a_in_65_get_in_ICO_1", 9999]};
	p0 kbTell [player, "kb", "a_in_65_get_in_KER_1",
		if (player in truck && p0 in truck) then {"VEHICLE"} else {
			if (player distance p0 > 5) then {
				"SIDE"
			} else {"DIRECT"}}];
	waitUntil {p0 kbWasSaid [player, "kb", "a_in_65_get_in_KER_1", 9999]};
	Adams kbTell [player, "kb", "a_in_75_road_ICO_1", "SIDE"];
	updated = true;

	if (isServer) then {
		group Lacey addVehicle truckSec;
		Lacey assignAsDriver truckSec;
		[Lacey] orderGetIn true;
		LaceyAmbientBoard = true;
		waitUntil {Lacey in truckSec};
		truckSec action ["EngineOff", truckSec];
	};	
};

if (isServer) then {
	waitUntil {{driver truck == _x} forEach allPlayers};
	p0 = driver truck;
	publicVariable "p0";
	truck lockCargo false;
	truck lock true;

	group Adams addVehicle truck;
	Adams assignAsCargo truck;
	[Adams] orderGetIn true;
	Adams doWatch objNull;

	[] spawn {
		waitUntil {Adams in truck};
		Adams setBehaviour "AWARE";
		Adams forceSpeed -1;

		waitUntil {{_x in truck} count (call BIS_fnc_listPlayers) == count (call BIS_fnc_listPlayers)};
		allInTruck = true;
	};

	toCheckpoint = true;
};
waitUntil {!(isNil "p0")};

[] spawn {
	private _units = []; // array of all units, might just use allUnits
	waitUntil {{!(alive _x)} count _units > 0 || !(isNil "outOfTruck")}; // double check once outOfTruck var set to make sure var is the same
	if (isNil "outOfTruck") then {call courtMartial}; // have to declare courtMartial
}; // event handler for if the player runs anything over

sleep 1;
waitUntil {!(isNil "updated")};

if (isServer) then {
	flyAway = true;
	transportHeli flyInHeight 50;
};

[] spawn {
	waitUntil {Adams kbWasSaid [player, "kb", "a_in_75_road_ICO_1", 9999]};
	November kbTell [player, "kb", "a_in_70_fly_away_NOV_0", "SIDE"];
	waitUntil {November kbWasSaid [player, "kb", "a_in_70_fly_away_NOV_0", 9999]};
	Adams kbTell [player, "kb", "a_in_70_fly_away_ICO_0", "SIDE"];
	waitUntil {(Adams kbWasSaid [player, "kb", "a_in_70_fly_away_ICO_0", 9999]) && !(isNil "allInTruck")};
	Adams kbTell [player, "kb", "a_in_73_great_service_ICO_0", "VEHICLE"]; // Conversation and helicopter getting out of the way.
};

waitUntil {isEngineOn truck};
0 fadeMusic 0;
1 fadeMusic 0.3;
playMusic "radio_music";
musicEH = addMusicEventHandler ["MusicStop", {playMusic "radio_music"}];

[] spawn {
	waitUntil {!(player in truck)};
	removeMusicEventHandler ["MusicStop", musicEH];
	playMusic ""; //plays radio music until the player gets out.
};

waitUntil {(getPosATL transportHeli select 2) > 10};
Adams kbTell [player, "kb", "a_in_75_road_ICO_0", "VEHICLE"];

[] spawn {
	waitUntil {triggerActivated t_offroadArea};
	Adams kbTell [player, "kb", "a_in_x01_offroading_ICO_0", "VEHICLE"];
};

waitUntil {((truck distance goatHerder) < 200) || !(isNil "approachingCheckpoint")};
if (isNil "approachingCheckpoint") then {
	[] spawn {
		if (isServer) then {
			{
				_x enableSimulation true;
				sleep (0.2 + random 0.8);
			} forEach goats;
		};
		waitUntil {{damage _x > 0.1} count goats > 0 || !(isNil "atCheckpoint")};
		if (isNil "atCheckpoint") then {
			Adams kbTell [player, "kb", "a_in_x01_offroading_ICO_0", "VEHICLE"];
		};
	};
	if (isServer) then {
		goatHerder playMove "Acts_ShowingTheRightWay_in";
	};
	Adams kbTell [player, "kb", "a_in_76_turn_ICO_0", "VEHICLE"];
	waitUntil {Adams kbWasSaid [player, "kb", "a_in_76_turn_ICO_0", 9999]};
	Adams kbTell [player, "kb", "a_in_76_turn_ICO_1", "VEHICLE"];
	waitUntil {Adams kbWasSaid [player, "kb", "a_in_76_turn_ICO_1", 9999]};
	Adams kbTell [player, "kb", "a_in_76_turn_ICO_2", "VEHICLE"];
	waitUntil {Adams kbWasSaid [player, "kb", "a_in_76_turn_ICO_2", 9999]};
	driver truck kbTell [player, "kb", "a_in_76_turn_KER_0", "VEHICLE"];
};

waitUntil {(truck distance [5235.48,5812.21]) < 120};
nearCheckpoint = true; // unused
if (isServer) then {
	if (animationState goatHerder == "Acts_ShowingTheRightWay_loop") then {
		goatHerder playMove "Acts_ShowingTheRightWay_out";
	};
	checkMGG reveal truck;
	checkMGG doWatch truck;
};
Adams kbTell [player, "kb", "a_in_80_slow_down_ICO_0", "VEHICLE"];
waitUntil {Adams kbWasSaid [player, "kb", "a_in_80_slow_down_ICO_0", 9999]};
Adams kbTell [player, "kb", "a_in_80_slow_down_ICO_1", "VEHICLE"];
waitUntil {Adams kbWasSaid [player, "kb", "a_in_80_slow_down_ICO_1", 9999]};

[] spawn {
	waitUntil {(((truck distance [5235.48,5812.21]) <=50) && (speed truck > 30)) || !(isNil "atCheckpoint")};
	if !(isNil "atCheckpoint") exitWith {};
	Adams kbTell [player, "kb", "a_in_x05_slowitdown_ICO_0", "VEHICLE"];
	waitUntil {Adams kbWasSaid [player, "kb", "a_in_x05_slowitdown_ICO_0", 9999]};
	Adams kbTell [player, "kb", "a_in_x05_slowitdown_ICO_1", "VEHICLE"];
	waitUntil {Adams kbWasSaid [player, "kb", "a_in_x05_slowitdown_ICO_1", 9999]};
};

waitUntil {triggerActivated checkZoneEnt};
atCheckpoint = true;
if (isServer) then {
	checkOff disableAI "ANIM";
	checkOFF playMove "Acts_PercMstpSlowWrflDnon_handup2c";
	
	private _animEH = checkOff addEventHandler ["AnimDone", {
		if (_this select 1 == "Acts_PercMstpSlowWrflDnon_handup2c") then {
			checkOff removeEventHandler ["AnimDone", checkOff getVariable "animEH"];
			checkOff enableAI "ANIM";
			stopDone = true; // unused
		};
	}];
	checkOff setVariable ["animEH", _animEH];
};
sleep 0.5;

checkOff kbTell [player, "kb", "a_in_90_stop_CHO_0", "DIRECT"];
waitUntil {checkOff kbWasSaid [player, "kb", "a_in_90_stop_CHO_0", 9999]};

waitUntil {sleep 3; speed truck == 0};
["tsk_check", objNull] call BIS_fnc_taskSetDestination;

[] spawn {
	checkOff kbTell [player, "kb", "a_in_95_inspect_CHO_0", "DIRECT"];
	waitUntil {checkOff kbWasSaid [player, "kb", "a_in_95_inspect_CHO_0", 9999]};
	checkInspector kbTell [player, "kb", "a_in_95_inspect_CHI_0", "DIRECT"];
	waitUntil {checkInspector kbWasSaid [player, "kb", "a_in_95_inspect_CHI_0", 9999]};

	sleep 0.5;
	driver truck kbTell [player, "kb", "a_in_97_tense_KER_0", "VEHICLE"];
	waitUntil {driver truck kbWasSaid [player, "kb", "a_in_97_tense_KER_0", 9999]};
	Adams kbTell [player, "kb", "a_in_97_tense_ICO_0", "VEHICLE"];
	waitUntil {Adams kbWasSaid [player, "kb", "a_in_97_tense_ICO_0", 9999]};
	Adams kbTell [player, "kb", "a_in_97_tense_ICO_1", "SIDE"];
	waitUntil {Adams kbWasSaid [player, "kb", "a_in_97_tense_ICO_1", 9999]};
	Adams kbTell [player, "kb", "a_in_97_tense_ICO_2", "SIDE"];
	waitUntil {Adams kbWasSaid [player, "kb", "a_in_97_tense_ICO_2", 9999]};
	Lacey kbTell [player, "kb", "a_in_97_tense_BRA_0", "SIDE"];
	waitUntil {Lacey kbWasSaid [player, "kb", "a_in_97_tense_BRA_0", 9999]};
	Adams kbTell [player, "kb", "a_in_97_tense_ICO_3", "VEHICLE"];
	waitUntil {Adams kbWasSaid [player, "kb", "a_in_97_tense_ICO_3", 9999]};
};

if (isServer) then {
	checkOff disableAI "ANIM";
	checkOff playMove "Acts_SignalToCheck";

	private _animEH = checkOff addEventHandler ["AnimDone", {
		if (_this select 1 == "Acts_SignalToCheck") then {
			checkOff removeEventHandler ["AnimDone", checkOff getVariable "animEH"];
			{checkOff enableAI _x} forEach ["ANIM", "AUTOTARGET", "FSM", "MOVE", "TARGET"];

			checkOff reveal truck;
			checkOff doWatch truck;
		};
	}];
	checkOff setVariable ["animEH", _animEH];
};

sleep 3;
inspecting = true; // unused
if (isServer) then {
	{checkInspector disableAI _x} forEach ["ANIM", "AUTOTARGET", "FSM", "MOVE", "TARGET"];
	checkInspector switchMove "Acts_WalkingChecking";

	private _animEH = checkInspector addEventHandler ["AnimDone", {
		if (_this select 1 == "Acts_WalkingChecking") then {
			checkInspector removeEventHandler ["AnimDone", checkInspector getVariable "animEH"];
			{checkInspector enableAI _x} forEach ["ANIM", "AUTOTARGET", "FSM", "MOVE", "TARGET"];

			checkInspector setBehaviour "CARELESS";
			checkInspector switchMove "AmovPercMstpSlowWrflDnon";
			[checkInspector] joinSilent checkOff;
			inspecting = false; // same unsued from before start of isServer condition
		};
	}];
	checkInspector setVariable ["animEH", _animEH];
};

sleep 20;
checkInspector kbTell [player, "kb", "a_in_100_clear_CHI_0", "DIRECT"];
waitUntil {checkInspector kbWasSaid [player, "kb", "a_in_100_clear_CHI_0", 9999]};
checkOff kbTell [player, "kb", "a_in_100_clear_CHO_0", "DIRECT"];
waitUntil {checkOff kbWasSaid [player, "kb", "a_in_100_clear_CHO_0", 9999]};
sleep 2;

if (isServer) then {
	checkOff stop false;
	if !(checkOff checkAIFeature "MOVE") then {
		{checkOff enableAI _x} forEach ["ANIM", "AUTOTARGET", "FSM", "MOVE", "TARGET"];
	};
	gateKeeper disableAI "ANIM";
	gateKeeper playMove "AinvPercMstpSrasWrflDnon_Putdown_AmovPercMstpSrasWrflDnon";

	private _animEH = gateKeeper addEventHandler ["AnimDone", {
		if (_this select 1 == "AmovPercMstpSrasWrflDnon_AinvPercMstpSrasWrflDnon_Putdown") then {
			[] spawn {
				sleep 0.5;
				barGate animate ["Door_1_rot", 1];
				
				sleep 1.5;
				
			};
		} else {
			if (_this select 1 == "AinvPercMstpSrasWrflDnon_Putdown_AmovPercMstpSrasWrflDnon") then {
				gateKeeper removeEventHandler ["AnimDone", gateKeeper getVariable "animEH"];
				{gateKeeper enableAI _x} forEach ["ANIM", "AUTOTARGET", "FSM", "MOVE", "TARGET"];
			};
		};
	}];
	gateKeeper setVariable ["animEH", _animEH];
};

[] spawn {
	private _pos = position truck;
	sleep 6;

	if (truck distance _pos < 10) then {
		Adams kbTell [player, "kb", "a_in_x10_moveon_ICO_0", "VEHICLE"];
	};
};

waitUntil {triggerActivated checkZone && triggerActivated checkZoneExt};
truckMine setDamage 1;

checkPass = true;
["tsk_check", [5235.48,5812.21]] call BIS_fnc_taskSetDestination;

if (isServer) then {
	barGate animate ["Door_1_rot", 0];
	{_x doWatch objNull} forEach [checkOff, checkMGG];
};

Adams kbTell [player, "kb", "a_in_105_left_checkpoint_ICO_0", "VEHICLE"];
waitUntil {Adams kbWasSaid [player, "kb", "a_in_105_left_checkpoint_ICO_0", 9999]};
Adams kbTell [player, "kb", "a_in_105_left_checkpoint_ICO_1", "VEHICLE"];
waitUntil {Adams kbWasSaid [player, "kb", "a_in_105_left_checkpoint_ICO_1", 9999]};
Adams kbTell [player, "kb", "a_in_105_left_checkpoint_ICO_3", "VEHICLE"];
waitUntil {Adams kbWasSaid [player, "kb", "a_in_105_left_checkpoint_ICO_3", 9999]};

waitUntil {truck distance officerTruck <= 150};
Adams kbTell [player, "kb", "a_in_110_hazard_ICO_0", "VEHICLE"];
waitUntil {Adams kbWasSaid [player, "kb", "a_in_110_hazard_ICO_0", 9999]};
crashSpotted = true;
Adams kbTell [player, "kb", "a_in_110_hazard_ICO_1", "VEHICLE"];
waitUntil {Adams kbWasSaid [player, "kb", "a_in_110_hazard_ICO_1", 9999]};
[] spawn {
	sleep 10;
	if (Adams in truck) then {
		Adams kbTell [player, "kb", "a_in_110_hazard_ICO_1", "VEHICLE"];
	};
};

["tsk_range", objNull] call BIS_fnc_taskSetDestination;
if (isServer) then {
	truck lock false;
	unassignVehicle Adams;
	doGetOut Adams;

	{
		_x setBehaviour "AWARE";
		_x stop false;
	} forEach units forestGroup;
};
{group _x leaveVehicle truck} forEach [Adams, player];

while {player in truck} do {
	waitUntil {speed truck < 1 || !(player in truck)};
	if (player in truck) then {
		sleep 0.5;
		
		if (speed truck < 1 && player in truck) then {
			player action ["GetOut", truck];
		};
	};
};

waitUntil {!(Adams in truck)};
if (isServer) then {
	deleteVehicle t_leaderMoveTrig;
	
	[] spawn {
		waitUntil {{_x in truck} count (call BIS_fnc_listPlayers) == 0};
		outOfTruck = true;
		truck lock true;
		truck engineOn false;

		{
			sleep 0.5;
			_unit = _x;

			{_unit enableAI _x} forEach ["ANIM", "AUTOTARGET", "FSM", "MOVE", "TARGET"];
			_unit allowDamage true;
			_unit setCaptive false;
			_unit hideObject false;
			_unit enableSimulation true;

			_group = switch (side _unit) do {
				case WEST: {createGroup EAST};
				case RESISTANCE: {createGroup CIVILIAN};
			};

			_group copyWaypoints group _unit;
			while {count waypoints _group > 1} do {
				sleep 0.5;
				deleteWaypoint (waypoints _group select 0);
			};

			[_unit] joinSilent _group;
			_unit setCombatMode "BLUE";
			_unit allowFleeing 0;
		} forEach rangeAmbient
	};

	
};

[] spawn {
	waitUntil {{_x in truck} count (call BIS_fnc_listPlayers) == 0};
	xray kbTell [player, "kb", "a_in_128_ambient_2_XRA_0", "SIDE"];
	waitUntil {xray kbWasSaid [player, "kb", "a_in_128_ambient_2_XRA_0", 9999]};
	BHQ kbTell [player, "kb", "a_in_128_ambient_2_BHQ_0", "SIDE"];
	waitUntil {BHQ kbWasSaid [player, "kb", "a_in_128_ambient_2_BHQ_0", 9999]};
	xray kbTell [player, "kb", "a_in_128_ambient_2_XRA_1", "SIDE"];
	waitUntil {xray kbWasSaid [player, "kb", "a_in_128_ambient_2_XRA_1", 9999]};
	xray kbTell [player, "kb", "a_in_128_ambient_2_XRA_2", "SIDE"];
	waitUntil {xray kbWasSaid [player, "kb", "a_in_128_ambient_2_XRA_2", 9999]};
};

waitUntil {!(isNil "atOff")};
if (isServer) then {
	{Adams disableAI _x} forEach ["ANIM", "AUTOTARGET", "FSM", "MOVE", "TARGET"];
	Adams playMove "Acts_TreatingWounded_in";

	Adams setVelocity [0, 0, 0];
	Adams setPos [5689.89, 5308.88];
	Adams setDir 92.013;
	sleep 0.25;

	Adams setVelocity [0, 0, 0];
	Adams setPos [5689.89, 5308.88];
	Adams setDir 92.013;

	private _animEH = Adams addEventHandler ["AnimDone", {
		if (_this select 1 == "Acts_TreatingWounded_in") then {
			Adams removeEventHandler ["AnimDone", Adams getVariable "animEH"];
			Adams attachTo [treatLogic, [0, 0, 0]];
			Adams switchMove "Acts_TreatingWounded01";

			private _animEH = Adams addEventHandler ["AnimDone", {(_this select 0) switchMove (_this select 1)}];
			Adams setVariable ["animEH", _animEH];
			atCrash = true;
		};
	}];
	Adams setVariable ["animEH", _animEH];
};

Adams kbTell [player, "kb", "a_in_115_check_ICO_0", "DIRECT"];
waitUntil {Adams kbWasSaid [player, "kb", "a_in_115_check_ICO_0", 9999]};
Adams kbTell [player, "kb", "a_in_117_request_help_ICO_0", "SIDE"];
waitUntil {Adams kbWasSaid [player, "kb", "a_in_117_request_help_ICO_0", 9999]};
sleep 2;
Adams kbTell [player, "kb", "a_in_117_request_help_ICO_1", "SIDE"];
waitUntil {Adams kbWasSaid [player, "kb", "a_in_117_request_help_ICO_1", 9999]};
sleep 3;

if (isServer) then {
	[] spawn {
		{
			sleep 0.5;
			deleteVehicle _x;
		} forEach ([transportHeli] + units group transportHeliD + units group checkOff);

		{_x setDamage 0.7} forEach [AA1, AA1Truck];
		AA1Truck setHitPointDamage ["HitLFWheel", 1];
		{_x allowDamage false} forEach [AA1, AA1Truck];

		[AA1Ambient1, "AA1Pos1", "KIA_gunner_static_low01"] spawn AA1setup;
		[AA1Ambient2, "AA1Pos2", "KIA_driver_boat01"] spawn AA1setup;
		[AA1Ambient3, "AA1Pos3", "KIA_driver_sdv"] spawn AA1setup;
		[AA1Ambient4, "AA1Pos4", "KIA_gunner_standup01"] spawn AA1setup;
		[AA1Ambient5, "AA1Pos5", "KIA_passenger_boat_holdleft"] spawn AA1setup;
	};
};

0 fadeMusic 0.4;
playMusic "LeadTrack03_F_EPA";

if (isServer) then {
	private _bomb = "Bo_GBU12_LGB" createVehicle [6480.510, 5380.242, 1];
	_bomb hideObject true;
	_bomb setVelocity [0, 0, -1];
	
	{_x setCombatMode "YELLOW"} forEach rangeAmbient;
};

sleep 1;

[] spawn {
	sleep 1.5;
	addCamShake [10, 0.8, 20];
	sleep 1;

	wreck1 setDamage 1;
	sleep 5;
	wreck2; setDamage 1;
};

if (isServer) then {
	Adams removeEventHandler ["AnimDone", Adams getVariable "animEH"];
	detach Adams;
	Adams playMoveNow "Acts_TreatingWounded_Out";

	private _animEH = Adams addEventHandler ["AnimDone", {
		if (_this select 1 == "Acts_TreatingWounded_Out") then {
			Adams removeEventHandler ["AnimDone", Adams getVariable "animEH"];
			{Adams enableAI _x} forEach ["ANIM", "AUTOTARGET", "FSM", "MOVE", "TARGET"];
		};
	}];
	Adams setVariable ["animEH", _animEH];
	
	Adams doWatch markerPos "mrk_range";
};

observe = true;

range kbTell [player, "kb", "a_in_120_range_RAN_0", "SIDE"];
waitUntil {range kbWasSaid [player, "kb", "a_in_120_range_RAN_0", 9999]};
sleep 1;
range kbTell [player, "kb", "a_in_120_range_RAN_1", "SIDE"];
waitUntil {range kbWasSaid [player, "kb", "a_in_120_range_RAN_1", 9999]};
BHQ kbTell [player, "kb", "a_in_120_range_BHQ_0", "SIDE"];
waitUntil {BHQ kbWasSaid [player, "kb", "a_in_120_range_BHQ_0", 9999]};
Edwards kbTell [player, "kb", "a_in_120_range_LOG_0", "SIDE"];
waitUntil {Edwards kbWasSaid [player, "kb", "a_in_120_range_LOG_0", 9999]};
Adams kbTell [player, "kb", "a_in_120_range_ICO_0", "SIDE"];
waitUntil {Adams kbWasSaid [player, "kb", "a_in_120_range_ICO_0", 9999]};
Edwards kbTell [player, "kb", "a_in_120_range_LOG_1", "SIDE"];
waitUntil {Edwards kbWasSaid [player, "kb", "a_in_120_range_LOG_1", 9999]};