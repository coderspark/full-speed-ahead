extends CharacterBody2D

var delta_rot = 0
@export var max_turn_speed = 5
var IsOwner = true
var tsincestopped = 0
var health = 5

func _physics_process(delta: float) -> void: 
	if tsincestopped >= -100:
		if Input.get_axis("move_left", "move_right") == 0:
			delta_rot *= 0.9
		delta_rot += Input.get_axis("move_left","move_right") * 0.1
		if abs(delta_rot) >= max_turn_speed:
			delta_rot = max_turn_speed * delta_rot/abs(delta_rot)
		rotation += delta_rot * 0.01
		velocity = transform.x * tsincestopped
		if tsincestopped < 50:
			tsincestopped += 1
	else:
		velocity *= 0.8
		if velocity.distance_to(Vector2(0, 0)) <= 1:
			tsincestopped = 0
	$"../../Camera/Control/Label".text = "Health: " + str(health)
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	delta_rot = 0
	tsincestopped = -30
	health -= 1
