--@strict
local CoreTypes = require(script.Loader.CoreTypes)
local PluginsManager = require(script.Loader.MainModule)

local Core = {}
Core.__index = Core

function Core.new(file: Instance): CoreTypes.Core
	local self = setmetatable({}, Core)

	self.File = file
	self.Client = game.ReplicatedStorage:WaitForChild("Nebula Infinity | Client")
	self.Logger = require(script.Parent.Parent.APIs.Library.Logger.MainModule)
	self.Notifications = require(script.Parent.Parent.APIs.Library.Notification.MainModule)
	self.Server = require(script.Parent.Parent.APIs.Library.Server.MainModule)
	self.Data = require(script.Parent.Parent.APIs.Library.Data.MainModule)
	self.BanHandler = require(script.Parent.Parent.APIs.Library[`Ban Handler`].MainModule)
	self.WarningHandler = require(script.Parent.Parent.APIs.Library[`Warning Handler`].MainModule)

	self.ProtectedRun = function(thread)
		local success, err = pcall(thread)
		if not success then
			warn("[Core Protected Run Error]:", err)
		end
	end

	function self:AdminCount()
		return self.Client.Extras.AdminCount.Value
	end

	self.PluginsManager = PluginsManager.new(self)

	shared["Nebula Infinity V 3.0"].Client.FunctionStorage.RequestPlugins.Main.OnServerInvoke = function()
		local tb = {}
		for _, Plugin in pairs(script.Loader.MainModule.Plugins:GetChildren()) do
			tb[Plugin.Name] = {
				Icon = Plugin.Config.Icon:GetAttribute("ImageId"),
				Name = Plugin.Name,
				Description = Plugin.Config.Description:GetAttribute("Description"),
				Creator = Plugin.Config.Creator:GetAttribute("Creator"),
			}
		end
		return tb
	end

	shared["Nebula Infinity V 3.0"].Client.FunctionStorage.InstallPlugin.Main.OnServerInvoke = function(Player, PluginName)
		self.PluginsManager:InstallPlugin(Player, PluginName)
	end

	return self
end

return Core
