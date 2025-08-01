repeat task.wait() until shared["Nebula Infinity V 3.0"].Services 

local start = tick()
local time = 0

local Libary =  {

	["RankService"] = require(script.RankService.MainModule),
	["CommandService"] = require(script["Command Handler"].MainModule),	
	["Logger"] = require(script["Logger"].MainModule),	
	["RankUsers"] = require(script.RankService.RankUsers),
	["Server"] = require(script.Server.MainModule),
	["Data"] = require(script.Data.MainModule),
	["EventsHandler"] = require(script.EventsHandler.MainModule),
	["Ban Service"] = require(script["Ban Handler"].MainModule),
	["Warning Service"] = require(script["Warning Handler"].MainModule),

}

task.spawn(function()
	repeat task.wait() time = tick() - start until time >= 2
	warn("Nebula Infinity | Third Edition has loaded in ".. time .. " seconds!")
end)

game:GetService("TestService"):Message( " Nebula Infinity Third Edition has been installed correctly | Loaded Modules! " )

-- @ | Return

return Libary
