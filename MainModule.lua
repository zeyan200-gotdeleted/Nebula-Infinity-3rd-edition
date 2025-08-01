return function( file : StyleSheet ) 


	shared["Nebula Infinity V 3.0"] = {}

	shared["Nebula Infinity V 3.0"].File = file
	shared["Nebula Infinity V 3.0"].Settings = require( file:FindFirstChild("Settings") )
	shared["Nebula Infinity V 3.0"].Storage, shared["Nebula Infinity V 3.0"].Tables = {}, {}

	-- Failsafe initiation

	warn(shared["Nebula Infinity V 3.0"])

	local failed = require(script.APIs.FailSafe).init( file )

	if not failed then

		-- Load instances initiation

		require( script.Framework.LoadInstances ) 
		
		task.wait(0.5)
		
		shared["Nebula Infinity V 3.0"].Client = game:GetService("ReplicatedStorage"):WaitForChild("Nebula Infinity | Client")


		shared["Nebula Infinity V 3.0"].Services = require( script.APIs.Services )		
		shared["Nebula Infinity V 3.0"].Library = require( script.APIs.Library )  
		shared["Nebula Infinity V 3.0"].Plugins = require( script.Framework.PluginsHandler ).__int( file )
		
	end

end
