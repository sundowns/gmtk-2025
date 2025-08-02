extends Node3D
class_name Player

@onready var planning: Node3D = $"Planning"
@onready var planning_sprite: Sprite3D = $"Planning/Sprite3D"
@onready var replay: Node3D = $"Replay"
@onready var replay_mesh: MeshInstance3D = $"Replay/ReplayMesh"

@export var is_selected: bool = false
@export var move_speed: float = 3
@export var rotation_speed: float = 7
@export var colour: Color = Color("ff8a8a")

## Replay
var _replay_actions: Array = []
var _replay_timer: float = 0.0
var _current_action_index: int = 0
var _initial_position: Vector3 = Vector3.ZERO
## Recording
var _recording_start_time_msec := 0
var is_recording := false

func _ready() -> void:
	planning_sprite.modulate = Constants.COLOUR_PLAYER_PLANNING_DEFAULT
	Events.game_mode_changed.connect(on_game_mode_changed)
	(replay_mesh.material_override as StandardMaterial3D).albedo_color = colour
	_initial_position = global_position

func _physics_process(delta: float) -> void:
	if GameModeManager.current_mode == GameModeManager.GameMode.PLANNING:
		handle_planning_input(delta)
	elif GameModeManager.current_mode == GameModeManager.GameMode.REPLAY:
		handle_replay(delta)

func handle_planning_input(delta: float) -> void:
	if not is_selected: return

	if Input.is_action_just_pressed("start_recording"):
		_on_recording_request()

	if !is_recording: return # prevent movement outside of recording
	
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
		var direction = velocity.normalized()
		replay_mesh.basis = replay_mesh.basis.slerp(Basis.looking_at(direction), delta * rotation_speed)
		global_position += direction * move_speed * delta
		if is_recording:
			ActionRecorder.record_move(get_instance_id(), global_position, Time.get_ticks_msec() - _recording_start_time_msec)

func handle_replay(delta: float) -> void:
	# Do nothing if there are no actions to play
	if _replay_actions.is_empty():
		return

	_replay_timer += delta

	# If the replay is finished, snap to the final position and stop.
	var last_action = _replay_actions.back()
	if _replay_timer >= last_action.timestamp:
		global_position = last_action.data
		return

	# Find the current and next actions in the sequence
	while _current_action_index + 1 < _replay_actions.size() and _replay_actions[_current_action_index + 1].timestamp < _replay_timer:
		_current_action_index += 1

	var previous_action = _replay_actions[_current_action_index]
	var next_action = _replay_actions[_current_action_index + 1]

	# Interpolate between the two actions based on the timer
	var t = inverse_lerp(previous_action.timestamp, next_action.timestamp, _replay_timer)
	global_position = previous_action.data.lerp(next_action.data, t)

func on_game_mode_changed(mode: GameModeManager.GameMode) -> void:
	match mode:
		GameModeManager.GameMode.PLANNING:
			enter_planning_mode()
		GameModeManager.GameMode.REPLAY:
			enter_replay_mode()

func enter_replay_mode() -> void:
	replay.visible = true
	planning.visible = false
	_replay_actions = ActionRecorder.get_actions_for_player(get_instance_id())
	_replay_timer = 0.0
	_current_action_index = 0
	
	if not _replay_actions.is_empty():
		# Create a "zeroth" action at the beginning of the replay sequence
		# to ensure smooth interpolation from the player's starting position.
		var initial_action = {
			"timestamp": 0.0,
			"type": "MOVE",
			"data": _initial_position
		}
		_replay_actions.insert(0, initial_action)

	# Set initial position for replay
	global_position = _initial_position


func enter_planning_mode() -> void:
	replay.visible = false
	planning.visible = true
	is_recording = false
	global_position = _initial_position

func _on_selectable_area_component_selected() -> void:
	Events.new_player_selection_request.emit(self)

func _on_selection() -> void:
	is_selected = true
	planning_sprite.modulate = Constants.COLOUR_PLAYER_PLANNING_SELECTED

func _on_deselection() -> void:
	is_selected = false
	planning_sprite.modulate = Constants.COLOUR_PLAYER_PLANNING_DEFAULT

func _on_selectable_area_component_hover_end() -> void:
	if is_selected: return
	planning_sprite.modulate = Constants.COLOUR_PLAYER_PLANNING_DEFAULT

func _on_selectable_area_component_hover_start() -> void:
	if is_selected: return
	planning_sprite.modulate = Constants.COLOUR_PLAYER_PLANNING_HOVERED

func _on_recording_request() -> void:
	if is_recording:
		stop_recording()
	else:
		start_recording()
	Events.current_player_is_recording_changed.emit(is_recording)

func stop_recording() -> void:
	is_recording = false
	Events.deselect_current_player_request.emit()
	global_position = _initial_position

func start_recording() -> void:
	planning_sprite.modulate = Constants.COLOUR_PLAYER_PLANNING_RECORDING
	is_recording = true
	_recording_start_time_msec = Time.get_ticks_msec()
	ActionRecorder.start_recording_for_player(get_instance_id())
