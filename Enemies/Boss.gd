extends KinematicBody2D
var TYPE = "ENEMY"
const SPEED = 20

var moveDir = Vector2.RIGHT
var oldDir = Vector2.ZERO
var knockDir = Vector2.ZERO

enum {
	IDLE,
	JUMP,
	MOVE,
	LAND
}
var hp = 30
var player = null

var state = IDLE
var stateChooser = [IDLE, JUMP]
var deathName = "Boss"
var iframes = 0
var canDamage = 0
#resources
var bloodSplatter = preload("res://Explosion/DeathSplatter.tscn")
var death = preload("res://Enemies/DeadEnemies.tscn")

func _ready():
	set_physics_process(false)
	set_z_index(1)
	if get_parent().has_node("Player"):
		player = get_parent().get_node("Player")
	$AnimationPlayer.play('idle')
	state = IDLE
	

func _physics_process(delta):
	if player == null:
		set_physics_process(false)
		
	if iframes > 0:
		iframes -= 1
		get_node("Sprite").modulate = Color(10,10,10,10)
	else:
		get_node("Sprite").modulate = Color(1,1,1,1)
	
	do_state()
	damage_loop()

func damage_loop():
	if canDamage == 0 && state != MOVE && state != JUMP:
		for body in $Hitbox.get_overlapping_areas():
			if body.get("TYPE") == "PLAYER_HITBOX":
				var player = body.get_parent()
				player.knockDir = player.get_global_position() - get_global_position()
				player.take_damage()
				canDamage = 50
	else:
		canDamage -= 1

func do_state():
	match state:
		IDLE:
			pass
		JUMP:
			jump()
		MOVE:
			move()

func jump():
	if $AnimationPlayer.current_animation != "jump" && $AnimationPlayer.current_animation != "":
		$AnimationPlayer.play("jump")

func move():
	var flyPos = $Hitbox.get_global_position()
	var playerPos = player.get_global_position()
	var moveDir = (playerPos - flyPos).normalized() * SPEED
	move_and_slide(moveDir, Vector2.ZERO)

func choose(array):
	array.shuffle()
	return array.front()

func _on_StateTimer_timeout():
	$StateTimer.wait_time = choose([1.25, 1.5, 1.75])
	if state != JUMP:
		state = choose([IDLE, JUMP])
	if state == JUMP && $AnimationPlayer.current_animation == "":
		state = MOVE
	

func do_knockback():
	pass

func take_damage():
	if iframes == 0:
		iframes = 15
		hp -= 1
		if hp <= 0:
			do_death()

func do_death():
	get_node("Sprite").modulate = Color(10,10,10,10)
	var boom = bloodSplatter.instance()
	boom.set_position(position)
	get_parent().add_child(boom)
	var dead = death.instance()
	dead.set_position(position)
	dead.deathName = "Boss"
	get_parent().get_node("DeadEnemies").add_child(dead)
	get_tree().change_scene("res://Title/Win.tscn")
	queue_free()