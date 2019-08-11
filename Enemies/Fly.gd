extends KinematicBody2D
var TYPE = "ENEMY"
const SPEED = 15

var moveDir = Vector2.RIGHT
var oldDir = Vector2.ZERO
var knockDir = Vector2.ZERO

enum {
	IDLE,
	NEW_DIR,
	MOVE,
	CHASE,
	KNOCKBACK
}
var hp = 3
var player = null

var dirChoose = [Vector2.RIGHT, Vector2.DOWN, Vector2.UP, Vector2.LEFT, Vector2(1,1), Vector2(-1,-1), Vector2(-1,1), Vector2(1,-1)]
var state = IDLE
var oldState = IDLE
var stateChooser = [IDLE, MOVE, NEW_DIR, MOVE, NEW_DIR]
var deathName = "Fly"
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
	$AnimationPlayer.play('alive')
	

func _physics_process(delta):
	if player != null:
		var distance2Hero = get_global_position().distance_to(player.get_global_position())
		if(distance2Hero < 20 && state != KNOCKBACK): 
			state = CHASE
		elif oldState == CHASE:
			state = choose(stateChooser)
	else:
		set_physics_process(false)
		
	if iframes > 0:
		iframes -= 1
		get_node("Sprite").modulate = Color(10,10,10,10)
	else:
		get_node("Sprite").modulate = Color(1,1,1,1)
	
	do_state()
	damage_loop()
	oldState = state

func damage_loop():
	if canDamage == 0:
		for body in $Hitbox.get_overlapping_areas():
			if body.get("TYPE") == "PLAYER_HITBOX":
				print("hurting player")
				var player = body.get_parent()
				player.knockDir = player.get_global_position() - get_global_position()
				player.take_damage()
				canDamage = 100
	else:
		canDamage -= 1

func do_state():
	match state:
		IDLE:
			pass
		NEW_DIR:
			moveDir = choose(dirChoose)
			if moveDir == oldDir:
				choose(dirChoose)
			if moveDir == oldDir:
				choose(dirChoose)
			oldDir = moveDir
			state = choose([IDLE, MOVE, MOVE])
		MOVE:
			move()
		CHASE:
			move_to_player()
		KNOCKBACK:
			do_knockback()

func move_to_player():
	var flyPos = get_global_position()
	var playerPos = player.get_global_position()
	var  moveDir = (playerPos - position).normalized() * SPEED
	move_and_slide(moveDir, Vector2.ZERO)

func move():
	move_and_slide(moveDir.normalized() *SPEED, Vector2.ZERO)

func choose(array):
	array.shuffle()
	return array.front()

func _on_StateTimer_timeout():
	$StateTimer.wait_time = choose([0.25, 0.5, 0.75])
	if state != CHASE:
		state = choose(stateChooser)

func do_knockback():
	if iframes != 0:
		move_and_slide(knockDir.normalized() * SPEED * 2, Vector2.ZERO)
	else:
		state = choose(stateChooser)

func take_damage():
	if iframes == 0:
		iframes = 15
		hp -= 1
		if hp <= 0:
			do_death()
		else:
			state = KNOCKBACK

func do_death():
	get_node("Sprite").modulate = Color(10,10,10,10)
	var boom = bloodSplatter.instance()
	boom.set_position(position)
	get_parent().add_child(boom)
	var dead = death.instance()
	dead.set_position(position)
	dead.deathName = "Fly"
	get_parent().get_node("DeadEnemies").add_child(dead)
	queue_free()