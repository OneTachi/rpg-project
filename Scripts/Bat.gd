extends KinematicBody2D

export var ACCELERATION = 500
export var MAX_SPEED = 50
export var FRICTION = 200
export var WANDER_TARGET_RANGE = 4
enum {
	IDLE,
	WANDER,
	CHASE
}


const DeathEffect = preload("res://Scenes/Effects/EnemyDeathEffect.tscn")

onready var detect = $PlayerDetectionZone
onready var stats = $Stats
onready var sprite = $Sprite
onready var hurtbox = $Hurtbox
onready var soft = $SoftCollision
onready var wander_controller = $WanderController
onready var anim = $AnimationPlayer

var knockback = Vector2.ZERO
var velocity = Vector2.ZERO

var state = IDLE

func _ready():
	state = pick_random_state([IDLE, WANDER])

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
# warning-ignore:return_value_discarded
	move_and_slide(knockback)
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			if wander_controller.get_timer_time() == 0:
				update_wander()
		
		WANDER:
			seek_player()
			if wander_controller.get_timer_time() == 0:
				update_wander()
			
			move_toward_point(wander_controller.target_position, delta)
			
			if global_position.distance_to(wander_controller.target_position) <= WANDER_TARGET_RANGE:
				update_wander()
		
		CHASE:
			var player = detect.player
			if player != null:
				move_toward_point(player.global_position, delta)
			else:
				state = IDLE
	
	if soft.is_colliding():
		velocity += soft.get_push_vector() * delta * 400
	velocity = move_and_slide(velocity)

func move_toward_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0

func update_wander():
	state = pick_random_state([IDLE, WANDER])
	wander_controller.start_wander_timer(rand_range(1, 3))

func seek_player():
	if detect.can_see_player():
		state = CHASE

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()
	
 
func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * 120
	hurtbox.create_hitEffect()
	hurtbox.start_invincible(.4)


func _on_Stats_no_health():
	queue_free()
	var deathEffect = DeathEffect.instance()
	get_parent().add_child(deathEffect)
	deathEffect.global_position = global_position
	


func _on_Hurtbox_invincibility_started():
	anim.play("Start")


func _on_Hurtbox_invincibility_ended():
	anim.play("Stop")
