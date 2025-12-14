-- @ | Services

local Services = shared["Nebula Infinity V 3.0"].Services

-- @ | Variables

local Callbacks, Methods, PrefixStorage , Debounces = {}, {}, {}, {}
local Meta = setmetatable({}, Callbacks)
local CustomRanks = require(shared["Nebula Infinity V 3.0"].File.Ranks.Customs)

Callbacks.__index, Methods.__index = Callbacks, Methods

-- @ | Type config

export type rank = {
	Administrator : boolean,

	Name : string,
	Id : number,

	Pages : {},
}

export type rankName = ( name: string ) -> ()
export type rankId = ( id: number ) -> ()

-- @ | Methods

function Methods:UpdateRanked( rankName : rankName, rankId : rankId, player : Player )

	local DataStoreService:DataStoreService = Services.DataStoreService
	local DataStore:DataStore = DataStoreService:GetDataStore("Nebula Infinity | Third Edition Ranks")

	DataStore:UpdateAsync("Ranks", function(pastData)
		pastData = pastData or {}

		pastData[player.UserId] = {

			["RankName"] = rankName,
			["RankId"] = rankId,
		}

		return pastData
	end)

	repeat task.wait() until shared["Nebula Infinity V 3.0"].Client.PlayerInfo:FindFirstChild(player.Name)

	task.wait(0.5)

	DataStoreService:GetDataStore("Nebula Infinity | Third Edition Prefixes"):UpdateAsync("Prefixs", function(pastData)
		pastData = pastData or {}

		pastData[player.UserId] = {

			["Prefix"] = shared["Nebula Infinity V 3.0"].Client.PlayerInfo[player.Name]:GetAttribute("Prefix") or "!",
		}

		return pastData
	end)

	player:SetAttribute( "Prefix", shared["Nebula Infinity V 3.0"].Client.PlayerInfo[player.Name]:GetAttribute("Prefix") or "!" )

end

-- @ | Callbacks

function Callbacks:RankUserAsync( player : Player, rankName : rankName )
	local Preset = require(script["Pre-Set"])
warn(Preset)
	for i, v in pairs(CustomRanks) do
		Preset[v.Name] = v
	end
	
	warn(Preset)
	
	if Preset[rankName] then

		Preset = Preset[rankName]

		player:SetAttribute ( "Rank", rankName )
		player:SetAttribute( "RankId", Preset["Id"] )

		if not player.PlayerGui:FindFirstChild("Nebula Infinity") then
			local UI 

			if shared["Nebula Infinity V 3.0"].Client.FunctionStorage.RequestDevice.Main:InvokeClient( player ) then
				UI = script.Parent.Parent.Parent.Parent.Interface["Nebula Infinity // Mobile"]:Clone() 
			else
				UI = script.Parent.Parent.Parent.Parent.Interface["Nebula Infinity // PC"]:Clone() 
			end

			UI.Parent = player.PlayerGui
			UI.Name = "Nebula Infinity"
			UI.Config.Main.Enabled = true
			shared["Nebula Infinity V 3.0"].Client.Extras.AdminCount.Value += 1

			
			if not require(game:GetService("ServerScriptService")["Nebula Infinity 3rd Edition"].Settings).Customs.Interactable  then
				UI.Config.Main.MainModule.Events.Interactable:FireClient( player )
			end
			
			Methods:UpdateRanked(rankName,Preset["Id"], player)

			task.delay(2.5, function()
				shared["Nebula Infinity V 3.0"].Client.EventStorage.Notification:FireClient(player, `You have been ranked as {rankName}! Press "N" or type "!panel" in chat to open the panel.`) 
			end)
		end
	end
end

function Callbacks:GetRankByUserId( Player : Player | number )
	local RankId

	if typeof( Player ) == "number" then
		local DataStoreService:DataStoreService = Services.DataStoreService
		local DataStore:DataStore = DataStoreService:GetDataStore("Nebula Infinity | Third Edition Ranks")

		DataStore:UpdateAsync("Ranks", function(pastData)
			pastData = pastData or {}

			RankId = pastData[Player]["RankId"]

			return pastData
		end)

	else
		RankId = Player:GetAttribute( "RankId" )
	end

	return RankId
end

Services.Players.PlayerRemoving:Connect(function( Player : Player )
	local DataStoreService:DataStoreService = Services.DataStoreService
	local DataStore:DataStore = DataStoreService:GetDataStore("Nebula Infinity | Third Edition Ranks")

	DataStore:UpdateAsync("Ranks", function(pastData)
		pastData = pastData or {}

		pastData[Player.UserId] = {

			["RankName"] = Player:GetAttribute( "Rank" ),
			["RankId"] = Player:GetAttribute( "RankId" ),
		}

		return pastData
	end)

	task.wait(0.2)

	DataStoreService:GetDataStore("Nebula Infinity | Third Edition Prefixes"):UpdateAsync("Prefixs", function(pastData)
		pastData = pastData or {}

		pastData[Player.UserId] = {

			["Prefix"] = PrefixStorage[Player.UserId] or shared["Nebula Infinity V 3.0"].File:GetAttribute("Prefix") or "!" ,
		}

		return pastData
	end)

	table.remove(PrefixStorage, Player.UserId)

end)

game:BindToClose(function( )
	if game["Run Service"]:IsStudio() then return end


	local DataStoreService:DataStoreService = Services.DataStoreService
	local DataStore:DataStore = DataStoreService:GetDataStore("Nebula Infinity | Third Edition Ranks")

	for _, Player in pairs(Services.Players:GetPlayers()) do
		DataStoreService:GetDataStore("Nebula Infinity | Third Edition Prefixes"):UpdateAsync("Prefixs", function(pastData)
			pastData = pastData or {}

			pastData[Player.UserId] = {

				["Prefix"] = PrefixStorage[Player.UserId] or shared["Nebula Infinity V 3.0"].File:GetAttribute("Prefix") or "!",
			}

			return pastData
		end)

		task.wait(0.2)

		DataStore:UpdateAsync("Ranks", function(pastData)
			pastData = pastData or {}

			pastData[Player.UserId] = {

				["RankName"] = Player:GetAttribute( "Rank" ),
				["RankId"] = Player:GetAttribute( "RankId" ),
			}

			return pastData
		end)
	end

end)

return Meta
