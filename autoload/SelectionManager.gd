extends Node

var current_selected_player: Player

func _ready() -> void:
	Events.new_player_selection_request.connect(on_player_selected)
	Events.deselect_current_player_request.connect(on_player_deselected)

func on_player_deselected() -> void:
	if current_selected_player != null:
		current_selected_player._on_deselection()
	current_selected_player = null

func on_player_selected(new_player: Player) -> void:
	if current_selected_player == new_player: return
	if GameModeManager.current_mode != GameModeManager.GameMode.PLANNING: return
	
	if current_selected_player != null: 
		current_selected_player._on_deselection()
	
	current_selected_player = new_player
	current_selected_player._on_selection()
	Events.new_player_selected.emit(current_selected_player)
