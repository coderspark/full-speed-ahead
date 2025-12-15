extends AudioStreamPlayer2D

@export var looppoint = 0
func _ready() -> void:
	play()
func _on_finished() -> void:
	play(looppoint)
