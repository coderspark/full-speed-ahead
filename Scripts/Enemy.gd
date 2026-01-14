extends Node2D

var PATH_POINTS = [Vector2(0, 0), Vector2(0, 0)]
var DIST = 0
var n = 0
var dir = 1
func init(points: Array, numberpos: float) -> void:
	PATH_POINTS = points
	DIST = PATH_POINTS[0].distance_to(PATH_POINTS[1])
	n = numberpos
# i like math :3
func _physics_process(delta: float) -> void:
	n += (dir-0.5)*2 * 0.005
	if 1 - n <= 0.01 and dir == 1:
		dir = 0
	if n <= 0.01 and dir == 0:
		dir = 1
	position = lerp(PATH_POINTS[0], PATH_POINTS[1], n)
	if dir == 0:
		look_at(PATH_POINTS[0])
	else:
		look_at(PATH_POINTS[1])
