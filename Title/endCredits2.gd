extends Node2D

onready var bg = $Floor
var origBgPos = Vector2(0, 32)
var nextScene = false

func _ready():
	$TransAnim.play("fade out")
	pass # Replace with function body.

func _process(delta):

	move_bg()

	if nextScene:
		$TransAnim.play("fade in")
		yield(get_node("TransAnim"), "animation_finished")
		get_tree().change_scene("res://Title/Title.tscn")


func _input(event):
	if event is InputEventKey and event.pressed:
		if $AnyKeyTimer.is_stopped():
			nextScene = true

func move_bg():
	var pos = bg.position
	bg.set_position(Vector2(pos.x -.1, pos.y + .1))
	if bg.position.y >= 40:
		bg.set_position(origBgPos)

