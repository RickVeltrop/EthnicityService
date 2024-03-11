local MainModule

local module = {}

module.Datastore = nil
module.DatastoreLoaded = false

function module:Start(Module)
	MainModule = Module
	module.Datastore = require(script.Datastore):Start(MainModule)
end

-- Counts non-nil values in a dictionary
function module:CountDict(Tbl) : number
	local Count = 0

	for i,_ in Tbl do Count += 1 end

	return Count
end

-- Calculates the average RGB values of a table of Color3 values
function module:AverageColor3(Colors:{Color3}|Color3) : Color3
	if typeof(Colors) == 'Color3' then Colors = {Colors} end
	local ColorsCount = module:CountDict(Colors)
	
	local TotalR = 0
	local TotalG = 0
	local TotalB = 0

	for i,v in Colors do
		local Color = BrickColor.new(v).Color

		TotalR += Color.R * 255
		TotalG += Color.G * 255
		TotalB += Color.B * 255
	end

	local AvgR = TotalR / ColorsCount
	local AvgG = TotalG / ColorsCount
	local AvgB = TotalB / ColorsCount
	local AvgColor = Color3.new(AvgR, AvgG, AvgB)

	return AvgColor
end

return module
