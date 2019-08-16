extends Node2D
var TYPE = "PICKUP"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	for body in $Hitbox.get_overlapping_bodies():
		if body.get("TYPE") == "PLAYER":
			if body.hp != body.maxHp:
				body.hp += 1
				get_parent().find_node("Camera").update_hp()
				queue_free()