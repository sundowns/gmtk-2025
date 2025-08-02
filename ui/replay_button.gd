extends Button
class_name ReplayButton

func _ready() -> void:
	focus_mode = Control.FOCUS_NONE
	Events.game_mode_changed.connect(_on_game_mode_changed)

func _on_game_mode_changed(mode: GameModeManager.GameMode):
	match mode:
		GameModeManager.GameMode.PLANNING:
			text = "PLAY"
		GameModeManager.GameMode.REPLAY:
			text = "RESET"

func _on_pressed() -> void:
	GameModeManager.toggle_game_mode()
