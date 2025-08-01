extends Node

# { player_id: [ {timestamp, type, data} ] }
var _recorded_actions := {}
var _recording_start_time_msec := 0
var _is_recording := false

func start_recording() -> void:
	clear_actions()
	_is_recording = true
	_recording_start_time_msec = Time.get_ticks_msec()
	print("ActionRecorder: Started recording.")

func stop_recording() -> void:
	_is_recording = false
	print("ActionRecorder: Stopped recording.")

func record_move(player_id: int, target_position: Vector3) -> void:
	if not _is_recording:
		return

	if not _recorded_actions.has(player_id):
		_recorded_actions[player_id] = []
	
	var timestamp_msec = Time.get_ticks_msec() - _recording_start_time_msec
	var action = {
		"timestamp": timestamp_msec / 1000.0, # Convert to seconds
		"type": "MOVE",
		"data": target_position
	}
	_recorded_actions[player_id].append(action)

func get_actions_for_player(player_id: int) -> Array:
	if _recorded_actions.has(player_id):
		return _recorded_actions[player_id]
	return []

func clear_actions() -> void:
	_recorded_actions.clear()
	print("ActionRecorder: All actions cleared.")
