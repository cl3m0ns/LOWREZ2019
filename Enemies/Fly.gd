extends KinematicBody2D
var TYPE = "ENEMY"

var moveDir = Vector2.RIGHT
enum {
	IDLE,
	NEW_DIR,
	MOVE,
	CHASE
}

var player = null

var dirChoose = [Vector2.RIGHT, Vector2.DOWN, Vector2.UP, Vector2.LEFT, Vector2(1,1), Vector2(-1,-1), Vector2(-1,1), Vector2(1,-1)]

const SPEED = 20
var state = IDLE

func _ready():
	set_physics_process(false)
	if get_parent().has_node("Player"):
		player = get_parent().get_node("Player")
	$AnimationPlayer.play('alive')
	

func _physics_process(delta):
	if player != null:
		var distance2Hero = get_global_position().distance_to(player.get_global_position())
		print(distance2Hero)
		if(distance2Hero < 20): 
			state = CHASE
		else:
			state = choose([IDLE, MOVE, NEW_DIR, MOVE, NEW_DIR])
	
	match state:
		IDLE:
			pass
		NEW_DIR:
			moveDir = choose(dirChoose)
			state = choose([IDLE, MOVE])
		MOVE:
			move()
		CHASE:
			move_to_player()

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
	if state != CHASE:
		state = choose([IDLE, MOVE, NEW_DIR, MOVE, NEW_DIR])
