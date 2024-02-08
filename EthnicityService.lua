--// Services
local plrs = game:GetService('Players')
local dss = game:GetService('DataStoreService')

--// Variabls
local DatastoreModule
local Connections = {}

--// Functions

-- Counts non-nil values in a dictionary
local function CountDict(Tbl)
	local Count = 0
	
	for i,_ in Tbl do Count += 1 end
	
	return Count
end

--// Types
export type DatastoreUpdateType = 'never'|'ifdarker'|'iflighter'|'always'

--// Module
local module = {}

-- The minimum GetSkinDarknessAsync required to be allowed in-game.
module.MinSkinDarkness = nil

-- Gets a player's skin color as Color3 value.
function module:GetSkinColorAsync(UserId:number, UseDatastoreDataIfPresent:boolean) : Color3
	if UseDatastoreDataIfPresent and DatastoreModule and DatastoreModule:TryGetPlayerDataFromCache(UserId) then
		return DatastoreModule:TryGetPlayerDataFromCache(UserId).SkinColor
	end
	
	local RequestedCharAppearance = plrs:GetCharacterAppearanceInfoAsync(UserId)
	local BodyColors = RequestedCharAppearance.bodyColors
	local BodyPartsCount = CountDict(BodyColors)
	
	local TotalR = 0
	local TotalG = 0
	local TotalB = 0
	
	for i,v in BodyColors do
		local Color = BrickColor.new(v).Color
		
		TotalR += Color.R * 255
		TotalG += Color.G * 255
		TotalB += Color.B * 255
	end
	
	local AvgR = TotalR / BodyPartsCount
	local AvgG = TotalG / BodyPartsCount
	local AvgB = TotalB / BodyPartsCount
	local AvgSkinColor = Color3.new(AvgR, AvgG, AvgB)
	
	return AvgSkinColor
end

-- Finds how yellow a person's skin color is percentually.
function module:GetSkinYellownessAsync(UserId:number, UseDatastoreDataIfPresent:boolean) : number
	if UseDatastoreDataIfPresent and DatastoreModule and DatastoreModule:TryGetPlayerDataFromCache(UserId) then
		return DatastoreModule:TryGetPlayerDataFromCache(UserId).SkinDarkness
	end
	
	local RequestedCharAppearance = plrs:GetCharacterAppearanceInfoAsync(UserId)
	local BodyColors = RequestedCharAppearance.bodyColors
	local BodyPartsCount = CountDict(BodyColors)

	local TotalR = 0
	local TotalG = 0

	for i,v in BodyColors do
		local Color = BrickColor.new(v).Color

		TotalR += Color.R * 255
		TotalG += Color.G * 255
	end

	local AvgYellowness = ((TotalR / BodyPartsCount) + (TotalG / BodyPartsCount)) / 3
	return math.round(AvgYellowness / 2.55)
end

-- Finds how dark a person's skin color is percentually.
function module:GetSkinDarknessAsync(UserId:number, UseDatastoreDataIfPresent:boolean) : number
	if UseDatastoreDataIfPresent and DatastoreModule and DatastoreModule:TryGetPlayerDataFromCache(UserId) then
		return DatastoreModule:TryGetPlayerDataFromCache(UserId).SkinYellowness
	end
	
	local RequestedCharAppearance = plrs:GetCharacterAppearanceInfoAsync(UserId)
	local BodyColors = RequestedCharAppearance.bodyColors
	local BodyPartsCount = CountDict(BodyColors)

	local TotalR = 0
	local TotalG = 0
	local TotalB = 0

	for i,v in BodyColors do
		local Color = BrickColor.new(v).Color

		TotalR += Color.R * 255
		TotalG += Color.G * 255
		TotalB += Color.B * 255
	end
	
	local AvgDarkness = ((TotalR / BodyPartsCount) + (TotalG / BodyPartsCount) + (TotalB / BodyPartsCount)) / 3
	return math.round(AvgDarkness / 2.55)
end

-- Allows you to set a minimum darkness level (0-100%) required to play.
function module:StartSkinDarknessEnforcement(MinimumSkinDarkness:number)
	assert(not Connections['SkinDarknessEnforcementEvent'], 'Skin darkness is already enforced.')
	assert(math.clamp(MinimumSkinDarkness, 0, 100) == MinimumSkinDarkness, 'MinimumSkinDarkness must be a number 0-100')
	
	module.MinSkinDarkness = math.clamp(MinimumSkinDarkness, 0, 100)

	Connections['SkinDarknessEnforcementEvent'] = plrs.PlayerAdded:Connect(function(Plr:Player)
		local Darkness = module:GetSkinDarknessAsync(Plr.UserId)
		
		if Darkness <= MinimumSkinDarkness then
			plrs:WaitForChild(Plr.Name):Kick('Unexpected client.')
		end
	end)
end

-- Reverses module:StartSkinDarknessEnforcement()
function module:StopSkinDarknessEnforcement()
	assert(Connections['SkinDarknessEnforcementEvent'], 'Skin darkness is not currently enforced.')
	
	Connections['SkinDarknessEnforcementEvent']:Disconnect()
end

-- Starts up a datastore which prevents players from "cheating" by changing their characters.
function module:StartEthnicityDatastore(Name:string, Scope:string?, Options:DataStoreOptions?, UpdateType:DatastoreUpdateType)
	assert(not DatastoreModule, 'EthnicityDatastore already started.')
	local EthnicityDatastore = dss:GetDataStore(Name, Scope, Options)
	
	DatastoreModule = require(script.Datastore)
	DatastoreModule:Start(module, EthnicityDatastore, UpdateType)
end

-- Pauses the events started by StartEthnicityDatastore.
function module:PauseEthnicityDatastore()
	assert(DatastoreModule, 'EthnicityDatastore has not been started.')
	
	DatastoreModule:SetEventRunSwitch(true)
end

-- Resumes the events started by StartEthnicityDatastore after calling module:PauseEthnicityDatastore().
function module:ResumeEthnicityDatastore()
	assert(DatastoreModule, 'EthnicityDatastore has not been started.')
	
	DatastoreModule:SetEventRunSwitch(false)
end

-- Modifies the UpdateType value passed into module:StartEthnicityDatastore()
function module:UpdateSaveNewEthnicityData(UpdateType:DatastoreUpdateType)
	assert(DatastoreModule, 'EthnicityDatastore has not been started.')
	
	DatastoreModule:SetUpdateDatastoreValue(UpdateType)
end

return module
