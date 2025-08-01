extends Area3D
class_name SelectableAreaComponent

signal selected

func on_cursor_selection():
	selected.emit()
