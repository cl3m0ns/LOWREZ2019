extends Node2D
var TYPE = "EFFECT"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	set_z_index(1)
	$Particles2D.one_shot = true
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if $LifeTimer.is_stopped():
		queue_free()