extends Node3D
class_name Player

@onready var planning: Node3D = get_node("Planning")
@onready var replay: Node3D = get_node("Replay")
@onready var replay_mesh: MeshInstance3D = get_node("Replay/ReplayMesh")

@export var is_selected: bool = false
@export var move_speed: float = 3
@export var rotation_speed: float = 7
@export var colour: Color = Color("ff8a8a")

func _ready() -> void:
	Events.game_mode_changed.connect(on_game_mode_changed)
	(replay_mesh.material_override as StandardMaterial3D).albedo_color = colour

func _physics_process(delta: float) -> void:
	if GameModeManager.current_mode != GameModeManager.GameMode.PLANNING: return
	if !is_selected: return
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
		var direction = velocity.normalized()
		replay_mesh.basis = replay_mesh.basis.slerp(Basis.looking_at(direction), delta * rotation_speed)
		global_position += direction * move_speed * delta;

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

func _on_selectable_area_component_selected() -> void:
	Events.new_player_selection_request.emit(self)

func _on_selection() -> void:
	is_selected = true

func _on_deselection() -> void:
	is_selected = false
