export type Logger = {
	newLog: (self: any, message: string, important: boolean?) -> (),
}

export type Notifications = {
	create: (Player: Player, message: string) -> (),
}

export type Server = {

	JoinPlayer: (senderId: number, userId: number) -> (),
	Shutdown: () -> (),
	Migrate: () -> (),
	UniversalShutdown: () -> (),
	UniversalMigrate : () -> (),
	Lock : (rank: string) -> (),
	Announce : (sender: Player | number, message: string) -> (),
	UniversalAnnounce : (sender: Player, message: string) -> (),
	Unlock : () -> (),
	UniversalLock : (rank: string) -> (),
	UniversalUnlock : () -> (),

} 

export type Data = {

	UpdateValue : ( valueName : (any) , newValue : (any) , player : Player ) -> (),
	ReturnValue : ( valueName : (any), player : Player ) -> (),

}

export type BanHandler = {

	IsBanned : (Player: number | string) -> (),
	PermBan : (Player: Player, Reason: string) -> (),
	TimeBan : (Player: Player, Reason: string, Duration: number) -> (),
	ServerBan : (Player: Player, Reason: string) -> (),
	UnBan : (Player : Player ) -> (),

}

export type WarningHandler = {

	Warn : ( Player : Player, Reason : string, Admin : Player) -> (),
	GetWarningsByUserId : ( Player : Player | number ) -> (),
	ClearAllWarnings : ( Player : Player | number ) -> (),

}

export type Core = {
	File: Instance,
	Client: Instance,
	Logger: Logger,
	Notifications: Notifications,
	Server: Server,
	Data: Data,
	BanHandler: BanHandler,
	WarningHandler:  WarningHandler,
	
	ProtectedRun: (thread: () -> ()) -> (),
	AdminCount: () -> number,

}

return {

	Logger = Logger,
	Notifications = Notifications,
	Server = Server,
	Data = Data,
	BanHandler = BanHandler,
	WarningHandler = WarningHandler,

	Core = Core,
}
