-- @ | Services

local Services = shared["Nebula Infinity V 3.0"].Services

-- @ | Variables

local Callbacks, Methods, Debounces = {}, {}, {}
local Meta = setmetatable({}, Callbacks)

Callbacks.__index, Methods.__index = Callbacks, Methods

-- @ | Methods



-- @ | Callbacks

function Callbacks:create( Player : Player, Text : string )

		if Player then

			 local succ, err = pcall(function()

				local clone = Player.PlayerGui["Nebula Infinity"].UI.Popups["Notifications"].Template:Clone()

				clone.Canvas.Container.Content.Txt.Text = ""

				clone.Canvas.GroupTransparency = 1
				clone.Visible = true
				clone.Name = Text	
				clone.Parent = Player.PlayerGui["Nebula Infinity"].UI.Popups["Notifications"]

				game.TweenService:Create(clone.Canvas, TweenInfo.new(0.25), {GroupTransparency = 0}):Play()

				task.wait(.26)

				local Sound = coroutine.wrap(function()
					local sound = script.Notify:Clone()

					sound.Parent = workspace
					sound:Play()

					task.wait(sound.TimeLength)

					sound:Destroy()
				end)()

				local function typewrite(speed, Text, obj)
					local length = string.len(Text)

					for i = 1, length, 1 do
						obj.Text = string.sub(Text, 1, i)

						local char = string.sub(Text, i, i)

						if char == ";" or char == "," or char == ":" then
							task.wait(speed * 5)
						elseif char == "." or char == "!" or char == "?" then
							task.wait(speed * 10)
						else
							task.wait(speed)
						end
					end
				end

				coroutine.wrap(function()
					typewrite(0.05, Text, clone.Canvas.Container.Content.Txt)
				end)()


				clone.Canvas.Topbar.Right.Close.Hitbox.MouseButton1Click:Connect(function()
					Services.TweenService:Create(clone.Canvas, TweenInfo.new(0.25), {GroupTransparency = 1}):Play()

					task.wait(.26)
					clone:Destroy()
					return
				end)

				task.delay(25, function()
					Services.TweenService:Create(clone.Canvas, TweenInfo.new(0.25), {GroupTransparency = 1}):Play()

					task.wait(.26)
					clone:Destroy()
					return
				end)

			end)

			if not succ or err then
				warn(err)
			shared["Nebula Infinity V 3.0"].Tables["__Errors"] = err
			end
			
		end


	return succ or err
end

--

return Meta
