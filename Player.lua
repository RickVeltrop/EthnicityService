--// Services
local plrs = game:GetService('Players')

--// Modules
local Internals = require(script.Parent.Internal)

--// Variables
local MainModule

--// Types
export type module = {
	GetSkinColorAsync: (UserId:number, UseDatastoreDataIfPresent:boolean) -> Color3,
	GetSkinYellownessAsync: (UserId:number, UseDatastoreDataIfPresent:boolean) -> number,
	GetSkinDarknessAsync: (UserId:number, UseDatastoreDataIfPresent:boolean) -> number,

	GetCharSkinColor: (Character:Model) -> Color3,
	GetCharSkinYellowness: (Character:Model) -> number,
	GetCharSkinDarkness: (Character:Model) -> number
}

--// Functions
local function GetCharacterSkinColor(Character:Model)
	local Colors = {}

	for i,v in Character:GetChildren() do
		if not v:IsA('BasePart') then continue end
		if v.Name == 'HumanoidRootPart' then continue end

		table.insert(Colors, v.Color)
	end

	return Colors
end

local module = {}

-- Gets a player's skin color as Color3 value.
function module:GetSkinColorAsync(UserId:number, UseDatastoreDataIfPresent:boolean) : Color3
	if UseDatastoreDataIfPresent and Internals.DatastoreLoaded and Internals.Datastore:TryGetPlayerDataFromCache(UserId) then
		return Internals.Datastore:TryGetPlayerDataFromCache(UserId).SkinColor
	end

	local RequestedCharAppearance = plrs:GetCharacterAppearanceInfoAsync(UserId)
	local BodyColors = RequestedCharAppearance.bodyColors

	local ColorsArray = {}
	for i,v in BodyColors do table.insert(ColorsArray, v) end

	return Internals:AverageColor3(ColorsArray)
end

-- Finds how yellow a person's skin color is percentually.
function module:GetSkinYellownessAsync(UserId:number, UseDatastoreDataIfPresent:boolean) : number
	if UseDatastoreDataIfPresent and Internals.DatastoreLoaded and Internals.Datastore:TryGetPlayerDataFromCache(UserId) then
		return Internals.Datastore:TryGetPlayerDataFromCache(UserId).SkinDarkness
	end

	local RequestedCharAppearance = plrs:GetCharacterAppearanceInfoAsync(UserId)
	local BodyColors = RequestedCharAppearance.bodyColors

	local ColorsArray = {}
	for i,v in BodyColors do table.insert(ColorsArray, v) end

	local AvgColor = Internals:AverageColor3(ColorsArray)
	local AvgYellowness = (AvgColor.R + AvgColor.G) / 2
	
	return math.round(AvgYellowness / 2.55)
end

-- Finds how dark a person's skin color is percentually.
function module:GetSkinDarknessAsync(UserId:number, UseDatastoreDataIfPresent:boolean) : number
	if UseDatastoreDataIfPresent and Internals.DatastoreLoaded and Internals.Datastore:TryGetPlayerDataFromCache(UserId) then
		return Internals.Datastore:TryGetPlayerDataFromCache(UserId).SkinYellowness
	end

	local RequestedCharAppearance = plrs:GetCharacterAppearanceInfoAsync(UserId)
	local BodyColors = RequestedCharAppearance.bodyColors

	local ColorsArray = {}
	for i,v in BodyColors do table.insert(ColorsArray, v) end

	local AvgColor = Internals:AverageColor3(ColorsArray)
	local AvgDarkness = (AvgColor.R + AvgColor.G + AvgColor.B) / 3
	
	return 100 - math.round(AvgDarkness / 2.55)
end

-- Gets a character's skin color as Color3 value.
function module:GetCharSkinColor(Character:model) : Color3
	local BodyColors = GetCharacterSkinColor(Character)

	return Internals:AverageColor3(BodyColors)
end

-- Finds how yellow a character's skin color is percentually.
function module:GetCharSkinYellowness(Character:model) : number
	local BodyColors = GetCharacterSkinColor(Character)

	local AvgColor = Internals:AverageColor3(BodyColors)
	local AvgYellowness = (AvgColor.R + AvgColor.G) / 2

	return math.round(AvgYellowness / 2.55)
end

-- Finds how dark a person's skin color is percentually.
function module:GetCharSkinDarkness(Character:model) : number
	local BodyColors = GetCharacterSkinColor(Character)

	local AvgColor = Internals:AverageColor3(BodyColors)
	local AvgDarkness = (AvgColor.R + AvgColor.G + AvgColor.B) / 3

	return 100 - math.round(AvgDarkness / 2.55)
end


export type module = typeof(module)
function module:Setup(Main) : module
	MainModule = Main

	module.Setup = nil

	return module
end


return module
