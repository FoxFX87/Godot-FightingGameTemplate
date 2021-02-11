extends KinematicBody

enum STATE {IDLE, PUNCH, KICK, MOVE, HIGHPUNCH, HIGHKICK,
			LOWKICK}

export (float) var speed = 10
export (float) var gravity = 50

var velocity = Vector3.ZERO
var currentState = STATE.IDLE
var isMoving = false

onready var anim = $AnimationPlayer
onready var hitHighP = $HighPunchHitbox
onready var hitLowP = $LowPunchHitbox
onready var hitHighK = $HighKickHitbox
onready var hitLowK = $LowKickHitbox

func _ready():
	Globals.fighter_one.id = self
	pass

func get_input():
	
	var rmove = Input.get_action_strength("move_right")
	var lmove = Input.get_action_strength("move_left")
	
	velocity.z = (lmove - rmove) * speed
	
	isMoving = sign(velocity.z) != 0
	
func _physics_process(delta):
	
	var punch = Input.is_action_just_pressed("attack_punch")
	var kick = Input.is_action_just_pressed("attack_kick")
	var lowpunch = Input.is_action_just_pressed("attack_low_punch")
	var lowkick = Input.is_action_just_pressed("attack_low_kick")
	
	#scale.z = stats.opponent
	
	match currentState:
		
		STATE.IDLE:
			get_input()
			anim.play("FightingIdle")
			anim.playback_speed = 1
			
			if isMoving:
				currentState = STATE.MOVE
			if punch:
				currentState = STATE.HIGHPUNCH
			if kick:
				currentState = STATE.KICK
			if lowpunch:
				currentState = STATE.PUNCH
			if lowkick:
				currentState = STATE.LOWKICK
			
		STATE.MOVE:
			get_input()
			var rmove = Input.get_action_strength("move_right")
			var lmove = Input.get_action_strength("move_left")
			
			if rmove:
				anim.play("Walking")
			if lmove:
				anim.play("WalkBack")
			
			if not isMoving:
				currentState = STATE.IDLE
			if punch:
				currentState = STATE.PUNCH
			if kick:
				currentState = STATE.KICK
				
		STATE.PUNCH:
			velocity.z = 0
			anim.play("Punching")
			anim.playback_speed = 1.5
			
			if anim.current_animation_position >= 0.4:
				if punch:
					currentState = STATE.HIGHPUNCH
			
		STATE.HIGHPUNCH:
			velocity.z = 0
			anim.play("HighJab")
			anim.playback_speed = 1.5
			
		STATE.LOWKICK:
			velocity.z = 0
			anim.play("LowKick")
			anim.playback_speed = 1.5
				
		STATE.KICK:
			velocity.z = 0
			anim.play("HighKick")
			anim.playback_speed = 1.5
			
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	velocity = move_and_slide(velocity, Vector3.UP)

func _on_AnimationPlayer_animation_finished(_anim_name):
	if currentState in [STATE.PUNCH, STATE.KICK, 
						STATE.HIGHKICK, STATE.HIGHPUNCH,
						STATE.LOWKICK]:
		currentState = STATE.IDLE


func _on_HighPunchHitbox_area_entered(_area):
	var loc = hitHighP.global_transform.origin
	Globals.instanceSceneOnMain(Globals.hitParticle, loc)


func _on_LowPunchHitbox_area_entered(_area):
	var loc = hitLowP.global_transform.origin
	Globals.instanceSceneOnMain(Globals.hitParticle, loc)


func _on_HighKickHitbox_area_entered(_area):
	var loc = hitHighK.global_transform.origin
	Globals.instanceSceneOnMain(Globals.hitParticle, loc)


func _on_LowKickHitbox_area_entered(_area):
	var loc = _area.global_transform.origin - Vector3(0, 3, 0)
	Globals.instanceSceneOnMain(Globals.hitParticle, loc)
