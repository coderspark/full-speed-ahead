extends Control
var game = preload("res://Scenes/MainScene.tscn")

func _on_play_pressed() -> void:
	print("PLAY")
	get_tree().change_scene_to_packed(game)
