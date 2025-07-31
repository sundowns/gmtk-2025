extends Node

func _ready() -> void:
	Global.set_current_mode(Global.GameMode.PLANNING)

func _unhandled_input(event: InputEvent) -> void:
	if (event.is_action_pressed("debug_toggle_game_mode")):
		if (Global.current_mode == Global.GameMode.PLANNING):
			Global.set_current_mode(Global.GameMode.REPLAY)
		elif (Global.current_mode == Global.GameMode.REPLAY):
			Global.set_current_mode(Global.GameMode.PLANNING)
