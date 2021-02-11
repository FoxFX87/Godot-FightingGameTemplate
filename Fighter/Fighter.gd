extends KinematicBody

enum STATE {IDLE, LEFT_PUNCH, RIGHT_PUNCH}

export (float) var speed = 10
export (float) var gravity = 50
export (float) var jump_force = 20

var velocity = Vector3.ZERO
var current_state = STATE.IDLE

onready var anim = $AnimationPlayer

func get_input():
	var rmove = Input.get_action_strength("move_right")
	var lmove = Input.get_action_strength("move_left")
	
	velocity.z = (lmove - rmove) * speed
	
	
func _physics_process(delta):
	
	var test_punch = Input.is_action_pressed("attack_left_punch")
	var test_upper = Input.is_action_pressed("attack_right_upper")
	
	match current_state:
		STATE.IDLE:
			anim.play("Idle")
			get_input()
			
			if is_on_floor():
				if Input.is_action_pressed("move_jump"):
					velocity.y = jump_force
				if test_punch:
					current_state = STATE.LEFT_PUNCH
				if test_upper:
					current_state = STATE.RIGHT_PUNCH
			
		STATE.LEFT_PUNCH:
			velocity.z = 0
			anim.play("Left Punch")
			
		STATE.RIGHT_PUNCH:
			velocity.z = 0
			anim.play("Right Punch")
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	velocity = move_and_slide(velocity, Vector3.UP)

func return_to_idle():
	current_state = STATE.IDLE
