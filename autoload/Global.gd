extends Node

var current_mode: GameMode

enum GameMode {
	PLANNING = 0,
	REPLAY = 1,
}

func set_current_mode(mode: GameMode):
	current_mode = mode
	Events.GameModeChanged.emit(current_mode)
