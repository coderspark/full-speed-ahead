extends Camera2D

var trauma = 0.0
var trauma_power = 2
var max_offset = Vector2(100,100)
func _process(delta: float) -> void:
	if trauma:
		trauma = max(trauma - 0.5 * delta, 0)
		shake()
func shake():
	var amount = pow(trauma, trauma_power)
	offset.x = max_offset.x * amount * randf_range(-1, 1)
	offset.y = max_offset.y * amount * randf_range(-1, 1)
func traumatize(amount):
	trauma = min(trauma + amount, 1.0)
