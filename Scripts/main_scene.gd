extends Node2D

var TimeOfDAy := 1000.0

func _ready() -> void:
	$UI/Canvas/Shop.show()
	modulate = TimeToColorModulate(TimeOfDAy)

func finish() -> void:
	$UI/Canvas/Victory.show()
	get_tree().paused = true

func _on_ui_restart_game() -> void:
	get_parent().RestartGame()

func _process(delta: float) -> void:
	if Global.AdvanceTime and $Players/Player.GameStarted and !$Players/Player.paused:
		TimeOfDAy += 2
		modulate = TimeToColorModulate(TimeOfDAy)
		if TimeOfDAy > 1950 and not Global.DayEnded:
			$UI.IntitializeCutscene()
			$Players/Player.EndDay()
			Global.DayEnded = true
			await $UI.AnimationFinished
			$UI.OpenCookingMenu()
			await $UI.AnimationFinished
		

func TimeToColorModulate(time:float) -> Color:
	if time < 900:
		return Color.from_hsv(0, (900-time) / 400, 1 - ((900-time) / 400))
	elif time > 1700:
		return Color.from_hsv(0, clampf((time-1700) / 400,0,0.5), clampf(1 - ((time-1700) / 400),0.5,1))
	else:
		return Color(1,1,1,1)
