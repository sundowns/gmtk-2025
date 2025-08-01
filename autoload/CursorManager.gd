extends Node3D

var _collision_mask: int = Constants.PLAYER_COLLISION_MASK
var _camera: Camera3D

#var _current_hovered_component: Area3D = null;
var _is_locked: bool = false

func _ready() -> void:
	#set_process(false)
	set_cursor_lock(false)

func set_camera(camera: Camera3D) -> void:
	_camera = camera;
	#set_process(true);

func set_cursor_lock(is_locked: bool):
	_is_locked = is_locked

	set_process_unhandled_input(!_is_locked);
	set_process(!_is_locked);

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

	#public override void _Process(double delta)
	#{
		#base._Process(delta);
		#// Only perform hover raycast if the mouse is over the game window and not over a UI element 
		#if (Input.MouseMode == Input.MouseModeEnum.Visible)
		#{
			#HoverRaycast(GetViewport().GetMousePosition(), CursorModeMaskMap[Mode]);
		#}
	#}

	#private void HoverRaycast(Vector2 mousePosition, uint collisionMask)
	#{
		#if (Camera == null || !Camera.IsInsideTree()) return;
#
		#Vector3 rayOrigin = Camera.ProjectRayOrigin(mousePosition);
		#Vector3 rayEnd = Camera.ProjectRayNormal(mousePosition) * 1000.0f;
#
		#PhysicsRayQueryParameters3D query = new()
		#{
#
			#From = rayOrigin,
			#To = rayOrigin + rayEnd,
			#CollisionMask = collisionMask,
			#CollideWithAreas = true,
			#CollideWithBodies = false,
		#};
#
		#PhysicsDirectSpaceState3D spaceState = GetWorld3D().DirectSpaceState;
		#Godot.Collections.Dictionary result = spaceState.IntersectRay(query);
#
		#SelectionAreaComponent newHoveredObject = null;
		#if (result.Count > 0)
		#{
			#newHoveredObject = (SelectionAreaComponent)result["collider"];
		#}
#
		#// Check if the hovered object has changed
		#if (newHoveredObject != CurrentHoveredComponent)
		#{
			#UnhoverCurrentSelectionComponent();
#
			#// If a new object is now hovered, highlight it
			#if (newHoveredObject != null)
			#{
				#CurrentHoveredComponent = newHoveredObject;
				#CurrentHoveredComponent.OnCursorHoverStart();
			#}
		#}
	#}

#
	#private void UnhoverCurrentSelectionComponent()
	#{
		#if (CurrentHoveredComponent == null) return;
		#CurrentHoveredComponent.OnCursorHoverEnd();
		#CurrentHoveredComponent = null;
	#}
