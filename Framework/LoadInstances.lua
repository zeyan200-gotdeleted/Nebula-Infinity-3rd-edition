-- @ | Variables

local Callbacks, Methods, Debounces = {}, {}, {}
local Meta = setmetatable({}, Callbacks)

Callbacks.__index, Methods.__index = Callbacks, Methods

-- @ | Methods

local __ = coroutine.wrap(function()
	for _,location in pairs(script.Assets:GetChildren()) do
		for x, item in pairs(location:GetChildren()) do

			item.Parent = game:FindFirstChild(location.Name)

			if item:IsA("ModuleScript") then
				local succ, err = pcall(function()

					require(item)

				end)

				if not succ and shared["Nebula Infinity V 3.0"].Tables["__Errors"] then
					shared["Nebula Infinity V 3.0"].Tables["__Errors"] = err
					warn(err)
				end
			end
		end
	end
end)()	

-- @ | Callbacks


return Meta
