extends Control
var game = preload("res://node_2d.tscn")

func _on_play_pressed() -> void:
	print("PLAY")
	get_tree().change_scene_to_packed(game)
