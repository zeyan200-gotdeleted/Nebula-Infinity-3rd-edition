-- @ | Variables

local DataStore = game:GetService("DataStoreService"):GetDataStore("Nebula Third Edition | Bans")

local Callbacks, Methods, ServerBans, Debounces = {}, {}, {}, {}
local Meta = setmetatable({}, Callbacks)

Callbacks.__index, Methods.__index = Callbacks, Methods

-- @ | Methods

-- @ | Callbacks

function Callbacks:IsBanned(Player: number | string)
	local data

	local success, result = pcall(function()
		return DataStore:GetAsync("BanLand")
	end)

	if not success then
		warn("Failed to get ban data:", result)
		return false 
	end

	local pastData = result or {}
	local playerID = typeof(Player) == "string" and Player or tostring(Player)
	data = pastData[playerID]

	if data == nil then
		return false
	end

	if data.Banned == true then
		if data.BanType == "Perm" then
			return true
		elseif data.BanType == "Time" and os.time() < data.UnbanTime then
			return true
		elseif data.BanType == "Time" and os.time() >= data.UnbanTime then
			Callbacks:UnBan(playerID)
			return false
		end
	end

	return false
end

function Callbacks:PermBan(Player: Player, Reason: string)
	local success, result = pcall(function()
		if game.CreatorType == Enum.CreatorType.User and game.CreatorId == Player.UserId then error("Can't ban the creator of this experience.") end
		if game.CreatorType == Enum.CreatorType.Group and game:GetService("GroupService"):GetGroupInfoAsync(game.CreatorId)["Owner"].Id == Player.UserId then error("Can't ban the creator of this experience.") end

		DataStore:UpdateAsync("BanLand", function(pastData)
			pastData = pastData or {}
			pastData[tostring(Player.UserId)] = {
				["BanType"] = "Perm",
				["UserId"] = Player.UserId, 
				["Reason"] = Reason,
				["Banned"] = true,
			}
			return pastData 
		end)
	end)

	if not success then
		warn("Failed to permaban:", result)
		return
	end

	Player:Kick(Reason)
end

function Callbacks:TimeBan(Player: Player, Reason: string, Duration: number)
	local success, result = pcall(function()
		if game.CreatorType == Enum.CreatorType.User and game.CreatorId == Player.UserId then error("Can't ban the creator of this experience.") end
		if game.CreatorType == Enum.CreatorType.Group and game:GetService("GroupService"):GetGroupInfoAsync(game.CreatorId)["Owner"].Id == Player.UserId then error("Can't ban the creator of this experience.") end

		DataStore:UpdateAsync("BanLand", function(pastData)
			pastData = pastData or {}
			pastData[tostring(Player.UserId)] = {
				["BanType"] = "Time",
				["UserId"] = Player.UserId, 
				["Reason"] = Reason,
				["Banned"] = true,
				["UnbanTime"] = os.time() + Duration
			}
			return pastData 
		end)
	end)

	if not success then
		warn("Failed to time ban:", result)
		return
	end

	Player:Kick(Reason)
end

function Callbacks:ServerBan(Player: Player, Reason: string)
	if game.CreatorType == Enum.CreatorType.User and game.CreatorId == Player.UserId then error("Can't ban the creator of this experience.") end
	if game.CreatorType == Enum.CreatorType.Group and game:GetService("GroupService"):GetGroupInfoAsync(game.CreatorId)["Owner"].Id == Player.UserId then error("Can't ban the creator of this experience.") end

	table.insert(ServerBans, Player.UserId)
	Player:Kick(Reason)
end

function Callbacks:UnBan(Player)
	local playerID = tostring(Player) 
	if not playerID or typeof(Player) ~= "string" then
		return error("Player Id is invalid, Please provide a valid user Id.")
	end

	local success, result = pcall(function()
		DataStore:UpdateAsync("BanLand", function(pastData)
			pastData = pastData or {}
			pastData[playerID] = nil 
			return pastData
		end)
	end)

	if not success then
		warn("Failed to unban:", result)
	end
end

-- @ | RBX Signals

for _, Player in pairs(game:GetService("Players"):GetPlayers()) do
	if Callbacks:IsBanned(Player.UserId) then
		local success, result = pcall(function()
			return DataStore:GetAsync("BanLand")
		end)

		if success then
			local pastData = result or {}
			local data = pastData[tostring(Player.UserId)]
			if data and data.Reason then
				Player:Kick(data.Reason)
			end
		else
			warn("Failed to get ban data during initial check:", result)
		end
	end
end

game.Players.PlayerAdded:Connect(function(Player)
	if Callbacks:IsBanned(Player.UserId) then
		local success, result = pcall(function()
			return DataStore:GetAsync("BanLand")
		end)

		if success then
			local pastData = result or {}
			local data = pastData[tostring(Player.UserId)]
			if data and data.Reason then
				Player:Kick(data.Reason)
			end
		else
			warn("Failed to get ban data on PlayerAdded:", result)
		end
	end

	if table.find(ServerBans, tonumber(Player.UserId)) then
		Player:Kick("You are banned from this server.")
	end
end)

return Meta
