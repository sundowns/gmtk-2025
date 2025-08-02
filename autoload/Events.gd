extends Node

@warning_ignore("unused_signal")
signal game_mode_changed(mode: GameModeManager.GameMode)

@warning_ignore("unused_signal")
signal new_player_selection_request(player: Player)
@warning_ignore("unused_signal")
signal new_player_selected(player: Player)
@warning_ignore("unused_signal")
signal deselect_current_player_request
@warning_ignore("unused_signal")
signal player_deselected # no player is selected (not fired when selection changes between players)

@warning_ignore("unused_signal")
signal start_stop_recording_request
@warning_ignore("unused_signal")
signal current_player_is_recording_changed(is_recording: bool)
