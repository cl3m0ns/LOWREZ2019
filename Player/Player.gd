extends KinematicBody2D

# Declare member variables here
export (int) var speed = 25
var TYPE = "PLAYER"
var bullet = preload("res://Bullet/Bullet.tscn")
var moveDir = Vector2.ZERO
var attackDir = Vector2.ZERO

var lastmoveDir = Vector2.ZERO

enum facings { up, down, left, right }
enum states { idle, move }

var FACING = facings.right
var STATE
var PREV_STATE
var NEXT_STATE = states.idle

# Called when the node enters the scene tree for the first time.
func _ready():
	set_z_index(1)
	idle_state()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	STATE = NEXT_STATE
	if STATE == states.idle:
		idle_state()
	elif STATE == states.move:
		move_state()


func set_last_moveDir():
	lastmoveDir = moveDir;


func get_next_state():
	var right = Input.is_action_pressed("move_right")
	var left = Input.is_action_pressed("move_left")
	var up = Input.is_action_pressed("move_up")
	var down = Input.is_action_pressed("move_down")
	
	var attack_left = Input.is_action_pressed("ui_left")
	var attack_right = Input.is_action_pressed("ui_right")
	var attack_up = Input.is_action_pressed("ui_up")
	var attack_down = Input.is_action_pressed("ui_down")
	
	if right || left || up || down:
		NEXT_STATE = states.move
	else:
		NEXT_STATE = states.idle



#########################################################
###### IDLE STATE #######################################
#########################################################
func idle_state():
	match FACING:
		facings.right:
			$Sprite.flip_h = false
			$AnimationPlayer.play("Idle Side")
		facings.left:
			$Sprite.flip_h = true
			$AnimationPlayer.play("Idle Side")
		facings.up:
			$AnimationPlayer.play("Idle Back")
		facings.down:
			$AnimationPlayer.play("Idle Front")
	
	try_and_attack()
		
	if attackDir != Vector2.ZERO:
		update_attack_sprite()
	
	set_last_moveDir()
	get_next_state()
#########################################################


########################ATTACK STUFF######################
func try_and_attack():
	get_attack_inputs()
	if attackDir != Vector2.ZERO && $ShootTimer.is_stopped():
		attack_loop()

func get_attack_inputs():
	var attack_up = Input.is_action_pressed("ui_up")
	var attack_down = Input.is_action_pressed("ui_down")
	var attack_right = Input.is_action_pressed("ui_right")
	var attack_left = Input.is_action_pressed("ui_left")
	
	if attack_up: 
		attackDir = Vector2.UP
	elif attack_down: 
		attackDir = Vector2.DOWN
	elif attack_left: 
		attackDir = Vector2.LEFT
	elif attack_right: 
		attackDir = Vector2.RIGHT
	else:
		attackDir = Vector2.ZERO

func attack_loop():
	var myBullet = bullet.instance()
	var bulletPos = Vector2(position.x + 5, position.y + 5)
	
	match attackDir:
		Vector2.UP:
			bulletPos = Vector2(position.x, position.y - 5)
			myBullet.set_rotation_degrees(270)
		Vector2.DOWN:
			bulletPos = Vector2(position.x, position.y + 5)
			myBullet.set_rotation_degrees(90)
		Vector2.LEFT:
			bulletPos = Vector2(position.x -5, position.y)
			myBullet.set_rotation_degrees(180)
		Vector2.RIGHT:
			bulletPos = Vector2(position.x +5, position.y)
			myBullet.set_rotation_degrees(0)
	
	myBullet.moveDir = attackDir
	myBullet.set_position(bulletPos)
	
	#add to scene
	get_parent().add_child(myBullet)
	#start timer
	$ShootTimer.start()



#########################################################
###### MOVE STATE #######################################
#########################################################
func move_state():
	get_movement_inputs()
	movement_loop()
	try_and_attack()
	if attackDir != Vector2.ZERO:
		update_attack_sprite()
	else:
		update_walk_sprite()
	set_last_moveDir()
	get_next_state()

func movement_loop():
	var motion = moveDir.normalized() * speed
	move_and_slide(motion, Vector2(0,0))

func get_movement_inputs():
	var move_up = Input.is_action_pressed("move_up");
	var move_down = Input.is_action_pressed("move_down");
	var move_right = Input.is_action_pressed("move_right");
	var move_left = Input.is_action_pressed("move_left");
	
	moveDir.x = -int(move_left) + int(move_right)
	moveDir.y = -int(move_up) + int(move_down)

func update_walk_sprite():
	var movingHorizontal = false
	var movingVertical = false
	if lastmoveDir.x != 0:movingHorizontal = true
	if lastmoveDir.y != 0:movingVertical = true
	
	if moveDir.x < 0 && !movingVertical:
		$Sprite.flip_h = true
		$AnimationPlayer.play("Walk Side")
		FACING = facings.left
	elif moveDir.x > 0 && !movingVertical:
		$Sprite.flip_h = false
		$AnimationPlayer.play("Walk Side")
		FACING = facings.right
	elif moveDir.y > 0 && !movingHorizontal:
		$AnimationPlayer.play("Walk Front")
		FACING = facings.down
	elif moveDir.y < 0 && !movingHorizontal:
		$AnimationPlayer.play("Walk Back")
		FACING = facings.up
	elif moveDir.y == 0 && moveDir.x == 0:
		NEXT_STATE = states.idle
		PREV_STATE = STATE
	
###########################################################

func update_attack_sprite():
	var animationStr = "Idle "
	if STATE == states.move:
		animationStr = "Walk "
	if attackDir.x < 0:
		$Sprite.flip_h = true
		$AnimationPlayer.play(animationStr+"Side")
		FACING = facings.left
	elif attackDir.x > 0:
		$Sprite.flip_h = false
		$AnimationPlayer.play(animationStr+"Side")
		FACING = facings.right
	elif attackDir.y > 0:
		$AnimationPlayer.play(animationStr+"Front")
		FACING = facings.down
	elif attackDir.y < 0:
		$AnimationPlayer.play(animationStr+"Back")
		FACING = facings.up