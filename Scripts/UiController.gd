extends Control

signal StartGame

var shop_current_id = 0

var paused = false

func CallStartGame():
	StartGame.emit()
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		paused = !paused
		get_tree().paused = paused
		$Paused.visible = paused
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
		n.get_node("Button").disabled = !(int(n.name) == shop_current_id)
	$Shop/Boats.position = Vector2.ZERO


func _on_button_pressed() -> void:
	'''
	TODO: Player laten weten welke boat hij wordt 
	
	Je kan shop_current_id gebruiken voor welke button is geklikt
	'''
	print("klik")


func _on_lag_pressed() -> void:
	Engine.max_fps = 4
