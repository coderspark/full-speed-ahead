extends Control

signal _on_hover
signal _on_hover_exited



func _on_mouse_entered() -> void:
	_on_hover.emit(int(name))


func _on_mouse_exited() -> void:
	_on_hover_exited.emit()
