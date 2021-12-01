extends KinematicBody2D

var speed = 80 setget set_speed

onready var anim = $AnimatedSprite
var point = Vector2.ZERO
var coll = null

func _ready(): 
	anim.play("Animate")

func _physics_process(delta):
	coll = move_and_collide(point * speed * delta)
	if coll != null:
		queue_free()

func set_speed(value):
	speed = value

func toward_point(value):
	point = value.normalized()
	self.rotation =  PI + atan2(value.y, value.x) 
