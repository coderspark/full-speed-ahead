extends Camera2D

func _process(delta: float) -> void:
	position.x = $"../Players/Player".position.x
