extends Control

signal StartGame
signal RestartGame
var shop_current_id = 0

var paused = false

func _ready() -> void:
	RandomizeShopContents()

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
	$GameOver/restart.disabled = true
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
	var Boats = []
	for i in range(3):
		var n = Global.BOAT_STATS.keys().pick_random()
		while n in Boats:
			n = Global.BOAT_STATS.keys().pick_random()
		Boats.append(n)
		get_node("Shop/Boat" + str(i+1) + "/Label").text = n
		get_node("Shop/Boat" + str(i+1) + "/Texture").texture = load("res://Assets/Art/Boats/" + n)
	var Food = []
	for i in range(6):
		var n = Global.FoodItems.keys().pick_random()
		Boats.append(n)
	
