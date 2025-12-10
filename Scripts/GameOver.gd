extends Panel

func gameover():
	get_tree().paused = true
	visible = true

func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
