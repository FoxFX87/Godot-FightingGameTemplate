extends KinematicBody

var damaged = false
var gravity = 50
export (float) var knockbackFactor = 10

var velocity = Vector3.ZERO
var knockback = Vector3.ZERO
var stats = Globals.fighter_two
var onFloor

onready var anim = $AnimationPlayer
onready var flash = $Flash
onready var floorRay1 = $FloorRayCast
onready var floorRay2 = $FloorRayCast2
onready var floorRay3 = $FloorRayCast3
onready var floorRay4 = $FloorRayCast4

func _ready():
	stats.id = self
	pass

func hit_flash():
	flash.play("Flash")

func _physics_process(delta):
	
	onFloor = 	floorRay1.is_colliding() or floorRay2.is_colliding() or floorRay3.is_colliding() or floorRay4.is_colliding()
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	velocity = move_and_slide(velocity, Vector3.UP)
	
	knockback = knockback.move_toward(Vector3.ZERO, delta * 200)
	knockback = move_and_slide(knockback)


func _on_HeadHurtbox_hit(_damage, horHit, verHit):
	hit_flash()
	stats.health -= _damage
	var hKnock = -horHit * knockbackFactor
	var vKnock = verHit * knockbackFactor
	knockback = Vector3(0, vKnock, hKnock)
	anim.play("TakingPunch")
	anim.playback_speed = 1.5

func _on_TorsoHurtbox_hit(_damage, horHit, verHit):
	hit_flash()
	stats.health -= _damage
	var hKnock = -horHit * knockbackFactor
	var vKnock = verHit * knockbackFactor
	knockback = Vector3(0, vKnock, hKnock)
	anim.play("Reaction")
	anim.playback_speed = 1.0

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name in ["Reaction", "TakingPunch"] and onFloor:
		anim.play("FightingIdle")
		anim.playback_speed = 1.0

func _on_TorsoHurtbox_incomingBlock():
	print("Block This Attack")
	pass # Replace with function body.
