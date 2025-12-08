extends CharacterBody2D

var delta_rot = 0
@export var max_turn_speed = 5
var IsOwner = true
var tsincestopped = 0

var health = 5

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
			var rot = 0
			if tdata & TileSetAtlasSource.TRANSFORM_TRANSPOSE and tdata & TileSetAtlasSource.TRANSFORM_FLIP_H: rot = 0.5*PI
			if tdata & TileSetAtlasSource.TRANSFORM_FLIP_H and tdata & TileSetAtlasSource.TRANSFORM_FLIP_V: rot = PI
			if tdata & TileSetAtlasSource.TRANSFORM_TRANSPOSE and tdata & TileSetAtlasSource.TRANSFORM_FLIP_V: rot = 1.5*PI
			res.append([ttype, rot])
	return res

func _physics_process(delta: float) -> void: 
	if Input.get_axis("move_left", "move_right") == 0:
		delta_rot *= 0.9
	delta_rot += Input.get_axis("move_left","move_right") * 0.1
	if abs(delta_rot) >= max_turn_speed:
		delta_rot = max_turn_speed * delta_rot/abs(delta_rot)
	rotation += delta_rot * 0.01
	velocity = transform.x * tsincestopped
	if tsincestopped < 50:
		tsincestopped += 1
	var overlap = getoverlappingtiles()
	for t in overlap:
		if t[0] == Vector2i(0, 3):
			velocity += Vector2(sin(t[1]), cos(t[1])) * 10
	$"../../Camera/Control/Label".text = "Health: " + str(health)
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	delta_rot = 0
	tsincestopped = -30
	health -= 1
