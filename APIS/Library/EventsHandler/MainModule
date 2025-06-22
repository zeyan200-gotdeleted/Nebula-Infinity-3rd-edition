-- @ | Services

local Services = shared["Nebula Infinity V 3.0"].Services

-- @ | Variables

local Callbacks, Methods, Debounces = {}, {}, {}
local Meta = setmetatable({}, Callbacks)

Callbacks.__index, Methods.__index = Callbacks, Methods

-- @ | Methods



-- @ | Callbacks

shared["Nebula Infinity V 3.0"].Client.EventStorage.UpdateLeaderstat.OnServerEvent:Connect(function( player, Player ,ButtonName, NewValue )		
		local Leaderstats = Player:FindFirstChild("leaderstats")
		
		if Leaderstats and Leaderstats:FindFirstChild(ButtonName) then
			Leaderstats:FindFirstChild(ButtonName).Value = NewValue
		end
end)

return Meta
