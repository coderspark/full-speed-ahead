extends Control

var shop_current_id = 0

func gameover():
	get_tree().paused = true
	$GameOver.visible = true

func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _ready() -> void:
	UpdateShopLocations()

func _on_next_pressed() -> void:
	if $Shop/MainAnimations.is_playing():
		return
	print("right")
	$"Shop/MainAnimations".play("Slide_left")
	await $"Shop/MainAnimations".animation_finished
	shop_current_id += 1
	UpdateShopLocations()



func _on_prev_pressed() -> void:
	if $Shop/MainAnimations.is_playing():
		return
	print("left")
	$"Shop/MainAnimations".play("Slide_right")
	await $"Shop/MainAnimations".animation_finished
	shop_current_id -= 1
	UpdateShopLocations()

func UpdateShopLocations():
	for n : Panel in $Shop/Boats.get_children():
		if n.name != str(n.name.to_int()):
			printerr(n.name, " isnt an int")
		n.position.x = 144 - (48 * (shop_current_id - n.name.to_int()))
	$Shop/Boats.position = Vector2.ZERO
