local module = {}

module.UpdateType = {
	IfLighter = 0,
	IfDarker = 1,
	Always = 2,
	Never = 3
}
export type UpdateType = typeof(module.UpdateType)

return module
