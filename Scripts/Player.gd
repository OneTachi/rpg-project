extends KinematicBody2D


var HurtSound = preload("res://Scenes/Player/PlayerHurtSound.tscn")

const ACCELERATION = 600
const MAX_SPEED = 80
const ROLL_SPEED = 100
const FRICTION = 600

enum {
	MOVE,
	ROLL,
	ATTACK
}

signal dropmenu

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN
var stats = PlayerStats

onready var anim = $AnimationPlayer
onready var animTree = $AnimationTree
onready var animState = $AnimationTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/SwordHitbox
onready var hurtbox = $Hurtbox
onready var blinkanim = $BlinkAnimationPlayer

func _ready():
	randomize()
	stats.connect("no_health", self, "queue_free")
	animTree.active = true
	swordHitbox.knockback_vector = roll_vector

func _physics_process(delta):
	if (Input.is_action_pressed("escape")):
		emit_signal("dropmenu")
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state()
		ATTACK:
			attack_state()
	
	


func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		swordHitbox.knockback_vector = input_vector
		animTree.set("parameters/Idle/blend_position", input_vector)
		animTree.set("parameters/Run/blend_position", input_vector)
		animTree.set("parameters/Attack/blend_position", input_vector)
		animTree.set("parameters/Roll/blend_position", input_vector)
		animState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move()
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK 
	if Input.is_action_just_pressed("roll"):
		state = ROLL

func attack_state():
	animState.travel("Attack")
	velocity = Vector2.ZERO

func roll_state():
	velocity = roll_vector * ROLL_SPEED
	animState.travel("Roll")
	move()

func roll_anim_finished():
	velocity = velocity * .9
	state = MOVE

func attack_anim_finished():
	state = MOVE

func move():
	velocity = move_and_slide(velocity)


func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	hurtbox.start_invincible(.4)
	hurtbox.create_hitEffect()
	var hurtsound = HurtSound.instance()
	get_tree().current_scene.add_child(hurtsound)


func _on_Hurtbox_invincibility_started():
	blinkanim.play("Start")


func _on_Hurtbox_invincibility_ended():
	blinkanim.play("Stop")
