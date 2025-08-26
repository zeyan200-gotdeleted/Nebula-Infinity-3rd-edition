export type PluginModule = {
	__init: (Core: any, Player: Player) -> (),

}

export type PlayerPlugins = {
	[string]: boolean
}

return {}
