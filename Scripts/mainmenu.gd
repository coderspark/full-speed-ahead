extends Node2D
var game = preload("res://Scenes/MainScene.tscn")

func _ready() -> void:
	$Fade/Animations.play("fade_out")
	await $Fade/Animations.animation_finished
	$LevelSelect.hide()

func _on_play_pressed() -> void:
	print("PLAY")
	$Fade/Animations.play("fade_in")
	await $Fade/Animations.animation_finished
	$MainMenu.hide()
	$LevelSelect.show()
	$Fade/Animations.play("fade_out")
	await $Fade/Animations.animation_finished


func StartGame(lvl:String):
	$Fade/Animations.play("fade_in")
	await $Fade/Animations.animation_finished
	$LevelSelect.queue_free()
	var n = game.instantiate()
	n.name = "MainScene"
	add_child(n)
	$Camera.queue_free()
	$Fade/Animations.play("fade_out")
	await $Fade/Animations.animation_finished

func RestartGame():
	$Fade/Animations.play("fade_in")
	await $Fade/Animations.animation_finished
	print(get_children())
	$MainScene.name = "1"
	var n = game.instantiate()
	n.name = "MainScene"
	add_child(n)
	$"1".queue_free()
	$Fade/Animations.play("fade_out")
	await $Fade/Animations.animation_finished
func _on_quit_pressed() -> void:
	get_tree().quit()
