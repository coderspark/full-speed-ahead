extends Node2D
var game = preload("res://Scenes/MainScene.tscn")
var tutorial = preload("res://Scenes/Tutorial_scene.tscn")

@onready var LevelBG = preload("res://Assets/Art/UI/WorldMap/worldmap.png")

func _ready() -> void:
	get_tree().paused = false
	$Fade/Animations.play("fade_out")
	await $Fade/Animations.animation_finished
	$LevelSelect.hide()
	if ResourceLoader.load(Global.SAVE_PATH + Global.SAVE_NAME,"",ResourceLoader.CACHE_MODE_IGNORE) == null:
		ResourceSaver.save(SaveLoadData.new(),Global.SAVE_PATH + Global.SAVE_NAME)
	Global.SaveFile = ResourceLoader.load(Global.SAVE_PATH + Global.SAVE_NAME,"",ResourceLoader.CACHE_MODE_IGNORE).duplicate(true)
	Global.Coins = Global.SaveFile.SaveData["Coins"]
	$LevelSelect/Coins.text = str(Global.Coins)

func _on_play_pressed() -> void:
	$MainMenu/Animations.play("Play")

func NewGame():
	Global.SaveFile = SaveLoadData.new()
	Global.Coins = Global.SaveFile.SaveData["Coins"]
	$LevelSelect/Coins.text = str(Global.Coins)
	LevelSelect()


func LoadGame():
	Global.SaveFileLoaded = true
	Global.SaveFile = ResourceLoader.load(Global.SAVE_PATH + Global.SAVE_NAME,"",ResourceLoader.CACHE_MODE_IGNORE).duplicate(true)
	Global.LevelName = Global.SaveFile.CurrentLevelData["Name"]
	if Global.SaveFile.IsInGame:
		$Fade/Animations.play("fade_in")
		await $Fade/Animations.animation_finished
		get_tree().paused = false
		$LevelSelect.queue_free()
		Global.CurrentDay = 1
		var n = game.instantiate()
		n.name = "MainScene"
		add_child(n)
		$MainMenu.queue_free()
		$MainMenu/MainMenuMusic.queue_free()
		$Camera.queue_free()
		$Fade/Animations.play("fade_out")
		await $Fade/Animations.animation_finished
	else:
		LevelSelect()

func LevelSelect():
	$LevelSelect/Coins.text = str(Global.Coins)
	$Fade/Animations.play("fade_in")
	await $Fade/Animations.animation_finished
	$MainMenu.hide()
	$LevelSelect.show()
	$Fade/Animations.play("fade_out")
	await $Fade/Animations.animation_finished

func CoinSelect(lvl:String):
	Global.LevelName = lvl
	$LevelSelect/CoinSelect.visible = true
	$LevelSelect/CoinSelect/AnimationPlayer.play("fall")
	await $LevelSelect/CoinSelect/AnimationPlayer.animation_finished

func StartGame():
	Global.SaveFileLoaded = false
	Global.BroughtCoins = int($LevelSelect/CoinSelect/TextEdit.text)
	Global.Coins -= Global.BroughtCoins
	$LevelSelect/Paaseiland.disabled = true
	$LevelSelect/Jakarta.disabled = true
	$LevelSelect/KaapDeGoedeHoop.disabled = true
	$LevelSelect/Portugal.disabled = true
	$LevelSelect/Engeland.disabled = true
	if $MainMenu/MainMenuMusic != null:
		$MainMenu/MainMenuMusic.queue_free()
	$Fade/Animations.play("fade_in")
	await $Fade/Animations.animation_finished
	get_tree().paused = false
	$LevelSelect.queue_free()
	Global.CurrentDay = 1
	var n = game.instantiate()
	n.name = "MainScene"
	add_child(n)
	$Camera.queue_free()
	$Fade/Animations.play("fade_out")
	await $Fade/Animations.animation_finished

func RestartGame():
	Global.SaveFileLoaded = false
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


func _on_tutorial_pressed() -> void:
	$Fade/Animations.play("fade_in")
	await $Fade/Animations.animation_finished
	get_tree().paused = false
	$MainMenu.queue_free()
	$LevelSelect.queue_free()
	Global.LevelName = "Tutorial"
	Global.CurrentDay = 0
	var n = tutorial.instantiate()
	n.name = "MainScene"
	add_child(n)
	$Camera.queue_free()
	$Fade/Animations.play("fade_out")
	await $Fade/Animations.animation_finished


func _on_back_pressed() -> void:
	$MainMenu/Animations.play("Un-Play")
