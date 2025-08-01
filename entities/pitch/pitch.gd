extends MeshInstance3D
class_name Pitch

@export var planning_material: Material
@export var replay_material: Material

func _ready() -> void:
	Events.game_mode_changed.connect(on_game_mode_changed)

func on_game_mode_changed(mode: GameModeManager.GameMode) -> void:
	if mode == GameModeManager.GameMode.PLANNING:
		material_override = planning_material
	elif mode == GameModeManager.GameMode.REPLAY:
		material_override = replay_material
