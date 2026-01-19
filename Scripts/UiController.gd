extends Control

signal StartGame
signal RestartGame

var ShopOpen = false

var current_shop_contents = []

var paused = false

func _ready() -> void:
	RandomizeShopContents()
	$Canvas/Shop.hide()

func CallStartGame():
	StartGame.emit()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ADMIN"):
		RandomizeShopContents()
	if Input.is_action_just_pressed("pause"):
		if ShopOpen:
			ShopOpen = false
			$Canvas/Shop.hide()
			get_tree().paused = false
			return
		paused = !paused
		get_tree().paused = paused
		$Canvas/Paused.visible = paused
func gameover():
	get_tree().paused = true
	$Canvas/GameOver.visible = true

func _on_restart_pressed() -> void:
	get_tree().paused = false
	$Canvas/GameOver/restart.disabled = true
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
		var n : String = Global.BOAT_STATS.keys().pick_random()
		while n in Boats:
			n = Global.BOAT_STATS.keys().pick_random()
		Boats.append(n)
		$Canvas/Shop.get_node("Boat" + str(i + 1)).disabled = false
		var text = n.replace_char(95,32) # "_" -> " "
		text = text + "\n" + "      " + str(Global.BOAT_STATS[n]["cost"])
		get_node("Canvas/Shop/Boat" + str(i+1) + "/Label").text = text
		get_node("Canvas/Shop/Boat" + str(i+1) + "/Texture").texture = load("res://Assets/Art/Boats/" + n + ".png")
	current_shop_contents = Boats
	var Food : Array = []
	for i in range(6):
		var n = Global.FoodItems.keys().pick_random()
		$Canvas/Shop.get_node("Food" + str(i + 1)).disabled = false
		while n in Food:
			n = Global.FoodItems.keys().pick_random()
		Food.append(n)
		var text = n.replace_char(95,32) # "_" -> " "
		text = text + "\n" + "      " + str(Global.FoodItems[n][0])
		get_node("Canvas/Shop/Food" + str(i+1) + "/Label").text = text
		get_node("Canvas/Shop/Food" + str(i+1) + "/Texture").texture = load("res://Assets/Art/Food/" + n + ".png")
	current_shop_contents.append_array(Food)
	
func ShowShop():
	get_tree().paused = true
	$Canvas/Shop.show()
	ShopOpen = true

func ShopButtonPressed(id:int):
	if id <= 2:
		if Global.BOAT_STATS[current_shop_contents[id]]["cost"] < $"../Players/Player".coins:
			$"../Players/Player".coins -= Global.BOAT_STATS[current_shop_contents[id]]["cost"]
			$"../Players/Player".UpdateCoinCount()
			$Canvas/Shop.get_node("Boat" + str(id + 1)).disabled = true
			$"../Players/Player".UpdateBoat(current_shop_contents[id])
	else:
		if Global.FoodItems[current_shop_contents[id]][0] < $"../Players/Player".coins:
			$"../Players/Player".coins -= Global.FoodItems[current_shop_contents[id]][0]
			$"../Players/Player".UpdateCoinCount()
			$Canvas/Shop.get_node("Food" + str(id -2)).disabled = true
			$"../Players/Player".AddFoodItemToInventory(current_shop_contents[id])
			
