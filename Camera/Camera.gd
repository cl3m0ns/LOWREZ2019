extends Camera2D

var oldPos = Vector2(0, 64)
var TYPE = "CAMERA"
func _ready():
	$Area.connect("body_entered", self, "body_entered")
	$Area.connect("body_exited", self, "body_exited")

func _process(delta):
	var player = get_node("../Player")
	var pos = player.global_position
	var x = floor(pos.x / 64) * 64
	var y = floor(pos.y / 64) * 64
	global_position = Vector2(x, y)
	
	if oldPos != global_position:
		move_player_into_room()
	
	oldPos = global_position
	check_for_enemies()

func update_hp():
	var player = get_parent().get_node("Player")
	var hp = player.hp
	match hp:
		0:
			$hp.modulate = Color(0,0,0,0)
			$hp2.modulate = Color(0,0,0,0)
			$hp3.modulate = Color(0,0,0,0)
			disable_enemies()
		1:
			$hp2.modulate = Color(0,0,0,0)
			$hp3.modulate = Color(0,0,0,0)
		2:
			$hp3.modulate = Color(0,0,0,0)
		3:
			$hp.modulate = Color(1,1,1,1)
			$hp2.modulate = Color(1,1,1,1)
			$hp3.modulate = Color(1,1,1,1)

func disable_enemies():
	var collisions = $Area.get_overlapping_bodies()
	
	for i in collisions:
		if i.get("TYPE") == "ENEMY":
			i.set_physics_process(false)

func check_for_enemies():
	var collisions = $Area.get_overlapping_bodies()
	
	var showDoors = false
	for i in collisions:
		if i.get("TYPE") == "ENEMY":
			showDoors = true
	
	if GLOBAL.DOORS_HIDDEN && showDoors:
		var doors = get_parent().get_node("Doors").get_children()
		for d in doors:
			d.show_doors()
		
	elif !GLOBAL.DOORS_HIDDEN && !showDoors:
		var doors = get_parent().get_node("Doors").get_children()
		for d in doors:
			d.hide_doors()

func body_exited(body):
	if body.get("TYPE") == "ENEMY":
		body.set_physics_process(false)

func move_player_into_room():
	var player = get_node("../Player")
	var myPos = get_global_position()
	var playerPos = player.get_global_position()
	var center = Vector2(myPos.x + 32, myPos.y + 32)
	print(center)
	if center.x - playerPos.x > 20:
		center.x -= 24
	if center.y - playerPos.y > 20:
		center.y -= 24
	if center.x - playerPos.x < -20:
		center.x += 24
	if center.y - playerPos.y < -20:
		center.y += 24
	
	player.set_position(Vector2(center.x, center.y))

func body_entered(body):
	if body.get("TYPE") == "ENEMY":
		body.set_physics_process(true)