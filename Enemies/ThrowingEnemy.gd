extends KinematicBody2D
var TYPE = "ENEMY"

enum {
	IDLE,
	ATTACK
}
var hp = 3
var player = null
var damage = 1
var throwingCooldown = 0
var stateChooser = [IDLE, ATTACK]
var deathName = "Throwing1"
var iframes = 0
var knockDir = Vector2.ZERO
#resources
var bloodSplatter = preload("res://Explosion/DeathSplatter.tscn")
var death = preload("res://Enemies/DeadEnemies.tscn")
var bullet = preload("res://Bullet/EnemyBullet.tscn")
var state = IDLE

func _ready():
	set_physics_process(false)
	set_z_index(1)
	if get_parent().has_node("Player"):
		player = get_parent().get_node("Player")
	$AnimationPlayer.play('idle')
	

func _physics_process(delta):
	if iframes > 0:
		iframes -= 1
		get_node("Sprite").modulate = Color(10,10,10,10)
	else:
		get_node("Sprite").modulate = Color(1,1,1,1)
	
	do_state()

func do_state():
	if throwingCooldown > 0:
		throwingCooldown -= 1

	
	match state:
		IDLE:
			$AnimationPlayer.play('idle')
		ATTACK:
			do_attack()


func do_bullet():
	var myBullet = bullet.instance()
	var bulletPos = Vector2.ZERO
	var bulletDir = Vector2.RIGHT
	match $Sprite.flip_h:
		true:
			bulletPos = Vector2(position.x -5, position.y + 2)
			bulletDir = Vector2.LEFT
			myBullet.set_rotation_degrees(180)
		false:
			bulletPos = Vector2(position.x +5, position.y + 2)
			bulletDir = Vector2.RIGHT
			myBullet.set_rotation_degrees(0)
	
	myBullet.moveDir = bulletDir
	myBullet.damage = damage
	myBullet.set_position(bulletPos)
	
	#add to scene
	$ShootAudio.play()
	get_parent().add_child(myBullet)

func do_attack():
	if throwingCooldown <= 0:
		$AnimationPlayer.play("attack")
		throwingCooldown = 100

func choose(array):
	array.shuffle()
	return array.front()

func _on_StateTimer_timeout():
	$StateTimer.wait_time = choose([0.25, 0.5, 0.75])
	if throwingCooldown <= 0:
		state = choose(stateChooser)
	elif state != ATTACK:
		state = IDLE

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
	dead.deathName = "Throwing1"
	get_parent().get_node("DeadEnemies").add_child(dead)
	queue_free()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "attack":
		do_bullet()
		state = IDLE
