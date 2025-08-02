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

func _physics_process(_delta: float) -> void:
	if (target != null):
		global_position = global_position.lerp(target.global_position, 1.0 - exp(-_delta * move_speed))

func _on_new_player_selected(player: Player) -> void:
	target = player
