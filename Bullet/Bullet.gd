extends KinematicBody2D

var TYPE = "BULLET"
const speed = 50
var moveDir = Vector2.ZERO
var canHurt = true
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
	
	damage_loop()
	
	if $LifeTimer.is_stopped():
		queue_free()
		

func explode_and_die():
	var boom = deathAnim.instance()
	boom.set_position(position)
	get_parent().add_child(boom)
	queue_free()
	

func damage_loop():
	for body in $Hitbox.get_overlapping_bodies():
		if body.get("TYPE") == "ENEMY" && canHurt:
			print("hurting someone")
			canHurt = false
			body.hp = body.hp -1
			if body.hp <= 0:
				body.do_death()
		if body != self && body.get("TYPE") != "PLAYER":
			explode_and_die()