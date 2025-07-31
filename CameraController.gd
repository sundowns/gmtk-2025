extends Node3D
class_name CameraController

@onready var camera: Camera3D;

@export var target: Node3D
@export var minimum_distance: float = 1

@export var move_speed: float = 4

func _physics_process(_delta: float) -> void:
	if (target != null):
		global_position = target.global_position
