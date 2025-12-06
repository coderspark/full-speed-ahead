extends CharacterBody2D

var delta_rot = 0
@export var max_turn_speed = 5
var IsOwner = true

func _physics_process(delta: float) -> void: 
	if Input.get_axis("move_left", "move_right") == 0:
		delta_rot *= 0.9
	delta_rot += Input.get_axis("move_left","move_right") * 0.1
	if abs(delta_rot) >= max_turn_speed:
		delta_rot = max_turn_speed * delta_rot/abs(delta_rot)
	rotation += delta_rot * 0.01
	velocity = transform.x * 50
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("win")
