extends Node

class fighter:
	
	var id
	var max_health
	var health setget SetHealth, GetHealth
	signal health_changed(value)
	signal player_down
	
	func _init():
		id = null
		max_health = 100
		health = max_health
		
	func SetHealth(value : int):
		
		health = clamp(value, 0, max_health)
		emit_signal("health_changed", health)
		
		if health <= 0:
			emit_signal("player_down")
	
	func GetHealth():
		return health
		
var fighter_one = fighter.new()
var fighter_two = fighter.new()

#Particles
const hitParticle = preload("res://Particles/TestParticles.tscn")

func _ready():
	pass

func instanceSceneOnMain(scene, translation):
	var main = get_tree().current_scene
	var inst = scene.instance()
	main.add_child(inst)
	inst.global_transform.origin = translation
	return inst
