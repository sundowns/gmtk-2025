extends Node3D
class_name Ball

@onready var planning: Node3D = $"Planning"
@onready var replay: Node3D = $"Replay"

func _ready() -> void:
	Events.game_mode_changed.connect(on_game_mode_changed)

func on_game_mode_changed(mode: GameModeManager.GameMode) -> void:
	match mode:
		GameModeManager.GameMode.PLANNING:
			enter_planning_mode()
		GameModeManager.GameMode.REPLAY:
			enter_replay_mode()

func enter_replay_mode() -> void:
	replay.visible = true
	planning.visible = false

func enter_planning_mode() -> void:
	replay.visible = false
	planning.visible = true
