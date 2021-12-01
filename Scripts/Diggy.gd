extends KinematicBody2D


enum {
	IDLE,
	SHOOT,
	REPOSITION
}

const Bullet = preload("res://Scenes/Effects/DirtBullet.tscn")
const DeathEffect = preload("res://Scenes/Effects/EnemyDeathEffect.tscn")

onready var stats = $Stats
onready var detect = $PlayerDetectionZone
onready var danger = $DangerZone
onready var hurtbox = $Hurtbox
onready var timer = $Timer
onready var dTimer = $DangerTimer
onready var anim = $AnimationPlayer
onready var part = $Particles2D
onready var hitAnim = $HitAnimationPlayer

var state = IDLE
var repos = false
var to_position

func _physics_process(delta):
	match state:
		IDLE:
			if idle_anim():
				seek_player()
		
		SHOOT:
			idle_anim()
			var player = detect.player
			if player != null:
				if timer.is_stopped():
					var bullet = Bullet.instance()
					get_parent().add_child(bullet)
					bullet.global_position = global_position
					bullet.set_speed(120)
					bullet.toward_point(global_position.direction_to(player.global_position) + Vector2(rand_range(-.4, .4), rand_range(-.4, .4)))
					timer.start(1)
			else:
				state = IDLE
			seek_danger()
		
		REPOSITION:
			if dTimer.is_stopped():
				to_position = Vector2(rand_range(-100, 100), rand_range(-100, 100))
				hurtbox.stay_invincible(false)
				anim.play("Duck")
				dTimer.start(2)
			if repos:
				move_and_slide(to_position * .8)

func duck():
	hurtbox.stay_invincible(true)
	repos = true
	part.emitting = true

func rise():
	anim.play("Rise")
	repos = false
	to_position = global_position
	state = IDLE
	part.emitting = false

func idle_anim():
	if !anim.is_playing():
		anim.play("Look")
	if anim.current_animation == "Look":
		return true
	else:
		return false

func seek_player():
	if detect.can_see_player():
		state = SHOOT

func seek_danger():
	if danger.can_see_player():
		state = REPOSITION

func _on_Stats_no_health():
	var deathEffect = DeathEffect.instance()
	get_parent().add_child(deathEffect)
	deathEffect.global_position = global_position
	queue_free()

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	if !hurtbox.invincible:
		hurtbox.start_invincible(.4)
	#hitAnim.play("Start")


func _on_Hurtbox_invincibility_ended():
	pass
	#hitAnim.play("Stop")

func _on_DangerTimer_timeout():
	rise()
