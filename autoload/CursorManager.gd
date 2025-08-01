extends Node3D

var _collision_mask: int = Constants.PLAYER_COLLISION_MASK
var _camera: Camera3D

var _current_hovered_component: SelectableAreaComponent = null;
var _is_locked: bool = false

func _ready() -> void:
	set_physics_process(false)
	set_cursor_lock(false)

func set_camera(camera: Camera3D) -> void:
	_camera = camera;
	set_physics_process(true);
	unhover_current_selection_component()

func set_cursor_lock(is_locked: bool):
	_is_locked = is_locked

	set_process_unhandled_input(!_is_locked);
	set_physics_process(!_is_locked);

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("select"):
		selection_raycast(get_viewport().get_mouse_position());

func selection_raycast(mouse_position: Vector2):
	if (!_camera || !_camera.is_inside_tree()): 
		return
	await get_tree().physics_frame

	var ray_origin: Vector3 = _camera.project_ray_origin(mouse_position)
	var ray_end: Vector3 = _camera.project_ray_normal(mouse_position) * 1000.0

	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_origin + ray_end, _collision_mask, [])
	query.collide_with_areas = true
	query.collide_with_bodies = false

	var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state;
	var result = space_state.intersect_ray(query)

	if (result.size() > 0):
		var selected_component: SelectableAreaComponent = result["collider"] as SelectableAreaComponent
		selected_component.on_cursor_selection();

func _physics_process(_delta: float) -> void:
 	#Only perform hover raycast if the mouse is over the game window and not over a UI element 
	if (Input.mouse_mode == Input.MouseMode.MOUSE_MODE_VISIBLE):
		hover_raycast(get_viewport().get_mouse_position())

func hover_raycast(mouse_position: Vector2) -> void:
	if (!_camera || !_camera.is_inside_tree()): 
		return
	
	var ray_origin: Vector3 = _camera.project_ray_origin(mouse_position)
	var ray_end: Vector3 = _camera.project_ray_normal(mouse_position) * 1000.0

	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_origin + ray_end, _collision_mask, [])
	query.collide_with_areas = true
	query.collide_with_bodies = false

	var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state;
	var result = space_state.intersect_ray(query)

	var new_hovered_object: SelectableAreaComponent = null;
	if (result.size() > 0):
		new_hovered_object = result["collider"] as SelectableAreaComponent

	if (new_hovered_object != _current_hovered_component):
		unhover_current_selection_component();
		if (new_hovered_object != null):
			_current_hovered_component = new_hovered_object;
			_current_hovered_component.on_cursor_hover_start();

func unhover_current_selection_component():
	if (_current_hovered_component == null): return
	_current_hovered_component.on_cursor_hover_end()
	_current_hovered_component = null;
