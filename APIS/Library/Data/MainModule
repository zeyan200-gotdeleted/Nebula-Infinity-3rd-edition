-- @ | Services

local Services = shared["Nebula Infinity V 3.0"].Services

-- @ | Variables

local Callbacks, Methods, PrefixStorage , Debounces = {}, {}, {}, {}
local Meta = setmetatable({}, Callbacks)

Callbacks.__index, Methods.__index = Callbacks, Methods

-- @ | Methods

function Methods:UpdateValue( valueName : (any) , newValue : (any) , player : Player )

	local DataStoreService:DataStoreService = Services.DataStoreService
	local DataStore:DataStore = DataStoreService:GetDataStore("Nebula Infinity | Third Edition")

	DataStore:UpdateAsync(valueName, function(pastData)
		pastData = pastData or {}

		pastData[player.UserId] = {

			[valueName] = newValue
		}

		return pastData
	end)

end

function Methods:ReturnValue( valueName : (any), player : Player )

	local DataStoreService:DataStoreService = Services.DataStoreService
	local DataStore:DataStore = DataStoreService:GetDataStore("Nebula Infinity | Third Edition | Settings")
	local returnedValue

	DataStore:UpdateAsync(valueName, function(pastData)
		pastData = pastData or {}
		local succ, err = pcall(function()
			returnedValue = pastData[player.UserId][valueName]
		end)
		return pastData
	end)

	if not returnedValue and valueName == "Notifications" then
		returnedValue = "Bottom"
else
		returnedValue = "Top"
end

	return returnedValue 
end

-- @ | Callbacks

shared["Nebula Infinity V 3.0"].Client.FunctionStorage.UpdateValue.Main.OnServerInvoke = function( Player, valueName, newValue )
	Methods:UpdateValue( valueName, newValue, Player )
end

shared["Nebula Infinity V 3.0"].Client.FunctionStorage.RequestValue.Main.OnServerInvoke = function( Player, valueName )
	return Methods:ReturnValue( valueName, Player )
end

return Meta
