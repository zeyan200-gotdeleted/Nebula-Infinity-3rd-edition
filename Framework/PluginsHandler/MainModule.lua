-- @ | Services

local Services = shared["Nebula Infinity V 3.0"].Services

-- @ | Variables

local Callbacks, Methods, Debounces = {}, {}, {}
local Meta = setmetatable({}, Callbacks)

Callbacks.__index, Methods.__index = Callbacks, Methods

-- @ | Methods


-- @ | Callbacks

function Callbacks.__int( file : StyleSheet )
	local self = setmetatable({}, Callbacks)

	self.File = file

	self.ProtectedRun = function( thread )
		local succ, err = pcall(function( )

			thread( )

		end)		
	end

	self["Nebula Infinity | Client"] = game.ReplicatedStorage:WaitForChild( "Nebula Infinity | Client" )
	self.AdminCount = function( ) return self["Nebula Infinity | Client"].Extras.AdminCount.Value end

	self.Logger = require( script.Parent.Parent.APIs.Library.Logger.MainModule )
	self.Notifications = require( script.Parent.Parent.APIs.Library.Notification.MainModule )

	require( script.Loader.MainModule )

	return self
end

return Meta
