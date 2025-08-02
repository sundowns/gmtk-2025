extends Control
class_name ReplayUi

@onready var button: Button = $Button

func _ready() -> void:
	focus_mode = Control.FOCUS_NONE
	Events.game_mode_changed.connect(_on_game_mode_changed)

func _on_game_mode_changed(mode: GameModeManager.GameMode):
	match mode:
		GameModeManager.GameMode.PLANNING:
			button.text = "PLAY"
		GameModeManager.GameMode.REPLAY:
			button.text = "RESET"

func _on_button_pressed() -> void:
	GameModeManager.toggle_game_mode()
