extends CharacterBody2D

var delta_rot = 0

var max_turn_speed = 5
var turn_velocity = 0.1
var max_speed = 50

var IsOwner = true
var boatvel = 0
var isbounce = false
var isNavigating = false
var health = 5
var max_health = 5
var coin_mult = 1.0
var activebuffs = [0.0, 0.0, 0.0, 0.0] # Speed TurnSpeed Health CoinMultiplier

var paused = false
var iframes = 0
var coins = 0

var MyBoat = ""

var IntermissionsReached = []

var elapsed = 0.0
@export var GameStarted = false
func _ready() -> void:
	if Global.SaveFileLoaded:
		var data = Global.SaveFile.CurrentLevelData
		position = data["PlayerPos"]
		rotation = data["PlayerRot"]
		IntermissionsReached = data["IntermissionsReached"]
		coins = data["LevelCoins"]
		Global.LastRecipe = data["LastRecipe"]
		activebuffs = data["ActiveBuffs"]
		UpdateCoinCount()
		UpdateBoat(Global.SaveFile.SaveData["BoatName"])
		UpdateBuffs()
		health = data["Health"]
		$"../../UI/Canvas/HUD/HP".HP = health
		$"../../UI/Canvas/HUD/HP".Update()
	else:
		coins = Global.BroughtCoins + Global.LevelData[Global.LevelName]["StartCoinCount"]
		UpdateCoinCount()
		if Global.SaveFile.SaveData["BoatName"] == "":
			UpdateBoat(Global.STARTER_BOAT)
		else:
			UpdateBoat(Global.SaveFile.SaveData["BoatName"])
	

func getoverlappingtiles() -> Array:
	var res = []
	var rect = $"Collision Detector/CollisionShape2D2".shape.get_rect()
	var top_left = $"../../TileMap".local_to_map(rect.position + position )
	var bottom_right = $"../../TileMap".local_to_map(position + rect.position + rect.size )
	for x in range(top_left.x, bottom_right.x + 1):
		for y in range(top_left.y, bottom_right.y+1):
			var coords = Vector2i(x, y)
			var ttype = $"../../TileMap".get_cell_atlas_coords(coords)
			var tdata = $"../../TileMap".get_cell_alternative_tile(coords)
			var rot = PI
			if tdata & TileSetAtlasSource.TRANSFORM_TRANSPOSE and tdata & TileSetAtlasSource.TRANSFORM_FLIP_H: rot = 0.5*PI
			if tdata & TileSetAtlasSource.TRANSFORM_FLIP_H and tdata & TileSetAtlasSource.TRANSFORM_FLIP_V: rot = 0
			if tdata & TileSetAtlasSource.TRANSFORM_TRANSPOSE and tdata & TileSetAtlasSource.TRANSFORM_FLIP_V: rot = 1.5*PI
			res.append([ttype, rot, coords])
	return res

func _physics_process(delta: float) -> void:
	if isNavigating:
		var dir = ($Navigation.get_next_path_position() - global_position).normalized()
		velocity = dir * 1000 * delta
		rotation = lerp_angle(rotation, dir.angle(),delta * 3)
		move_and_slide()
	elif GameStarted and !Global.DayEnded:
		if Input.get_axis("move_left", "move_right") == 0:
			delta_rot *= 0.9
		delta_rot += Input.get_axis("move_left","move_right") * turn_velocity
		if abs(delta_rot) >= max_turn_speed:
			delta_rot = max_turn_speed * delta_rot/abs(delta_rot)
		if isbounce:
			boatvel = -30
		if iframes > 0:
			if (iframes % 10) <= 5:
				$Sprite.modulate = Color(1.0, 1.0, 1.0, 0.5)
			else:
				$Sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
			$"Collision Detector/CollisionShape2D2".disabled = true
			iframes -= 1
			if iframes == 0:
				$Sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
				$"Collision Detector/CollisionShape2D2".disabled = false
		rotation += delta_rot * 0.01
		velocity = transform.x * boatvel
		if boatvel < max_speed:
			boatvel += 60 * delta
		var overlap = getoverlappingtiles()
		var pushingdirs = []
		if int(float(GetProgress())/8) in Global.LevelData[Global.LevelName]["Intermissions"] and int(float(GetProgress())/8) not in IntermissionsReached:
			isNavigating = true
			IntermissionsReached.append(int(float(GetProgress())/8))
			GameStarted = false
			$Navigation.target_position = Vector2(position.x + 60,40)
		for t in overlap:
			if t[0] == Vector2i(0, 3) && iframes == 0 && !t[1] in pushingdirs:
				velocity += Vector2(sin(t[1]), cos(t[1])) * 10
				pushingdirs.append(t[1])
			if t[0] == Vector2i(0, 13) && iframes == 0 && !t[1] in pushingdirs:
				velocity += Vector2(sin(t[1]), cos(t[1])) * 25
				pushingdirs.append(t[1])
			if t[0] == Vector2i(0, 14):
				coins += 1 * coin_mult
				$"../../TileMap".remove_coin(t[2])
				UpdateCoinCount()
			if t[0] == Vector2i(6, 0):
				$"../..".finish()
		pushingdirs = []
	move_and_slide()

func _on_area_2d_body_entered(_body: Node2D) -> void:
	delta_rot = 0
	health -= 1
	$"../../UI/Canvas/HUD/HP".HP = health
	$"../../UI/Canvas/HUD/HP".Update()
	if health <= 0:
		$Camera.traumatize(0.25)
		$"../../UI".gameover()
		paused = true
	else:
		$Camera.traumatize(0.2)
	iframes = 75
	boatvel = -30

func _on_shop_detection_body_entered(_body: Node2D) -> void:
	$"../../UI".ShowShop()
	get_tree().paused = true
	
func UpdateCoinCount():
	$"../../UI/Canvas/HUD/Coins".text = str(coins)

func UpdateBoat(nam : String):
	MyBoat = nam
	if Global.LevelName == "Tutorial":
		max_health = 5
		health = 5
	else:
		max_health = Global.BOAT_STATS[nam]["hp"]
		health = max_health
	max_speed = Global.BOAT_STATS[nam]["speed"] * 10
	max_turn_speed = Global.BOAT_STATS[nam]["turn_speed"]
	turn_velocity = Global.BOAT_STATS[nam]["turn_speed"] / 30.0
	coin_mult = Global.BOAT_STATS[nam]["coin_multiplier"]
	velocity = Vector2.ZERO
	$"../../UI/Canvas/HUD/HP".MAX_HP = max_health
	$"../../UI/Canvas/HUD/HP".HP = health
	$"../../UI/Canvas/HUD/HP".Update()
	$Sprite.texture = load("res://Assets/Art/Boats/" + MyBoat + ".png")
	$Sprite.scale = Vector2(Global.BOAT_SCALE_MODIFIERS.get(nam,1.0),Global.BOAT_SCALE_MODIFIERS.get(nam,1.0))

func _on_ui_start_game() -> void:
	velocity = Vector2.ZERO
	boatvel = 0
	GameStarted = true
#Used in tutorial
func StopShip():
	velocity = Vector2.ZERO
	boatvel = 0
	GameStarted = false

func EndDay():
	GameStarted = false
	while velocity != Vector2.ZERO:
		velocity *= 0.95
		await get_tree().create_timer(0.01,true,true,true).timeout
		

func GetProgress() -> float:
	return float(floorf((position.x + 80.0) / 16.0))
	


func _on_navigation_finished() -> void:
	GameStarted = false
	isNavigating = false
	velocity = Vector2.ZERO
	boatvel = 0
	while rotation - PI/2 > 0.01:
		print(rotation)
		rotation = lerp_angle(rotation, PI/2, 0.016 * 3)
		await get_tree().process_frame
	$"../../UI".ShopIntermission = true
	$"../../UI/Animations".play("ShopFadein")

func UpdateBuffs():
	max_health = Global.BOAT_STATS[MyBoat]["hp"] + activebuffs[2]
	health += activebuffs[2]
	max_turn_speed = Global.BOAT_STATS[MyBoat]["turn_speed"] * (1+activebuffs[1])
	max_speed = Global.BOAT_STATS[MyBoat]["speed"] * (1+activebuffs[0]) * 10
	coin_mult = Global.BOAT_STATS[MyBoat]["coin_multiplier"] * (1+activebuffs[3])
	turn_velocity = max_turn_speed / 30
	$"../../UI/Canvas/HUD/HP".MAX_HP = max_health
	$"../../UI/Canvas/HUD/HP".HP = health
	$"../../UI/Canvas/HUD/HP".Update()
