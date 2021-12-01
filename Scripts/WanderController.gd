extends Node2D

export(int) var wander_range = 32

onready var start_position = global_position
onready var target_position = global_position
onready var timer = $Timer

func _ready():
	update_target()

func update_target():
	var target_vector = Vector2(rand_range(-wander_range, wander_range), rand_range(-wander_range, wander_range))
	target_position = global_position + target_vector

func get_timer_time():
	return timer.get_time_left()

func start_wander_timer(duration):
	timer.start(duration)

func _on_Timer_timeout():
	update_target()
