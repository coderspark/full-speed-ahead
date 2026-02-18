extends Control

signal StartGame
signal RestartGame
signal AnimationFinished

var ShopRerollCost := 0.0

var ShopOpen = false

var current_shop_contents = []
var Inventory = {}

var paused = false

var IsStarving = false

var ShopIntermission = false

var hoverCheck = preload("res://Scenes/hover_check.tscn")

var wharf_lock_name = ""

func _ready() -> void:
	print("IM ALIVE@@!W@!@!@!@!@!@")

	if Global.SaveFileLoaded:
		var data = Global.SaveFile.CurrentLevelData
		Inventory = data["Inventory"]
		$Canvas/Countdown/Animations.play("Countdown")
	else:
		ShopIntermission = false
		if not Global.LevelName == "Tutorial":
			$Animations.play("ShopFadein")
	if Global.LevelName == "Tutorial":
		AddFoodItemToInventory("Gin")
		AddFoodItemToInventory("Plums")
		AddFoodItemToInventory("Rice")
	if Global.CurrentDay < 10:
		$Canvas/HUD/TimeOfDAy/Day.text = "Day 0" + str(Global.CurrentDay)
	else:
		$Canvas/HUD/TimeOfDAy/Day.text = "Day " + str(Global.CurrentDay)
	RandomizeShopContents()
	FormatInventory(Inventory)
	$Canvas/Shop.hide()

func CallStartGame():
	StartGame.emit()

func _process(_delta: float) -> void:
	$Canvas/HUD/TimeOfDAy/Progress.text = CalculatePercentage() + "%"
	if Input.is_action_just_pressed("ADMIN"):
		RandomizeShopContents()
	if Input.is_action_just_pressed("pause"):
		paused = !paused
		get_tree().paused = paused
		$Canvas/Paused.visible = paused

func gameover():
	get_tree().paused = true
	$Canvas/GameOver.visible = true

func _on_deathmenu_pressed() -> void:
	print("begone with thee")
	$Animations.play("FadeToBlack")
	await $Animations.animation_finished
	Global.Coins += Global.BroughtCoins / 2.0
	Global.BroughtCoins = 0
	Global.LevelSelecting = true
	$"..".AutoSave(true)
	get_tree().reload_current_scene()

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
		if n in $"../Players/Player".Boats:
			$Canvas/Shop.get_node("Boat" + str(i + 1)).disabled = true
			$Canvas/Shop.get_node("Boat" + str(i + 1) + "/Texture").texture = load("res://Assets/Art/Boats/" + n + ".png")
			$Canvas/Shop.get_node("Boat" + str(i + 1) + "/Label").text = "Owned"
			$Canvas/Shop.get_node("Boat" + str(i + 1) + "/Coin").hide()
		else:
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
	if $"../Players/Player".health >= $"../Players/Player".max_health:
		$Canvas/Shop/Repair.disabled = true
	else:
		$Canvas/Shop/Repair.disabled = false
	
	
func ShowShop():
	get_tree().paused = true
	$Canvas/Shop.show()
	ShopOpen = true

func ShopButtonPressed(id:int):
	if id == -1:
		if $"../Players/Player".coins >= clampi(ceil(Global.BOAT_STATS[$"../Players/Player".MyBoat]["cost"] / 2),5,50):
			$"../Players/Player".heal()
	elif id <= 2:
		if Global.BOAT_STATS[current_shop_contents[id]]["cost"] <= $"../Players/Player".coins:
			$"../Players/Player".coins -= Global.BOAT_STATS[current_shop_contents[id]]["cost"]
			$"../Players/Player".UpdateCoinCount()
			$Canvas/Shop.get_node("Boat" + str(id + 1)).disabled = true
			$Canvas/Shop.get_node("Boat" + str(id + 1) + "/Label").text = "Owned"
			$Canvas/Shop.get_node("Boat" + str(id + 1) + "/Coin").hide()
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
	# IF YOU KNOW A BETTER WAY FOR THIS, PLEASE IMPLEMENT IT
	$Canvas/Cooking/Menu1/Buffs.text = "+10%\n-10%"
	$Canvas/Cooking/Menu2/Buffs.text = "+10%\n-10%"
	$Canvas/Cooking/Menu3/Buffs.text = "+10%\n-5%"
	$Canvas/Cooking/Menu4/Buffs.text = "+1 HP\n-10%"
	$Canvas/Cooking/Menu5/Buffs.text = "+10%\n-5%"
	$Canvas/Cooking/Menu6/Buffs.text = "+10%\n-5%"
	$Canvas/Cooking/Menu7/Buffs.text = "+2 HP\n-5%"
	match Global.LastRecipe:
		0:
			$Canvas/Cooking/Menu1/Buffs.text = "+0%\n-20%"
		1:
			$Canvas/Cooking/Menu2/Buffs.text = "+0%\n-20%"
		2:
			$Canvas/Cooking/Menu3/Buffs.text = "+0%\n-10%"
		3:
			$Canvas/Cooking/Menu4/Buffs.text = "+0 HP\n-20%"
		4:
			$Canvas/Cooking/Menu5/Buffs.text = "+0%\n-10%"
		5:
			$Canvas/Cooking/Menu6/Buffs.text = "+0%\n-10%"
		6:
			$Canvas/Cooking/Menu7/Buffs.text = "+0 HP\n-10%"
	$Canvas/Shop.hide()
	$Animations.play("CookingFadein")

func FormatInventory(Inv : Dictionary):
	var Output : String
	var Before = "[font=res://Assets/Fonts/8bitoperator_jve.ttf][font_size=24]"
	Output = Before
	for n : String in Inv.keys():
		Output += "[img=32]res://Assets/Art/Food/" + n + ".png[/img]" + n.replace("_"," ") + ": " + str(Inv[n]) + "\n"
	if Inv == {}:
		Output += "Empty"
	$Canvas/Cooking/Label.text = Output
	$Canvas/RecipeBook/Label.text = Output

func FormatBoats(Boats: Array):
	var Output : String
	var Before = "[font=res://Assets/Fonts/8bitoperator_jve.ttf][font_size=24]"
	Output = Before
	for n : String in Boats:
		Output += "[img=32]res://Assets/Art/Boats/" + n + ".png[/img]" + n.replace("_"," ") + "\n"

	if Boats == []:
		Output += "You don't own any boats!"
	for n in $Canvas/Boats/Hovers.get_children():
		n.name = "DWUGAgd" + str(randi())
		n.queue_free()
	for n in range(Boats.size()):
		var H : Control = hoverCheck.instantiate()
		$Canvas/Boats/Hovers.add_child(H)
		H.name = "Hover" + str(n)
		H.position = Vector2(26,91+(31*n))
		H._on_pressed.connect(_on_pressed)
	$Canvas/Boats/Label.text = Output

func UpdateCookableRecipies():
	var nofood = true
	for ID in range(7):
		if CheckRecipeCraftable(ID) == true:
			nofood = false
		$"Canvas/Cooking".get_node("Menu" + str(ID + 1)).disabled = !CheckRecipeCraftable(ID)
	if nofood:
		$"Canvas/Cooking/Label".visible = false
		for i in range(7):
			$"Canvas/Cooking".get_node("Menu" + str(i + 1)).visible = false
		$"Canvas/Cooking/starvetext".visible = true
		$"Canvas/Cooking/Continue".visible = true

func AddFoodItemToInventory(nam:String):
	var nameids = {
		"Bacon":1,
		"Beer":2,
		"Gin":3,
		"Gray_peas":4,
		"Green_peas":5,
		"Meat":6,
		"Pickles":7,
		"Plums":8,
		"Rice":9,
		"Sauerkraut":10,
		"Stockfish":11,
		"White_beans":12,
		"Wine":13,
	}
	if Inventory.has(nam):
		Inventory[nam] += 1
	else:
		Inventory[nam] = 1
	$"Canvas/Shop/BoughtItems".get_node("Panel" + str(nameids[nam])).get_node("Label").text = " " + str(Inventory[nam])

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
	var buffs = Global.RecipeBuffs[id]
	# nerf buffs that were just applied last day
	if Global.LastRecipe == id:
		for i in range(4):
			if buffs[i] > 0:
				buffs[i] = 0
			else:
				buffs[i] *= 2.0
	$"../Players/Player".activebuffs = buffs
	$"../Players/Player".UpdateBuffs()
	Global.LastRecipe = id
	InitNextDay()
		
func IntitializeCutscene():
	$Animations.play("Cinematic_fadein")
	await $Animations.animation_finished
	AnimationFinished.emit()

func _on_continue_pressed() -> void:
	$Animations.play("ShopFadeout")
	await $Animations.animation_finished
	if ShopIntermission:
		$Animations.play("FadeToBlack")
		await $Animations.animation_finished
		$"../Players/Player".position.x += 50
		$"../Players/Player".position.y = 80
		$"../Players/Player".rotation_degrees = 0
		
		$Animations.play("FadeBackToNormal")
		await $Animations.animation_finished
		$Canvas/Countdown/Animations.play("Countdown")
	else:
		$Canvas/Countdown/Animations.play("Countdown")
		

func InitNextDay():
	$Animations.play("CookingFadeOut")
	await $Animations.animation_finished
	Global.CurrentDay += 1
	if Global.CurrentDay < 10:
		$Canvas/HUD/TimeOfDAy/Day.text = "Day 0" + str(Global.CurrentDay)
	else:
		$Canvas/HUD/TimeOfDAy/Day.text = "Day " + str(Global.CurrentDay)
		
	$Animations.play("next_day")
	await $Animations.animation_finished

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
	print("begone with thee")
	$Animations.play("FadeToBlack")
	await $Animations.animation_finished
	Global.Coins += $"../Players/Player".coins
	Global.LevelSelecting = true
	$"..".AutoSave(true)
	get_tree().reload_current_scene()

func _on_back_to_cooking_pressed() -> void:
	$Canvas/RecipeBook.hide()
	$Canvas/Boats.hide()
	$Canvas/Shop.show()

func _on_recipe_book_pressed() -> void:
	$Canvas/Shop.hide()
	$Canvas/RecipeBook.show()

func SetCorrectDay():
	$Canvas/Cinematic/NextDay/Text.text = "DAY " + str(Global.CurrentDay)

func SetCorrectProgress():
	$Canvas/Cinematic/NextDay/Text2.text = "\n\nPROGRESS: " + CalculatePercentage() + "%"

func UpdateTimeIndicator(tim:int):
	#time is 700 - 1900
	#verschil: 1200
	#Indicator heeft 175 px
	var time_diff : float = clamp(1900-tim,0,1200)
	var time_value : float = time_diff / 1200
	var indicator_pos = 175.0 * (1 - time_value)
	$Canvas/HUD/TimeOfDAy/TimeIndicator.position.x = indicator_pos

func NextDay():
	$"..".TimeOfDAy = $"..".DayStartTime
	$Animations.play("Cinematic_fadeout")
	await $Animations.animation_finished
	$"../Players/Player".boatvel = 0
	$Canvas/Countdown/Animations.play("Countdown")
	$"../Players/Player".GameStarted = false
	$"../Players/Player".paused = false
	Global.DayEnded = false
	
func CalculatePercentage() -> String:
	return str(int(clamp(float($"../Players/Player".GetProgress()) / float(Global.LevelData[Global.LevelName]["LengthTiles"] * 8 + 16) * 100,0,100)))


func _starve() -> void:
	$"../Players/Player".activebuffs = [0.0, 0.0, 0.0, 0.0]
	$"../Players/Player".UpdateBuffs()
	Global.LastRecipe = -1
	IsStarving = true
	InitNextDay()


func _on_boats_pressed() -> void:
	FormatBoats($"../Players/Player".Boats)
	$Canvas/Shop.hide()
	$Canvas/Boats.show()

func _on_pressed(id:int):
	print(id)
	if $"../Players/Player".Boats.size() <= id:
		$Canvas/Boats/Info.hide()
		return
	$Canvas/Boats/Info.show()
	var BoatName : String = $"../Players/Player".Boats[id]
	wharf_lock_name = BoatName
	$Canvas/Boats/Info/Image.texture = load("res://Assets/Art/Boats/" + BoatName + ".png")
	$Canvas/Boats/Info/Name.text = BoatName.replace("_", " ")
	$Canvas/Boats/Info/HP.text = str(Global.BOAT_STATS[BoatName]["hp"]) + " HP"
	$Canvas/Boats/Info/Speed.text = str(Global.BOAT_STATS[BoatName]["speed"])
	$Canvas/Boats/Info/TurnSpeed.text = str(Global.BOAT_STATS[BoatName]["turn_speed"])
	$Canvas/Boats/Info/CoinMult.text = str(Global.BOAT_STATS[BoatName]["coin_multiplier"]) + "x"
	


func _on_select_pressed() -> void:
	print(wharf_lock_name)
	if wharf_lock_name == "":
		return
	$"../Players/Player".UpdateBoat(wharf_lock_name)
