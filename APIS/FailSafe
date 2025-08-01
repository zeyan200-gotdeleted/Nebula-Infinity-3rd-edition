local field = {}

function field.init( file : StyleSheet )
	local gameSettings = field:gameSettings()
	local files = field:file( file )

	task.wait()

	if not gameSettings["httpRequests"] or not gameSettings["apiServices"] and files then

		if game["Run Service"]:IsStudio() then
			for _, Player in pairs(game.Players:GetPlayers()) do
				local Clone = script.Interface.Setup:Clone()

				Clone.Parent = Player.PlayerGui
				Clone.ClientHandler.Enabled = true
			end

			game.Players.PlayerAdded:Connect(function( Player )
				local Clone = script.Interface.Setup:Clone()

				Clone.Parent = Player.PlayerGui
				Clone.ClientHandler.Enabled = true
			end)

			return
		else
			warn(`Nebula Infinity has been set up incorrectly, please go into studio to see a set up guide.`)
			
			return	
		end
	end

	if not files then
		if game["Run Service"]:IsStudio() then
			for _, Player in pairs(game.Players:GetPlayers()) do
				local Clone = script.Interface.Setup:Clone()

				Clone.ClientHandler:SetAttribute("Page", "Corruption")
				Clone.ClientHandler.Enabled = true

				Clone.Parent = Player.PlayerGui
			end

			game.Players.PlayerAdded:Connect(function( Player )
				local Clone = script.Interface.Setup:Clone()

				Clone.ClientHandler:SetAttribute("Page", "Corruption")
				Clone.ClientHandler.Enabled = true

				Clone.Parent = Player.PlayerGui
			end)

			return
		else
			warn(`Nebula Infinity has been set up incorrectly, please go into studio to see a set up guide.`)
			
			return
		end
	end

	game:GetService("TestService"):Message( " Nebula Infinity Third Edition has been installed correctly | Loading Modules! " )
	
	return false
end

function field:gameSettings()

	local Settings = {
		httpRequests = true,
		apiServices = true,
	}

	local DataStoreService = game:GetService(`DataStoreService`)

	local status, message = pcall(function()
		DataStoreService:GetDataStore("NebulaTest"):SetAsync("NebulaTest", math.pi * 35 / 2 )	
	end)

	Settings.apiServices = status

	local successful, result = pcall(function()
		game:GetService("HttpService"):GetAsync("https://google.com")
	end)

	Settings.httpRequests = successful

	return Settings
end

function field:file( file : StyleSheet )

	if not file then
		return false
	end

	local requiredItems = {"Tools", "Settings", "Command Handler", "Ranks"}

	for _, itemName in pairs(requiredItems) do
		if not file:FindFirstChild(itemName) then
			return false
		end
	end

	for _, obj in pairs(file:GetChildren()) do
		if not table.find(requiredItems, obj.Name) and obj.Name ~= "ThumbnailCamera" and obj.Name ~= "READ ME" then
			return false
		end
	end

	return true
end

return field

