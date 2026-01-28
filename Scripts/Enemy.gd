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
	n += dir * 0.5/DIST
	if 1 - n <= 0.01 and dir == 1:
		dir = -1
	if n <= 0.01 and dir == -1:
		dir = 1
	position = lerp(PATH_POINTS[0], PATH_POINTS[1], n)
	if dir == -1:
		if PATH_POINTS[0].x == PATH_POINTS[1].x:
			rotation = 1.5 * PI
		else:
			rotation = PI
	else:
		if PATH_POINTS[0].x == PATH_POINTS[1].x:
			rotation = 0.5 * PI
		else:
			rotation = 0
