extends Node3D
class_name CameraController

@onready var camera: Camera3D = $Camera3D

@export var target: Node3D
@export var minimum_distance: float = 1

@export var move_speed: float = 4

func _ready() -> void:
	Callable(initialise).call_deferred()
	Events.current_player_is_recording_changed.connect(_on_current_player_is_recording_changed)

func initialise() -> void:
	CursorManager.set_camera(camera)

func _physics_process(delta: float) -> void:
	match GameModeManager.current_mode:
		GameModeManager.GameMode.PLANNING:
			planning_mode_update(delta)
		GameModeManager.GameMode.REPLAY:
			replay_mode_update(delta)


func _on_current_player_is_recording_changed(is_recording: bool) -> void:
	if is_recording:
		target = SelectionManager.current_selected_player

func planning_mode_update(delta: float):
	if (target != null):
		move_towards_target_position(target.global_position, delta)
	else:
		var velocity: Vector3 = Vector3.ZERO
		if Input.is_action_pressed("move_left"):
			velocity -= Vector3(1, 0, 0)
		if Input.is_action_pressed("move_right"):
			velocity += Vector3(1, 0, 0)
		if Input.is_action_pressed("move_up"):
			velocity -= Vector3(0, 0, 1)
		if Input.is_action_pressed("move_down"):
			velocity += Vector3(0, 0, 1)

		if velocity.length() > 0:
			global_position += velocity.normalized() * move_speed * delta
		
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
