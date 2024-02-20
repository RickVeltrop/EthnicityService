--// Services
local plrs = game:GetService('Players')
local dss = game:GetService('DataStoreService')

--// Modules
local Internals = require(script.Internal)

--// Variables
local Connections = {}

--// Module
local module = {}

-- The minimum GetSkinDarknessAsync required to be allowed in-game.
module.MinSkinDarkness = nil

-- Module subdivisions
module.Player = require(script.Player):Setup(module, Internals)
module.Datastore = require(script.Datastore):Setup(module, Internals)

-- Allows you to set a minimum darkness level (0-100%) required to play.
function module:StartSkinDarknessEnforcement(MinimumSkinDarkness:number)
	assert(not Connections['SkinDarknessEnforcementEvent'], 'Skin darkness is already enforced.')
	assert(math.clamp(MinimumSkinDarkness, 0, 100) == MinimumSkinDarkness, 'MinimumSkinDarkness must be a number 0-100')
	
	module.MinSkinDarkness = math.clamp(MinimumSkinDarkness, 0, 100)

	Connections['SkinDarknessEnforcementEvent'] = plrs.PlayerAdded:Connect(function(Plr:Player)
		local Darkness = module.Player:GetSkinDarknessAsync(Plr.UserId)
		
		if Darkness >= MinimumSkinDarkness then
			plrs:WaitForChild(Plr.Name):Kick('Unexpected client.')
		end
	end)
end

-- Reverses module:StartSkinDarknessEnforcement()
function module:StopSkinDarknessEnforcement()
	assert(Connections['SkinDarknessEnforcementEvent'], 'Skin darkness is not currently enforced.')
	
	Connections['SkinDarknessEnforcementEvent']:Disconnect()
end

return module
