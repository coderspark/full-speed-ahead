extends Node2D

func _ready() -> void:
	print("LOADED LEVEL: " + Global.LevelName)

func _on_ui_restart_game() -> void:
	get_parent().RestartGame()
