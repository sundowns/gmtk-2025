extends Node3D
class_name CurrentPlayer

@export var move_speed: float = 5;

func _ready() -> void:
    pass

func _physics_process(delta: float) -> void:
    var velocity: Vector3 = Vector3.ZERO;
    if Input.is_action_pressed("move_left"):
        velocity -= Vector3(1, 0, 0);
    if Input.is_action_pressed("move_right"):
        velocity += Vector3(1, 0, 0);
    if Input.is_action_pressed("move_up"):
        velocity -= Vector3(0, 0, 1);
    if Input.is_action_pressed("move_down"):
        velocity += Vector3(0, 0, 1);

    if (velocity.length() > 0):
        global_position += velocity.normalized() * move_speed * delta;
