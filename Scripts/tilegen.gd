extends TileMapLayer

var TOP_LEFT = Vector2(-11, 0)
var TEMPLATE_START = Vector2(-21, -14)
var enemy = preload("res://Scenes/Enemy.tscn")

enum TileTransform {
	ROTATE_0 = 0,
	ROTATE_90 = TileSetAtlasSource.TRANSFORM_TRANSPOSE | TileSetAtlasSource.TRANSFORM_FLIP_H,
	ROTATE_180 = TileSetAtlasSource.TRANSFORM_FLIP_H | TileSetAtlasSource.TRANSFORM_FLIP_V,
	ROTATE_270 = TileSetAtlasSource.TRANSFORM_TRANSPOSE | TileSetAtlasSource.TRANSFORM_FLIP_V,
}

func paste_template(id: int, pos: int) -> void:
	var enemies = [[], []]
	for row in range(12):
		for col in range(6):
			var templatecoord = get_cell_atlas_coords(Vector2(TEMPLATE_START.x+col+id*8, TEMPLATE_START.y+row))
			var templatealtid = get_cell_alternative_tile(Vector2(TEMPLATE_START.x+col+id*8, TEMPLATE_START.y+row))
			if templatecoord == Vector2i(0, 2):
				enemies[0].append(map_to_local(Vector2(TOP_LEFT.x+col+pos, TOP_LEFT.y+row)))
			if templatecoord == Vector2i(1, 2):
				enemies[1].append(map_to_local(Vector2(TOP_LEFT.x+col+pos, TOP_LEFT.y+row)))
			if templatecoord == Vector2i(0, 4):
				if randi_range(0, 100) < 50:
					templatecoord = Vector2i(1, 4)
			set_cell(Vector2(TOP_LEFT.x+col+pos, TOP_LEFT.y+row), 0, templatecoord, templatealtid)
	for e in enemies:
		if len(e) == 2:
			var tmpenemy = enemy.instantiate()
			tmpenemy.init(e, randf_range(0, 100)/100)
			add_child(tmpenemy)

func _ready() -> void:
	var map = []
	for _n in range(50):
		map.append(randi_range(0, 9))
	for t in range(len(map)):
		paste_template(map[t], 6+(10*t))
