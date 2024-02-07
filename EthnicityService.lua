local plrs = game:GetService('Players')

local MinSkinDarkness
local SkinDarknessEnforcementEvent

local function CountDict(Tbl)
	local Count = 0
	
	for i,_ in Tbl do Count += 1 end
	
	return Count
end

local module = {}

function module:GetSkinColorAsync(UserId:number) : Color3
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

function module:GetSkinYellownessAsync(UserId) : number
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

function module:GetSkinDarknessAsync(UserId) : number
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

function module:StartSkinDarknessEnforcement(MinimumSkinDarkness:number)
	assert(not SkinDarknessEnforcementEvent, 'Skin darkness is already enforced.')
	
	MinSkinDarkness = math.clamp(MinimumSkinDarkness, 0, 255)

	SkinDarknessEnforcementEvent = plrs.PlayerAdded:Connect(function(Plr:Player)
		local Darkness = module:GetSkinDarknessAsync(Plr.UserId)
		
		if Darkness <= MinimumSkinDarkness then
			plrs:WaitForChild(Plr.Name):Kick('Unexpected client.')
		end
	end)
end

function module:UpdateSkinEnforcementDarkness(MinimumSkinDarkness:number)
	MinSkinDarkness = math.clamp(MinimumSkinDarkness, 0, 255)
end

function module:StopSkinDarknessEnforcement()
	assert(SkinDarknessEnforcementEvent, 'Skin darkness is not currently enforced.')
	
	SkinDarknessEnforcementEvent:Disconnect()
end

return module
