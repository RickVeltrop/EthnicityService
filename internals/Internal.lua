local module = {}

module.Datastore = require(script.Datastore)
module.DatastoreLoaded = false

-- Counts non-nil values in a dictionary
function module:CountDict(Tbl)
	local Count = 0

	for i,_ in Tbl do Count += 1 end

	return Count
end

return module
