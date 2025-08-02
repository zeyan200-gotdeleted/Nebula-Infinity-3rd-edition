-- @ | Services

local Services = shared["Nebula Infinity V 3.0"].Services

-- @ | Variables

local Callbacks, Methods, Debounces = {}, {}, {}
local Meta = setmetatable({}, Callbacks)

Callbacks.__index, Methods.__index = Callbacks, Methods

-- @ | Methods

if not shared["Nebula Infinity V 3.0"].Tables["__Logs"] then
	shared["Nebula Infinity V 3.0"].Tables["__Logs"] = {}
end

-- @ | Callbacks

function Callbacks:newLog( action : any, system : boolean, extra : ( any )  ) 
	local succ, err = pcall(function()
		if not system then

			shared["Nebula Infinity V 3.0"].Client.EventStorage.UserLog:FireClient( false,extra["User"], action, extra )

		else

			shared["Nebula Infinity V 3.0"].Client.EventStorage.UserLog:FireAllClients( true ,action, extra ) 

		end

		table.insert( shared["Nebula Infinity V 3.0"].Tables["__Logs"], {

			Action = action,
			System = system,
			User = extra.User or nil,
			Date = os.date("%X"),

			Message = extra["Message"],
			Extra = extra,


		} )
		
	end)

	if not succ	then
		shared["Nebula Infinity V 3.0"].Tables["__Errors"] = err
		
		Callbacks:newLog("Error", true, {Message = err})
	end

	return succ or err
end

-- @ | RBX Signals

shared["Nebula Infinity V 3.0"].Client.EventStorage.newLog.Event:Connect(Callbacks.newLog)

shared["Nebula Infinity V 3.0"].Client.FunctionStorage.RequestLogs.Main.OnServerInvoke = function()
	return shared["Nebula Infinity V 3.0"].Tables["__Logs"] or {}
end

--
require(script.Player)

--

return Meta
