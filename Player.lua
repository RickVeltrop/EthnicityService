--// Services
local plrs = game:GetService('Players')

--// Variables
local MainModule
local Internals

--// Types
export type module = {
	GetSkinColorAsync: (UserId:number, UseDatastoreDataIfPresent:boolean) -> Color3,
	GetSkinYellownessAsync: (UserId:number, UseDatastoreDataIfPresent:boolean) -> number,
	GetSkinDarknessAsync: (UserId:number, UseDatastoreDataIfPresent:boolean) -> number
}

local module = {}

-- Gets a player's skin color as Color3 value.
function module:GetSkinColorAsync(UserId:number, UseDatastoreDataIfPresent:boolean) : Color3
	if UseDatastoreDataIfPresent and Internals.DatastoreLoaded and Internals.Datastore:TryGetPlayerDataFromCache(UserId) then
		return Internals.Datastore:TryGetPlayerDataFromCache(UserId).SkinColor
	end

	local RequestedCharAppearance = plrs:GetCharacterAppearanceInfoAsync(UserId)
	local BodyColors = RequestedCharAppearance.bodyColors
	local BodyPartsCount = Internals:CountDict(BodyColors)

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
	if UseDatastoreDataIfPresent and Internals.DatastoreLoaded and Internals.Datastore:TryGetPlayerDataFromCache(UserId) then
		return Internals.Datastore:TryGetPlayerDataFromCache(UserId).SkinDarkness
	end

	local RequestedCharAppearance = plrs:GetCharacterAppearanceInfoAsync(UserId)
	local BodyColors = RequestedCharAppearance.bodyColors
	local BodyPartsCount = Internals:CountDict(BodyColors)

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
	if UseDatastoreDataIfPresent and Internals.DatastoreLoaded and Internals.Datastore:TryGetPlayerDataFromCache(UserId) then
		return Internals.Datastore:TryGetPlayerDataFromCache(UserId).SkinYellowness
	end

	local RequestedCharAppearance = plrs:GetCharacterAppearanceInfoAsync(UserId)
	local BodyColors = RequestedCharAppearance.bodyColors
	local BodyPartsCount = Internals:CountDict(BodyColors)

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
	return 100 - math.round(AvgDarkness / 2.55)
end



function module:Setup(Main, Internal)
	MainModule = Main
	Internals = Internal
	
	module.Setup = nil
	
	return module
end

return module
