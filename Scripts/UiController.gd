extends Control

signal StartGame
signal RestartGame
signal AnimationFinished

var ShopRerollCost := 0.0

var ShopOpen = false

var current_shop_contents = []
var Inventory = {}

var paused = false

func _ready() -> void:
	RandomizeShopContents()
	FormatInventory(Inventory)
	$Canvas/Shop.hide()

func CallStartGame():
	StartGame.emit()

func _process(_delta: float) -> void:
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
		get_node("Canvas/Shop/Boat" + str(i+1) + "/Coin").show()
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
		get_node("Canvas/Shop/Food" + str(i+1) + "/Coin").show()
		
		get_node("Canvas/Shop/Food" + str(i+1) + "/Texture").texture = load("res://Assets/Art/Food/" + n + ".png")
	current_shop_contents.append_array(Food)
	
func ShowShop():
	get_tree().paused = true
	$Canvas/Shop.show()
	ShopOpen = true

func ShopButtonPressed(id:int):
	if id <= 2:
		if Global.BOAT_STATS[current_shop_contents[id]]["cost"] <= $"../Players/Player".coins:
			$"../Players/Player".coins -= Global.BOAT_STATS[current_shop_contents[id]]["cost"]
			$"../Players/Player".UpdateCoinCount()
			#$Canvas/Shop.get_node("Boat" + str(id + 1)).disabled = true
			#$Canvas/Shop.get_node("Boat" + str(id + 1) + "/Texture").texture = preload("res://Assets/Art/Temp/sold_out.png")
			#$Canvas/Shop.get_node("Boat" + str(id + 1) + "/Label").text = "SOLD OUT"
			#$Canvas/Shop.get_node("Boat" + str(id + 1) + "/Coin").hide()
			$"../Players/Player".UpdateBoat(current_shop_contents[id])
	else:
		if Global.FoodItems[current_shop_contents[id]][0] <= $"../Players/Player".coins:
			$"../Players/Player".coins -= Global.FoodItems[current_shop_contents[id]][0]
			$"../Players/Player".UpdateCoinCount()
			#$Canvas/Shop.get_node("Food" + str(id -2)).disabled = true
			#$Canvas/Shop.get_node("Food" + str(id -2) + "/Texture").texture = preload("res://Assets/Art/Temp/sold_out.png")
			#$Canvas/Shop.get_node("Food" + str(id -2) + "/Label").text = "SOLD OUT"
			#$Canvas/Shop.get_node("Food" + str(id -2) + "/Coin").hide()
			
			AddFoodItemToInventory(current_shop_contents[id])
	FormatInventory(Inventory)


func OpenCookingMenu() -> void:
	FormatInventory(Inventory)
	UpdateCookableRecipies()
	$Canvas/Shop.hide()
	$Animations.play("CookingFadein")

func FormatInventory(Inv : Dictionary):
	var Output : String
	var Before = "[font=res://Assets/Fonts/8bitoperator_jve.ttf][font_size=24]"
	Output += Before
	for n : String in Inv.keys():
		Output += "[img=32]res://Assets/Art/Food/" + n + ".png[/img]" + n.replace("_"," ") + ": " + str(Inv[n]) + "\n"
	if Inv == {}:
		Output += "Empty"
	$Canvas/Cooking/Label.text = Output
	$Canvas/RecipeBook/Label.text = Output


func UpdateCookableRecipies():
	for ID in range(7):
		$"Canvas/Cooking".get_node("Menu" + str(ID + 1)).disabled = !CheckRecipeCraftable(ID)
		print(ID)

func AddFoodItemToInventory(nam:String):
	if Inventory.has(nam):
		Inventory[nam] += 1
	else:
		Inventory[nam] = 1

func RemoveFoodItemFromInventory(nam:String):
	if Inventory.has(nam):
		if Inventory[nam] <= 1:
			Inventory.erase(nam)
		else:
			Inventory[nam] -= 1
	else:
		printerr("Inventory did not contain the following: " + nam)

func CheckRecipeCraftable(id:int):
	var Recipe = Global.Recipies[id]
	for Item in Recipe:
		if not Item in Inventory:
			return false
	return true

func CookRecipe(id:int):
	
	var Recipe = Global.Recipies[id]
	for Item in Recipe:
		if not Item in Inventory:
			return false
	for Item in Recipe:
		RemoveFoodItemFromInventory(Item)
		$Animations.play("next_day")

func IntitializeCutscene():
	$Animations.play("Cinematic_fadein")
	await $Animations.animation_finished
	AnimationFinished.emit()

func _on_continue_pressed() -> void:
	$Animations.play("ShopFadeout")


func _on_reroll_pressed() -> void:
	if $"../Players/Player".coins >= ShopRerollCost:
		$"../Players/Player".coins -= ShopRerollCost
		$"../Players/Player".UpdateCoinCount()
		RandomizeShopContents()
		if ShopRerollCost == 0:
			ShopRerollCost = 0.5
		else:
			ShopRerollCost *= 2
		$Canvas/Shop/Reroll/Coin.show()
		$Canvas/Shop/Reroll/Cost.text = str(ShopRerollCost)
func _on_backtomenu_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_back_to_cooking_pressed() -> void:
	$Canvas/RecipeBook.hide()
	$Canvas/Shop.show()

func _on_recipe_book_pressed() -> void:
	$Canvas/Shop.hide()
	$Canvas/RecipeBook.show()

func SetCorrectDay():
	$Canvas/Cinematic/NextDay/Text.text = "DAY " + str(Global.CurrentDay)
