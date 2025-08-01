extends Node

var current_mode: GameMode

enum GameMode {
	PLANNING = 0,
	REPLAY = 1,
}

func set_current_mode(mode: GameMode):
	current_mode = mode
	Events.game_mode_changed.emit(current_mode)

	match current_mode:
		GameMode.PLANNING:
			ActionRecorder.start_recording()
		GameMode.REPLAY:
			ActionRecorder.stop_recording()
