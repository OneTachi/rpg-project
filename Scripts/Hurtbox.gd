extends Area2D

const HitEffect = preload("res://Scenes/Effects/HitEffect.tscn")


var invincible = false setget set_invincible
var stay = false
onready var timer = $Timer
onready var col = $CollisionShape2D
signal invincibility_started
signal invincibility_ended

func set_invincible(value):
	invincible = value
	if invincible:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")

func start_invincible(duration):
	self.invincible = true
	timer.start(duration)

func stay_invincible(value):
	self.invincible = value 
	stay = value

func create_hitEffect():
	var effect = HitEffect.instance()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position


func _on_Timer_timeout():
	if !stay:
		self.invincible = false # Using setter, won't activate without self


func _on_Hurtbox_invincibility_ended():
	col.set_deferred("disabled", false)


func _on_Hurtbox_invincibility_started():
	col.set_deferred("disabled", true)
