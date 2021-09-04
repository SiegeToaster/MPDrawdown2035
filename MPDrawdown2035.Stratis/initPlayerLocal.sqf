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
maxwellHeloMove = false;

execVM "ambientConversations\00.sqf"; // adds ambient conversations between two people near whiteboard at LZ connor
{_x kbAddTopic ["kb", "kb.bikb"]} forEach [Adams, November, Lacey, Edwards, checkOff, checkInspector, xray, BHQ, range, evac, player]; // setup

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
player enableSimulationGlobal true;
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
[1, nil, false] spawn BIS_fnc_cinemaBorder;
sleep 1;

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
sleep 0.25;
player action ["WeaponOnBack", player]; // make players lower weapons
sleep 0.75;
transportHeli lock true;
atRgn = true; // Make players get out & remove cinematic borders & locks heli

if (isServer) then {
	{_x setDamage 1} forEach [officer, officerTruckD];
	officerTruck enableSimulationGlobal false;
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

	officer hideObjectGlobal false;
	officer enableSimulationGlobal true;

	truckMine = "ATMine_Range_Ammo" createVehicle [5680.392,5314.729,0.000];
}; // sets up crash site

waitUntil {!(isNil "atRgn")};
1 fadeMusic 0.2;
playMusic "EventTrack01_F_EPA"; // makes sure players are at camp rogain and plays music quietly

[] spawn {
	waitUntil {{_x distance Edwards < 5} forEach allPlayers}; // waits until p0 are within 5 meters of logi dude
	{
		if (_x in allPlayers) then {
			p0 = _x;
			publicVariable "p0";
		};
	} forEach (nearestObjects [Edwards, ["man"], 5]);

	p0 kbTell [player, "kb", "a_in_55_orders_KER_0", "DIRECT"]; // orders start
	[] spawn {Edwards playMoveNow "Acts_SittingJumpingSaluting_out"}; // spawn needed because animation would make unneeded silence.
	waitUntil {player kbWasSaid [player, "kb", "a_in_55_orders_KER_0", 9999]};

	Edwards say3D "Acts_SittingJumpingSaluting_out";
	{Edwards enableAI _x} forEach ["ANIM", "FSM"];
	detach Edwards; //makes Edwards jump down and salute

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
};

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

waitUntil {!isNil "ordersRecieved"};
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
				_x enableSimulationGlobal true;
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
			_unit hideObjectGlobal false;
			_unit enableSimulationGlobal true;

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
		} forEach ([transportHeli] + units group November + units group checkOff);

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
	_bomb hideObjectGlobal true;
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
	wreck2 setDamage 1;
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

if (isServer) then {
	[] spawn {
		waitUntil {{!(isNil _x)} count ["observing", "stopObserving"] > 0};
		if (isNil "stopObserving") then {
			waitUntil {animationState Adams == "AmovPercMstpSlowWrflDnon"};
			{Adams disableAI _x} forEach ["AUTOTARGET", "FSM", "MOVE", "TARGET"];
			Adams playMoveNow "Acts_listeningToRadio_In";

			waitUntil {!(isNil "stopObserving")};
			Adams playMoveNow "Acts_listeningToRadio_Out";

			private _animEH = Adams addEventHandler ["AnimDone", {
				if (_this select 1 == "Acts_listeningToRadio_Out") then {
					Adams removeEventHandler ["AnimDone", Adams getVariable "animEH"];
					Adams playMoveNow "Acts_ShieldFromSun_in";
				};
			}];
			Adams setVariable ["animEH", _animEH];

			waitUntil {!(isNil "toCamp")};
			Adams setBehaviour "AWARE";
			Adams doWatch objNull;
			Adams disableAI "ANIM";
			Adams playMoveNow "Acts_ShieldFromSun_out";

			private _animEH = Adams addEventHandler ["AnimDone", {
				if (_this select 1 == "Acts_ShieldFromSun_out") then {
					Adams removeEventHandler ["AnimDone", Adams getVariable "animEH"];
					{Adams enableAI _x} forEach ["ANIM", "AUTOTARGET", "FSM", "MOVE", "TARGET"];
					Adams playMoveNow "AmovPercMstpSrasWrflDnon";
				};
			}];
			Adams setVariable ["animEH", _animEH];
		};
	};
};

range kbTell [player, "kb", "a_in_120_range_RAN_0", "SIDE"];
waitUntil {range kbWasSaid [player, "kb", "a_in_120_range_RAN_0", 9999]};
sleep 1;
range kbTell [player, "kb", "a_in_120_range_RAN_1", "SIDE"];
waitUntil {range kbWasSaid [player, "kb", "a_in_120_range_RAN_1", 9999]};
BHQ kbTell [player, "kb", "a_in_120_range_BHQ_0", "SIDE"];
waitUntil {BHQ kbWasSaid [player, "kb", "a_in_120_range_BHQ_0", 9999]};
[
	configFile >> "CfgORBAT" >> "BIS" >> "B_Aegis_A_1",
	"mil_destroy",
	[1,0,0,1],
	1.2,1.2,45
] call BIS_fnc_ORBATAddGroupOverlay;
"mrk_kamino" setMarkerColor "ColorIndependent";

Edwards kbTell [player, "kb", "a_in_120_range_LOG_0", "SIDE"];
waitUntil {Edwards kbWasSaid [player, "kb", "a_in_120_range_LOG_0", 9999]};
Adams kbTell [player, "kb", "a_in_120_range_ICO_0", "SIDE"];
waitUntil {Adams kbWasSaid [player, "kb", "a_in_120_range_ICO_0", 9999]};
Edwards kbTell [player, "kb", "a_in_120_range_LOG_1", "SIDE"];
waitUntil {Edwards kbWasSaid [player, "kb", "a_in_120_range_LOG_1", 9999]};
if (isServer) then {
	{plane1D enableAI _x} forEach ["ANIM", "AUTOTARGET", "FSM", "MOVE", "TARGET"];
	{
		_x enableSimulationGlobal true;
		_x hideObjectGlobal false;
		_x allowDamage true;
	} forEach [plane1, plane1D];
	if (!isEngineOn plane1) then { plane1 engineOn true; };
};
assignTskReturn = true;
Adams kbTell [player, "kb", "a_in_125_comply_ICO_0", "SIDE"];
waitUntil {Adams kbWasSaid [player, "kb", "a_in_125_comply_ICO_0", 9999]};
stopObserving = true;

sleep 2;
Adams kbTell [player, "kb", "a_in_130_planes_ICO_0", "DIRECT"];
waitUntil {Adams kbWasSaid [player, "kb", "a_in_130_planes_ICO_0", 9999]};

sleep 3;
[player] joinSilent Adams;
toCamp = true;
{_x setCaptive false} forEach [Adams, player];

if (isServer) then {
	[] spawn {
		sleep 4;
		{
			if (((side _x) == civilian) || ((side _x) == resistance)) then {
				_x setSkill ["aimingShake", 0.01];
				_x setSkill ["aimingAccuracy", 0.01];
				_x setSkill ["aimingSpeed", 0.3];
			};
		} forEach allUnits;

		forestAttack = true;
		{_x removeEventHandler ["HandleDamage", _x getVariable "damageEH"]} forEach units forestGroup;

		{
			private _unit = _x;

			if (vehicle _unit == _unit) then {
				_unit setPosATL (_unit getVariable ["pos", getPosATL _unit]);
				_unit setDir (_unit getVariable ["dir", direction _unit]);
			};

			{_unit enableAI _x} forEach ["ANIM", "AUTOTARGET", "FSM", "MOVE", "TARGET"];
			_unit enableSimulationGlobal true;
			_unit hideObjectGlobal false;
			_unit setCaptive false;
			_unit allowDamage true;
		} forEach (units forestGroup + units AA1Group1 + units AA1Group2);

		enemyHeli1 setPos [
			markerPos "mrk_enemyHeli1Pos" select 0,
			markerPos "mrk_enemyHeli1Pos" select 1,
			50
		];
		enemyHeli1 setDir markerDir "mrk_enemyHeli1Pos";
		
		{
			_x assignAsCargo enemyHeli1;
			_x moveInCargo enemyHeli1;
		} forEach units rangeAttackGrp;

		{
			private _unit = _x;
			{_unit enableAI _x} forEach ["ANIM", "AUTOTARGET", "FSM", "MOVE", "TARGET"];
			
			_unit enableSimulationGlobal true;
			_unit hideObjectGlobal false;
			_unit allowDamage true;
		} forEach (units group enemyHeli1D + units rangeAttackGrp);

		while {count waypoints group enemyHeli1D > 7} do {
			deleteWaypoint (waypoints group enemyHeli1D select 0);
		};
		
		enemyHeli1 enableSimulationGlobal true;
		enemyHeli1 hideObjectGlobal false;
		enemyHeli1 allowDamage true;

		{_x setCaptive false} forEach units rangeAttackGrp;

		sleep 12;
		{
			private _fire = "test_EmptyObjectForFireBig" createVehicle position _x;
			_fire setPos position _x;

			deleteVehicle _x;
		} forEach [wreck1, wreck2];
	};
	if (isNil "p0" || !(p0 in (call BIS_fnc_listPlayers))) then {
		p0 = selectRandom (call BIS_fnc_listPlayers);
		publicVariable "p0";
	};	
};

waitUntil {!(isNil "p0")};
Adams kbTell [player, "kb", "a_in_135_on_foot_ICO_0", "GROUP"];
waitUntil {Adams kbWasSaid [player, "kb", "a_in_135_on_foot_ICO_0", 9999]};
p0 kbTell [player, "kb", "a_in_135_on_foot_KER_0", "GROUP"];
waitUntil {p0 kbWasSaid [player, "kb", "a_in_135_on_foot_KER_0", 9999]};
BHQ kbTell [player, "kb", "a_in_140_enemies_BHQ_0", "SIDE"];
waitUntil {BHQ kbWasSaid [player, "kb", "a_in_140_enemies_BHQ_0", 9999]};
evac kbTell [player, "kb", "a_in_127_ambient_1_EVA_0", "SIDE"];
waitUntil {evac kbWasSaid [player, "kb", "a_in_127_ambient_1_EVA_0", 9999]};
evac kbTell [player, "kb", "a_in_127_ambient_1_EVA_1", "SIDE"];
waitUntil {evac kbWasSaid [player, "kb", "a_in_127_ambient_1_EVA_1", 9999]};
BHQ kbTell [player, "kb", "a_in_127_ambient_1_BHQ_0", "SIDE"];
waitUntil {BHQ kbWasSaid [player, "kb", "a_in_127_ambient_1_BHQ_0", 9999]};
p0 kbTell [player, "kb", "a_in_137_wtf_KER_0", "GROUP"];
waitUntil {p0 kbWasSaid [player, "kb", "a_in_137_wtf_KER_0", 9999]};
Adams kbTell [player, "kb", "a_in_137_wtf_ICO_0", "GROUP"];
waitUntil {Adams kbWasSaid [player, "kb", "a_in_137_wtf_ICO_0", 9999]};
p0 kbTell [player, "kb", "a_in_137_wtf_KER_1", "GROUP"];
waitUntil {p0 kbWasSaid [player, "kb", "a_in_137_wtf_KER_1", 9999]};
Adams kbTell [player, "kb", "a_in_145_fubar_ICO_1", "GROUP"];
waitUntil {Adams kbWasSaid [player, "kb", "a_in_145_fubar_ICO_1", 9999]};

waitUntil {behaviour Adams == "COMBAT"};
sleep 2;
BHQ kbTell [player, "kb", "a_in_140_enemies_BHQ_1", "SIDE"];
waitUntil {BHQ kbWasSaid [player, "kb", "a_in_140_enemies_BHQ_1", 9999]};
BHQ kbTell [player, "kb", "a_in_140_enemies_BHQ_2", "SIDE"];
waitUntil {BHQ kbWasSaid [player, "kb", "a_in_140_enemies_BHQ_2", 9999]};

waitUntil {({alive _x} count units forestGroup) == 0};
if (isServer) then {
	if (isNil "p0" || !(p0 in (call BIS_fnc_listPlayers))) then {
			p0 = selectRandom (call BIS_fnc_listPlayers);
			publicVariable "p0";
	};
};
sleep (5 + random 5);
waitUntil {!(isNil "p0")};

p0 kbTell [player, "kb", "a_in_145_fubar_KER_0", "GROUP"];
waitUntil {p0 kbWasSaid [player, "kb", "a_in_145_fubar_KER_0", 9999]};
Adams kbTell [player, "kb", "a_in_145_fubar_ICO_0", "GROUP"];
waitUntil {Adams kbWasSaid [player, "kb", "a_in_145_fubar_ICO_0", 9999]};
Adams kbTell [player, "kb", "a_in_137_wtf_ICO_1", "GROUP"];
waitUntil {Adams kbWasSaid [player, "kb", "a_in_137_wtf_ICO_1", 9999]};
Adams kbTell [player, "kb", "a_in_155_contacts_ICO_0", "SIDE"];
waitUntil {Adams kbWasSaid [player, "kb", "a_in_155_contacts_ICO_0", 9999]};
sleep 2;
Adams kbTell [player, "kb", "a_in_155_contacts_ICO_1", "SIDE"];
waitUntil {Adams kbWasSaid [player, "kb", "a_in_155_contacts_ICO_1", 9999]};

if (isServer) then {
	{if (alive _x) then {_x setDamage 1}} forEach rangeAmbient;
	// BIS_campSetup
	Edwards hideObjectGlobal true;
	Edwards enableSimulationGlobal false;
	Edwards allowDamage false;
	Edwards setCaptive true;
	{Edwards disableAI _x} forEach ["ANIM", "AUTOTARGET", "FSM", "MOVE", "TARGET"];
	Edwards setPos [7093.7,5965.62,0.0014205];

	{deleteVehicle _x} forEach ([Conway, Mitchell, campDriver1, Lacey, rgnHeliGuide, rgnLogic, campCrew1, campCrew2, campCrew3, campTruck1, campGuard1, campGuard2] + goats);

	truckSec setPos (markerPos "mrk_truckSecPos");
	truckSec setDir (markerDir "mrk_truckSecPos");

	{_x setDamage 1} forEach [truckSec, campTruck2];

	enemyTruck1 setPosATL (enemyTruck1 getVariable ["pos", getPosATL enemyTruck1]);
	enemyTruck1 setDir (enemyTruck1 getVariable ["dir", direction enemyTruck1]);
	enemyTruck1 enableSimulationGlobal true;
	enemyTruck1 hideObjectGlobal false;
	enemyTruck1 allowDamage true;

	{
		private _unit = _x;

		if (vehicle _unit == _unit) then {
			_unit setPosATL (_unit getVariable ["pos", getPosATL _unit]);
			_unit setDir (_unit getVariable ["dir", direction _unit]);
			{_unit enableAI _x} forEach ["ANIM", "AUTOTARGET", "FSM", "MOVE", "TARGET"];
			_unit enableSimulationGlobal true;
			_unit hideObjectGlobal false;
			_unit setCaptive false;
			_unit allowDamage true;
		};
	} forEach [campAmbient1, campAmbient2, campAmbient6, campAmbient8];

	"test_EmptyObjectForSmoke" createVehicle [4967.898,5899.229,0.000];

	[campAmbient1, "mrk_campPos1"] spawn campSetup;
	[campAmbient2, "mrk_campPos2"] spawn campSetup;
	[campAmbient3, "mrk_campPos3"] spawn campSetup;
	[campAmbient4, "mrk_campPos4"] spawn campSetup;
	[campAmbient5, "mrk_campPos5"] spawn campSetup;
	[campAmbient6, "mrk_campPos6"] spawn campSetup;
	[campAmbient7, "mrk_campPos7"] spawn campSetup;
	[campAmbient8, "mrk_campPos8"] spawn campSetup;

	campFight = true;

	// BIS_AA2Setup
	private _fire = createVehicle ["test_EmptyObjectForFireBig", position AA2, [], 0, "NONE"];
	_fire setPos position AA2;
	{deleteVehicle _x} forEach [AA2C, AA2G, AA2D, AA2, AA2Crate];

	[AA2Ambient1, "mrk_AA2Pos1"] spawn AA2setup;
	[AA2Ambient2, "mrk_AA2Pos2"] spawn AA2setup;
	[AA2Ambient3, "mrk_AA2Pos3"] spawn AA2setup;
	[AA2Ambient4, "mrk_AA2Pos4"] spawn AA2setup;

	assignTskEvac = true;
};

Edwards kbTell [player, "kb", "a_in_160_evac_LOG_0", "SIDE"];
waitUntil {Edwards kbWasSaid [player, "kb", "a_in_160_evac_LOG_0", 9999]};
sleep 0.5;
BHQ kbTell [player, "kb", "a_in_160_evac_BHQ_0", "SIDE"];
waitUntil {BHQ kbWasSaid [player, "kb", "a_in_160_evac_BHQ_0", 9999]};
BHQ kbTell [player, "kb", "a_in_160_evac_BHQ_1", "SIDE"];
waitUntil {BHQ kbWasSaid [player, "kb", "a_in_160_evac_BHQ_1", 9999]};
BHQ kbTell [player, "kb", "a_in_160_evac_BHQ_2", "SIDE"];
waitUntil {BHQ kbWasSaid [player, "kb", "a_in_160_evac_BHQ_2", 9999]};
BHQ kbTell [player, "kb", "a_in_160_evac_BHQ_3", "SIDE"];
waitUntil {BHQ kbWasSaid [player, "kb", "a_in_160_evac_BHQ_3", 9999]};

{
	[
		_x,
		"mil_destroy",
		[1,0,0,1],
		1.2,1.2,45
	] call BIS_fnc_ORBATAddGroupOverlay;
} forEach [
	configFile >> "CfgORBAT" >> "BIS" >> "B_Aegis_A_2",
	configFile >> "CfgORBAT" >> "BIS" >> "B_Aegis_HelicopterSquadron",
	configFile >> "CfgORBAT" >> "BIS" >> "B_Aegis_HQCompany",
	configFile >> "CfgORBAT" >> "BIS" >> "B_Aegis_ACompany",
	configFile >> "CfgORBAT" >> "BIS" >> "B_Aegis_A_3",
	configFile >> "CfgORBAT" >> "BIS" >> "B_Aegis_A_4"
];
{_x setMarkerColor "ColorIndependent"} forEach ["mrk_rogain", "mrk_airBase"];

if (isServer) then {
	if (isNil "p0" || !(p0 in (call BIS_fnc_listPlayers))) then {
			p0 = selectRandom (call BIS_fnc_listPlayers);
			publicVariable "p0";
	};
};

p0 kbTell [player, "kb", "a_in_165_aa_KER_0", "GROUP"];
waitUntil {p0 kbWasSaid [player, "kb", "a_in_165_aa_KER_0", 9999]};
Adams kbTell [player, "kb", "a_in_165_aa_ICO_0", "GROUP"];
waitUntil {Adams kbWasSaid [player, "kb", "a_in_165_aa_ICO_0", 9999]};
Adams kbTell [player, "kb", "a_in_165_aa_ICO_1", "GROUP"];
waitUntil {Adams kbWasSaid [player, "kb", "a_in_165_aa_ICO_1", 9999]};

waitUntil {triggerActivated t_overCampTrig};
[] spawn {
	if (isServer) then {
		Adams doWatch markerPos "mrk_camp";
		waitUntil {{!(isNil _x)} count ["watching", "toAA"] > 0};
		if !(isNil "toAA") exitWith {};
		{_x setBehaviour "CARELESS"} forEach ([Adams] + allPlayers);
		
		waitUntil {animationState Adams == "AmovPercMstpSlowWrflDnon"};
		{Adams disableAI _x} forEach ["AUTOTARGET", "FSM", "MOVE", "TARGET"];
		Adams playMoveNow "Acts_ShieldFromSun_in";

		waitUntil {!(isNil "toAA")};
		{_x setBehaviour "AWARE"} forEach ([Adams] + allPlayers);
		Adams doWatch objNull;
		Adams disableAI "ANIM";
		Adams playMoveNow "Acts_ShieldFromSun_out";

		private _animEH = Adams addEventHandler ["AnimDone", {
			if (_this select 1 == "Acts_ShieldFromSun_out") then {
				Adams removeEventHandler ["AnimDone", Adams getVariable "animEH"];
				{Adams enableAI _x} forEach ["ANIM", "AUTOTARGET", "FSM", "MOVE", "TARGET"];
				Adams playMoveNow "AmovPercMstpSrasWrflDnon";
			};
		}];
		Adams setVariable ["animEH", _animEH];
	};
};

waitUntil {{_x distance Adams < 10} forEach allPlayers};
enemyHeli2 setPosATL (enemyHeli2 getVariable ["pos", getPosATL enemyHeli2]);
enemyHeli2 setDir (enemyHeli2 getVariable ["dir", direction enemyHeli2]);

{
	_x enableSimulationGlobal true;
	_x hideObjectGlobal false;
	_x allowDamage true;
} forEach [plane2, enemyHeli2];
if (!isEngineOn plane2) then { plane2 engineOn true; };

{
	private _unit = _x;
	
	{_unit enableAI _x} forEach ["ANIM", "AUTOTARGET", "FSM", "MOVE", "TARGET"];
	_unit enableSimulationGlobal true;
	_unit hideObjectGlobal false;
	_unit allowDamage true;
} forEach ([plane2D] + units group enemyHeli2D);
planeSwap1 = true;

if (isServer) then {
	if (isNil "p0" || !(p0 in (call BIS_fnc_listPlayers))) then {
			p0 = selectRandom (call BIS_fnc_listPlayers);
			publicVariable "p0";
	};
};

p0 kbTell [player, "kb", "a_in_170_over_camp_KER_0", "GROUP"];
waitUntil {p0 kbWasSaid [player, "kb", "a_in_170_over_camp_KER_0", 9999]};
sleep 4;
Adams kbTell [player, "kb", "a_in_170_over_camp_ICO_0", "GROUP"];
waitUntil {Adams kbWasSaid [player, "kb", "a_in_170_over_camp_ICO_0", 9999]};
toAA = true;

[] spawn {
	waitUntil {Adams distance markerPos "mrk_AA1" <= 40};
	{if (alive _x && _x distance markerPos "mrk_AA1" > 40) then {_x setDamage 1}} forEach (units AA1Group1 + units AA1Group2);
};

waitUntil {{alive _x} count (units AA1Group1 + units AA1Group2) == 0};

[] spawn {
	if (isServer) then {
		Adams setUnitPos "UP";
		planeSwap2 = true;

		sleep (6 + random 10);
		evacInbound = true;

		maxHeli setPos [
			markerPos "evacHeliPos" select 0,
			markerPos "evacHeliPos" select 1,
			50
		];
		maxHeli setDir markerDir "evacHeliPos";

		maxHeli enableSimulationGlobal true;
		maxHeli hideObjectGlobal false;
		maxHeli setVelocity [0, 0, 0];

		{
			_unit = _x;
			{_unit enableAI _x} forEach ["ANIM", "AUTOTARGET", "FSM", "MOVE", "TARGET"];
			_unit enableSimulationGlobal true;
			_unit hideObjectGlobal false;
		} forEach (units group maxHeliD + evacTeam);

		{
			_x setCaptive false;
			_x allowDamage true;
			_x assignAsCargo maxHeli;
			_x moveInCargo maxHeli;
		} forEach evacTeam;

		evacTaken = [];
		{_x call evacSetup} forEach evacTeam;
	};
};

p0 kbTell [player, "kb", "a_in_175_bad_sign_KER_0", "GROUP"];

[] spawn {
	waitUntil {triggerActivated t_AATrig};
	if (isServer) then {
		Adams doWatch [5366.165,5248.340,0.000];
	};

	waitUntil {{_x distance Adams < 10} forEach allPlayers};
	Adams kbTell [player, "kb", "a_in_180_at_aa_ICO_0", "GROUP"];
	// "BIS_AA1Cross" setMarkerAlpha 1;
	// supposed to cross out mrk_AA1, but there is no marker named so even in official
	planeSwap2 = true;
};

waitUntil {maxHeli distance markerPos "mrk_AA1" <= 350};

Adams kbTell [player, "kb", "a_in_185_evac_spotted_ICO_0", "GROUP"];
waitUntil {Adams kbWasSaid [player, "kb", "a_in_185_evac_spotted_ICO_0", 9999]};
sleep 2;

// cross out mrk_AA1

if (isServer) then {
	{
		private _unit = _x;
		if (vehicle _unit == _unit) then {
			_unit setPosATL (_unit getVariable ["pos", getPosATL _unit]);
			_unit setDir (_unit getVariable ["dir", direction _unit]);
		};

		{_unit enableAI _x} forEach ["ANIM", "AUTOTARGET", "FSM", "MOVE", "TARGET"];

		_unit enableSimulationGlobal true;
		_unit hideObjectGlobal false;
		_unit setCaptive false;
		_unit allowDamage true;
	} forEach evacAttack;
};

0 fadeMusic 0.6;
playMusic "LeadTrack03_F";

Adams doWatch maxHeli;
Adams reveal maxHeli;

toEvac = true;

[] spawn {
	waitUntil {bomber distance maxHeli < 250 || {alive _x} count units evacAttack1 == 0 || {vehicle _x distance markerPos "mrk_LZ2" <= 435} count ([Adams] + allPlayers) > 0};
	if !({alive _x} count units evacAttack1 == 0 || {vehicle _x distance markerPos "mrk_LZ2" <= 435} count ([Adams] + allPlayers) > 0) then {
		sleep 3;
		evac kbTell [player, "kb", "a_in_190_fly_over_EVA_0", "SIDE"];
	};
};

[] spawn {
	waitUntil {{alive _x} count units evacAttack1 == 0 || {vehicle _x distance markerPos "mrk_LZ2" <= 435} count ([Adams] + allPlayers) > 0};
	if (isServer) then {
		{if (alive _x) then {_x setDamage 1}} forEach units evacDefend2;
		execVM "unitPlay\planeAttack.sqf";
	};

	waitUntil {bomber distance markerPos "mrk_LZ2" <= 800};
	Adams reveal bomber;
	Adams doWatch bomber;

	[] spawn {
		Adams kbTell [player, "kb", "a_in_195_bomber_spotted_ICO_0", "GROUP"];
		waitUntil {Adams kbWasSaid [player, "kb", "a_in_195_bomber_spotted_ICO_0", 9999]};
		Adams kbTell [player, "kb", "a_in_200_bomb_inbound_ICO_0", "SIDE"];
	};
};



Adams kbTell [player, "kb", "a_in_183_evac_confirmed_ICO_0", "GROUP"];
waitUntil {Adams kbWasSaid [player, "kb", "a_in_183_evac_confirmed_ICO_0", 9999]};
Adams doWatch objNull;

sleep 1;

evac kbTell [player, "kb", "a_in_185_request_evac_EVA_0", "SIDE"];
waitUntil {evac kbWasSaid [player, "kb", "a_in_185_request_evac_EVA_0", 9999]};
Adams kbTell [player, "kb", "a_in_185_request_evac_ICO_0", "SIDE"];
waitUntil {Adams kbWasSaid [player, "kb", "a_in_185_request_evac_ICO_0", 9999]};
evac kbTell [player, "kb", "a_in_185_request_evac_EVA_1", "SIDE"];
waitUntil {evac kbWasSaid [player, "kb", "a_in_185_request_evac_EVA_1", 9999]};
Adams kbTell [player, "kb", "a_in_185_request_evac_ICO_1", "SIDE"];
waitUntil {Adams kbWasSaid [player, "kb", "a_in_185_request_evac_ICO_1", 9999]};

if (isServer) then {
	execVM "unitPlay\distantBombing.sqf";
};

"SmokeShellPurple" createVehicle [4600.353, 5300.814, 0.000];

waitUntil {!alive maxHeli};
0 fadeMusic 0.4;
playMusic "EventTrack01a_F_EPA";

if (isServer) then {
	Adams doWatch objNull;
};

sleep 1;
Adams kbTell [player, "kb", "a_in_205_heli_dead_ICO_0", "GROUP"];
waitUntil {Adams kbWasSaid [player, "kb", "a_in_205_heli_dead_ICO_0", 9999]};
Adams kbTell [player, "kb", "a_in_210_check_in_ICO_0", "SIDE"];

if (isServer) then {
	if (isNil "p0" || !(p0 in (call BIS_fnc_listPlayers))) then {
			p0 = selectRandom (call BIS_fnc_listPlayers);
			publicVariable "p0";
	};
};

waitUntil {Adams kbWasSaid [player, "kb", "a_in_210_check_in_ICO_0", 9999]};
p0 kbTell [player, "kb", "a_in_215_now_what_KER_0", "GROUP"];
waitUntil {p0 kbWasSaid [player, "kb", "a_in_215_now_what_KER_0", 9999]};
Adams kbTell [player, "kb", "a_in_215_now_what_ICO_0", "GROUP"];
waitUntil {Adams kbWasSaid [player, "kb", "a_in_215_now_what_ICO_0", 9999]};

if (isServer) then {
	findShelter = true;
};

Adams kbTell [player, "kb", "a_in_220_find_shelter_ICO_0", "GROUP"];
waitUntil {Adams kbWasSaid [player, "kb", "a_in_220_find_shelter_ICO_0", 9999]};
Adams kbTell [player, "kb", "a_in_220_find_shelter_ICO_1", "GROUP"];
waitUntil {Adams kbWasSaid [player, "kb", "a_in_220_find_shelter_ICO_1", 9999]};
Adams kbTell [player, "kb", "a_in_220_find_shelter_ICO_2", "GROUP"];
waitUntil {Adams kbWasSaid [player, "kb", "a_in_220_find_shelter_ICO_2", 9999]};
p0 kbTell [player, "kb", "a_in_220_find_shelter_KER_0", "GROUP"];
waitUntil {p0 kbWasSaid [player, "kb", "a_in_220_find_shelter_KER_0", 9999]};
Adams kbTell [player, "kb", "a_in_220_find_shelter_ICO_3", "GROUP"];
waitUntil {Adams kbWasSaid [player, "kb", "a_in_220_find_shelter_ICO_3", 9999]};

sleep 1;
0 fadeMusic 0.4;
playMusic "LeadTrack02b_F_EPA";

if (isServer) then {
	[] spawn {
		waitUntil {triggerActivated t_retreatTrig};

		enemyHeli3 setPosATL (enemyHeli3 getVariable ["pos", getPosATL enemyHeli3]);
		enemyHeli3 setDir (enemyHeli3 getVariable ["dir", direction enemyHeli3]);

		enemyHeli3 enableSimulationGlobal true;
		enemyHeli3 hideObjectGlobal false;
		enemyHeli3 allowDamage true;

		{
			private _unit = _x;

			if (vehicle _unit == _unit) then {
				_unit setPosATL (_unit getVariable ["pos", getPosATL _unit]);
				_unit setDir (_unit getVariable ["dir", direction _unit]);
			};

			{_unit enableAI _x} forEach ["ANIM", "AUTOTARGET", "FSM", "MOVE", "TARGET"];

			_unit enableSimulationGlobal true;
			_unit hideObjectGlobal false;
			_unit allowDamage true;
		} forEach (units retreatGrp1 + units group enemyHeli3D + units retreatGrp2);

		{_x setCaptive false} forEach units retreatGrp1;
	};
};

waitUntil {triggerActivated t_nearForestTrig};
Adams kbTell [player, "kb", "a_in_225_near_forest_ICO_0", "GROUP"];
waitUntil {Adams kbWasSaid [player, "kb", "a_in_225_near_forest_ICO_0", 9999]};

waitUntil {triggerActivated t_forestTrig};
{_x setCaptive true} forEach ([Adams] + allPlayers);

0 fadeMusic 0.4;
playMusic "EventTrack02a_F_EPA";

sleep 8;
if (isServer) then {enteredForest = true};
sleep 1;

Adams kbTell [player, "kb", "a_in_230_in_forest_ICO_0", "GROUP"];
waitUntil {Adams kbWasSaid [player, "kb", "a_in_230_in_forest_ICO_0", 9999]};

sleep 19;
6 fadeSound 0;
7 fadeMusic 0;
titleCut ["", "BLACK OUT", 6];

sleep 8;

endMission "A_in2_1";