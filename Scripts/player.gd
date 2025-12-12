extends CharacterBody2D

var delta_rot = 0
@export var max_turn_speed = 5
var IsOwner = true
var boatvel = 0
var isbounce = false
var health = 5
var paused = false



func getoverlappingtiles() -> Array:
	var res = []
	var rect = $"Collision Detector/CollisionShape2D2".shape.get_rect()
	var top_left = $"../../TileMap".local_to_map(rect.position + position)
	var bottom_right = $"../../TileMap".local_to_map(position + rect.position + rect.size)
	for x in range(top_left.x, bottom_right.x + 1):
		for y in range(top_left.y, bottom_right.y+1):
			var coords = Vector2i(x, y)
			var ttype = $"../../TileMap".get_cell_atlas_coords(coords)
			var tdata = $"../../TileMap".get_cell_alternative_tile(coords)
			var rot = PI
			if tdata & TileSetAtlasSource.TRANSFORM_TRANSPOSE and tdata & TileSetAtlasSource.TRANSFORM_FLIP_H: rot = 0.5*PI
			if tdata & TileSetAtlasSource.TRANSFORM_FLIP_H and tdata & TileSetAtlasSource.TRANSFORM_FLIP_V: rot = 0
			if tdata & TileSetAtlasSource.TRANSFORM_TRANSPOSE and tdata & TileSetAtlasSource.TRANSFORM_FLIP_V: rot = 1.5*PI
			res.append([ttype, rot])
	return res

func _physics_process(delta: float) -> void: 
	get_tree().paused = paused
	if Input.get_axis("move_left", "move_right") == 0:
		delta_rot *= 0.9
	delta_rot += Input.get_axis("move_left","move_right") * 0.1
	if abs(delta_rot) >= max_turn_speed:
		delta_rot = max_turn_speed * delta_rot/abs(delta_rot)
	if isbounce:
		boatvel = -30
	rotation += delta_rot * 0.01
	velocity = transform.x * boatvel
	
	if boatvel < 50:
		boatvel += 1
	var overlap = getoverlappingtiles()
	for t in overlap:
		if t[0] == Vector2i(0, 3):
			velocity += Vector2(sin(t[1]), cos(t[1])) * 10
	$"../../Camera/Control/HP".HP = health
	$"../../Camera/Control/HP".Update()
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	delta_rot = 0
	health -= 1
	if health <= 0:
		$"../../Camera/Control".gameover()
		paused = true
	isbounce = true
func _on_collision_detector_body_exited(body: Node2D) -> void:
	isbounce = false


func _on_shop_detection_body_entered(body: Node2D) -> void:
	get_tree().paused = true
	$"../../Camera/Control/Shop".show()
	
	
