-- @ | Services

local Services = shared["Nebula Infinity V 3.0"].Services

-- @ | Variables

local Callbacks, Methods, Debounces = {}, {}, {}
local Meta = setmetatable({}, Callbacks)

Callbacks.__index, Methods.__index = Callbacks, Methods

-- @ | Methods

function Methods:__( player : Player )
	local playerInfo = Services.ReplicatedStorage:WaitForChild("Nebula Infinity | Client").PlayerInfo
	
	repeat task.wait() until player.UserId
	
	if Services.ReplicatedStorage:WaitForChild("Nebula Infinity | Client").PlayerInfo:FindFirstChild(player.Name) then return end	
	
	local newValue = Instance.new("IntValue", playerInfo)
	
	newValue.Name = player.Name
	
	local prefix
	
	newValue:SetAttribute("IsVerified", player:IsVerified())
	
	game.DataStoreService:GetDataStore("Nebula Infinity | Third Edition Prefixes"):UpdateAsync("Prefixs", function(pastData)
		pastData = pastData
		prefix = pastData[player.UserId] or "!"
		
		if not pastData[player.UserId] then
			pastData[player.UserId] = "!"
		end
		
		return pastData
	end)
	
	newValue:SetAttribute( "Prefix", prefix )
	
	Services.Players.PlayerRemoving:Connect(function(p)
		if p.UserId == player.UserId then
			newValue:Destroy()
		end
	end)
	
end

-- @ | Callbacks


for _, player in pairs(Services.Players:GetPlayers()) do Methods:__( player ) end

Services.Players.PlayerAdded:Connect(function(player)
	Methods:__( player )

	task.wait(2.5)
	
	Methods:__( player )
end)



return Meta
