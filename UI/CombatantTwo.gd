extends ProgressBar

var fighter_stats = Globals.fighter_two

func _ready():
	max_value = fighter_stats.max_health
	fighter_stats.connect("health_changed", self, "UpdateUI")
	UpdateUI(fighter_stats.health)
	pass

func UpdateUI(_value):
	value = _value
