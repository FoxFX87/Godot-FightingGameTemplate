extends KinematicBody

var damaged = false
var gravity = 50

var velocity = Vector3.ZERO
var knockback = Vector3.ZERO

onready var blink = $Blink

func _on_Hurtbox_hit(_damage, _horHit, _verHit):
	#print("PUNCHED!")
	#print(_horHit)
	#print(_verHit)
	var hKnock = -_horHit * 10
	var vKnock = _verHit * 10
	knockback = Vector3(0, vKnock, hKnock)
	blink.play("Blink")

func _physics_process(delta):
	
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	velocity = move_and_slide(velocity, Vector3.UP)
	
	knockback = knockback.move_toward(Vector3.ZERO, delta * 200)
	knockback = move_and_slide(knockback)
