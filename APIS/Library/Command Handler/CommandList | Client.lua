return {

	{
		Name = "ping",
		Description = "Identify your ping value.",

		Aliases = {  },

		Rank = {1, 2, 3, 4, 5},
		RunContext = "Client",
		Loopable = false,

		Arguments = { },

		PreFunction = function( )

		end,

		Function = function( speaker : Player, args : any ) 
			local current, result = tick(), script:FindFirstChild("Ping"):InvokeServer(); result = tick()
			local text = `Ping: {math.floor((result - current) * 1000)} ms`


			local clone = game.Players.LocalPlayer.PlayerGui["Nebula Infinity"].UI.Popups["Notifications"].Template:Clone()

			clone.Canvas.Container.Content.Txt.Text = ""

			clone.Canvas.GroupTransparency = 1
			clone.Visible = true
			clone.Name = text	
			clone.Parent = game.Players.LocalPlayer.PlayerGui["Nebula Infinity"].UI.Popups["Notifications"]

			game.TweenService:Create(clone.Canvas, TweenInfo.new(0.25), {GroupTransparency = 0}):Play()

			task.wait(.26)

			local Sound = coroutine.wrap(function()
				local sound = script.Notify:Clone()

				sound.Parent = workspace
				sound:Play()

				task.wait(sound.TimeLength)

				sound:Destroy()
			end)()

			local function typewrite(speed, text, obj)
				local length = string.len(text)

				for i = 1, length, 1 do
					obj.Text = string.sub(text, 1, i)

					local char = string.sub(text, i, i)

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
				typewrite(0.05, text, clone.Canvas.Container.Content.Txt)
			end)()


			clone.Canvas.Topbar.Right.Close.Hitbox.MouseButton1Click:Connect(function()
				game.TweenService:Create(clone.Canvas, TweenInfo.new(0.25), {GroupTransparency = 1}):Play()

				task.wait(.26)
				clone:Destroy()
				return
			end)

			clone.Canvas.Topbar.Right.Close.Hitbox.TouchTap:Connect(function()
				game.TweenService:Create(clone.Canvas, TweenInfo.new(0.25), {GroupTransparency = 1}):Play()

				task.wait(.26)
				clone:Destroy()
				return
			end)

			task.delay(25, function()
				game.TweenService:Create(clone.Canvas, TweenInfo.new(0.25), {GroupTransparency = 1}):Play()

				task.wait(.26)
				clone:Destroy()
				return
			end)
		end,

	},	

	{
		Name = "panel",
		Description = "Opens the panels main gui.",

		Aliases = {  },

		Rank = {1, 2, 3, 4, 5},
		RunContext = "Client",
		Loopable = false,

		Arguments = { },

		PreFunction = function( )

		end,

		Function = function( speaker : Player, args : any ) 
			shared["Nebula Infinity V 3.0"].Navigation.__Toggle( true )
		end,

	},

	{
		Name = "dashboard",
		Description = "Loads the dashboard page.",

		Aliases = {  },

		Rank = {1, 2, 3, 4, 5},
		RunContext = "Client",
		Loopable = false,

		Arguments = { },

		PreFunction = function( )

		end,

		Function = function( speaker : Player, args : any ) 

			shared["Nebula Infinity V 3.0"].Navigation:__ChangePage( "Dashboard", true )
			shared["Nebula Infinity V 3.0"].Navigation.__Toggle( true )
		end,

	},

	{
		Name = "settings",
		Description = "Loads the settings page.",

		Aliases = {  },

		Rank = {1, 2, 3, 4, 5},
		RunContext = "Client",
		Loopable = false,

		Arguments = { },

		PreFunction = function( )

		end,

		Function = function( speaker : Player, args : any ) 

			shared["Nebula Infinity V 3.0"].Navigation:__ChangePage( "Settings", true )
			shared["Nebula Infinity V 3.0"].Navigation.__Toggle( true )
		end,

	},

	{
		Name = "commands",
		Description = "Loads the commands page.",

		Aliases = {  },

		Rank = {1, 2, 3, 4, 5},
		RunContext = "Client",
		Loopable = false,

		Arguments = { },

		PreFunction = function( )

		end,

		Function = function( speaker : Player, args : any ) 

			shared["Nebula Infinity V 3.0"].Navigation:__ChangePage( "Commands", true )
			shared["Nebula Infinity V 3.0"].Navigation.__Toggle( true )
		end,

	},

	{
		Name = "Logs",
		Description = "Loads the Logs page.",

		Aliases = {  },

		Rank = {1, 2, 3},
		RunContext = "Client",
		Loopable = false,

		Arguments = { },

		PreFunction = function( )

		end,

		Function = function( speaker : Player, args : any ) 

			shared["Nebula Infinity V 3.0"].Navigation:__ChangePage( "Logs", true )
			shared["Nebula Infinity V 3.0"].Navigation.__Toggle( true )
		end,

	},

	{
		Name = "Manager",
		Description = "Loads the Manager page.",

		Aliases = {  },

		Rank = {1, 2, 3, 4, 5},
		RunContext = "Client",
		Loopable = false,

		Arguments = { },

		PreFunction = function( )

		end,

		Function = function( speaker : Player, args : any ) 

			shared["Nebula Infinity V 3.0"].Navigation:__ChangePage( "Manager", true )
			shared["Nebula Infinity V 3.0"].Navigation.__Toggle( true )
		end,

	},

	{
		Name = "Plugins",
		Description = "Loads the Plugins page.",

		Aliases = {  },

		Rank = {1, 2, 3, 4},
		RunContext = "Client",
		Loopable = false,

		Arguments = { },

		PreFunction = function( )

		end,

		Function = function( speaker : Player, args : any ) 

			shared["Nebula Infinity V 3.0"].Navigation:__ChangePage( "Plugins", true )
			shared["Nebula Infinity V 3.0"].Navigation.__Toggle( true )
		end,

	},

	{
		Name = "Credits",
		Description = "Loads the Credits popup.",

		Aliases = {  },

		Rank = {1, 2, 3, 4},
		RunContext = "Client",
		Loopable = false,

		Arguments = { },

		PreFunction = function( )

		end,

		Function = function( speaker : Player, args : any ) 
			shared["Nebula Infinity V 3.0"].Navigation.__Toggle( true )

			shared["Nebula Infinity V 3.0"].Events.Popup:Fire("Credits")

		end,

	},

}
