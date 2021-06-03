{_x kbAddTopic ["amb_kb", "ambientConversations\kb.bikb"]} forEach [Wright, Davies, Conway, Mitchell];

sleep 5;
[] spawn {
	waitUntil {{vehicle _x distance Wright <= 4} forEach allPlayers};
	Wright kbTell [player, "amb_kb", "a_hub_090_ambient_special_00_ALPA_0", "DIRECT"];
	waitUntil {Wright kbWasSaid [player, "amb_kb", "a_hub_090_ambient_special_00_ALPA_0", 9999]};
	Davies kbTell [player, "amb_kb", "a_hub_090_ambient_special_00_ALPB_0", "DIRECT"];
	waitUntil {Davies kbWasSaid [player, "amb_kb", "a_hub_090_ambient_special_00_ALPB_0", 9999]};
	Wright kbTell [player, "amb_kb", "a_hub_090_ambient_special_00_ALPA_1", "DIRECT"];
	waitUntil {Wright kbWasSaid [player, "amb_kb", "a_hub_090_ambient_special_00_ALPA_1", 9999]};
	Davies kbTell [player, "amb_kb", "a_hub_090_ambient_special_00_ALPB_1", "DIRECT"];
	waitUntil {Davies kbWasSaid [player, "amb_kb", "a_hub_090_ambient_special_00_ALPB_1", 9999]};
	Wright kbTell [player, "amb_kb", "a_hub_090_ambient_special_00_ALPA_2", "DIRECT"];
	waitUntil {Wright kbWasSaid [player, "amb_kb", "a_hub_090_ambient_special_00_ALPA_2", 9999]};

	sleep 5;
	waitUntil {{vehicle _x distance Wright <= 3} forEach allPlayers};
	Wright kbTell [player, "amb_kb", "a_hub_091_ambient_special_01_ALPA_0", "DIRECT"];
	waitUntil {Wright kbWasSaid [player, "amb_kb", "a_hub_091_ambient_special_01_ALPA_0", 9999]};
	Davies kbTell [player, "amb_kb", "a_hub_091_ambient_special_01_ALPB_0", "DIRECT"];
	waitUntil {Davies kbWasSaid [player, "amb_kb", "a_hub_091_ambient_special_01_ALPB_0", 9999]};
	Wright kbTell [player, "amb_kb", "a_hub_091_ambient_special_01_ALPA_1", "DIRECT"];
	waitUntil {Wright kbWasSaid [player, "amb_kb", "a_hub_091_ambient_special_01_ALPA_1", 9999]};
	Wright kbTell [player, "amb_kb", "a_hub_091_ambient_special_01_ALPA_2", "DIRECT"];
	waitUntil {Wright kbWasSaid [player, "amb_kb", "a_hub_091_ambient_special_01_ALPA_2", 9999]};
	Davies kbTell [player, "amb_kb", "a_hub_091_ambient_special_01_ALPB_1", "DIRECT"];
	waitUntil {Davies kbWasSaid [player, "amb_kb", "a_hub_091_ambient_special_01_ALPB_1", 9999]};
	Davies kbTell [player, "amb_kb", "a_hub_091_ambient_special_01_ALPB_2", "DIRECT"];
	waitUntil {Davies kbWasSaid [player, "amb_kb", "a_hub_091_ambient_special_01_ALPB_2", 9999]};
	Davies kbTell [player, "amb_kb", "a_hub_091_ambient_special_01_ALPB_3", "DIRECT"];
	waitUntil {Davies kbWasSaid [player, "amb_kb", "a_hub_091_ambient_special_01_ALPB_3", 9999]};
	Davies kbTell [player, "amb_kb", "a_hub_091_ambient_special_01_ALPB_4", "DIRECT"];
	waitUntil {Davies kbWasSaid [player, "amb_kb", "a_hub_091_ambient_special_01_ALPB_4", 9999]};
	Wright kbTell [player, "amb_kb", "a_hub_091_ambient_special_01_ALPA_3", "DIRECT"];
	waitUntil {Wright kbWasSaid [player, "amb_kb", "a_hub_091_ambient_special_01_ALPA_3", 9999]};
};

[] spawn {
	waitUntil {{vehicle _x distance Conway <= 10} forEach allPlayers};

	Mitchell kbTell [player, "amb_kb", "a_hub_092_ambient_special_02_CHA_0", "DIRECT"];
	waitUntil {Mitchell kbWasSaid [player, "amb_kb", "a_hub_092_ambient_special_02_CHA_0", 9999]};
	Conway kbTell [player, "amb_kb", "a_hub_092_ambient_special_02_ALP_0", "DIRECT"];
	waitUntil {Conway kbWasSaid [player, "amb_kb", "a_hub_092_ambient_special_02_ALP_0", 9999]};
	Conway kbTell [player, "amb_kb", "a_hub_092_ambient_special_02_ALP_1", "DIRECT"];
	waitUntil {Conway kbWasSaid [player, "amb_kb", "a_hub_092_ambient_special_02_ALP_1", 9999]};
	Mitchell kbTell [player, "amb_kb", "a_hub_092_ambient_special_02_CHA_1", "DIRECT"];
	waitUntil {Mitchell kbWasSaid [player, "amb_kb", "a_hub_092_ambient_special_02_CHA_1", 9999]};
	Conway kbTell [player, "amb_kb", "a_hub_092_ambient_special_02_ALP_2", "DIRECT"];
	waitUntil {Conway kbWasSaid [player, "amb_kb", "a_hub_092_ambient_special_02_ALP_2", 9999]};
	Conway kbTell [player, "amb_kb", "a_hub_092_ambient_special_02_ALP_3", "DIRECT"];
	waitUntil {Conway kbWasSaid [player, "amb_kb", "a_hub_092_ambient_special_02_ALP_3", 9999]};
	
	waitUntil {!(isNil "ordersRecieved")};
	waitUntil {{vehicle _x distance Conway <= 5} forEach allPlayers};
	Mitchell kbTell [player, "amb_kb", "a_hub_093_ambient_special_03_CHA_0", "DIRECT"];
	waitUntil {Mitchell kbWasSaid [player, "amb_kb", "a_hub_093_ambient_special_03_CHA_0", 9999]};
	Conway kbTell [player, "amb_kb", "a_hub_093_ambient_special_03_ALP_0", "DIRECT"];
	waitUntil {Conway kbWasSaid [player, "amb_kb", "a_hub_093_ambient_special_03_ALP_0", 9999]};
	Conway kbTell [player, "amb_kb", "a_hub_093_ambient_special_03_ALP_1", "DIRECT"];
	waitUntil {Conway kbWasSaid [player, "amb_kb", "a_hub_093_ambient_special_03_ALP_1", 9999]};
	Mitchell kbTell [player, "amb_kb", "a_hub_093_ambient_special_03_CHA_1", "DIRECT"];
	waitUntil {Mitchell kbWasSaid [player, "amb_kb", "a_hub_093_ambient_special_03_CHA_1", 9999]};
	Conway kbTell [player, "amb_kb", "a_hub_093_ambient_special_03_ALP_2", "DIRECT"];
	waitUntil {Conway kbWasSaid [player, "amb_kb", "a_hub_093_ambient_special_03_ALP_2", 9999]};
	Conway kbTell [player, "amb_kb", "a_hub_093_ambient_special_03_ALP_3", "DIRECT"];
	waitUntil {Conway kbWasSaid [player, "amb_kb", "a_hub_093_ambient_special_03_ALP_3", 9999]};
};