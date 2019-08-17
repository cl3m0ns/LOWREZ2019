extends KinematicBody2D
var TYPE = "BOSS"
const SPEED = 20

var moveDir = Vector2.RIGHT
var oldDir = Vector2.ZERO
var knockDir = Vector2.ZERO

enum {
	IDLE,
	JUMP,
	MOVE,
	ATTACK
}
var hp = 10
var player = null
var attackStart = false
var canBeHurt = true
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
	if canDamage == 0:
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
			canBeHurt = true
			$AnimationPlayer.play('idle')
		JUMP:
			canBeHurt = false
			jump()
		MOVE:
			collision_mask
			canBeHurt = false
			move()
		ATTACK:
			canBeHurt = false
			attack()

func attack():
	if $AnimationPlayer.current_animation != "land" && attackStart == true:
		attackStart = false
		$AnimationPlayer.play("land")

func jump():
	if $AnimationPlayer.current_animation != "jump" && $AnimationPlayer.current_animation != "":
		#first time we hit jump
		$AnimationPlayer.play("jump")

func move():
	var flyPos = $Hitbox.get_global_position()
	var playerPos = player.get_global_position()
	var distToPlayer = flyPos.distance_to(playerPos); 
	var moveDir = (playerPos - flyPos).normalized() * SPEED
	if distToPlayer < 2:
		attackStart = true
		state = ATTACK
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
		$HurtAudio.play()
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
	GLOBAL.BOSS_ROOM = false
	get_tree().change_scene("res://Title/Win.tscn")
	queue_free()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "land":
		state = IDLE
		$StateTimer.wait_time = choose([1.25, 1.5, 1.75])
