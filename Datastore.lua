--// Services
local plrs = game:GetService('Players')
local dss = game:GetService('DataStoreService')

--// Modules
local MainModule
local Internals = require(script.Parent.Internal)

--// Types
export type DatastoreUpdateType = 'never'|'ifdarker'|'iflighter'|'always'
export type module = {
	StartEthnicityDatastore: (Name:string, Scope:string?, Options:DataStoreOptions?, UpdateType:DatastoreUpdateType) -> nil,
	PauseEthnicityDatastore: () -> nil,
	ResumeEthnicityDatastore: () -> nil,
	UpdateSaveNewEthnicityData: (UpdateType:DatastoreUpdateType) -> nil
}

local module = {}

-- Starts up a datastore which prevents players from "cheating" by changing their characters.
function module:StartEthnicityDatastore(Name:string, Scope:string?, Options:DataStoreOptions?, UpdateType:Internals.UpdateType)
	assert(not Internals.DatastoreLoaded, 'EthnicityDatastore already started.')
	local EthnicityDatastore = dss:GetDataStore(Name, Scope, Options)

	Internals.Datastore:Start(MainModule, EthnicityDatastore, UpdateType)
	Internals.DatastoreLoaded = true
end

-- Pauses the events started by StartEthnicityDatastore.
function module:PauseEthnicityDatastore()
	assert(Internals.DatastoreLoaded, 'EthnicityDatastore has not been started.')

	Internals.Datastore:SetEventRunSwitch(true)
end

-- Resumes the events started by StartEthnicityDatastore after calling module:PauseEthnicityDatastore().
function module:ResumeEthnicityDatastore()
	assert(Internals.DatastoreLoaded, 'EthnicityDatastore has not been started.')

	Internals.Datastore:SetEventRunSwitch(false)
end

-- Modifies the UpdateType value passed into module:StartEthnicityDatastore()
function module:UpdateSaveNewEthnicityData(UpdateType:DatastoreUpdateType)
	assert(Internals.DatastoreLoaded, 'EthnicityDatastore has not been started.')

	Internals.Datastore:SetUpdateDatastoreValue(UpdateType)
end


export type module = typeof(module)
function module:Setup(Module) : module
	MainModule = Module

	module.Setup = nil

	return module
end


return module
