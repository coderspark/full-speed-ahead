extends Node2D
var game = preload("res://Scenes/MainScene.tscn")

func _ready() -> void:
	$Fade/Animations.play("fade_out")
	await $Fade/Animations.animation_finished

func _on_play_pressed() -> void:
	print("PLAY")
	$Fade/Animations.play("fade_in")
	await $Fade/Animations.animation_finished
	$MainMenu.queue_free()
	add_child(game.instantiate())
	$Camera.queue_free()
	$Fade/Animations.play("fade_out")
	await $Fade/Animations.animation_finished


func _on_quit_pressed() -> void:
	get_tree().quit()
