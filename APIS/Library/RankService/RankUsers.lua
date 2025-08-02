
-- @ | Services

local Services = shared["Nebula Infinity V 3.0"].Services 

-- @ | Variables

local Callbacks, Methods, Debounces = {}, {}, {}
local Meta = setmetatable({}, Callbacks)

Callbacks.__index, Methods.__index = Callbacks, Methods

-- @ | Methods

function Methods:GetRank( player : Player )
	local Admins = shared["Nebula Infinity V 3.0"].Settings

	for index, rank in pairs(Admins["Administrators"]) do
		if table.find(rank, player.UserId) then
			return index
		end
	end

	if game.CreatorType == Enum.CreatorType.User and player.UserId == game.CreatorId then
		return "Owner"
	elseif game.CreatorType == Enum.CreatorType.Group and game.GroupService:GetGroupInfoAsync(game.CreatorId)["Id"] == game.CreatorId then
		return "Owner"
	end

	return "None"
end

function Methods:__(player)
	local Rank = Methods:GetRank(player)

	if Rank == "None" or Rank == nil then return end

	require(script.Parent.MainModule):RankUserAsync(player, Rank)
end

-- @ | Callbacks

for _, player in pairs(Services.Players:GetPlayers()) do Methods:__(player) end

Services.Players.PlayerAdded:Connect(function(player)
	Methods:__(player)

	task.wait(2.5)

	Methods:__(player)
end)

return Meta
