extends Node

var _recorded_actions := {}

func start_recording_for_player(player_id: int) -> void:
	# This will clear any existing actions for the player and start a new list.
	_recorded_actions[player_id] = []
	print("ActionRecorder: Started recording for player %d and cleared previous actions." % player_id)

func record_move(player_id: int, target_position: Vector3, recording_time_msec: int) -> void:
	# We only record if a recording has been started for this player.
	if not _recorded_actions.has(player_id):
		return

	var action = {
		"timestamp": recording_time_msec / 1000.0, # Convert to seconds
		"type": "MOVE",
		"data": target_position
	}
	_recorded_actions[player_id].append(action)

func get_actions_for_player(player_id: int) -> Array:
	if _recorded_actions.has(player_id):
		return _recorded_actions[player_id]
	return []

func clear_all_actions() -> void:
	_recorded_actions.clear()
	print("ActionRecorder: All actions cleared.")
