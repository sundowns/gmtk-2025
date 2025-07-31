extends MeshInstance3D
class_name Pitch

@export var planning_material: Material
@export var replay_material: Material

func _ready() -> void:
	Events.GameModeChanged.connect(on_game_mode_changed)

func on_game_mode_changed(mode: Global.GameMode) -> void:
	if mode == Global.GameMode.PLANNING:
		material_override = planning_material
	elif mode == Global.GameMode.REPLAY:
		material_override = replay_material
