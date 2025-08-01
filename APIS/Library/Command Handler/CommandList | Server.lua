
local accessoryTypes = {
	[8] = "HatAccessory",
	[41] = "HairAccessory",
	[42] = "FaceAccessory",
	[43] = "NeckAccessory",
	[44] = "ShouldersAccessory",
	[45] = "FrontAccessory",
	[46] = "BackAccessory",
	[47] = "WaistAccessory",
}

function ChangeProperty(plr, propertyName, propertyValue)
	local humanoid = plr.Character.Humanoid
	if humanoid then
		local desc = humanoid:GetAppliedDescription()
		desc[propertyName] = propertyValue
		pcall(function() humanoid:ApplyDescription(desc) end)
	end
end

function AddAccessory(plr, accessoryId)
	local humanoid = plr.Character.Humanoid
	if humanoid then
		local info = game.MarketplaceService:GetProductInfo(accessoryId)

		if info.AssetTypeId then
			local propertyName = accessoryTypes[info.AssetTypeId]
			if propertyName and info.AssetTypeId then
				local desc = humanoid:GetAppliedDescription()
				desc[propertyName] = desc[propertyName]..","..accessoryId
				pcall(function() humanoid:ApplyDescription(desc) end)
			end
		end
	end
end

function ClearAccessories(plr)
	local humanoid = plr.Character.Humanoid
	if humanoid then
		local desc = humanoid:GetAppliedDescription()
		for i,v in pairs(accessoryTypes) do
			desc[v] = ""
		end
		desc.HatAccessory = ""
		pcall(function() humanoid:ApplyDescription(desc) end)
	end
end

function ConvertToRig(plr, rigType)
	local humanoid = plr.Character.Humanoid
	local head = plr.Character.Head
	if humanoid and head then
		local newRig = script["Command Assets"]["Rig"..rigType]:Clone()
		local newHumanoid = newRig.Humanoid
		local originalCFrame = head.CFrame
		newRig.Name = plr.Name
		for a,b in pairs(plr.Character:GetChildren()) do
			if b:IsA("Accessory") or b:IsA("Pants") or b:IsA("Shirt") or b:IsA("ShirtGraphic") or b:IsA("BodyColors") then
				b.Parent = newRig
			elseif b.Name == "Head" and b:FindFirstChild("face") then
				newRig.Head.face.Texture = b.face.Texture
			end
		end
		plr.Character = newRig
		newRig.Parent = workspace
		newRig.Head.CFrame = originalCFrame
		local desc = game:GetService("Players"):GetHumanoidDescriptionFromUserId(plr.UserId)
		newHumanoid:ApplyDescription(desc)
	end
end

return {

	-- @ | Moderation

	{
		Name = "kick",
		Description = "Kicks the provided player.",

		Aliases = {  },

		Rank = {1, 2, 3, 4},
		RunContext = "Server",
		Loopable = false,

		Arguments = { "Player", "Reason" },

		PreFunction = function( )

		end,

		Function = function( speaker : Player, args : any ) 

			args[1]:Kick( args[2] or "You were kicked from this experience." )

		end,

	},

	{
		Name = "ban",
		Description = "Activates the ban ui.",

		Aliases = { },

		Rank = {1, 2, 3},
		RunContext = "Server",
		Loopable = false,

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker : Player, args : any ) 
			local Player = args[1]

			if not Player or not Player:IsA("Player") or speaker == Player then return end

			require( script["Built-In"].BanUI ).SetUp( speaker, Player )

		end,

	},

	{
		Name = "permban",
		Description = "Bans the provided player.",

		Aliases = { "pban" },

		Rank = {1, 2, 3},
		RunContext = "Server",
		Loopable = false,

		Arguments = { "Player", "Reason" },

		PreFunction = function( )

		end,

		Function = function( speaker : Player, args : any ) 
			local Player = args[1] or speaker

			if speaker == Player then return end

			local reason = table.concat(args," ", 2) or "You were banned from this game."

			shared["Nebula Infinity V 3.0"].Library["Ban Service"]:PermBan( Player, reason )

		end,

	},

	{
		Name = "serverban",
		Description = "Bans the provided player from a specific server.",

		Aliases = { "sban" },

		Rank = {1, 2, 3},
		RunContext = "Server",
		Loopable = false,

		Arguments = { "Player", "Reason" },

		PreFunction = function( )

		end,

		Function = function( speaker : Player, args : any ) 
			local Player = args[1] or speaker	

			if speaker == Player then return end

			local reason = table.concat(args," ", 2) or "You were banned from this game."

			shared["Nebula Infinity V 3.0"].Library["Ban Service"]:ServerBan( Player, reason )

		end,

	},

	{
		Name = "timeban",
		Description = "Temporarily bans the provided player for a set duration.",

		Aliases = { "tban", "tempban" },

		Rank = {1, 2, 3},
		RunContext = "Server",
		Loopable = false,

		Arguments = { "Player", "Duration", "Reason" },

		PreFunction = function( )

		end,

		Function = function(speaker: Player, args: any)
			local Player = args[1] or speaker

			if speaker == Player then return end

			local durationStr = args[2]
			local reason = table.concat(args, " ", 3) or "You were temporarily banned from this game."

			local function parseDuration(duration)
				local num, unit = duration:match("^(%d+)([smhd])$")
				num = tonumber(num)

				if not num then return nil end

				local multipliers = {
					s = 1,       
					m = 60,      
					h = 3600,   
					d = 86400     
				}

				return num * (multipliers[unit] or 0)
			end

			local duration = parseDuration(durationStr)

			if not duration or duration <= 0 then
				return warn("Invalid duration format. Use s/m/h/d (e.g., '30m' for 30 minutes).")
			end

			shared["Nebula Infinity V 3.0"].Library["Ban Service"]:TimeBan(Player, reason, duration)
		end,
	},

	{
		Name = "warn",
		Description = "Gives the provided user a warning.",

		Aliases = { "w" },

		Rank = {1, 2, 3},
		RunContext = "Server",
		Loopable = false,

		Arguments = { "Player", "Reason" },

		PreFunction = function( )

		end,

		Function = function(speaker: Player, args: any)
			local Player = args[1] or speaker
			local Reason = args[2]
			

			shared["Nebula Infinity V 3.0"].Library["Warning Service"]:Warn( Player, Reason , speaker)
		end,
	},

	{
		Name = "viewwarnings",
		Description = "View the provided user a warnings",

		Aliases = { "vw" },

		Rank = {1, 2, 3},
		RunContext = "Server",
		Loopable = false,

		Arguments = { "Player", "Reason" },

		PreFunction = function( )

		end,

		Function = function(speaker: Player, args: any)
			local Player = args[1] or speaker

			shared["Nebula Infinity V 3.0"].Client.FunctionStorage.Warnings.Main:InvokeClient( speaker, Player )

		
		end,
	},

	{
		Name = "clearallwarnings",
		Description = "Clear the provided user of all warnings",

		Aliases = { "cw" },

		Rank = {1, 2, 3},
		RunContext = "Server",
		Loopable = false,

		Arguments = { "Player", "Reason" },

		PreFunction = function( )

		end,

		Function = function(speaker: Player, args: any)
			local Player = args[1] or speaker

if Player == speaker then return error( `You cannot clear your own warnings!` ) end 

			shared["Nebula Infinity V 3.0"].Library["Warning Service"]:ClearAllWarnings( Player )
		end,
	},

	{
		Name = "unban",
		Description = "Unbans the provided player.",

		Aliases = { "removeban" },

		Rank = {1, 2, 3},
		RunContext = "Server",
		Loopable = false,

		Arguments = { "User" },

		PreFunction = function( )

		end,

		Function = function( speaker : Player, args : any ) 
			local Player = args[1] or speaker		

			shared["Nebula Infinity V 3.0"].Library["Ban Service"]:UnBan( Player )
		end,

	},

	{
		Name = "announce",
		Description = "Displays a message to everyone in the current server.",

		Aliases = { "message" },

		Rank = {1, 2, 3},
		RunContext = "Server",
		Loopable = false,

		Arguments = { "Message" },

		PreFunction = function( )

		end,

		Function = function( speaker : Player, args : any ) 
			local Player = speaker
			local message = table.concat(args, " ", 1)

			local filtered = nil

			local suc, errorMessage = pcall(function()
				filtered = game.Chat:FilterStringForBroadcast(message, speaker)
			end)			


			if not suc then filtered = message end

			if filtered == nil then return end

			message = filtered

			shared["Nebula Infinity V 3.0"].Library.Server:Announce( Player, message )

		end,

	},

	{
		Name = "gannounce",
		Description = "Displays a message to everyone all active servers.",

		Aliases = { "globalannounce", "universalannounce" },

		Rank = {1, 2, 3},
		RunContext = "Server",
		Loopable = false,

		Arguments = { "Message" },

		PreFunction = function( )

		end,

		Function = function( speaker : Player, args : any ) 

			local Player = speaker
			local message = table.concat(args, " ", 1)

			local filtered = nil

			local suc, errorMessage = pcall(function()
				filtered = game.Chat:FilterStringForBroadcast(message, speaker)
			end)			


			if not suc then filtered = message end

			if filtered == nil then return end

			message = filtered

			shared["Nebula Infinity V 3.0"].Library.Server:UniversalAnnounce( Player, message )

		end,

	},

	-- @ | Misc

	{
		Name = "refresh",
		Description = "Respawns player on last known position.",

		Aliases = {"re", "resetcharacter", "refreshcharacter", "refreshplayer"},

		Rank = {1, 2, 3, 4},
		RunContext = "Server",
		Loopable = true,

		Arguments = { "Player" },

		Function = function( speaker: Player, args: any ) : ()

			local Player = args[1] or speaker

			local position = Player.Character:GetPivot()

			task.delay(1, function()
				Player:LoadCharacter()

				repeat task.wait() until Player.Character and Player.Character:FindFirstChild("Humanoid")

				Player.Character:PivotTo(position)
			end)

		end,
	},

	{
		Name = "respawn",
		Description = "Resets the player using LoadCharacter.",

		Aliases = {"res" ,"respawns", "respawncharacter", "respawnplayer"},

		Rank = {1, 2, 3, 4},
		Loopable = true,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			Player:LoadCharacter()
		end,
	},

	{
		Name = "accessory",
		Description = "Gives the players character a accessory.",

		Aliases = { "hat" },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player", "Value"  },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker
			local Value = args[2] 

			if Value == nil or Value == 0 then return end

			AddAccessory(Player, Value)

		end,
	},

	{
		Name = "clearaccessory",
		Description = "Gives the players character a accessory.",

		Aliases = { "clearhats" },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			for _, child in pairs(Player.Character:GetChildren()) do
				if child:IsA("Accessory") then child:Destroy() end
			end

		end,
	},

	{
		Name = "join",
		Description = "Join a specific users server.",

		Aliases = { },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "UserId" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()

			shared["Nebula Infinity V 3.0"].Library.Server:JoinPlayer(speaker.UserId, tonumber(args[1]) or game:GetService("Players"):GetUserIdFromNameAsync(args[1]))

		end,
	},

	{
		Name = "gravity",
		Description = "Changes the gravity for the server.",

		Aliases = { },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Value" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Value = args[1] 

			if Value == nil then Value = 198.2 end

			workspace.Gravity = Value

		end,
	},

	{	
		Name = "clone",
		Description = "Clones the players character.",

		Aliases = { },

		Rank = {1, 2, 3, 4},
		Loopable = true,
		RunContext = "Server",

		Arguments = { "Player", "Amount" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker
			local Amount = args[2] or 1

			Player.Character.Archivable = true

			if tonumber(Amount) >= 15 then return error('You can only have 15 active clones.') end

			repeat task.wait()

				if not Player.Character then return end

local Clones = {}
				local CurrentClones = 0

				for _, obj in pairs(workspace:FindFirstChild("Nebula Infinity ・ Assets"):GetChildren()) do
					if obj:GetAttribute('Owner') == Player.Name then

table.insert(Clones, obj)
						CurrentClones += 1
					end
				end
				
				if CurrentClones >= 15 then Clones[15]:Destroy() end
				
				local clone = Player.Character:Clone()
				clone.Parent = workspace:FindFirstChild("Nebula Infinity ・ Assets")

clone:SetAttribute('Owner', Player.Name)
				clone:PivotTo(Player.Character:GetPivot() + Player.Character:GetPivot().LookVector * 2.5 + Vector3.new(0, 1 + (Player.Character:GetExtentsSize().Y or 0), 0))
				Amount -= 1

			until Amount == 0
		end,
	},

	{	
		Name = "rejoin",
		Description = "Forces the player to rejoin.",

		Aliases = { },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId, game.JobId, Player)

		end,
	},

	{	
		Name = "gear",
		Description = "Grants the player a gear from the marketplace.",

		Aliases = { },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player", "ToolId" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()

			local Player = args[1] or speaker
			local Tool = tonumber(args[2])
			local Gear = game.InsertService:LoadAsset( Tool )

			if not Gear then return end

			Gear:FindFirstChildWhichIsA("Tool").Parent = Player.Backpack

		end,

	},

	{	
		Name = "size",
		Description = "Changes the size the subjects character.",

		Aliases = { },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player", "Size" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker
			local size = args[2]

			if Player.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 then 
				ConvertToRig(Player, 'R15')

				task.wait()

				Player.Character:SetAttribute( "OriginalCharacterType", "R6" )
			end

			Player.Character.Humanoid.BodyDepthScale.Value = size
			Player.Character.Humanoid.BodyHeightScale.Value = size * 1.05
			Player.Character.Humanoid.HeadScale.Value = size
			Player.Character.Humanoid.BodyWidthScale.Value = size
			Player.Character:PivotTo(Player.Character:GetPivot() + Vector3.new(0, size * 2, 0))
		end,
	},

	{	
		Name = "material",
		Description = "Changes the material the players character.",

		Aliases = { },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player", "Material" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker
			local Material = args[2] or Enum.Material.SmoothPlastic

			for _, obj in pairs(Player.Character:GetDescendants()) do
				if obj:IsA("BasePart") then	

					for _, material in pairs(Enum.Material:GetEnumItems()) do

						if material.Name:lower() == Material then
							obj.Material = material
						end
					end

				end
			end

		end,
	},

	{	
		Name = "opacity",
		Description = "Changes the opacity of the players character.",

		Aliases = { },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player", "Opacity" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker
			local Opacity = args[2] or 0.75

			for _, obj in pairs(Player.Character:GetChildren()) do
				if not obj:IsA("BasePart") and obj.Name ~= "HumanoidRootPart" then continue end

				obj.Transparency = Opacity
			end

		end,
	},

	{	
		Name = "invisible",
		Description = "Sets the players character to be invisible.",

		Aliases = { "hide", "invis", "hidecharacter" },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			for _, obj in pairs(Player.Character:GetChildren()) do
				if obj.Name == "HumanoidRootPart" then continue end


				if obj:IsA("BasePart") then

					obj.Transparency = 1

				elseif obj:IsA("Accessory") then 

					obj.Handle.Transparency = 1

				end
			end

			Player.Character:SetAttribute("OriginalValue", Player.Character.Humanoid.DisplayDistanceType.Name)

			Player.Character.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None

		end,

	},

	{	
		Name = "visible",
		Description = "Sets the players character to be visible.",

		Aliases = { "show", "vis", "showcharacter" },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			for _, obj in pairs(Player.Character:GetChildren()) do
				if obj.Name == "HumanoidRootPart" then continue end


				if obj:IsA("BasePart") then

					obj.Transparency = 0

				elseif obj:IsA("Accessory") then 

					obj.Handle.Transparency = 0

				end
			end

			Player.Character:SetAttribute("OriginalValue", Player.Character.Humanoid.DisplayDistanceType.Name)

			Player.Character.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType[Player.Character:GetAttribute("OriginalValue")]

		end,

	},

	{	
		Name = "setteam",
		Description = "Sets the players team.",

		Aliases = { "changeteam" },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player", "Team" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker
			local Team = args[2] 

			if not Team then return end

			for _, team in pairs(game.Teams:GetChildren()) do
				if team.Name:lower() == Team then
					Player.Team = team
				end
			end

		end,

	},

	{	
		Name = "createstat",
		Description = "Creates a new leaderstat.",

		Aliases = { "newstat", "newleaderstat", "createleaderstat", "insertleaderstat" },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "statname" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local StatName = table.concat(args, " ", 1)

			for _, player in pairs(game.Players:GetPlayers()) do
				if player:FindFirstChild("leaderstats") then
					local value = Instance.new("IntValue")
					value.Name = StatName
					value.Parent = player.leaderstats
				else 
					local leaderstats = Instance.new("Folder", player)

					leaderstats.Name = "leaderstats"

					local value = Instance.new("IntValue")
					value.Name = StatName
					value.Parent = player.leaderstats
				end
			end
		end,

	},

	{	
		Name = "removestat",
		Description = "Destroys a new leaderstat.",

		Aliases = { "destroystat" },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "StatName" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local StatName = table.concat(args, " ", 1)

			for _, player in pairs(game.Players:GetPlayers()) do
				if player:FindFirstChild("leaderstats") then

					player.leaderstats:FindFirstChild(StatName, true):Destroy()
				end
			end

		end,

	},

	{	
		Name = "setstat",
		Description = "set the value of a leaderstat for all players.",

		Aliases = { "changestat", },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player", "StatName", "Value" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local player, Name, Value = args[1], args[2], args[3]

			local leaderstats = player:FindFirstChild("leaderstats")

			if not leaderstats then return end

			local statValue

			for _, leaderstat in pairs(leaderstats:GetChildren()) do


				if leaderstat.Name:lower() == Name:lower() then
					statValue = leaderstat
				end
			end 

			if not statValue then return end

			statValue.Value = tonumber(Value) ~= nil and tonumber(Value) or 0

		end,

	},

	{	
		Name = "addstat",
		Description = "adds to the value of a leaderstat for specfic players.",

		Aliases = {  },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player", "StatName", "Value" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local subject = args[1] or speaker
			local name, value = args[2], args[3]


			local leaderstats = subject:FindFirstChild("leaderstats")

			if not leaderstats then return end

			local statValue

			for _, leaderstat in pairs(leaderstats:GetChildren()) do
				if leaderstat.Name:lower() == name:lower() then
					statValue = leaderstat
				end
			end 

			if not statValue then return end

			statValue.Value += tonumber(value) ~= nil and tonumber(value) or 0

		end,

	},

	{	
		Name = "substactstat",
		Description = "takes away from the value of a leaderstat for specfic players.",

		Aliases = {  },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player", "StatName", "Value" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local subject = args[1] or speaker
			local name, value = args[2], args[3]


			local leaderstats = subject:FindFirstChild("leaderstats")

			if not leaderstats then return end


			local statValue

			for _, leaderstat in pairs(leaderstats:GetChildren()) do
				if leaderstat.Name:lower() == name:lower() then
					statValue = leaderstat
				end
			end 

			if not statValue then return end

			statValue.Value -= tonumber(value) ~= nil and tonumber(value) or 0

		end,

	},

	{	
		Name = "createteam",
		Description = "Creates a new team.",

		Aliases = { "newteam", "newteam", "createteam", "insertteam" },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Team Name" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local StatName = table.concat(args, " ", 1)

			local team = Instance.new("Team", game.Teams)
			team.Name = StatName


			local color = shared["Nebula Infinity V 3.0"].Client.FunctionStorage.RunCommand.ColorWheel:InvokeClient( speaker, true)

			repeat task.wait() until color

			team.TeamColor = color

		end,

	},

	{	
		Name = "removeteam",
		Description = "Destroys a certain team.",

		Aliases = { "destroyteam" },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Team Name" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local StatName = table.concat(args, " ", 1)

			game.Teams:FindFirstChild(StatName):Destroy()

		end,

	},

	{	
		Name = "forcefield",
		Description = "Applies a force field to the subjected player.",

		Aliases = { "ff", "shield" },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			if Player.Character:FindFirstChild("Nebula Infinity ・ Force Field") then return end

			local ForceField = Instance.new("ForceField", Player.Character)

			ForceField.Name = "Nebula Infinity ・ Force Field"

		end,

	},

	{	
		Name = "unforcefield",
		Description = "Removes the force field the subjected player currently has.",

		Aliases = { "unff", "removeshield" },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			if Player.Character:FindFirstChild("Nebula Infinity ・ Force Field") then Player.Character:FindFirstChild("Nebula Infinity ・ Force Field"):Destroy( ) end
		end,

	},

	{	
		Name = "teleport",
		Description = "Moves the player to the target using :PivotTo().",

		Aliases = { "tp", "teleportto" },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player", "Subject" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker
			local Subject = args[2] or speaker

			Player.Character:PivotTo(Subject.Character:GetPivot() * CFrame.new(0, 1, -3))

		end,

	},

	{	
		Name = "bring",
		Description = "Brings the subject to sender using :PivotTo().",

		Aliases = { "take" },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Subject" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Subject = args[1] or speaker

			Subject.Character:PivotTo(speaker.Character:GetPivot() * CFrame.new(0, 1, -3))

		end,

	},

	{	
		Name = "chat",
		Description = "Forces the player to talk using the chat service.",

		Aliases = { "talk", "forcechat" },

		Rank = {1, 2, 3},
		Loopable = true,
		RunContext = "Server",

		Arguments = { "Subject", "Text" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker
			local Text = table.concat(args," ",2) or ""

			local filtered = nil
			local suc, errorMessage = pcall(function( )
				filtered = game.Chat:FilterStringForBroadcast( Text, speaker) 
			end)			

			if not suc then filtered = Text end

			if filtered == nil then return end

			Text = filtered

			game.Chat:Chat( Player.Character.Head, Text )
		end,

	},

	{	
		Name = "kill",
		Description = "Kills the player using :TakeDamage().",

		Aliases = { "kill" },

		Rank = {1, 2, 3, 4},
		Loopable = true,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			Player.Character.Humanoid:TakeDamage( Player.Character.Humanoid.MaxHealth )

		end,

	},

	{	
		Name = "god",
		Description = "Makes the subject immortal.",

		Aliases = { "god", "immortal", "infhealth" },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			if Player.Character.Humanoid.MaxHealth ~= math.huge then
				Player.Character.Humanoid:SetAttribute("OriginalHealth", Player.Character.Humanoid.Health)
				Player.Character.Humanoid:SetAttribute("OriginalMaxHealth", Player.Character.Humanoid.MaxHealth)

				Player.Character.Humanoid.MaxHealth = math.huge
				Player.Character.Humanoid.Health = math.huge
			end
		end,

	},

	{	
		Name = "ungod",
		Description = "Makes the subject mortal.",

		Aliases = { "mortal" },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			if Player.Character.Humanoid.MaxHealth == math.huge then
				if Player.Character.Humanoid:GetAttribute('OriginalMaxHealth') == nil then return end
				Player.Character.Humanoid.MaxHealth = Player.Character.Humanoid:GetAttribute('OriginalMaxHealth') or 100
				Player.Character.Humanoid.Health = Player.Character.Humanoid:GetAttribute('OriginalHealth') or 100
			end

		end,

	},

	{	
		Name = "heal",
		Description = "Heals the subject to full health.",

		Aliases = { },

		Rank = {1, 2, 3, 4},
		Loopable = true,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			Player.Character.Humanoid.Health = Player.Character.Humanoid.MaxHealth

		end,

	},

	{	
		Name = "health",
		Description = "Sets the subjects to full health.",

		Aliases = { },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player", "Value" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker
			local Value = args[2] or 100

			Player.Character:FindFirstChildWhichIsA("Humanoid").Health += tonumber(Value) ~= nil and tonumber(Value) or 0

			if tonumber(Value) ~= nil and tonumber(Value) > Player.Character:FindFirstChildWhichIsA("Humanoid").MaxHealth then
				Player.Character:FindFirstChildWhichIsA("Humanoid").MaxHealth = tonumber(Value) or 0
			end
		end,

	},

	{	
		Name = "damage",
		Description = "Damages the player using :TakeDamage().",

		Aliases = { },

		Rank = {1, 2, 3, 4},
		Loopable = true,
		RunContext = "Server",

		Arguments = { "Player", "Value" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker
			local Value = args[2] or 100

			Player.Character.Humanoid:TakeDamage(tonumber(Value))

		end,

	},

	{	
		Name = "bighead",
		Description = "Gives the player a abnormally large head.",

		Aliases = { "bigbrain", "hugehead", "largehead" },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			if 	Player.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 then 
				ConvertToRig(Player, 'R15')

				task.wait()

				Player.Character:SetAttribute( "OriginalCharacterType", "R6" )
			end

			Player.Character.Humanoid:FindFirstChild("HeadScale").Value = 2

		end,

	},

	{	
		Name = "smallhead",
		Description = "Gives the player a abnormally tiny head.",

		Aliases = { "tinybrain", "tinyhead", "peanutbrain", "smallbrain" },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			if 	Player.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 then 
				ConvertToRig(Player, 'R15')

				task.wait()

				Player.Character:SetAttribute( "OriginalCharacterType", "R6" )
			end

			Player.Character.Humanoid:FindFirstChild("HeadScale").Value = 0.35

		end,

	},

	{	
		Name = "normalhead",
		Description = "Gives the player a not so abnormally head.",

		Aliases = { "head" },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			Player.Character.Humanoid:FindFirstChild("HeadScale").Value = 1

		end,

	},

	{	
		Name = "glitch",
		Description = "Glitches the players avatar.",

		Aliases = { "glitched", "error", "error404", "404" },

		Rank = {1, 2, 3, 4},
		Loopable = true,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			for _, obj in pairs(Player.Character:GetDescendants()) do
				if obj:IsA("BasePart") then
					obj.Color = Color3.fromHSV(math.random(0, 360)/360, math.random(0,2)==0 and 0 or 1, math.random(0,2)==0 and 0 or 1)

				elseif obj:IsA("Decal") or obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("Clothing")	 then
					obj:Destroy()						
				end
			end
		end,

	},

	{	
		Name = "fling",
		Description = "Makes the player go flying! Weee!",

		Aliases = { },

		Rank = {1, 2, 3, 4},
		Loopable = true,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			local velocity = Instance.new("BodyVelocity")
			velocity.Velocity = Vector3.new(500,250,0)
			velocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
			velocity.Parent = Player.Character.HumanoidRootPart

			game.Debris:AddItem(velocity,0.5)
		end,

	},

	{	
		Name = "shirt",
		Description = "Changes the players shirt to the given id.",

		Aliases = { },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player", "Value" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker
			local Value = args[2]

			if Value == nil or Value == 0 then return end

			ChangeProperty(Player, "Shirt", Value)
		end,

	},

	{	
		Name = "pants",
		Description = "Changes the players pants to the given id.",

		Aliases = { },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player", "Value" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker
			local Value = args[2]

			if Value == nil or Value == 0 then return end

			ChangeProperty(Player, "Pants", Value)
		end,

	},

	{	
		Name = "face",
		Description = "Changes the players faces decal id to the given id.",

		Aliases = { },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player", "Value" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker
			local Value = args[2]

			if Value == nil or Value == 0 then return end

			ChangeProperty(Player, "Face", Value)
		end,

	},

	{	
		Name = "jump",
		Description = "Forces the player to jump.",

		Aliases = { "bunnyhop" },

		Rank = {1, 2, 3, 4},
		Loopable = true,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			Player.Character:FindFirstChild("Humanoid").Jump = true

		end,

	},

	{	
		Name = "sit",
		Description = "Forces the player to sit.",

		Aliases = {  },

		Rank = {1, 2, 3, 4},
		Loopable = true,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			Player.Character:FindFirstChild("Humanoid").Sit = true

		end,

	},

	{	
		Name = "spin",
		Description = "Forces the player to spin.",

		Aliases = {  },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player", "Value" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			local Speed = args[2]
			Speed = tonumber(Speed) ~= nil and tonumber(Speed) or 6

			local BodyAngularVelocity = Player.Character.HumanoidRootPart:FindFirstChild("Spin") and Player.Character.HumanoidRootPart.Spin or Instance.new('BodyAngularVelocity', Player.Character.HumanoidRootPart)
			BodyAngularVelocity.AngularVelocity = Vector3.new(0,tonumber(Speed),0)
			BodyAngularVelocity.Name = "Spin"
			local value = Speed
			BodyAngularVelocity.MaxTorque = Vector3.new(0, 4000 + value *500, 0)

		end,

	},

	{	
		Name = "unspin",
		Description = "Forces the player to stop spinning.",

		Aliases = {  },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			local BodyAngularVelocity = Player.Character.HumanoidRootPart:FindFirstChild("Spin")
			BodyAngularVelocity:Destroy()


		end,

	},


	{	
		Name = "character",
		Description = "Changes the appearance of the subjects character to another players.",

		Aliases = {  },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player", "Id" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker
			local target = args[2] 

			target = game.Players:GetUserIdFromNameAsync(target)

			local humanoidDesc = game.Players:GetHumanoidDescriptionFromUserId(target)
			Player.Character.Humanoid:ApplyDescription(humanoidDesc)


		end,

	},

	{	
		Name = "speed",
		Description = "Changes the speed of the players character using Humanoid.WalkSpeed.",

		Aliases = {  },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player", "Value" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker
			local Value = args[2] 

			Player.Character.Humanoid.WalkSpeed = tonumber(Value) or 16


		end,

	},

	{	
		Name = "freeze",
		Description = "Freezes the player or subject.",

		Aliases = {  },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker
			local Value = args[2] 

			for _,obj in pairs(Player.Character:GetChildren()) do
				if obj:IsA("BasePart") and obj.Name ~= "HumanoidRootPart" then
					obj.Transparency = 0.25
					obj.Material = Enum.Material.Ice
					if obj:GetAttribute("OriginalColor") == nil then
						obj:SetAttribute("OriginalColor", obj.Color)
					end
					obj.Color = Color3.fromHSV(0.55275, math.random(5,10)/10, 1)

					obj.Anchored = true
				elseif obj:IsA("Clothing") then
					obj.Parent = Player.Character.Humanoid
				end
			end

		end,

	},

	{	
		Name = "unfreeze",
		Description = "Freezes the player or subject.",

		Aliases = {  },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			for _, obj in pairs(Player.Character:GetDescendants()) do
				if obj:IsA("BasePart") and obj.Name ~= "HumanoidRootPart" then
					obj.Transparency = 0
					obj.Color = obj:GetAttribute("OriginalColor")

					obj.Material = Enum.Material.Plastic
					obj.Anchored = false
				elseif obj:IsA("Clothing") then
					obj.Parent = Player.Character
				end
			end

		end,

	},

	{	
		Name = "fire",
		Description = "Sets the player on fire. Ouch!",

		Aliases = {  },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			local fire = Player.Character.PrimaryPart:FindFirstChild("Nebula Infinity ・ Fire") or Instance.new("Fire", Player.Character.PrimaryPart)
			fire.Name = "Nebula Infinity ・ Fire"
			fire.Color = Color3.fromRGB(236, 139, 70)

		end,

	},

	{	
		Name = "unfire",
		Description = "Takes the player on fire out. Phew!",

		Aliases = {  },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			if Player.Character.PrimaryPart:FindFirstChild("Nebula Infinity ・ Fire") then
				Player.Character.PrimaryPart:FindFirstChild("Nebula Infinity ・ Fire"):Destroy()
			end

		end,

	},

	{	
		Name = "sparkles",
		Description = "Applies sparkles to the subjects body.",

		Aliases = {  },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			local sparkles = Player.Character.PrimaryPart:FindFirstChild("Nebula Infinity ・ Sparkles") or Instance.new("Sparkles", Player.Character.PrimaryPart)
			sparkles.Name = "Nebula Infinity ・ Sparkles"
			sparkles.Color = Color3.fromRGB(249, 61, 255)

		end,

	},

	{	
		Name = "unsparkles",
		Description = "Remove sparkles from the subjects body.",

		Aliases = {  },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			if Player.Character.PrimaryPart:FindFirstChild("Nebula Infinity ・ Sparkles") then
				Player.Character.PrimaryPart:FindFirstChild("Nebula Infinity ・ Sparkles"):Destroy()
			end

		end,

	},

	{	
		Name = "smoke",
		Description = "Applies smoke to the player or subject.",

		Aliases = {  },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			local Smoke = Player.Character.PrimaryPart:FindFirstChild("Nebula Infinity ・ Smoke") or Instance.new("Smoke", Player.Character.PrimaryPart)
			Smoke.Name = "Nebula Infinity ・ Smoke"
			Smoke.Color = Color3.fromRGB(255, 255, 255)

		end,

	},

	{	
		Name = "unsmoke",
		Description = "Removes smoke from the player or subject.",

		Aliases = {  },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			if Player.Character.PrimaryPart:FindFirstChild("Nebula Infinity ・ Smoke") then
				Player.Character.PrimaryPart:FindFirstChild("Nebula Infinity ・ Smoke"):Destroy()
			end

		end,

	},

	{	
		Name = "explosion",
		Description = "Explodes the subject.",

		Aliases = {  },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			local explosion = Instance.new("Explosion", Player.Character.PrimaryPart)
			explosion.Position = Player.Character.PrimaryPart.Position
			game.Debris:AddItem(explosion, 2)

		end,

	},

	{	
		Name = "fly",
		Description = "Grants the subject, or player flight.",

		Aliases = { "flight", "etativel" },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player", "Speed" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker
			local Speed = args[2] or 26

			shared["Nebula Infinity V 3.0"].Client.FunctionStorage.Flight.Main:InvokeClient(Player, true, "fly" , Speed )

		end,

	},

	{	
		Name = "unfly",
		Description = "Removes the subjects, or players ability flight.",

		Aliases = { },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			shared["Nebula Infinity V 3.0"].Client.FunctionStorage.Flight.Main:InvokeClient(Player, false, "fly" , 0 )

		end,

	},

	{	
		Name = "noclip",
		Description = "Grants the subjects, or players the ability to clip through walls.",

		Aliases = { },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player", "Speed" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker
			local Speed = args[2]

			shared["Nebula Infinity V 3.0"].Client.FunctionStorage.Flight.Main:InvokeClient(Player, true, "noclip" , Speed )

		end,

	},

	{	
		Name = "clip",
		Description = "Removes the subjects, or players the ability to clip through walls.",

		Aliases = { },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			shared["Nebula Infinity V 3.0"].Client.FunctionStorage.Flight.Main:InvokeClient(Player, false, "noclip" , 0 )

		end,

	},

	{	
		Name = "disco",
		Description = "Starts a disco party.",

		Aliases = { "party", "discoparty", "discoball" },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { },

		PreFunction = function( )
			coroutine.wrap(function()
				repeat task.wait() until game.Lighting:FindFirstChild("Nebula Infinity ・ Disco")
				coroutine.wrap(function()
					while task.wait() do
						local H,S,V = game.Lighting:FindFirstChild("Nebula Infinity ・ Disco").TintColor:ToHSV()

						if H == 0 or H == 360 then
							H = 1
						end

						game.Lighting:FindFirstChild("Nebula Infinity ・ Disco").TintColor = Color3.fromHSV(H + 1/360, .5, 1)

					end
				end)()
			end)()
		end,

		Function = function( speaker: Player, args: any ) : ()

			game.Lighting["Nebula Infinity ・ Disco"].Enabled = true

		end,

	},

	{	
		Name = "undisco",
		Description = "Stops an active disco party.",

		Aliases = { "stopparty", "undiscoparty", "undiscoball" },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { },

		PreFunction = function( )
		end,

		Function = function( speaker: Player, args: any ) : ()

			game.Lighting["Nebula Infinity ・ Disco"].Enabled = false

		end,

	},

	{	
		Name = "jail",
		Description = "Sends the player to jail.",

		Aliases = { "prison" },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			local Jail = script["Command Assets"]["Nebula Infinity ・ Jail"]:Clone()

			Jail.Name = `Nebula Infinity ・ { Player.Name }'s Jail`

			Jail.Parent = workspace["Nebula Infinity ・ Assets"]

			if Jail then

				shared["Nebula Infinity V 3.0"].Client.FunctionStorage.Core.Main:InvokeClient( Player, "ResetButtonCallback", false )

				if Player:GetAttribute( "Jailed" ) == false or Player:GetAttribute( "Jailed" ) == nil then
					Player:SetAttribute( "Jailed", true )
					Player:SetAttribute( "SavedPosition", Player.Character:GetPivot() )

					pcall(function()
						local ObjectValue = Instance.new( "ObjectValue", Player )

						ObjectValue.Name = "LastSpawnLocation"
						ObjectValue.Value = Player.RespawnLocation
					end)

					Jail:PivotTo( Player.Character:GetPivot() )

					Player.Character:PivotTo( Jail.Tp.CFrame )
					Player.RespawnLocation = Jail.Tp
				end
			end
		end,

	},

	{	
		Name = "unjail",
		Description = "Kicks the player out of there jail.",

		Aliases = {  },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			local Jail = workspace["Nebula Infinity ・ Assets"]:FindFirstChild( `Nebula Infinity ・ { Player.Name }'s Jail` )

			if not Jail then return end


			shared["Nebula Infinity V 3.0"].Client.FunctionStorage.Core.Main:InvokeClient( Player, "ResetButtonCallback", false )

			if Player:GetAttribute( "Jailed" ) then
				Player:SetAttribute( "Jailed", false )

				Jail:PivotTo( Player.Character:GetPivot() )

				Player.Character:PivotTo( Player:GetAttribute("SavedPosition") )
				Player.RespawnLocation = Player:FindFirstChild( "LastSpawnLocation" ).Value or workspace:FindFirstChild( "SpawnLocation", true )
			end

			Jail:Destroy()

		end,

	},

	{	
		Name = "mute",
		Description = "Removes the players ability to chat.",

		Arguments = { "Player" },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Aliases = { },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			shared["Nebula Infinity V 3.0"].Client.FunctionStorage.Core.Main:InvokeClient( Player, "Chat", false )

		end,

	},

	{	
		Name = "unmute",
		Description = "Grants the player the ability to chat.",

		Aliases = { },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			shared["Nebula Infinity V 3.0"].Client.FunctionStorage.Core.Main:InvokeClient( Player, "Chat", true )

		end,

	},

	{	
		Name = "setspawn",
		Description = "Sets the players new spawn location.",

		Aliases = {  },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			if not Player.Character then return end

			local spawnLocation = Instance.new("SpawnLocation", workspace)
			spawnLocation.Position = Player.Character.HumanoidRootPart.Position
			spawnLocation.Transparency = 1
			spawnLocation.CanCollide = false
			spawnLocation.Anchored = true

			Player.RespawnLocation = spawnLocation	
		end,

	},

	{	
		Name = "fov",
		Description = "Changes the players fov",

		Aliases = {  },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player", "Fov" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker
			local FOV = args[2]

			shared["Nebula Infinity V 3.0"].Client.FunctionStorage.Core.Camera:InvokeClient( Player, "FieldOfView", tonumber(FOV) )

		end,

	},

	{	
		Name = "crash",
		Description = "Crashes the player.",

		Aliases = {  },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker
			local FOV = args[2]

			shared["Nebula Infinity V 3.0"].Client.FunctionStorage.Core.Fun:InvokeClient( Player, "Crash" )

		end,

	},

	{	
		Name = "highlight",
		Description = "Gives the player a highlight.",

		Aliases = {  },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			local highlight = Instance.new(`Highlight`,Player.Character)

			highlight.Name = `Nebula Infinity ・ Highlight`

			highlight.OutlineTransparency = 0
			highlight.FillTransparency = 1
		end,

	},

	{	
		Name = "unhighlight",
		Description = "Removes the players highlight.",

		Aliases = {  },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			Player.Character:FindFirstChild("Nebula Infinity ・ Highlight", true):Destroy()
		end,

	},

	{	
		Name = "clearinventory",
		Description = "Clears the given players inventroy.",

		Aliases = {  },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			Player.Character.Humanoid:UnequipTools()
			Player.Backpack:ClearAllChildren()

		end,

	},

	{	
		Name = "sword",
		Description = "Grants the player a sword.",

		Aliases = {  },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			script["Command Assets"].Sword:Clone().Parent = Player.Backpack

		end,

	},

	{	
		Name = "showname",
		Description = "Makes the players name visible.",

		Aliases = {  },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			Player.Character.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer

		end,

	},

	{	
		Name = "hidename",
		Description = "Makes the players name invisible.",

		Aliases = {  },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			Player.Character.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None

		end,

	},

	{	
		Name = "changename",
		Description = "Changes the players name.",

		Aliases = {  },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player", "Text" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker
			local text = args[2]

			local filtered = nil

			local suc, errorMessage = pcall(function()
				filtered = game.Chat:FilterStringForBroadcast(text, speaker)
			end)	

			if not suc then filtered = text end

			if filtered == nil then return end

			text = filtered

			Player.Character.Humanoid.DisplayName = text
		end,

	},

	{	
		Name = "gold",
		Description = "Makes the player gold.",

		Aliases = {  },

		Rank = {1, 2, 3, 4, 5},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			for _, obj in pairs(Player.Character:GetChildren()) do
				if obj:IsA(`BasePart`) then
					obj.Color = Color3.fromRGB(187, 194, 56)
					obj.Material = Enum.Material.Metal
				end
			end

		end,

	},

	{	
		Name = "ungold",
		Description = "Makes the player normal again.",

		Aliases = {  },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker
			local lastPosition = Player.Character:GetPivot()

			Player:LoadCharacter()

			task.wait()

			Player.Character:PivotTo(lastPosition)

		end,

	},

	{	
		Name = "colorplayer",
		Description = "Changes the players color.",

		Aliases = { "paintplayer" },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			local color = shared["Nebula Infinity V 3.0"].Client.FunctionStorage.RunCommand.ColorWheel:InvokeClient( speaker, true )

			repeat task.wait() until color

			for _, obj in pairs(Player.Character:GetChildren()) do
				if obj:IsA(`BasePart`) then
					obj.Color = color
				end
			end

		end,

	},

	{	
		Name = "setskybox",
		Description = "Sets the sky boxes texture.",

		Aliases = {  },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Id" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Id = tonumber(args[1])

			if not Id then return end

			if game.Lighting:FindFirstChildOfClass("Sky") then
				local sky = game.Lighting:FindFirstChildOfClass("Sky")

				sky.SkyboxBk = Id
				sky.SkyboxDn = Id
				sky.SkyboxFt = Id
				sky.SkyboxLf = Id
				sky.SkyboxRt = Id
				sky.SkyboxUp = Id
				sky.SkyboxBk = Id

			elseif not game.Lighting:FindFirstChildOfClass("Sky") then

				local sky = Instance.new("Sky",game.Lighting)
				sky.SkyboxBk = Id
				sky.SkyboxDn = Id
				sky.SkyboxFt = Id
				sky.SkyboxLf = Id
				sky.SkyboxRt = Id
				sky.SkyboxUp = Id
				sky.SkyboxBk = Id
			end

		end,

	},

	{	
		Name = "r6",
		Description = "Changes the players avatar type to R6.",

		Aliases = {  },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			ConvertToRig(Player, 'R6')

		end,

	},

	{	
		Name = "r15",
		Description = "Changes the players avatar type to R15.",

		Aliases = {  },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			ConvertToRig(Player, 'R15')

		end,

	},

	{	
		Name = "handto",
		Description = "Hands the player a tool from the senders inventory.",

		Aliases = { },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = speaker
			local Subject = args[1] 

			if not Subject or not Player then return end

			Player.Character:FindFirstChildWhichIsA("Tool").Parent = Subject.Character

		end,

	},

	{	
		Name = "time",
		Description = "Changes the time of day.",

		Aliases = { },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Time" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Time = args[1]

			game.Lighting.TimeOfDay = tonumber(Time) or 1

		end,

	},

	{	
		Name = "void",
		Description = "Sends the player to the void.",

		Aliases = { },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			Player.Character:PivotTo(CFrame.new(-1000, -1000, -1000))

		end,

	},

	{	
		Name = "nuke",
		Description = "Summons a nuke.",

		Aliases = { },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = {  },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()

			local Indicator = Instance.new("Part", workspace)
			Indicator.Size = Vector3.new(0)
			Indicator.Shape = "Ball"
			Indicator.Position = Vector3.new(0,50,0)
			Indicator.CanCollide = false
			Indicator.Anchored = true

			game.TweenService:Create(Indicator,TweenInfo.new(0.5), {Size = Vector3.new(200,200,200)}):Play()

			task.delay(0.45,function()
				local Lighting = Instance.new("ColorCorrectionEffect", game.Lighting)
				Lighting.TintColor = Color3.fromRGB(255,50,0)
				Lighting.Saturation = 1
				Lighting.Contrast = 1
				Lighting.Brightness = 1

				local nuke = Instance.new("Explosion", workspace)
				nuke.Position = Vector3.new(0,50,0)
				nuke.BlastPressure = math.huge
				nuke.BlastRadius = math.huge

				game:GetService("Debris"):AddItem(Lighting, 3)
				game:GetService("Debris"):AddItem(nuke, 3)

				task.wait(3)
				game.TweenService:Create(Indicator,TweenInfo.new(0.5), {Size = Vector3.new(0,0,0)}):Play()
				task.wait(0.45); Indicator:Destroy()	
			end)

		end,

	},

	{	
		Name = "tool",
		Description = "Grants the player a tool.",

		Aliases = { },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player", "Tool" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()

			local Player = args[1] or speaker
			local Tool = table.concat(args, " ", 2)

			game.ServerScriptService["Nebula Infinity 3rd Edition"].Tools:FindFirstChild(Tool, true):Clone().Parent = Player.Backpack

		end,

	},

	{	
		Name = "punish",
		Description = "Makes the player unable to play the game.",

		Aliases = { },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()

			local Player = args[1] or speaker

			Player.Character:Destroy()

		end,

	},

	{	
		Name = "unpunish",
		Description = "Fixes the effects applied by the punish command.",

		Aliases = { },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()

			local Player = args[1] or speaker

			Player:LoadCharacter()

		end,

	},

	{	
		Name = "clearterrain",
		Description = "Removes all terrain in workspace.",

		Aliases = {  },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			workspace.Terrain:Clear()
		end,

	},


	{	
		Name = "colorterrain",
		Description = "Change the terrain color.",

		Aliases = { "terraincolor" },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Material" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()

			local color = shared["Nebula Infinity V 3.0"].Client.FunctionStorage.RunCommand.ColorWheel:InvokeClient( speaker, true)

			repeat task.wait() until color

			if not args[1] then
				args[1] = "grass"
			end

			if args[1] == "water" then
				workspace.Terrain.WaterColor = color

			else

				for _, material in pairs(Enum.Material:GetEnumItems()) do

					if material.Name:lower() == args[1] then
						workspace.Terrain:SetMaterialColor( material, color )
					end
				end

			end

		end,

	},

	{	
		Name = "award",
		Description = "Awards the player with a badge.",

		Aliases = {  },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player", "BadgeId" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			game:GetService("BadgeService"):AwardBadge( Player.UserId, tonumber(args[2]) )

		end,

	},

	{	
		Name = "brightness",
		Description = "Change the ambience brightness.",

		Aliases = {  },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Brightness" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()

			game:GetService("Lighting").Brightness = args[1] or game:GetService("Lighting").Brightness


		end,

	},

	{	
		Name = "ambience",
		Description = "Change the ambience color.",

		Aliases = {  },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Color" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local color = shared["Nebula Infinity V 3.0"].Client.FunctionStorage.RunCommand.ColorWheel:InvokeClient( speaker, true )

			repeat task.wait() until color

			game:GetService("Lighting").Ambient = color or game:GetService("Lighting").Ambient


		end,

	},

	{	
		Name = "fogstart",
		Description = "Change the fogstart setting.",

		Aliases = {  },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Number" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()

			game:GetService("Lighting").FogStart = args[1] or game:GetService("Lighting").Brightness


		end,

	},

	{	
		Name = "fogend",
		Description = "Change the fogend setting.",

		Aliases = {  },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Number" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()

			game:GetService("Lighting").FogEnd = args[1] or game:GetService("Lighting").Brightness


		end,

	},

	{	
		Name = "fogcolor",
		Description = "Change the fogs color.",

		Aliases = { "colorfog" },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()

			local color = shared["Nebula Infinity V 3.0"].Client.FunctionStorage.RunCommand.ColorWheel:InvokeClient( speaker, true )

			repeat task.wait() until color

			game.Lighting.FogColor = color or game.Lighting.FogColor

		end,

	},

	{	
		Name = "headless",
		Description = "Hides a player's head.",

		Aliases = { "invisiblehead" },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			if not Player.Character or not Player.Character:FindFirstChild("Humanoid") then return end

			Player.Character.Head.Transparency = 1
			if Player.Character.Head:FindFirstChildWhichIsA("Decal") then Player.Character.Head:FindFirstChildWhichIsA("Decal").Transparency = 1 end

		end,

	},

	{	
		Name = "warp",
		Description = "Wraps the player's FOV in and out.",

		Aliases = {  },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			shared["Nebula Infinity V 3.0"].Client.FunctionStorage.RunCommand.Warp:InvokeClient( Player )

		end,

	},

	{	
		Name = "blackout",
		Description = "Makes the player blackout.",

		Aliases = { "dizzy" },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player", "Duration" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			if typeof(tonumber(args[1])) == "number" then
				Player = speaker
				args[2] = args[1]
			end

			shared["Nebula Infinity V 3.0"].Client.FunctionStorage.RunCommand.Dizzy:InvokeClient( Player, tonumber(args[2]) or 5 )

			task.delay( tonumber(args[1]) or tonumber(args[2]) or 5, function() 
				task.wait(6)

				Player:LoadCharacter()
			end)

		end,

	},


	{	
		Name = "blur",
		Description = "Applies a blur effect to the subjected player.",

		Aliases = { "blureffect" },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player", "Size" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			shared["Nebula Infinity V 3.0"].Client.FunctionStorage.RunCommand.Blur:InvokeClient( Player, args[2] )

		end,

	},

	{	
		Name = "unblur",
		Description = "un-applies the blur effect for the subjected player.",

		Aliases = { "unblureffect" },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			shared["Nebula Infinity V 3.0"].Client.FunctionStorage.RunCommand.Blur:InvokeClient( Player )

		end,

	},

	{	
		Name = "dwarf",
		Description = "Makes the player a dwarf.",

		Aliases = {  },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker
			local Humanoid = Player.Character.Humanoid

			if Humanoid.RigType == Enum.HumanoidRigType.R6 then 
				ConvertToRig(Player, 'R15')

				task.wait()

				Player.Character:SetAttribute( "OriginalCharacterType", "R6" )
				Humanoid = Player.Character.Humanoid
			end


			Humanoid.BodyDepthScale.Value, Humanoid.BodyHeightScale.Value, Humanoid.BodyWidthScale.Value, Humanoid.HeadScale.Value = 0.75, 0.5, 0.75, 1.4

		end,

	},

	{	
		Name = "undwarf",
		Description = "Makes the player a normal size again.",

		Aliases = {  },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker
			local Humanoid = Player.Character.Humanoid

			if Player.Character:GetAttribute( "OriginalCharacterType") == "R6" then
				ConvertToRig(Player, 'R6')
			end

			Humanoid.BodyDepthScale.Value, Humanoid.BodyHeightScale.Value, Humanoid.BodyWidthScale.Value, Humanoid.HeadScale.Value = 1, 1, 1, 1

		end,

	},

	{	
		Name = "giant",
		Description = "Makes the player a giant again.",

		Aliases = {  },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker
			local Humanoid = Player.Character.Humanoid

			if Humanoid.RigType == Enum.HumanoidRigType.R6 then 
				ConvertToRig(Player, 'R15')

				task.wait()

				Player.Character:SetAttribute( "OriginalCharacterType", "R6" )
				Humanoid = Player.Character.Humanoid
			end


			Humanoid.BodyDepthScale.Value, Humanoid.BodyHeightScale.Value, Humanoid.BodyWidthScale.Value, Humanoid.HeadScale.Value = 2, 2, 2, 2
		end,

	},

	{	
		Name = "ungiant",
		Description = "Makes the player a normal size again.",

		Aliases = {  },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker
			local Humanoid = Player.Character.Humanoid

			Humanoid.BodyDepthScale.Value, Humanoid.BodyHeightScale.Value, Humanoid.BodyWidthScale.Value, Humanoid.HeadScale.Value = 1, 1, 1, 1

			if Player.Character:GetAttribute( "OriginalCharacterType") == "R6" then
				ConvertToRig(Player, 'R6')
			end

		end,

	},

	{	
		Name = "depth",
		Description = "Adjust how much depth the character has.",

		Aliases = { "depthscale" },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player", "Number" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker
			local Humanoid = Player.Character.Humanoid

			Humanoid.BodyDepthScale.Value = args[2] or 1

			if Humanoid.RigType == Enum.HumanoidRigType.R6 then 
				ConvertToRig(Player, 'R15')

				task.wait()

				Player.Character:SetAttribute( "OriginalCharacterType", "R6" )
				Humanoid = Player.Character.Humanoid
			end

		end,

	},

	{	
		Name = "undepth",
		Description = "Adjust how much depth the character has to the regular integers.",

		Aliases = { "undepthscale" },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker
			local Humanoid = Player.Character.Humanoid

			Humanoid.BodyDepthScale.Value = 1


			if Player.Character:GetAttribute( "OriginalCharacterType") == "R6" then
				ConvertToRig(Player, 'R6')
			end

		end,

	},

	{	
		Name = "height",
		Description = "Adjust the height of the players character.",

		Aliases = { "heightscale" },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player", "Number" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker
			local Humanoid = Player.Character.Humanoid

			if Humanoid.RigType == Enum.HumanoidRigType.R6 then 
				ConvertToRig(Player, 'R15')

				task.wait()

				Player.Character:SetAttribute( "OriginalCharacterType", "R6" )
				Humanoid = Player.Character.Humanoid
			end

			Humanoid.BodyHeightScale.Value = args[2] or 1

		end,

	},

	{	
		Name = "unheight",
		Description = "Adjust the height of the players character to regular integers.",

		Aliases = { "unheightscale" },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker
			local Humanoid = Player.Character.Humanoid

			Humanoid.BodyHeightScale.Value = 1

			if Player.Character:GetAttribute( "OriginalCharacterType") == "R6" then
				ConvertToRig(Player, 'R6')
			end

		end,

	},

	{	
		Name = "hipheight",
		Description = "Adjust the hipheight of the players character.",

		Aliases = { "hipheight" },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player", "Number" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			Player.Character.Humanoid.HipHeight = args[2] or 2

		end,

	},	

	{	
		Name = "unhipheight",
		Description = "Adjust the hipheight of the players character to the regular integers.",

		Aliases = { "unhipheight" },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			Player.Character.Humanoid.HipHeight = 2

		end,

	},

	{	
		Name = "squash",
		Description = "Turns the player into a pancake",

		Aliases = { "squish" },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker
			local Humanoid = Player.Character.Humanoid

			if Humanoid.RigType == Enum.HumanoidRigType.R6 then 
				ConvertToRig(Player, 'R15')

				task.wait()

				Player.Character:SetAttribute( "OriginalCharacterType", "R6" )
				Humanoid = Player.Character.Humanoid
			end

			Humanoid.BodyHeightScale.Value = 0.1

		end,

	},

	{	
		Name = "unsquash",
		Description = "Turns the player into a there regular selfs.",

		Aliases = { "unsquish" },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker
			local Humanoid = Player.Character.Humanoid

			Humanoid.BodyHeightScale.Value = 1

			if Player.Character:GetAttribute( "OriginalCharacterType") == "R6" then
				ConvertToRig(Player, 'R6')
			end
		end,

	},

	{	
		Name = "proportion",
		Description = "Adjust how wide/narrow a player's character is.",

		Aliases = {  },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player", "Number" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker
			local Humanoid = Player.Character.Humanoid

			Humanoid.BodyProportionScale.Value = args[2] or 1

			if Player.Character:GetAttribute( "OriginalCharacterType") == "R6" then
				ConvertToRig(Player, 'R6')
			end


		end,

	},

	{	
		Name = "unproportion",
		Description = "returns how wide/narrow the players character was.",

		Aliases = {  },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player", "Number" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker
			local Humanoid = Player.Character.Humanoid

			Humanoid.BodyProportionScale.Value = 1

			if Player.Character:GetAttribute( "OriginalCharacterType") == "R6" then
				ConvertToRig(Player, 'R6')
			end


		end,

	},

	{	
		Name = "width",
		Description = "Adjusts how wide the player is overall.",

		Aliases = {  },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player", "Number" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker
			local Humanoid = Player.Character.Humanoid

			if Humanoid.RigType == Enum.HumanoidRigType.R6 then 
				ConvertToRig(Player, 'R15')

				task.wait()

				Player.Character:SetAttribute( "OriginalCharacterType", "R6" )
				Humanoid = Player.Character.Humanoid
			end

			Humanoid.BodyWidthScale.Value = args[2] or 1

		end,

	},

	{	
		Name = "unwidth",
		Description = "Adjusts how wide the player was overall.",

		Aliases = {  },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker
			local Humanoid = Player.Character.Humanoid

			Humanoid.BodyWidthScale.Value = args[2] or 1

			if Player.Character:GetAttribute( "OriginalCharacterType") == "R6" then
				ConvertToRig(Player, 'R6')
			end
		end,

	},

	{	
		Name = "fat",
		Description = "Makes the player fat.",

		Aliases = { },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker
			local Humanoid = Player.Character.Humanoid

			if Humanoid.RigType == Enum.HumanoidRigType.R6 then 
				ConvertToRig(Player, 'R15')

				task.wait()

				Player.Character:SetAttribute( "OriginalCharacterType", "R6" )
				Humanoid = Player.Character.Humanoid
			end

			Humanoid.BodyWidthScale.Value, Humanoid.BodyDepthScale.Value = 2, 1.5


		end,

	},

	{	
		Name = "unfat",
		Description = "Makes the player normal size.",

		Aliases = { },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker
			local Humanoid = Player.Character.Humanoid

			Humanoid.BodyWidthScale.Value, Humanoid.BodyDepthScale.Value = 1, 1


			if Player.Character:GetAttribute( "OriginalCharacterType") == "R6" then
				ConvertToRig(Player, 'R6')
			end

		end,

	},

	{	
		Name = "skinny",
		Description = "Makes the player skinny.",

		Aliases = { "twig", "thin", "sk" },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker
			local Humanoid = Player.Character.Humanoid

			if Humanoid.RigType == Enum.HumanoidRigType.R6 then 
				ConvertToRig(Player, 'R15')

				task.wait()

				Player.Character:SetAttribute( "OriginalCharacterType", "R6" )
				Humanoid = Player.Character.Humanoid
			end

			Humanoid.BodyWidthScale.Value, Humanoid.BodyDepthScale.Value = 0.2, 0.2


		end,

	},

	{	
		Name = "unskinny",
		Description = "Makes the player normal size.",

		Aliases = {  },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker
			local Humanoid = Player.Character.Humanoid

			Humanoid.BodyWidthScale.Value, Humanoid.BodyDepthScale.Value = 1, 1

			if Player.Character:GetAttribute( "OriginalCharacterType") == "R6" then
				ConvertToRig(Player, 'R6')
			end

		end,

	},

	{	
		Name = "bundle",
		Description = "Applies a bundle to the subjected player.",

		Aliases = {  },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player", "Number" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local plr = args[1] or speaker

			local hd

			local success, bundleDetails = pcall(function() 
				return game:GetService("AssetService"):GetBundleDetailsAsync(args[2])
			end)

			if success and bundleDetails then 
				for _, item in next, bundleDetails.Items do 
					if item.Type == "UserOutfit" then
						success, hd = pcall(function()
							return game:GetService('Players'):GetHumanoidDescriptionFromOutfitId(item.Id)
						end)
						break
					end
				end
			end

			if not hd then return end

			local newDescription = plr.Character.Humanoid:GetAppliedDescription()
			local defaultDescription = Instance.new("HumanoidDescription")

			for _, property in next, {"BackAccessory", "BodyTypeScale", "ClimbAnimation", "DepthScale", "Face", "FaceAccessory", "FallAnimation", "FrontAccessory", "GraphicTShirt", "HairAccessory", "HatAccessory", "Head", "HeadColor", "HeadScale", "HeightScale", "IdleAnimation", "JumpAnimation", "LeftArm", "LeftArmColor", "LeftLeg", "LeftLegColor", "NeckAccessory", "Pants", "ProportionScale", "RightArm", "RightArmColor", "RightLeg", "RightLegColor", "RunAnimation", "Shirt", "ShouldersAccessory", "SwimAnimation", "Torso", "TorsoColor", "WaistAccessory", "WalkAnimation", "WidthScale"} do
				if hd[property] ~= defaultDescription[property] then newDescription[property] = hd[property] end
			end

			plr.Character.Humanoid:ApplyDescription(newDescription)

		end,

	},

	{	
		Name = "dino",
		Description = "Makes the player into a dinosaur.",

		Aliases = {  },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()

			local plr = args[1] or speaker

			local hd; local success, bundleDetails = pcall(function() return game:GetService("AssetService"):GetBundleDetailsAsync(458) end) if success and bundleDetails then for _, item in next, bundleDetails.Items do if item.Type == "UserOutfit" then success, hd = pcall(function() return game:GetService('Players'):GetHumanoidDescriptionFromOutfitId(item.Id) end) break end end end
			if not hd then return end

			local newDescription = plr.Character.Humanoid:GetAppliedDescription()
			local defaultDescription = Instance.new("HumanoidDescription")
			newDescription.BackAccessory, newDescription.FaceAccessory, newDescription.FrontAccessory, newDescription.HairAccessory, newDescription.HatAccessory, newDescription.NeckAccessory, newDescription.ShouldersAccessory, newDescription.WaistAccessory = "", "", "", "", "", "", "", ""

			for _, property in next, {"BackAccessory", "BodyTypeScale", "ClimbAnimation", "DepthScale", "Face", "FaceAccessory", "FallAnimation", "FrontAccessory", "GraphicTShirt", "HairAccessory", "HatAccessory", "Head", "HeadColor", "HeadScale", "HeightScale", "IdleAnimation", "JumpAnimation", "LeftArm", "LeftArmColor", "LeftLeg", "LeftLegColor", "NeckAccessory", "Pants", "ProportionScale", "RightArm", "RightArmColor", "RightLeg", "RightLegColor", "RunAnimation", "Shirt", "ShouldersAccessory", "SwimAnimation", "Torso", "TorsoColor", "WaistAccessory", "WalkAnimation", "WidthScale"} do
				if hd[property] ~= defaultDescription[property] then newDescription[property] = hd[property] end
			end

			pcall(function() plr.Character.Humanoid:ApplyDescription(hd) end)

			plr.Character.Humanoid:ApplyDescription(newDescription)

		end,

	},

	{	
		Name = "follow",
		Description = "Makes the player follow the subject.",

		Aliases = { "fl" },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player", "Subject" },

		PreFunction = function( )
			shared["Nebula Infinity V 3.0"].Storage["FollowLoops"] = {}
		end,

		Function = function( speaker: Player, args: any ) : ()

			local Player = args[1] or speaker
			local target = args[2]

			shared["Nebula Infinity V 3.0"].Storage["FollowLoops"][Player] = target

			coroutine.wrap(function()
				while shared["Nebula Infinity V 3.0"].Storage["FollowLoops"][Player] == target do
					Player.Character:FindFirstChild("Humanoid"):MoveTo(target.Character:GetPivot().Position)
					Player.Character:FindFirstChild("Humanoid").MoveToFinished:Wait()
				end 
			end)()
		end,

	},

	{	
		Name = "unfollow",
		Description = "stops the player from follow the subject.",

		Aliases = { "ufl", "uf" },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )
			shared["Nebula Infinity V 3.0"].Storage["FollowLoops"] = {}
		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			shared["Nebula Infinity V 3.0"].Storage["FollowLoops"][Player] = nil

		end,

	},

	{
		Name = "reloadmap",
		Description = "Reloads the map.",

		Aliases = { "refreshmap", "loadmap", "rmap", "lmap" },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = {"Player"},

		PreFunction = function()
			local storage = game.ServerScriptService:WaitForChild("Nebula Infinity ・ Storage")

			local existingWorldSaves = storage:FindFirstChild("WorldSaves")
			if existingWorldSaves then
				existingWorldSaves:Destroy()
			end

			local worldModel = Instance.new("WorldModel")
			worldModel.Name = "WorldSaves"
			worldModel.Parent = storage

			local newWorldModel = Instance.new("WorldModel")
			newWorldModel.Name = "OriginalMap"
			newWorldModel.Parent = worldModel

			for _, child in ipairs(game.Workspace:GetChildren()) do 
				if not child:IsA("Terrain") then 
					local clone = child:Clone()
					clone.Parent = newWorldModel
				end
			end
		end,

		Function = function(speaker: Player, args: any) : ()
			local Player = args[1] or speaker

			for _, child in ipairs(game.Workspace:GetChildren()) do
				if child:IsA("Model") and game.Players:FindFirstChild(child.Name) then
					continue
				end

				if not child:IsA("Terrain") then 
					child:Destroy()
				end
			end

			local originalMap = game.ServerScriptService:WaitForChild("Nebula Infinity ・ Storage"):FindFirstChild("WorldSaves"):FindFirstChild("OriginalMap")

			if originalMap then
				for _, x in ipairs(originalMap:GetChildren()) do
					x:Clone().Parent = workspace
				end
			end
		end,
	},

	{
		Name = "join",
		Description = "Join a specific player in another server.",

		Aliases = { },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "UserId" },

		PreFunction = function()

		end,

		Function = function(speaker: Player, args: any) : ()
			shared["Nebula Infinity V 3.0"].Library.Server:Join(speaker.UserId, args[1] or game:GetService("Players"):GetUserIdFromNameAsync(args[1]))
		end,
	},

	{
		Name = "shutdown",
		Description = "Shuts down the current server.",

		Aliases = { "closeserver", "shutdownserver" },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { },

		PreFunction = function()

		end,

		Function = function(speaker: Player, args: any) : ()
			shared["Nebula Infinity V 3.0"].Library.Server:Shutdown()
		end,
	},

	{
		Name = "gshutdown",
		Description = "Shuts down the game.",

		Aliases = { "globalshutdown", "shutdowngame" },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { },

		PreFunction = function()

		end,

		Function = function(speaker: Player, args: any) : ()
			shared["Nebula Infinity V 3.0"].Library.Server:UniversalShutdown()
		end,
	},

	{
		Name = "migrate",
		Description = "Update server to latest version.",

		Aliases = { "updateserver" },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { },

		PreFunction = function()

		end,

		Function = function(speaker: Player, args: any) : ()
			shared["Nebula Infinity V 3.0"].Library.Server:Migrate()
		end,
	},

	{
		Name = "gmigrate",
		Description = "Updates all server to latest version.",

		Aliases = { "globalmigrate", "updateallservers" },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { },

		PreFunction = function()

		end,

		Function = function(speaker: Player, args: any) : ()
			shared["Nebula Infinity V 3.0"].Library.Server:UniversalMigrate()
		end,
	},

	{
		Name = "serverlock",
		Description = "Stop anyone with a lower rank required from joining.",

		Aliases =  { "lockserver" },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Rank" },

		PreFunction = function()
			shared["Nebula Infinity V 3.0"].Storage["serverlock"] = {}
		end,

		Function = function(speaker: Player, args: any) : ()

			local speakerRank = shared["Nebula Infinity V 3.0"].Library.RankService:GetRankByUserId(speaker.UserId)

			if args[1] == nil or args[1] == speaker then
				args[1] = speakerRank
			end

			if speakerRank and speakerRank < args[1] then
				args[1] = speakerRank
			end

			if args[1] > 0 then
				shared["Nebula Infinity V 3.0"].Client.EventStorage.Notification:FireClient(speaker, `Server locked for {args[1].Name} and above.`)
				shared["Nebula Infinity V 3.0"].Library.Server:Lock( args[1] )
			else
				shared["Nebula Infinity V 3.0"].Client.EventStorage.Notification:FireClient(speaker, `Server unlocked`)
				shared["Nebula Infinity V 3.0"].Library.Server:Unlock()
			end
		end,
	},

	{
		Name = "unserverlock",
		Description = "allows anyone with a lower rank required from joining.",

		Aliases =  {},

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { },

		PreFunction = function()
			shared["Nebula Infinity V 3.0"].Storage["serverlock"] = {}
		end,

		Function = function(speaker: Player, args: any) : ()
			shared["Nebula Infinity V 3.0"].Client.EventStorage.shared["Nebula Infinity V 3.0"]:FireClient(speaker, `Server unlocked`)
			shared["Nebula Infinity V 3.0"].Library.Server:Unlock()
		end,
	},

	{
		Name = "universalLock",
		Description = "Stop anyone from joining without required rank.",

		Aliases =  {},

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Rank" },

		PreFunction = function()
			shared["Nebula Infinity V 3.0"].Storage["serverlock"] = {}
		end,

		Function = function(speaker: Player, args: any) : ()
			local speakerRank = shared["Nebula Infinity V 3.0"].Library.RankService:GetRankByUserId(speaker.UserId)

			if args[1] == nil or args[1] == speaker then
				args[1] = speakerRank
			end

			if speakerRank and speakerRank < args[1] then
				args[1] = speakerRank
			end

			if args[1] > 0 then
				shared["Nebula Infinity V 3.0"].Client.EventStorage.shared["Nebula Infinity V 3.0"]:FireClient(speaker, `Server locked for {args[1].Name} and above.`)
				shared["Nebula Infinity V 3.0"].Library.Server:UniversalLock( args[1] )
			else
				shared["Nebula Infinity V 3.0"].Client.EventStorage.shared["Nebula Infinity V 3.0"]:FireClient(speaker, `Server unlocked`)
				shared["Nebula Infinity V 3.0"].Library.Server:UniversalUnlock()
			end
		end,
	},

	{
		Name = "ununiversalLock",
		Description = "Allows anyone to join even without then required rank.",

		Aliases =  {},

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = {  },

		PreFunction = function()
			shared["Nebula Infinity V 3.0"].Storage["serverlock"] = {}
		end,

		Function = function(speaker: Player, args: any) : ()

			shared["Nebula Infinity V 3.0"].Client.EventStorage.shared["Nebula Infinity V 3.0"]:FireClient(speaker, `Server unlocked`)
			shared["Nebula Infinity V 3.0"].Library.Server:UniversalUnlock()
		end,
	},

	{
		Name = "wallstick",
		Description = "Allows for the player to walk on walls.",

		Aliases =  { "stickywalls" },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function()
		end,

		Function = function(speaker: Player, args: any) : ()

			if workspace.StreamingEnabled then
				shared["Nebula Infinity V 3.0"].Client.EventStorage.Notification:FireClient( args[1] or speaker, `The sticky walls command only works with streaming enabled being disabled.` )
				return
			end

			shared["Nebula Infinity V 3.0"].Client.FunctionStorage.RunCommand.Wallstick:InvokeClient( args[1] or speaker, true )

		end,
	},	

	{
		Name = "unwallstick",
		Description = "Allows for the player to walk normally.",

		Aliases =  { "unstickywalls" },

		Rank = {1, 2, 3},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function()
		end,

		Function = function(speaker: Player, args: any) : ()

			if workspace.StreamingEnabled then
				shared["Nebula Infinity V 3.0"].Client.EventStorage.Notification:FireClient( args[1] or speaker, `The sticky walls command only works with streaming enabled being disabled.` )
				return
			end

			shared["Nebula Infinity V 3.0"].Client.FunctionStorage.RunCommand.Wallstick:InvokeClient( args[1] or speaker, false )

		end,
	},

	{	
		Name = "to",
		Description = "Moves the player to the targets location using :PivotTo().",

		Aliases = {  },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			speaker.Character:PivotTo( args[1].Character:GetPivot() + args[1].Character:GetPivot().LookVector * 2.5 )
		end,

	},

	{	
		Name = "poop",
		Description = "How long have you been holding that in for, geeze.",

		Aliases = {  },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local plr = args[1] or speaker
			local maxPoops = 20
			local poopSounds = {174658105,148635119}

			-- Code from HD Admin

			local function poopSound(sound_id,part)
				local soundPoop = Instance.new("Sound",part)
				soundPoop.SoundId = "rbxassetid://"..sound_id
				soundPoop.Volume = 0.5
				soundPoop:Play()
				local soundPlaying = soundPoop.IsPlaying or soundPoop.Played:Wait()

				wait()
			end
			local function poop(clone,toilet,sound_id,poopCount, poopGroup)
				local poop = script["Command Assets"].Poop:Clone()
				poopSound(sound_id,poop)
				poop.CanCollide = false

				local totalPoops = maxPoops
				local increment = 1/totalPoops
				local newH = (poopCount-1)*increment
				local newColor = Color3.fromHSV(newH, 0.7, 0.7)
				poop.Color = newColor

				poop.CFrame = toilet.Seat.CFrame * CFrame.new(0,(poopCount*1)-0.5,0)
				clone:SetPrimaryPartCFrame(poop.CFrame * CFrame.new(0,3,0))
				poop.Parent = poopGroup
			end

			local head = plr.Character.Head

			if not head then return end

			local originalCFrame = head.CFrame

			local poopCount = 0
			local poopGroup = Instance.new("Model",workspace)
			local toilet = script["Command Assets"].Toilet:Clone()

			poopGroup.Name = plr.Name.."'s poop"
			toilet.PrimaryPart = toilet.Seat
			toilet:SetPrimaryPartCFrame(plr.Character.HumanoidRootPart.CFrame * CFrame.new(0,-1,0)) --* CFrame.Angles(0,math.rad(90), 0))
			toilet.Parent = workspace
			toilet.Seat:Sit(plr.Character.Humanoid)

			plr.Character.Head.face.Texture = "rbxassetid://101522923340393"
			wait()

			plr.Character:SetPrimaryPartCFrame(toilet.PrimaryPart.CFrame * CFrame.new(0,3,0))

			for a,b in pairs(plr.Character:GetChildren()) do
				if b:IsA("BasePart") and b.Name ~= "HumanoidRootPart" then
					b.Anchored = true
				end
			end
			wait(1)

			poopSound(174658105,plr.Character.HumanoidRootPart)

			wait(2)
			poopCount = poopCount + 1

			poop(plr.Character,toilet,148635119,poopCount, poopGroup)

			wait(1.5)

			plr.Character.Head.face.Texture = "rbxassetid://316545711"


			for i = 1,maxPoops do
				if i == maxPoops - 2 then
					for a,b in pairs(plr.Character:GetChildren()) do
						if b:IsA("BasePart") and b.Name ~= "HumanoidRootPart" then
							b.Anchored = false
						end
					end

					local explosion = Instance.new("Explosion")
					explosion.Position = plr.Character.Head.Position
					explosion.Parent = plr.Character
					explosion.DestroyJointRadiusPercent = 0

					plr.Character:BreakJoints()
				elseif i > maxPoops-1 then
					for a,b in pairs(poopGroup:GetChildren()) do
						b.Anchored = false
						b.CanCollide = true
					end
				end
				poopCount = poopCount + 1

				if i >= maxPoops then
					wait(1.5)
				else
					poop(plr.Character,toilet,poopSounds[math.random(1,#poopSounds)],poopCount, poopGroup)
					wait()
				end
			end

			wait(3)

			poopGroup:Destroy()
			toilet:Destroy()

			plr.Character.Parent = workspace

		end,

	},

	{	
		Name = "morph",
		Description = "Changes the character to a specifc morph.",

		Aliases = {  },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player", "Morph" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker
			local Morph = args[2] 

			if not Morph then return end

			for _, morph in pairs(script["Command Assets"].Morphs:GetChildren()) do
				if morph.Name:lower() == Morph then
					local character = morph:Clone()

					if not Player.Character or not Player.Character:FindFirstChild("Humanoid") then continue end


					morph.Parent = workspace
					morph:PivotTo(Player.Character:GetPivot())

					local animate = Player.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and script["Built-In"]["Animate (R6)"]:Clone() or script["Built-In"]["Animate (R15)"]:Clone()
					animate.Parent, animate.Name = morph, "Animate" 

					morph.Humanoid.WalkSpeed = Player.Character.Humanoid.WalkSpeed
					morph.Humanoid.JumpPower = Player.Character.Humanoid.JumpPower

					morph.Humanoid.MaxHealth = Player.Character.Humanoid.MaxHealth
					morph.Humanoid.Health = Player.Character.Humanoid.Health

					morph.Name = Player.Character.Name


					Player.Character:Destroy()
					Player.Character = morph

					shared["Nebula Infinity V 3.0"].Client.FunctionStorage.Morph.Main:InvokeClient( Player )
					animate.Enabled = true

					for _, asset in morph:GetDescendants() do if asset:IsA("BasePart") then asset.Anchored = false end end

				end
			end

		end,

	},

	{	
		Name = "glass",
		Description = "Spawns broken glass to the players location.",

		Aliases = { "shatterglass" },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

			shared["Nebula Infinity V 3.0"].Storage["GlassConnections"] = { }

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker


			local DebugEnabled = false

			local Debris = game:GetService("Debris")

			local function FracturePart(PartToFracture)

				local BreakingPointAttachment = PartToFracture:FindFirstChild("BreakingPoint")

				local DebrisDespawn = false
				local DebrisDespawnDelay = 0
				local WeldDebris = false
				local AnchorDebris = false

				if DebugEnabled then
					local DebugPart = Instance.new("Part")
					DebugPart.Shape = "Ball"
					DebugPart.CanCollide = false
					DebugPart.Anchored = true
					DebugPart.Size = Vector3.new(0.5, 0.5, 0.5)
					DebugPart.Color = Color3.fromRGB(255, 0, 0)
					DebugPart.Position = BreakingPointAttachment.WorldPosition
					DebugPart.Parent = workspace
				end

				local BreakSound = Instance.new("Sound")
				BreakSound.SoundId = "rbxassetid://6737582037"

				local SoundPart = Instance.new("Part")
				SoundPart.Size = Vector3.new(0.2, 0.2, 0.2)
				SoundPart.Position = PartToFracture.Position
				SoundPart.Name = "TemporarySoundEmitter"
				SoundPart.Anchored = true
				SoundPart.CanCollide = false
				SoundPart.Transparency = 1

				BreakSound.Parent = SoundPart
				BreakSound.Parent = workspace
				BreakSound:Play()
				Debris:AddItem(SoundPart, 2)

				if not BreakingPointAttachment then
					warn("The 'BreakingPoint' attachment is not a valid member of " .. PartToFracture.Name .. ". Please insert an attachment named 'BreakingPoint'")
				end

				local BreakingPointY = BreakingPointAttachment.Position.Y
				local BreakingPointZ = BreakingPointAttachment.Position.Z

				local ShardBottomLeft = Instance.new("WedgePart")
				local ShardBottomRight = Instance.new("WedgePart")
				local ShardTopLeft = Instance.new("WedgePart")
				local ShardTopRight = Instance.new("WedgePart")

				local BreakSound = PartToFracture:FindFirstChild("BreakSound")

				-- Bottom Left
				ShardBottomLeft.Material = PartToFracture.Material
				ShardBottomLeft.MaterialVariant = PartToFracture.MaterialVariant
				ShardBottomLeft.Color = PartToFracture.Color
				ShardBottomLeft.Transparency = PartToFracture.Transparency
				ShardBottomLeft.Size = PartToFracture.Size - Vector3.new(0, (PartToFracture.Size.Y / 2) - BreakingPointY, (PartToFracture.Size.Z / 2) + BreakingPointZ)
				local OldSizeY = ShardBottomLeft.Size.Y
				local OldSizeZ = ShardBottomLeft.Size.Z
				ShardBottomLeft.CFrame = PartToFracture.CFrame * CFrame.new(0, BreakingPointY - (ShardBottomLeft.Size.Y / 2), BreakingPointZ + (ShardBottomLeft.Size.Z / 2))
				ShardBottomLeft.CFrame = ShardBottomLeft.CFrame * CFrame.Angles(math.rad(90), 0, 0)
				ShardBottomLeft.Size = Vector3.new(ShardBottomLeft.Size.X, OldSizeZ, OldSizeY)
				local ShardBottomLeft2 = ShardBottomLeft:Clone()
				ShardBottomLeft2.CFrame = ShardBottomLeft2.CFrame * CFrame.Angles(math.rad(180), 0, 0)

				-- Bottom Right
				ShardBottomRight.Material = PartToFracture.Material
				ShardBottomRight.MaterialVariant = PartToFracture.MaterialVariant
				ShardBottomRight.Color = PartToFracture.Color
				ShardBottomRight.Transparency = PartToFracture.Transparency
				ShardBottomRight.Size = PartToFracture.Size - Vector3.new(0, (PartToFracture.Size.Y / 2) + BreakingPointY, (PartToFracture.Size.Z / 2) + BreakingPointZ)
				ShardBottomRight.CFrame = PartToFracture.CFrame * CFrame.new(0, BreakingPointY + (ShardBottomRight.Size.Y / 2), BreakingPointZ + (ShardBottomRight.Size.Z / 2))
				local ShardBottomRight2 = ShardBottomRight:Clone()
				ShardBottomRight2.CFrame = ShardBottomRight2.CFrame * CFrame.Angles(math.rad(180), 0, 0)

				-- Top Left
				ShardTopLeft.Material = PartToFracture.Material
				ShardTopLeft.MaterialVariant = PartToFracture.MaterialVariant
				ShardTopLeft.Color = PartToFracture.Color
				ShardTopLeft.Transparency = PartToFracture.Transparency
				ShardTopLeft.Size = PartToFracture.Size - Vector3.new(0, (PartToFracture.Size.Y / 2) + BreakingPointY, (PartToFracture.Size.Z / 2) - BreakingPointZ)
				local OldSizeY = ShardTopLeft.Size.Y
				local OldSizeZ = ShardTopLeft.Size.Z
				ShardTopLeft.CFrame = PartToFracture.CFrame * CFrame.new(0, BreakingPointY + (ShardTopLeft.Size.Y / 2), BreakingPointZ - (ShardTopLeft.Size.Z / 2))
				ShardTopLeft.CFrame = ShardTopLeft.CFrame * CFrame.Angles(math.rad(90), 0, 0)
				ShardTopLeft.Size = Vector3.new(ShardTopLeft.Size.X, OldSizeZ, OldSizeY)
				local ShardTopLeft2 = ShardTopLeft:Clone()
				ShardTopLeft2.CFrame = ShardTopLeft2.CFrame * CFrame.Angles(math.rad(180), 0, 0)

				-- Top Right
				ShardTopRight.Material = PartToFracture.Material
				ShardTopRight.MaterialVariant = PartToFracture.MaterialVariant
				ShardTopRight.Color = PartToFracture.Color
				ShardTopRight.Transparency = PartToFracture.Transparency
				ShardTopRight.Size = PartToFracture.Size - Vector3.new(0, (PartToFracture.Size.Y / 2) - BreakingPointY, (PartToFracture.Size.Z / 2) - BreakingPointZ)
				ShardTopRight.CFrame = PartToFracture.CFrame * CFrame.new(0, BreakingPointY - (ShardTopRight.Size.Y / 2), BreakingPointZ - (ShardTopRight.Size.Z / 2))
				local ShardTopRight2 = ShardTopRight:Clone()
				ShardTopRight2.CFrame = ShardTopRight2.CFrame * CFrame.Angles(math.rad(180), 0, 0)

				local ShardDictionary = {ShardBottomLeft, ShardBottomLeft2, ShardBottomRight, ShardBottomRight2, ShardTopLeft, ShardTopLeft2, ShardTopRight, ShardTopRight2}


				local FirstShard = nil
				for Index, Shard in ipairs(ShardDictionary) do
					Shard.CanCollide = true

					if not FirstShard then
						FirstShard = Shard
					end

					Shard.Anchored = false
					if not AnchorDebris then
						Shard.Velocity = PartToFracture.Velocity
						Shard.RotVelocity = PartToFracture.RotVelocity
					end
					if WeldDebris and FirstShard then
						local Weld = Instance.new("WeldConstraint")
						Weld.Name = "ShardWeld"
						Weld.Part0 = FirstShard
						Weld.Part1 = Shard
						Weld.Parent = Shard
					end
					Shard.Name = "Shard"
					Shard.Parent = PartToFracture.Parent

					Debris:AddItem(Shard, 5)
				end
				PartToFracture:Destroy()

			end

			local part = Instance.new("Part", workspace)

			part.Material = Enum.Material.Glass
			part.Size = Vector3.new(Player.Character:GetExtentsSize().X * 1.5, Player.Character:GetExtentsSize().Y * 1.5, Player.Character:GetExtentsSize().Z * 1.5)
			part.Color = Color3.fromRGB(150, 150, 150)
			part.Transparency = 0.5	
			part.Anchored = true

			part.CFrame = Player.Character.HumanoidRootPart.CFrame

			local attachment = Instance.new("Attachment", part)

			attachment.Name = "BreakingPoint" 

			task.wait(1)

			FracturePart(part)

		end,

	},

	{	
		Name = "shout",
		Description = "Sends a message in the chat.",

		Aliases = {  },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Message" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Message = table.concat(args, " ", 1)

			if not Message then return end

			local filtered = nil

			local suc, errorMessage = pcall(function()
				filtered = game.Chat:FilterStringForBroadcast(Message, speaker)
			end)	

			if not suc then filtered = Message end

			if filtered == nil then return end

			Message = filtered

			shared["Nebula Infinity V 3.0"].Client.FunctionStorage.RunCommand.Shout:InvokeClient( speaker, Message )

		end,

	},

	{	
		Name = "heaven",
		Description = "Sends the player to heaven.",

		Aliases = {  },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()

			shared["Nebula Infinity V 3.0"].Client.FunctionStorage.RunCommand.Heaven:InvokeClient( args[1] or speaker )

		end,

	},

	{	
		Name = "unheaven",
		Description = "Revives the player.",

		Aliases = {  },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			Player:LoadCharacter()

		end,

	},

	{	
		Name = "fart",
		Description = "Makes the player fart.",

		Aliases = {  },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			local fart = Instance.new("Smoke", Player.Character.PrimaryPart)

			fart.Color = Color3.fromRGB(0, 170, 0)
			fart.Size = 1
			fart.TimeScale = 1
			fart.RiseVelocity = 1
			fart.Opacity = 0.3

			fart.Name = "Nebula Infinity ・ Fart"

		end,

	},

	{	
		Name = "unfart",
		Description = "Stops the player from farting.",

		Aliases = {  },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker
			local fart = Player.Character.PrimaryPart:FindFirstChild("Nebula Infinity ・ Fart")

			if fart then fart:Destroy() end

		end,

	},

	{	
		Name = "clear",
		Description = "Clears anything spawned by commands.",

		Aliases = { "clr" },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()

			workspace["Nebula Infinity ・ Assets"]:ClearAllChildren()

		end,

	},

	{	
		Name = "prank",
		Description = "Spawns a dummy to haunt the subject.",

		Aliases = { },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

			local lighting = game:GetService("Lighting")

			lighting:SetAttribute("OrignalAmbient", lighting.Ambient )
			lighting:SetAttribute("OrignalBrightness", lighting.Brightness )
			lighting:SetAttribute("OrignalColorShift_Top", lighting.ColorShift_Top )
			lighting:SetAttribute("OrignalColorShift_Bottom", lighting.ColorShift_Bottom )
			lighting:SetAttribute("OrignalEnvironmentDiffuseScale", lighting.EnvironmentDiffuseScale )
			lighting:SetAttribute("OrignalEnvironmentSpecularScale", lighting.EnvironmentSpecularScale )
			lighting:SetAttribute("OrignalGlobalShadows", lighting.GlobalShadows )
			lighting:SetAttribute("OrignalOutdoorAmbient", lighting.OutdoorAmbient )
			lighting:SetAttribute("OrignalShadowSoftness", lighting.ShadowSoftness )
			lighting:SetAttribute("OrignalClockTime", lighting.ClockTime )
			lighting:SetAttribute("OrignalGeographicLatitude", lighting.GeographicLatitude )

		end,

		Function = function( speaker: Player, args: any ) : ()

			shared["Nebula Infinity V 3.0"].Client.FunctionStorage.RunCommand.Prank:InvokeClient( args[1] or speaker )

		end,

	},

	{	
		Name = "carcrash",
		Description = "Hits the player with a car.",

		Aliases = { "cc", "car", "crash" },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			local Jeep = script["Command Assets"].Jeep:Clone()

			Jeep.Parent = workspace["Nebula Infinity ・ Assets"]

			Jeep:PivotTo( Player.Character:GetPivot() - Vector3.new(0, 0, -10) )

			task.wait(1.5)

			Jeep:PivotTo( Player.Character:GetPivot() )

			local explosion = Instance.new("Explosion", workspace)

			explosion.Position = Jeep.PrimaryPart.Position
			explosion.BlastPressure = 0
			explosion.DestroyJointRadiusPercent = 0

			script["Command Assets"].Explosion:Play()

			task.wait(0.48)

			local function attachmentCreater(name, parent, offset)
				local parentCFrame = parent.CFrame

				local att = Instance.new("Attachment")
				att.Parent = parent
				att.Name = name

				att.WorldCFrame = parentCFrame * offset

				return att
			end

			local function fling(char, humanoid, humanoidRootPart)
				local lookVector = humanoidRootPart.CFrame.LookVector
				local upVector = humanoidRootPart.CFrame.UpVector

				local timeFlinging = tick()

				local flingDirection = lookVector * 100 + upVector * 100

				humanoid.PlatformStand = true

				local bv = Instance.new("BodyVelocity")
				bv.Parent = humanoidRootPart
				bv.P = 1750
				bv.MaxForce = Vector3.new(9e9,9e9,9e9)
				bv.Velocity = flingDirection

				game.Debris:AddItem(bv,0.1)

				local av = Instance.new("AngularVelocity")
				av.Parent = humanoidRootPart
				av.MaxTorque = 10000
				av.ReactionTorqueEnabled = false

				local att1 = attachmentCreater("att1", humanoidRootPart, CFrame.new(0,0,0))
				local att2 = attachmentCreater("att2", humanoidRootPart, CFrame.new(0,0,0))

				game.Debris:AddItem(att1,.1)
				game.Debris:AddItem(att2,.1)

				game.Debris:AddItem(av,.1)

				av.Attachment0 = att1
				av.Attachment1 = att2

				av.AngularVelocity = Vector3.new(math.random(-20,20),math.random(-20,20),math.random(-20,20))

			end

			fling(Player.Character,Player.Character.Humanoid,Player.Character.HumanoidRootPart)

			task.wait(2)

			shared["Nebula Infinity V 3.0"].Client.FunctionStorage.RunCommand.CarCrash:InvokeClient( Player )

			Jeep:Destroy()

			task.wait(3)

			Player:LoadCharacter()

		end,

	},

	{	
		Name = "flag",
		Description = "Places the american flag at the players location.",

		Aliases = {  },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker

			local flag = script["Command Assets"].AmericanFlag:Clone()

			flag.Parent = workspace["Nebula Infinity ・ Assets"]
			flag:PivotTo(Player.Character:GetPivot())

		end,

	},

	{	
		Name = "JB",
		Description = "JB 🗿",

		Aliases = {  },

		Rank = {1, 2, 3, 4},
		Loopable = false,
		RunContext = "Server",

		Arguments = { "Player" },

		PreFunction = function( )

		end,

		Function = function( speaker: Player, args: any ) : ()
			local Player = args[1] or speaker
			local Humanoid = Player.Character.Humanoid

			local humanoidDesc = game.Players:GetHumanoidDescriptionFromUserId(4406691405)
			Player.Character.Humanoid:ApplyDescription(humanoidDesc)

			AddAccessory(Player, 88835287292574)
			AddAccessory(Player, 132369733629517)
			AddAccessory(Player, 10730111839)

			if Humanoid.RigType == Enum.HumanoidRigType.R6 then 
				ConvertToRig(Player, 'R15')

				task.wait()

				Player.Character:SetAttribute( "OriginalCharacterType", "R6" )
				Humanoid = Player.Character.Humanoid
			end


			Humanoid.BodyDepthScale.Value, Humanoid.BodyHeightScale.Value, Humanoid.BodyWidthScale.Value, Humanoid.HeadScale.Value = 0.75, 0.5, 0.75, 1.4

			task.delay(3, function()
				shared["Nebula Infinity V 3.0"].Client.FunctionStorage.RunCommand.Dizzy:InvokeClient( Player, tonumber(args[2]) or 5 )

				task.wait(6)

				Player:Kick( "JB has taken over you.." )

			end)


		end,

	},

}
