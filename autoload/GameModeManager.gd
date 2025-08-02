extends Node

var current_mode: GameMode

enum GameMode {
	PLANNING = 0,
	REPLAY = 1,
}

func set_current_mode(mode: GameMode):
	current_mode = mode
	Events.game_mode_changed.emit(current_mode)

func toggle_game_mode():
	if (current_mode == GameMode.PLANNING):
		set_current_mode(GameMode.REPLAY)
	elif (current_mode == GameMode.REPLAY):
		set_current_mode(GameMode.PLANNING)
