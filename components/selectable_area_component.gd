extends Area3D
class_name SelectableAreaComponent

signal selected
signal hover_start
signal hover_end

func on_cursor_selection():
	selected.emit()

func on_cursor_hover_start():
	if (!is_instance_valid(self)): return
	hover_start.emit()
	
func on_cursor_hover_end():
	if (!is_instance_valid(self)): return
	hover_end.emit()
