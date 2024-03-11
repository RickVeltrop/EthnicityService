--// Services
local plrs = game:GetService('Players')

--// Variables
local EthnicityDatastore
local MainModule

local PlrData = {}
local RunEvents = true
local UpdateDatastoreType

--// Functions

-- Converts a color3 to an array
local function Color3ToTable(Color:Color3)
	if typeof(Color) == 'table' then return Color end
	return { Color.R, Color.G, Color.B }
end

-- Reverses Color3ToTable()
local function TableToColor3(Tbl:{number})
	if typeof(Tbl) == 'Color3' then return Tbl end
	return Color3.fromRGB(table.unpack(Tbl))
end

-- Gets the average color of a table returned from Color3ToTable()
local function GetAverageColorFromTable(Tbl:{number})
	local Counter = 0
	for i,v in Tbl do Counter += v end
	return Counter / #Tbl
end

-- Creates a table with currently relevant player data
local function GetNewPlrData(Plr:Player)
	local NewData = {}
	
	NewData.SkinDarkness = MainModule:GetSkinDarknessAsync(Plr.UserId)
	NewData.SkinYellowness = MainModule:GetSkinYellownessAsync(Plr.UserId)
	NewData.SkinColor = MainModule:GetSkinColorAsync(Plr.UserId)
	
	return NewData
end

-- Called in datastore:UpdateAsync()
local function OnPlayerDataUpdate(Plr, CurrentData, KeyInfo)
	local NewData = PlrData[Plr.UserId]
	NewData.SkinColor = Color3ToTable(NewData.SkinColor)
	
	if not CurrentData then return NewData end
	if UpdateDatastoreType == MainModule.Enum.UpdateType.Never then return end
	
	local AverageSkinColorDifference = GetAverageColorFromTable(CurrentData.SkinColor) - GetAverageColorFromTable(NewData.SkinColor)
	if UpdateDatastoreType == MainModule.Enum.UpdateType.IfDarker and AverageSkinColorDifference < 0 then return end
	if UpdateDatastoreType == MainModule.Enum.UpdateType.IfLighter and AverageSkinColorDifference > 0 then return end

	return NewData
end

local function PlayerAdded(Plr:Player)
	if not RunEvents then return end
	if not EthnicityDatastore then return end
	
	local Data
	local Suc,Err = pcall(function()
		Data = EthnicityDatastore:GetAsync(Plr.UserId)
	end)

	if Suc and Data then
		Data.SkinColor = TableToColor3(Data.SkinColor)
		PlrData[Plr.UserId] = Data
	elseif Suc and not Data then
		PlrData[Plr.UserId] = GetNewPlrData(Plr)
	else
		warn(`Failed to load {Plr.Name}'s EthnicityDatastore due to uncaught error; {Err}`)
	end
end

local function PlayerRemoving(Plr:Player)
	if not RunEvents then return end
	if not EthnicityDatastore then return end
	
	local Suc,Err = pcall(function()
		EthnicityDatastore:UpdateAsync(Plr.UserId, function(CurrentData, KeyInfo)
			OnPlayerDataUpdate(Plr, CurrentData, KeyInfo)
		end)
	end)

	if not Suc then
		warn(`Failed to save {Plr.Name}'s EthnicityDatastore due to uncaught error; {Err}`)
	end
end

local function BindToClose()
	if not RunEvents then return end
	if not EthnicityDatastore then return end
	
	for i,v in plrs:GetPlayers() do
		PlayerRemoving(v)
	end
end

--// Events
plrs.PlayerAdded:Connect(PlayerAdded)
plrs.PlayerRemoving:Connect(PlayerRemoving)
game:BindToClose(BindToClose)

--// Module
local module = {}

function module:Start(Module, Datastore:GlobalDataStore?, UpdateType)
	MainModule = Module
	EthnicityDatastore = Datastore or EthnicityDatastore
	UpdateDatastoreType = UpdateType or Module.Enum.UpdateType.Always
end

-- Sets global UpdateDatastoreType
function module:SetUpdateDatastoreValue(UpdateType)
	UpdateDatastoreType = UpdateType
end

-- Gets a player's data if any is present
function module:TryGetPlayerDataFromCache(UserId:number)
	return PlrData[UserId]
end

-- Toggles events related to datastores
function module:SetEventRunSwitch(AreEventsPaused:boolean)
	RunEvents = not AreEventsPaused
end

return module
