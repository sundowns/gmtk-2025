extends Node

@warning_ignore("unused_signal")
signal game_mode_changed(mode: GameModeManager.GameMode)

@warning_ignore("unused_signal")
signal new_player_selection_request(player: Player)

@warning_ignore("unused_signal")
signal new_player_selected(player: Player)
