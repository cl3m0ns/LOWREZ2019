extends KinematicBody2D
var TYPE = "ENEMY"

var moveDir = Vector2.RIGHT
enum {
	IDLE,
	NEW_DIR,
	MOVE,
	CHASE
}
var hp = 3
var player = null

var dirChoose = [Vector2.RIGHT, Vector2.DOWN, Vector2.UP, Vector2.LEFT, Vector2(1,1), Vector2(-1,-1), Vector2(-1,1), Vector2(1,-1)]
const SPEED = 20
var state = IDLE
var oldState = IDLE
var oldDir = Vector2.ZERO
var stateChooser = [IDLE, MOVE, NEW_DIR, MOVE, NEW_DIR]

var bloodSplatter = preload("res://Explosion/DeathSplatter.tscn")
var death = preload("res://Enemies/DeadEnemies.tscn")
var deathName = "Fly"
func _ready():
	set_physics_process(false)
	if get_parent().has_node("Player"):
		player = get_parent().get_node("Player")
	$AnimationPlayer.play('alive')
	

func _physics_process(delta):
	if player != null:
		var distance2Hero = get_global_position().distance_to(player.get_global_position())
		if(distance2Hero < 20): 
			state = CHASE
		elif oldState == CHASE:
			state = choose(stateChooser)
	match state:
		IDLE:
			if oldState != state:
				print("Idle")
			pass
		NEW_DIR:
			if oldState != state:
				print("NEW_DIR")
			moveDir = choose(dirChoose)
			if moveDir == oldDir:
				choose(dirChoose)
			if moveDir == oldDir:
				choose(dirChoose)
			oldDir = moveDir
			state = choose([IDLE, MOVE, MOVE])
		MOVE:
			if oldState != state:
				print("MOVE")
			move()
		CHASE:
			if oldState != state:
				print("chase")
			move_to_player()
	
	oldState = state

func move_to_player():
	var flyPos = get_global_position()
	var playerPos = player.get_global_position()
	var  moveDir = (playerPos - position).normalized() * SPEED
	if (playerPos - position).length() > 5:
        move_and_slide(moveDir, Vector2.ZERO)

func move():
	move_and_slide(moveDir.normalized() *SPEED, Vector2.ZERO)

func choose(array):
	array.shuffle()
	return array.front()

func _on_StateTimer_timeout():
	$StateTimer.wait_time = choose([0.25, 0.5, 0.75])
	print($StateTimer.wait_time)
	if state != CHASE:
		state = choose(stateChooser)

func do_death():
	var boom = bloodSplatter.instance()
	boom.set_position(position)
	get_parent().add_child(boom)
	var dead = death.instance()
	dead.set_position(position)
	dead.deathName = "Fly"
	get_parent().get_node("DeadEnemies").add_child(dead)
	queue_free()
	pass