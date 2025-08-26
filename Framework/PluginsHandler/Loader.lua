--@strict
local PluginTypes = require(script.Parent.PluginTypes)
local CoreTypes = require(script.Parent.CoreTypes)

local PluginsManager = {}
PluginsManager.__index = PluginsManager

function PluginsManager.new(core: CoreTypes.Core)
	local self = setmetatable({}, PluginsManager)
	self.Core = core
	self.Plugins = {}

	local DataStoreService = game:GetService("DataStoreService")
	self.Store = DataStoreService:GetDataStore("Nebula_Plugins_V2")

	game.Players.PlayerAdded:Connect(function(player)
		self:LoadInstalledPlugins(player)
	end)

	for _, player in ipairs(game.Players:GetPlayers()) do
		self:LoadInstalledPlugins(player)
	end

	game:BindToClose(function()
		for _, player in pairs(game.Players:GetPlayers()) do
			self:SavePlugins(player)
		end
	end)

	return self
end

function PluginsManager:LoadInstalledPlugins(player: Player)
	local userId = player.UserId
	local success, pastData = pcall(function()
		return self.Store:GetAsync(userId)
	end)
	if not success then pastData = {} end

	self.Plugins[userId] = pastData or {}

	for _, Plugin in ipairs(script.Plugins:GetChildren()) do
		if self.Plugins[userId][Plugin.Name] then
			self:LoadPlugin(Plugin, player)
		end
	end
end

function PluginsManager:SavePlugins(player: Player)
	local userId = player.UserId
	local data = self.Plugins[userId] or {}

	local success, err = pcall(function()
		self.Store:UpdateAsync(userId, function(PastData)
			return data
		end)
	end)
	if not success then
		warn("Failed to save plugins for", player.Name, ": ", err)
	end
end

function PluginsManager:InstallPlugin(player: Player, PluginName: string)
	local userId = player.UserId
	self.Plugins[userId] = self.Plugins[userId] or {}
	self.Plugins[userId][PluginName] = true
	self:SavePlugins(player)

	local Plugin = script.Plugins:FindFirstChild(PluginName)
	if Plugin then
		self:LoadPlugin(Plugin, player)
	end
end

function PluginsManager:LoadPlugin(Plugin: ModuleScript, player: Player)
	if not Plugin:FindFirstChild("MainModule") then
		warn("No MainModule found for Plugin:", Plugin.Name)
		return
	end

	local success, mod: PluginTypes.PluginModule = pcall(require, Plugin.MainModule)
	if success and mod.__init then
		mod:__init(self.Core, player)
	else
		warn("Failed to require Plugin:", Plugin.Name, mod)
	end
end

return PluginsManager
