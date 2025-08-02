extends Node3D
class_name CameraController

@onready var camera: Camera3D = $Camera3D

@export var target: Node3D
@export var minimum_distance: float = 1

@export var move_speed: float = 4

func _ready() -> void:
	Callable(initialise).call_deferred()
	Events.new_player_selected.connect(_on_new_player_selected)

func initialise() -> void:
	CursorManager.set_camera(camera)

func _physics_process(delta: float) -> void:
	match GameModeManager.current_mode:
		GameModeManager.GameMode.PLANNING:
			planning_mode_update(delta)
		GameModeManager.GameMode.REPLAY:
			replay_mode_update(delta)
	
func _on_new_player_selected(player: Player) -> void:
	target = player

func planning_mode_update(delta: float):
	if (target != null):
		move_towards_target_position(target.global_position, delta)
		
func replay_mode_update(delta: float):
	var count: int = 0
	var aggregate_position: Vector3 = Vector3.ZERO
	for node in get_tree().get_nodes_in_group("Players"):
		if node is not Player: continue # shouldnt happen but oh well
		aggregate_position += (node as Player).global_position
		count += 1
	var average_position := aggregate_position/count
	move_towards_target_position(average_position, delta)

func move_towards_target_position(target_position: Vector3, delta: float):
	global_position = global_position.lerp(target_position, 1.0 - exp(-delta * move_speed))
