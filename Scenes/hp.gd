extends TextureProgressBar

var HP = 180
var MAX_HP = 5

func _ready() -> void:
	Update()

func Update():
	if HP > MAX_HP:
		HP = MAX_HP
	var hpPercent = HP / MAX_HP * 100
	value = HP
	max_value = MAX_HP
	if hpPercent > 60:
		tint_progress = Color("#00c900")
