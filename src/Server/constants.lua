return {
	MAX_RETRIES = 5;
	
	MAX_POSSIBLE_HEALTH = 150;
	
	MAX_POSSIBLE_TP_DISTANCE = 30;
	
	WARNING = " Exploiting is against the Roblox terms of service (ToS) and you may get banned.";
	
	PREFIX = "You have been kicked.";
	
	-- is rawblox gonna ban them?
	KICK_REASONS = {
		"modifying max health.";
		"noclipping.",
		"fly hacking.",
		"aimbot."
	};
	
	-- translate type of exploit value to table address, kind of like an enum
	DATA_TRANSLATE = {
		MAXHEALTH_HACKS = 1;
		NOCLIP = 2;
	};
	
	STATES = {
		NOCLIPPING = Enum.HumanoidStateType.StrafingNoPhysics;
		DEAD = Enum.HumanoidStateType.Dead;
	}
}