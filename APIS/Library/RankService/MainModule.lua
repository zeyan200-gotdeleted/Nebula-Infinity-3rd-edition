-- @ | Services

local Services = shared["Nebula Infinity V 3.0"].Services

-- @ | Variables

local Callbacks, Methods, PrefixStorage, Debounces, RankCache = {}, {}, {}, {}, {}
local Meta = setmetatable({}, Callbacks)
local CustomRanks = require(shared["Nebula Infinity V 3.0"].File.Ranks.Customs)
local Settings = require(script.Parent.Parent.Parent.Parent.Parent.Parent.Parent.Settings)

Callbacks.__index, Methods.__index = Callbacks, Methods

-- @ | Constants

local DATASTORE_RETRY_ATTEMPTS = 3
local DATASTORE_RETRY_DELAY = 1
local RANK_HIERARCHY = {
	["Owner"] = 1,
	["Head Admin"] = 2,
	["Admin"] = 3,
	["Moderator"] = 4,
	["VIP"] = 5,
	["None"] = 999
}

-- @ | Types

export type rank = {
	Administrator: boolean,
	Name: string,
	Id: number,
	Pages: {},
}

export type rankName = string
export type rankId = number

-- @ | Security / Validation Functions

local function IsValidPlayer(player)
	return typeof(player) == "Instance" and player:IsA("Player") and player.Parent == Services.Players
end

local function IsValidRankName(rankName)
	if typeof(rankName) ~= "string" then return false end

	if Settings.Administrators[rankName] then return true end

	for _, v in pairs(CustomRanks) do
		if v.Name == rankName then return true end
	end

	return false
end

local function SanitizeUserId(userId)
	if typeof(userId) == "number" and userId > 0 and userId <= 9999999999 then
		return userId
	end
	return nil
end

local function SafeDataStoreCall(callback, attempts)
	attempts = attempts or DATASTORE_RETRY_ATTEMPTS

	for i = 1, attempts do
		local success, result = pcall(callback)

		if success then
			return true, result
		else
			warn(`[Rank System] DataStore error (Attempt {i}/{attempts}): {result}`)

			if i < attempts then
				task.wait(DATASTORE_RETRY_DELAY * i)
			end
		end
	end

	return false, nil
end


function Methods:GetHighestRankFromGroups(player: Player): (string?, number?)
	if not IsValidPlayer(player) then return nil, nil end

	local highestRank = nil
	local highestPriority = 999

	for groupId, ranks in pairs(Settings.Groups) do
		local success, groupRank = pcall(function()
			return player:GetRankInGroupAssociated(groupId)
		end)

		if success and groupRank and groupRank > 0 then
			-- Check if this specific rank is mapped
			if ranks[groupRank] then
				local rankName = ranks[groupRank]
				local priority = RANK_HIERARCHY[rankName] or 999

				if priority < highestPriority then
					highestRank = rankName
					highestPriority = priority
				end
			end
		end
	end

	return highestRank, highestPriority
end

function Methods:GetRankFromGamepasses(player: Player): (string?, number?)
	if not IsValidPlayer(player) then return nil, nil end

	local highestRank = nil
	local highestPriority = 999

	for gamepassId, rankName in pairs(Settings.Gamepasses) do
		local success, ownsPass = pcall(function()
			return Services.MarketplaceService:UserOwnsGamePassAsync(player.UserId, gamepassId)
		end)

		if success and ownsPass then
			local priority = RANK_HIERARCHY[rankName] or 999

			if priority < highestPriority then
				highestRank = rankName
				highestPriority = priority
			end
		end
	end

	return highestRank, highestPriority
end

function Methods:GetRankFromAdminList(player: Player): (string?, number?)
	if not IsValidPlayer(player) then return nil, nil end

	for rankName, userIds in pairs(Settings.Administrators) do
		if table.find(userIds, player.UserId) then
			local priority = RANK_HIERARCHY[rankName] or 999
			return rankName, priority
		end
	end

	return nil, nil
end

function Methods:DeterminePlayerRank(player: Player): string
	if not IsValidPlayer(player) then return "None" end

	local cached = RankCache[player.UserId]
	if cached and (os.clock() - cached.timestamp) < 30 then
		return cached.rank
	end

	local highestRank = "None"
	local highestPriority = 999

	if game.CreatorType == Enum.CreatorType.User and player.UserId == game.CreatorId then
		return "Owner"
	elseif game.CreatorType == Enum.CreatorType.Group then
		local success, groupInfo = pcall(function()
			return Services.GroupService:GetGroupInfoAsync(game.CreatorId)
		end)

		if success and groupInfo and groupInfo.Owner and groupInfo.Owner.Id == player.UserId then
			return "Owner"
		end
	end

	local listRank, listPriority = Methods:GetRankFromAdminList(player)
	if listRank and listPriority < highestPriority then
		highestRank = listRank
		highestPriority = listPriority
	end

	local groupRank, groupPriority = Methods:GetHighestRankFromGroups(player)
	if groupRank and groupPriority < highestPriority then
		highestRank = groupRank
		highestPriority = groupPriority
	end

	local passRank, passPriority = Methods:GetRankFromGamepasses(player)
	if passRank and passPriority < highestPriority then
		highestRank = passRank
		highestPriority = passPriority
	end

	RankCache[player.UserId] = {
		rank = highestRank,
		timestamp = os.clock()
	}

	return highestRank
end

-- @ | DataStore Methods

function Methods:UpdateRankedData(rankName: rankName, rankId: rankId, player: Player)
	if not IsValidPlayer(player) then return false end
	if not IsValidRankName(rankName) then return false end

	local sanitizedUserId = SanitizeUserId(player.UserId)
	if not sanitizedUserId then return false end

	local success, _ = SafeDataStoreCall(function()
		local DataStoreService = Services.DataStoreService
		local RankDataStore = DataStoreService:GetDataStore("Nebula Infinity | Third Edition Ranks")

		RankDataStore:UpdateAsync("Ranks", function(pastData)
			pastData = pastData or {}

			pastData[sanitizedUserId] = {
				["RankName"] = rankName,
				["RankId"] = rankId,
				["LastUpdated"] = os.time()
			}

			return pastData
		end)
	end)

	if not success then
		warn(`[Rank System] Failed to save rank data for {player.Name}`)
		return false
	end

	local timeout = 0
	repeat 
		task.wait(0.1)
		timeout += 0.1
	until shared["Nebula Infinity V 3.0"].Client.PlayerInfo:FindFirstChild(player.Name) or timeout > 5

	task.wait(0.5)

	local prefixSuccess, _ = SafeDataStoreCall(function()
		local DataStoreService = Services.DataStoreService
		local PrefixDataStore = DataStoreService:GetDataStore("Nebula Infinity | Third Edition Prefixes")

		PrefixDataStore:UpdateAsync("Prefixs", function(pastData)
			pastData = pastData or {}

			local playerInfo = shared["Nebula Infinity V 3.0"].Client.PlayerInfo:FindFirstChild(player.Name)
			local prefix = playerInfo and playerInfo:GetAttribute("Prefix") or "!"

			pastData[sanitizedUserId] = {
				["Prefix"] = prefix,
			}

			return pastData
		end)
	end)

	if IsValidPlayer(player) then
		local playerInfo = shared["Nebula Infinity V 3.0"].Client.PlayerInfo:FindFirstChild(player.Name)
		local prefix = playerInfo and playerInfo:GetAttribute("Prefix") or "!"
		player:SetAttribute("Prefix", prefix)
	end

	return success and prefixSuccess
end

function Methods:LoadPlayerRankData(player: Player): (string?, number?)
	if not IsValidPlayer(player) then return nil, nil end

	local sanitizedUserId = SanitizeUserId(player.UserId)
	if not sanitizedUserId then return nil, nil end

	local rankName, rankId = nil, nil

	SafeDataStoreCall(function()
		local DataStoreService = Services.DataStoreService
		local RankDataStore = DataStoreService:GetDataStore("Nebula Infinity | Third Edition Ranks")

		local data = RankDataStore:GetAsync("Ranks")

		if data and data[sanitizedUserId] then
			rankName = data[sanitizedUserId]["RankName"]
			rankId = data[sanitizedUserId]["RankId"]
		end
	end)

	return rankName, rankId
end

-- @ | Callback Methods

function Callbacks:RankUserAsync(player: Player, rankName: rankName)
	if not IsValidPlayer(player) then 
		warn("[Rank System] Invalid player provided to RankUserAsync")
		return 
	end

	if not IsValidRankName(rankName) then
		warn(`[Rank System] Invalid rank name: {rankName}`)
		return
	end

	local debounceKey = `rank_{player.UserId}`
	if Debounces[debounceKey] then
		return
	end
	Debounces[debounceKey] = true

	local Preset = require(script["Pre-Set"])

	for i, v in pairs(CustomRanks) do
		Preset[v.Name] = v
	end

	if Preset[rankName] then
		Preset = Preset[rankName]

		player:SetAttribute("Rank", rankName)
		player:SetAttribute("RankId", Preset["Id"])

		if not player.PlayerGui:FindFirstChild("Nebula Infinity") then
			local UI

			local isMobile = false
			local success, result = pcall(function()
				return shared["Nebula Infinity V 3.0"].Client.FunctionStorage.RequestDevice.Main:InvokeClient(player)
			end)

			if success then
				isMobile = result
			end

			if isMobile then
				UI = script.Parent.Parent.Parent.Parent.Interface["Nebula Infinity // Mobile"]:Clone()
			else
				UI = script.Parent.Parent.Parent.Parent.Interface["Nebula Infinity // PC"]:Clone()
			end

			UI.Parent = player.PlayerGui
			UI.Name = "Nebula Infinity"
			UI.Config.Main.Enabled = true

			shared["Nebula Infinity V 3.0"].Client.Extras.AdminCount.Value += 1

			if not Settings.Customs.Interactable then
				pcall(function()
					UI.Config.Main.MainModule.Events.Interactable:FireClient(player)
				end)
			end

			Methods:UpdateRankedData(rankName, Preset["Id"], player)

			task.delay(2.5, function()
				if IsValidPlayer(player) then
					pcall(function()
						shared["Nebula Infinity V 3.0"].Client.EventStorage.Notification:FireClient(
							player, 
							`You have been ranked as {rankName}! Press "N" or type "!panel" in chat to open the panel.`
						)
					end)
				end
			end)
		end
	end

	task.delay(1, function()
		Debounces[debounceKey] = nil
	end)
end

function Callbacks:GetRankByUserId(Player: Player | number): number?
	local RankId = nil
	local userId = nil

	if typeof(Player) == "number" then
		userId = SanitizeUserId(Player)

		if not userId then return nil end

		SafeDataStoreCall(function()
			local DataStoreService = Services.DataStoreService
			local RankDataStore = DataStoreService:GetDataStore("Nebula Infinity | Third Edition Ranks")

			local data = RankDataStore:GetAsync("Ranks")

			if data and data[userId] then
				RankId = data[userId]["RankId"]
			end
		end)
	else
		if IsValidPlayer(Player) then
			RankId = Player:GetAttribute("RankId")
		end
	end

	return RankId
end

function Callbacks:InvalidateRankCache(player: Player)
	if not IsValidPlayer(player) then return end
	RankCache[player.UserId] = nil
end


local function OnPlayerAdded(player: Player)
	if not IsValidPlayer(player) then return end

	local rank = Methods:DeterminePlayerRank(player)

	if rank and rank ~= "None" then
		Callbacks:RankUserAsync(player, rank)
	end

	task.delay(2.5, function()
		if IsValidPlayer(player) then
			Callbacks:InvalidateRankCache(player)
			local newRank = Methods:DeterminePlayerRank(player)

			if newRank and newRank ~= "None" and newRank ~= player:GetAttribute("Rank") then
				Callbacks:RankUserAsync(player, newRank)
			end
		end
	end)
end

local function OnPlayerRemoving(player: Player)
	if not IsValidPlayer(player) then return end

	local sanitizedUserId = SanitizeUserId(player.UserId)
	if not sanitizedUserId then return end

	SafeDataStoreCall(function()
		local DataStoreService = Services.DataStoreService
		local RankDataStore = DataStoreService:GetDataStore("Nebula Infinity | Third Edition Ranks")

		RankDataStore:UpdateAsync("Ranks", function(pastData)
			pastData = pastData or {}

			pastData[sanitizedUserId] = {
				["RankName"] = player:GetAttribute("Rank"),
				["RankId"] = player:GetAttribute("RankId"),
				["LastUpdated"] = os.time()
			}

			return pastData
		end)
	end)

	task.wait(0.2)

	SafeDataStoreCall(function()
		local DataStoreService = Services.DataStoreService
		local PrefixDataStore = DataStoreService:GetDataStore("Nebula Infinity | Third Edition Prefixes")

		PrefixDataStore:UpdateAsync("Prefixs", function(pastData)
			pastData = pastData or {}

			pastData[sanitizedUserId] = {
				["Prefix"] = PrefixStorage[sanitizedUserId] 
					or shared["Nebula Infinity V 3.0"].File:GetAttribute("Prefix") 
					or "!",
			}

			return pastData
		end)
	end)

	PrefixStorage[sanitizedUserId] = nil
	RankCache[sanitizedUserId] = nil
end

for _, player in pairs(Services.Players:GetPlayers()) do
	task.spawn(OnPlayerAdded, player)
end

Services.Players.PlayerAdded:Connect(OnPlayerAdded)
Services.Players.PlayerRemoving:Connect(OnPlayerRemoving)

game:BindToClose(function()
	if game:GetService("RunService"):IsStudio() then return end

	for _, player in pairs(Services.Players:GetPlayers()) do
		task.spawn(OnPlayerRemoving, player)
	end

	task.wait(2)
end)

return Meta
