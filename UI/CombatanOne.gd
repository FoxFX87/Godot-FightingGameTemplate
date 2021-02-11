extends ProgressBar

var fighter_stats = Globals.fighter_one

func _ready():
	max_value = fighter_stats.max_health
	value = max_value
	pass
