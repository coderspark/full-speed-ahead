extends CharacterBody2D

var delta_rot = 0

var max_turn_speed = 5
var turn_velocity = 0.1
var max_speed = 50

var IsOwner = true
var boatvel = 0
var isbounce = false

var health = 5
var max_health = 5
var coin_mult = 1.0

var paused = false
var coins = 0

var MyBoat = ""


var GameStarted = false
func _ready() -> void:
	UpdateCoinCount()
	UpdateBoat(Global.STARTER_BOAT)
	

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
	if !GameStarted or Global.DayEnded:
		return
	
	if Input.get_axis("move_left", "move_right") == 0:
		delta_rot *= 0.9
	delta_rot += Input.get_axis("move_left","move_right") * turn_velocity
	if abs(delta_rot) >= max_turn_speed:
		delta_rot = max_turn_speed * delta_rot/abs(delta_rot)
	if isbounce:
		boatvel = -30
	rotation += delta_rot * 0.01
	velocity = transform.x * boatvel
	if boatvel < max_speed:
		boatvel += 1
	var overlap = getoverlappingtiles()
	var pushingdirs = []
	for t in overlap:
		if t[0] == Vector2i(0, 3) && !isbounce && !t[1] in pushingdirs:
			velocity += Vector2(sin(t[1]), cos(t[1])) * 10
			pushingdirs.append(t[1])
		if t[0] == Vector2i(0, 13) && !isbounce && !t[1] in pushingdirs:
			velocity += Vector2(sin(t[1]), cos(t[1])) * 25
			pushingdirs.append(t[1])
		if t[0] == Vector2i(0, 14):
			coins += 1 * coin_mult
			$"../../TileMap".remove_coin(t[2])
			UpdateCoinCount()
	pushingdirs = []
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	delta_rot = 0
	health -= 1
	$"../../UI/Canvas/HP".HP = health
	$"../../UI/Canvas/HP".Update()
	if health <= 0:
		$"../../UI".gameover()
		paused = true
	isbounce = true
func _on_collision_detector_body_exited(body: Node2D) -> void:
	isbounce = false


func _on_shop_detection_body_entered(body: Node2D) -> void:
	$"../../UI".ShowShop()
	get_tree().paused = true
	
func UpdateCoinCount():
	$"../../UI/Canvas/Coins".text = str(coins)

func UpdateBoat(nam : String):
	MyBoat = nam
	max_health = Global.BOAT_STATS[nam]["hp"]
	health = max_health
	max_speed = Global.BOAT_STATS[nam]["speed"] * 10
	max_turn_speed = Global.BOAT_STATS[nam]["turn_speed"]
	turn_velocity = Global.BOAT_STATS[nam]["turn_speed"] / 30.0
	coin_mult = Global.BOAT_STATS[nam]["coin_multiplier"]
	velocity = Vector2.ZERO
	$"../../UI/Canvas/HP".MAX_HP = max_health
	$"../../UI/Canvas/HP".HP = health
	$"../../UI/Canvas/HP".Update()
	$Sprite.texture = load("res://Assets/Art/Boats/" + MyBoat + ".png")
	$Sprite.scale = Vector2(Global.BOAT_SCALE_MODIFIERS.get(nam,1.0),Global.BOAT_SCALE_MODIFIERS.get(nam,1.0))

func _on_ui_start_game() -> void:
	GameStarted = true

func EndDay():
	GameStarted = false
	while velocity != Vector2.ZERO:
		velocity *= 0.9
		await get_tree().create_timer(0.01,true,true,true).timeout
		
