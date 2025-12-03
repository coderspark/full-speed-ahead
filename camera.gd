extends Camera2D

func _process(delta: float) -> void:
	position = $"../CharacterBody2D".position
