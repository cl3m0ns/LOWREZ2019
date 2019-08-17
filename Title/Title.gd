extends Node2D

onready var sprite1 = $Sprite1
onready var sprite2 = $Sprite2
onready var bg = $Floor
var origBgPos = Vector2(0, 32)
var nextScene = false

func _ready():
	$AudioStreamPlayer2D.play()
	$SnailPlayer.play("move")
	$Chef1Anim.play("move")
	$meatballAnim.play("move")
	$TransAnim.play("fade out")
	pass # Replace with function body.

func _process(delta):

	blink_any_key()
	move_bg()

	if $ClemTime.is_stopped() && nextScene:
		$TransAnim.play("fade in")
		yield(get_node("TransAnim"), "animation_finished")
		get_tree().change_scene("res://Title/Intro.tscn")


func _input(event):
	if event is InputEventKey and event.pressed:
		if $AnyKeyTimer.is_stopped() && !$Clemonades.visible:
			$TransAnim.play("fade in")
			yield(get_node("TransAnim"), "animation_finished")
			show_clemonades()
			$TransAnim.play("fade out")


func show_clemonades():
	$ClemTime.start()
	$Snail.visible = false
	$Sprite1.visible = false
	$Sprite2.visible = false
	$Chef1.visible = false
	$meatballsprite.visible = false
	$Clemonades.visible = true
	nextScene = true

func blink_any_key():
	if $BlinkTimer.is_stopped():
		if sprite1.visible:
			sprite1.visible = false
			sprite2.visible = true
		elif sprite2.visible:
			sprite1.visible = true
			sprite2.visible = false

		$BlinkTimer.start()

func move_bg():
	var pos = bg.position
	bg.set_position(Vector2(pos.x -.1, pos.y + .1))
	if bg.position.y >= 40:
		bg.set_position(origBgPos)
