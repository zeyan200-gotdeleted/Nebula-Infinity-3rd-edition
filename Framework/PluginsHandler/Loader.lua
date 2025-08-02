-- @ | Services

local Services = shared["Nebula Infinity V 3.0"].Services

-- @ | Variables

local DataStoreService = Services.DataStoreService
local DataStore = DataStoreService:GetDataStore( "Plugins" )
local Plugins = {}

local Callbacks, Methods , Debounces = {}, {}, {}
local Meta = setmetatable({}, Callbacks)

Callbacks.__index, Methods.__index = Callbacks, Methods

-- @ | Methods

function Methods:LoadInstalledPlugins( Player : Player )

	DataStore:UpdateAsync( Player.UserId, function( pastData : (any) ) 
		pastData = pastData or {}

		Plugins[Player.UserId] = pastData

		return pastData
	end)	

	for _, Plugin in pairs( script.Plugins:GetChildren() ) do
		if Plugins[ Player.UserId ][ Plugin.Name ] then
			Callbacks:LoadPlugin( Plugin, Player )
		end
	end

end

-- @ | Callbacks

function Callbacks:LoadPlugin( Plugin : StyleSheet, Player )

	if Plugin:FindFirstChild("MainModule") then
		require(Plugin:FindFirstChild("MainModule")):__init( self, Player )
	end

end

-- @ | RBX Signals

shared["Nebula Infinity V 3.0"].Client.FunctionStorage.InstallPlugin.Main.OnServerInvoke = function( player, PluginName )
	DataStore:UpdateAsync( player.UserId, function( pastData : (any) ) 
		pastData = pastData or {}

		pastData[PluginName] = true

		return pastData
	end)	

	Callbacks:LoadPlugin( script.Plugins:FindFirstChild( PluginName ), player )
end

shared["Nebula Infinity V 3.0"].Client.FunctionStorage.RequestPlugins.Main.OnServerInvoke = function(  )	
	local tb = {}

	for _, Plugin in pairs(script.Plugins:GetChildren()) do
		tb[Plugin.Name] = {

			["Icon"] = Plugin.Config.Icon:GetAttribute( "ImageId" ),
			["Name"] = Plugin.Name,
			["Description"] = Plugin.Config.Description:GetAttribute( "Description" ),
			["Creator"] = Plugin.Config.Creator:GetAttribute( "Creator" ),

		}
	end

	return tb
end

game:BindToClose(function()
	for _, player in pairs(game.Players:GetPlayers()) do
		DataStore:UpdateAsync( player.UserId, function( pastData : (any) ) 
			pastData = pastData or {}

			pastData = Plugins[player.UserId]

			return pastData
		end)	
	end
end)	

game.Players.PlayerAdded:Connect(function( Player )
	Methods:LoadInstalledPlugins( Player )
end)

for _, player in pairs(game.Players:GetPlayers()) do Methods:LoadInstalledPlugins( player ) end

return Meta
