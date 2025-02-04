-- @ | Library

local Callbacks, Methods, Tweens, Debounces, Storage = {}, {}, {}, {}, {}
Callbacks.__index, Methods.__index = Callbacks, Methods

local Players = game:GetService("Players")
local MessagingService = game:GetService("MessagingService")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")

-- @ | Methods

-- @ | Callbacks

function Callbacks:JoinPlayer(senderId: number, userId: number)
	MessagingService:PublishAsync("Nebula Infinity V 3.0", {
		["request"] = "join",
		["type"] = "universal",
		["userid"] = userId,
		["senderid"] = senderId,
	})
end

function Callbacks:Shutdown()
	for _, player in Players:GetPlayers() do
		player:Kick("⚠ | This server has shut down, please rejoin.")
	end

	Players.PlayerAdded:Connect(function(player)
		player:Kick("⚠ | This server has shut down, please rejoin.")
	end)
end

function Callbacks:Migrate()
	if #Players:GetPlayers() == 0 or RunService:IsStudio() then return end

	for _, Player in Players:GetPlayers() do
		local UI = script.TempUI:Clone()
		UI.Frame.TextLabel.Text = "Rebooting servers for update. Please wait"
		UI.Parent = Player.PlayerGui
	end

	task.wait(1.5)

	local reservedServerCode = TeleportService:ReserveServer(game.PlaceId)

	for _, player in Players:GetPlayers() do
		TeleportService:TeleportToPrivateServer(game.PlaceId, reservedServerCode, { player })
	end

	Players.PlayerAdded:Connect(function(player)
		TeleportService:TeleportToPrivateServer(game.PlaceId, reservedServerCode, { player })
	end)

	game:BindToClose(function()    
		repeat task.wait() until #Players:GetPlayers() == 0
	end)
end

function Callbacks:UniversalShutdown()
	MessagingService:PublishAsync("Nebula Infinity V 3.0", {
		["request"] = "shutdown",
		["type"] = "universal",
	})
end

function Callbacks:UniversalMigrate()
	MessagingService:PublishAsync("Nebula Infinity V 3.0", {
		["request"] = "migrate",
		["type"] = "universal",
	})
end

function Callbacks:Lock(rank: Instance)
	for _, player in Players:GetPlayers() do
		local playerRank = shared["Nebula Infinity V 3.0"].Library.RankService:GetRankByUserId(player.UserId)
		if playerRank and playerRank:GetAttribute("RankId") >= rank:GetAttribute("RankId") then continue end
		player:Kick("⚠ | This server is locked for " .. rank.Name .. " only.")
	end

	if self.ServerLock then self.ServerLock:Disconnect() end
	self.ServerLock = Players.PlayerAdded:Connect(function(player)
		local playerRank = shared["Nebula Infinity V 3.0"].Library.RankService:GetRankByUserId(player.UserId)
		if playerRank and playerRank:GetAttribute("RankId") >= rank:GetAttribute("RankId") then return end
		player:Kick("⚠ | This server is locked for " .. rank.Name .. " only.")
	end)
end

function Callbacks:Announce(sender: Player | number, message: string)
	local id, DisplayName, UserName

	if typeof(sender) == "number" then
		local data = game:GetService("UserService"):GetUserInfosByUserIdsAsync({ tonumber(sender) })[1]
		if data then
			id = data["Id"]
			UserName = data["Username"]
			DisplayName = data["DisplayName"]
		end
	else
		id = sender.UserId
		DisplayName = sender.DisplayName
		UserName = sender.Name
	end

	for _, Player in Players:GetPlayers() do
		local UI = script.Announce:Clone()
		UI.Frame.Title.Text = message

		-- fetching the thumbnail properly
		UI.Frame.Thumb.Image = shared["Nebula Infinity V 3.0"].Services.Players:GetUserThumbnailAsync(
			id,
			Enum.ThumbnailType.HeadShot,
			Enum.ThumbnailSize.Size420x420
		)
		UI.Frame.From.Text = `From: {DisplayName} (@{UserName})`
		UI.Parent = Player.PlayerGui
		game.Debris:AddItem(UI, 10)
	end
end

function Callbacks:UniversalAnnounce(sender: Player, message: string)
	MessagingService:PublishAsync("Nebula Infinity V 3.0", {
		["request"] = "announce",
		["type"] = "universal",
		["sender"] = sender.UserId,
		["value"] = message
	})
end

function Callbacks:Unlock()
	if self.ServerLock then self.ServerLock:Disconnect() end
end

function Callbacks:UniversalLock(rank: Instance)
	MessagingService:PublishAsync("Nebula Infinity V 3.0", {
		["request"] = "lock",
		["type"] = "universal",
		["value"] = rank.Name,
	})
end

function Callbacks:UniversalUnlock()
	MessagingService:PublishAsync("Nebula Infinity V 3.0", {
		["request"] = "unlock",
		["type"] = "universal",
	})
end

-- @ | Return

local Meta = setmetatable({}, Callbacks)

MessagingService:SubscribeAsync("Nebula Infinity V 3.0", function(requestData)
	requestData = requestData.Data

	warn(requestData)

	if requestData["request"] == "join" and requestData["type"] == "universal" then
		for _, player in Players:GetPlayers() do
			if player.UserId == requestData.userid then
				warn("Found a player, publishing!")
				MessagingService:PublishAsync("Nebula Infinity V 3.0", {
					["request"] = "found",
					["type"] = "universal",
					["jobid"] = game.JobId,
					["userid"] = requestData.userid,
					["senderid"] = requestData.senderid,
				})
				warn("Published")
				break
			end
		end
		return
	end

	if requestData["request"] == "found" and requestData["type"] == "universal" then
		warn("FOUND TELEPORTING")
		TeleportService:TeleportToPlaceInstance(game.PlaceId, requestData.jobid, Players:GetPlayerByUserId(requestData.senderid))
		return
	end

	if requestData["request"] == "shutdown" and requestData["type"] == "server" and requestData["jobid"] == game.JobId then
		Meta:Shutdown()
		return
	end

	if requestData["request"] == "shutdown" and requestData["type"] == "universal" then
		Meta:Shutdown()
		return
	end

	if requestData["request"] == "migrate" and requestData["type"] == "server" and requestData["jobid"] == game.JobId then
		Meta:Migrate()
		return
	end

	if requestData["request"] == "migrate" and requestData["type"] == "universal" then
		Meta:Migrate()
		return
	end 

	if requestData["request"] == "lock" and requestData["type"] == "universal" then
		local rank = shared["Nebula Infinity V 3.0"].Library.RankService:GetAsync(requestData.value)
		if not rank then return end

		if rank:GetAttribute("RankId") > 1 then
			Meta:Lock(rank)
		else
			Meta:Unlock()
		end

		return
	end 

	if requestData["request"] == "unlock" and requestData["type"] == "universal" then
		Meta:Unlock()
		return
	end 

	if requestData["request"] == "announce" and requestData["type"] == "universal" then
		warn("Global Announce")
		Meta:Announce(requestData["sender"], requestData["value"])
		return
	end
end)

if game.VIPServerId ~= "" and game.VIPServerOwnerId == 0 then
	for _, Player in Players:GetPlayers() do
		local UI = script.TempUI:Clone()
		UI.Frame.TextLabel.Text = "This is a temporary lobby. Teleporting back in a moment."
		UI.Parent = Player.PlayerGui
	end

	local waitTime = 5

	Players.PlayerAdded:Connect(function(player)
		task.wait(waitTime)
		waitTime = waitTime / 2
		TeleportService:Teleport(game.PlaceId, player)

		task.wait(5)

		warn("Teleport failed, retrying.")
		TeleportService:Teleport(game.PlaceId, player)
	end)

	for _, player in Players:GetPlayers() do
		TeleportService:Teleport(game.PlaceId, player)
		task.wait(waitTime)
		waitTime = waitTime / 2

		task.wait(5)

		warn("Teleport failed, retrying.")
		TeleportService:Teleport(game.PlaceId, player)
	end
end

return Meta
