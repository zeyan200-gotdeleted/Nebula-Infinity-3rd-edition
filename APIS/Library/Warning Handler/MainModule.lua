-- @ | Variables

local DataStore = game:GetService("DataStoreService"):GetDataStore("Nebula Third Edition | Warnings")

local Callbacks, Methods, Debounces = {}, {}, {}
local Meta = setmetatable({}, Callbacks)

Callbacks.__index, Methods.__index = Callbacks, Methods

-- @ | Methods

-- @ | Callbacks


-- Player - The player to warn
-- Reason - The reason for the warning
-- Admin - The admin that gave out the warning
function Callbacks:Warn( Player : Player, Reason : string, Admin : Player)
	local success, result = pcall(function()
		DataStore:UpdateAsync("Warnings", function(pastData)

			pastData = pastData or {}
			pastData[tostring(Player.UserId) .. #pastData + 1 or 1] = {
				["UserId"] = Player.UserId, 
				["Reason"] = Reason,
				["Admin"] = Admin.UserId,
			}

			return pastData
		end)
	end)
end


-- Player - The player that you would like the list of warnings for.
function Callbacks:GetWarningsByUserId( Player : Player | number )
	local UserId 

	if typeof(Player) == "Player" or typeof(Player) == "Instance" and Player.ClassName == "Player" then
		UserId = Player.UserId
	elseif typeof(Player) == "number" then
		UserId = Player
	else	
		error(`Type of player param not supported, given {typeof(Player)}, expected Player or Number.`)
	end

	local Warnings 

	local success, result = pcall(function()
		DataStore:UpdateAsync("Warnings", function(pastData)

			pastData = pastData or {}


			Warnings = pastData
			return pastData
		end)
	end)

	return Warnings
end

-- Player - The player that you would like to clear all warnings for.
function Callbacks:ClearAllWarnings( Player : Player | number )
	local UserId 

	if typeof(Player) == "Player" then
		UserId = Player.UserId
	elseif typeof(Player) == "number" then
		UserId = Player
	else
		error(`Type of player param not supported, given {typeof(Player)}, expected Player or Number.`)
	end


	local success, result = pcall(function()
		DataStore:UpdateAsync("Warnings", function(pastData)

			pastData = {}
			return pastData
		end)
	end)

	return true	
end


-- @ | RBX Signals

shared["Nebula Infinity V 3.0"].Client.FunctionStorage.RequestWarnings.Main.OnServerInvoke = function( Player : Player, UserId : number )
	return Callbacks:GetWarningsByUserId( UserId )
end


return Meta
