extends Control

signal StartGame
signal RestartGame
var shop_current_id = 0

var paused = false

func CallStartGame():
	StartGame.emit()
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		paused = !paused
		get_tree().paused = paused
		$Paused.visible = paused
func gameover():
	get_tree().paused = true
	$GameOver.visible = true

func _on_restart_pressed() -> void:
	get_tree().paused = false
	RestartGame.emit()

func _on_button_pressed() -> void:
	'''
	TODO: Player laten weten welke boat hij wordt 
	
	Je kan shop_current_id gebruiken voor welke button is geklikt
	'''
	print("klik")


func _on_lag_pressed() -> void:
	Engine.max_fps = 4


func _on_quit_pressed() -> void:
	get_tree().quit()

func RandomizeShopContents():
	pass
