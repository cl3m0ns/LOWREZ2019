extends Camera2D

func _ready():
	$Area.connect("body_entered", self, "body_entered")
	$Area.connect("body_exited", self, "body_exited")

func _process(delta):
	var player = get_node("../Player")
	var pos = player.global_position
	var x = floor(pos.x / 64) * 64
	var y = floor(pos.y / 64) * 64
	global_position = Vector2(x, y)

func body_exited(body):
	if body.get("TYPE") == "ENEMY":
		body.set_physics_process(false)

func body_entered(body):
	if body.get("TYPE") == "ENEMY":
		body.set_physics_process(true)