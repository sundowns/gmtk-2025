extends Node

func _ready() -> void:
	GameModeManager.set_current_mode(GameModeManager.GameMode.PLANNING)

func _unhandled_input(event: InputEvent) -> void:
	if (event.is_action_pressed("debug_toggle_game_mode")):
		if (GameModeManager.current_mode == GameModeManager.GameMode.PLANNING):
			GameModeManager.set_current_mode(GameModeManager.GameMode.REPLAY)
		elif (GameModeManager.current_mode == GameModeManager.GameMode.REPLAY):
			GameModeManager.set_current_mode(GameModeManager.GameMode.PLANNING)
