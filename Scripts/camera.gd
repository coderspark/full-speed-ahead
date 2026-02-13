extends Camera2D
var trauma = 0
func _process(delta: float) -> void:
	position.x = $"../Players/Player".position.x
	if trauma:
		trauma = max(trauma - 0.8 * delta, 0)
		shake()
func shake() -> void:
	trauma = min(trauma + 0.5, 1.0)
