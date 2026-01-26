extends Node2D

var TimeOfDAy := 700.0

func _ready() -> void:
	print("LOADED LEVEL: " + Global.LevelName)

func _on_ui_restart_game() -> void:
	get_parent().RestartGame()

func _process(delta: float) -> void:
	TimeOfDAy += 2
	modulate = TimeToColorModulate(TimeOfDAy)
	if TimeOfDAy > 1950 and not Global.DayEnded:
		$UI.IntitializeCutscene()
		$Players/Player.EndDay()
		Global.DayEnded = true
		

func TimeToColorModulate(time:float) -> Color:
	if time < 900:
		return Color.from_hsv(0, (900-time) / 400, 1 - ((900-time) / 400))
	elif time > 1700:
		return Color.from_hsv(0, clampf((time-1700) / 400,0,0.5), clampf(1 - ((time-1700) / 400),0.5,1))
	else:
		return Color(1,1,1,1)
