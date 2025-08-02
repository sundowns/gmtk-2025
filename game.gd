extends Node

func _ready() -> void:
	GameModeManager.set_current_mode(GameModeManager.GameMode.PLANNING)
