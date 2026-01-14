extends Node2D
var game = preload("res://Scenes/MainScene.tscn")

@onready var LevelBG = preload("res://Assets/Art/UI/WorldMap/worldmap.png")

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
	Global.LevelName = lvl
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


func _on_paaseiland_mouse_entered() -> void:
	$LevelSelect/BG.texture = preload("res://Assets/Art/UI/WorldMap/worldmap5.png")
	$LevelSelect/Info.text = "[font_size=30]Paaseiland
Difficulty: [color=D30000]Hard[/color]
Length: [color=D30000]Long[/color]
"

func _on_jakarta_mouse_entered() -> void:
	$LevelSelect/BG.texture = preload("res://Assets/Art/UI/WorldMap/worldmap4.png")
	$LevelSelect/Info.text = "[font_size=30]Jakarta
Difficulty: [color=D30000]Hard[/color]
Length: [color=D30000]Long[/color]
"

func _on_kaap_de_goede_hoop_mouse_entered() -> void:
	$LevelSelect/BG.texture = preload("res://Assets/Art/UI/WorldMap/worldmap3.png")
	$LevelSelect/Info.text = "[font_size=30]Kaap de goede hoop
Difficulty: [color=FFA500]Medium[/color]
Length: [color=FFA500]Medium[/color]
"
func _on_portugal_mouse_entered() -> void:
	$LevelSelect/BG.texture = preload("res://Assets/Art/UI/WorldMap/worldmap2.png")
	$LevelSelect/Info.text = "[font_size=30]Portugal
Difficulty: [color=00BF00]Easy[/color]
Length: [color=00BF00]Short[/color]
"
func _on_engeland_mouse_entered() -> void:
	$LevelSelect/BG.texture = preload("res://Assets/Art/UI/WorldMap/worldmap1.png")
	$LevelSelect/Info.text = "[font_size=30]Engeland
Difficulty: [color=00BF00]Easy[/color]
Length: [color=00BF00]Short[/color]
"

func _on_mouse_exited() -> void:
	$LevelSelect/BG.texture = LevelBG
	$LevelSelect/Info.text = ""
