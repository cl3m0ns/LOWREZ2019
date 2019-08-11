extends Node2D

var deathName = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	set_z_index(1)
	$Fly.visible = false
	print("dead z, ", get_z_index())
	match deathName:
		"Fly":
			$Fly.visible = true
			$Fly/FlyAnim.play("die")
			yield($Fly/FlyAnim, "animation_finished")
			set_physics_process(false)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
