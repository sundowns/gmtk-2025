extends Control
class_name RecordingUI

@onready var button: Button = $RecordButton
@onready var text_label: Label = $RecordButton/HBoxContainer/Label

func _ready() -> void:
	visible = false
	Events.game_mode_changed.connect(_on_game_mode_changed)
	Events.new_player_selected.connect(_on_new_player_selected)
	Events.player_deselected.connect(_on_player_deselected)
	Events.current_player_is_recording_changed.connect(_on_player_is_recording_changed)

func _on_record_button_pressed() -> void:	
	Events.start_stop_recording_request.emit()
	
func _on_game_mode_changed(mode: GameModeManager.GameMode):
	match mode:
		GameModeManager.GameMode.REPLAY:
			visible = false

func _on_player_deselected():
	visible = false

func _on_new_player_selected(player: Player):
	visible = true

func _on_player_is_recording_changed(is_recording: bool):
	if is_recording:
		text_label.text = "STOP"
	else:
		text_label.text = "RECORD"
