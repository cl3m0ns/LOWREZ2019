extends KinematicBody2D

const speed = 50
var moveDir = Vector2.ZERO
var deathAnim = preload("res://Explosion/Explosion.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var movement = moveDir.normalized() * speed * delta
	var collision_info = move_and_collide(movement)
	if collision_info:
		explode_and_die()
	
	if $LifeTimer.is_stopped():
		queue_free()
		

func explode_and_die():
	var boom = deathAnim.instance()
	boom.set_position(position)
	get_parent().add_child(boom)
	queue_free()
	