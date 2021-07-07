--[[
	Proximity Anticheat
	
	A powerful and light anticheat module.
	
	Author(s): xXEpic_TrayambakXx
]]

--[[
	Services
--]]
local Plrs = game:GetService('Players')

--[[
	Required modules
--]]
local constants = require(script.constants)
local vectorMath = require(script.compute.math.vector)

local reportCooldown = false

--[[
	Main class
--]]
local Proximity = {
	name = "Proximity Anticheat"
}

local lastLookVectors = {}

Plrs.PlayerAdded:Connect(function(plr)
	local plrChar = plr.Character or plr.CharacterAdded:Wait()
	lastLookVectors[plr.Name] = plrChar:WaitForChild("Head").CFrame.LookVector
end)

Proximity.__index = Proximity

--[[
	Functions begin from here
--]]
function Proximity:NoclipDetectionSkid(humanoid)
	--[[
		SOON TO BE DEPRECATED, DO NOT USE.
		
		A very naive way of detecting noclip as most exploiters just change the humanoid's state to 11 (Enum.HumanoidStateType.StrafingNoPhysics)
	]]
	
	if humanoid:GetState() == constants.STATES.NOCLIPPING then
		return true
	else
		return false
	end
end

function Proximity:AimbotDetectionSkid(plr, head)
	local currentLookVector = head.CFrame.LookVector
	local lastLookVector = lastLookVectors[plr]

	local delta = (currentLookVector - lastLookVector).Magnitude
	
	if delta > 2 then
		return true
	end
	return false
end

function Proximity:UpdateVectorLook()
	for i, plr in pairs(Plrs:GetPlayers()) do
		local char = plr.Character or plr.CharacterAdded:Wait()
		lastLookVectors[plr] = char:WaitForChild("Head").CFrame.LookVector
	end
end

function Proximity:NoclipDetectionAdvanced(character)
	--[[
		WORK IN PROGRESS, DO NOT USE.
		
		A more advanced way of detecting noclip.
	--]]
	
	local root = character:WaitForChild("HumanoidRootPart")
	
end

function Proximity:MaxHealthDetection(humanoid)
	if humanoid.MaxHealth > constants.MAX_POSSIBLE_HEALTH then
			return true
	end
	return false
end

function Proximity:Kick(player, reason)
	local success, err = pcall(function()
		player:Kick("\n[  "..Proximity.name.."  ]\nYou have been kicked.\nReason: "..tostring(constants.PREFIX..reason..constants.WARNING))
		msg_evnt:FireAllClients(
			"Proximity Anticheat", 
			player.Name.." was kicked for "..reason,
			Color3.fromRGB(255, 0, 4)
		)
		reportCooldown = true
		wait(2)
	end)
	
	if err then
		warn("["..Proximity.name..":Kick()] :: "..tostring(err))
	end
end

function Proximity:AddCamera()
	local camera
end

function Proximity:FlyHackSkidDetection(character)
	--[[
		Since most exploiters are 6 year old skids, and most of the public fly scripts use BodyGyro, we can just detect it and ban.
	--]]
	local bodyGyroExists = false
	local bodyVelocityExists = false
	
	local head = character:FindFirstChild("Head")
	local hrp = character:FindFirstChild("HumanoidRootPart")
	
	if hrp then
		if hrp:FindFirstChildOfClass("BodyGyro") and hrp:FindFirstChildOfClass("BodyVelocity") then
			return true
		end
	end
	
	if head then
		if head:FindFirstChildOfClass("BodyGyro") and head:FindFirstChildOfClass("BodyVelocity") then
			return true
		end
	end
	
	return false
end

function Proximity:AdvancedFlyHackDetection(character)
	--[[
		For the more "advanced" scripts.
		
		this is just testing, by the way, don't use this right now, it insta kicks you if you jump.
	]]
	local humanoid = character:WaitForChild("Humanoid")
	return false
end

function Proximity:AimbotDetection(character)
	local plr = Plrs:GetPlayerFromCharacter(character)
	
	return false
end

function Proximity:FlyHackDetection(character)
	local isHackSkid = Proximity:FlyHackSkidDetection(character)
	local isHackAdvanced = Proximity:AdvancedFlyHackDetection(character)
	
	if isHackSkid or isHackAdvanced then
		return true
	end
	return false
end

function Proximity:PerStrafeUpdate()
	--[[
		Gets called every time the player's position changes.
	]]
	
end

function Proximity:GetExploitData(player)
	local data = {}
	local success, err = pcall(function()
		local character = player.Character or player.CharacterAdded:Wait()
		local humanoid = character:WaitForChild("Humanoid")
		
		local maxHealthHX = Proximity:MaxHealthDetection(humanoid)
		local noclipHX = Proximity:NoclipDetectionSkid(humanoid)
		local flyHX = Proximity:FlyHackDetection(character)
		local aimbotHX = Proximity:AimbotDetection()
		
		--[[print("Is noclipping: "..tostring(noclipHX))
		print("Is MH hacking: "..tostring(maxHealthHX))--]]
		
		table.insert(data, 1, maxHealthHX)
		table.insert(data, 2, noclipHX)
		table.insert(data, 3, flyHX)
		table.insert(data, 4, aimbotHX)
	end)
	
	if err then warn("["..Proximity.name.."] :: "..tostring(err)) return end
	
	return data
end


function Proximity:FrameUpdate()
	--[[
		Main loop for the anticheat. Should be run on RunService.Heartbeat
	--]]
	
	local plrList = Plrs:GetPlayers()
	
	Proximity:UpdateVectorLook()
	
	for i, plr in pairs(plrList) do
		local exploitData = Proximity:GetExploitData(plr)
		
		for index, dat in pairs(exploitData) do
			local reason = constants.KICK_REASONS[index]
			
			if dat == true then
				Proximity:Kick(plr, reason)
				--print("[Proximity] :: Kicked "..plr.Name.." for "..reason)
			end
		end
	end
end

return Proximity