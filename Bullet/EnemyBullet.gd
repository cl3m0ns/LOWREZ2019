extends KinematicBody2D

var TYPE = "ENEMY_BULLET"
const speed = 50
var moveDir = Vector2.ZERO
var canHurt = true
var deathAnim = preload("res://Explosion/EnemyBulletExplosion.tscn")
var damage = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	set_z_index(1)
	explode()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var movement = moveDir.normalized() * speed * delta
	var collision_info = move_and_collide(movement)
	if collision_info:
		explode_and_die()
	
	damage_loop()
	
	if $LifeTimer.is_stopped():
		queue_free()
		

func explode_and_die():
	explode()
	queue_free()

func explode():
	var boom = deathAnim.instance()
	boom.set_position(position)
	get_parent().add_child(boom)

func damage_loop():
	for body in $Hitbox.get_overlapping_bodies():
		if body.get("TYPE") == "PLAYER" && canHurt:
			body.knockDir = body.get_global_position() - get_global_position()
			body.take_damage()
			canHurt = false
			explode_and_die()