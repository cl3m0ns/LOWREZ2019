extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var camera = get_parent().find_node("Camera")
	set_position(camera.position)
	
	if Input.is_action_just_released("escape") && !visible:
		visible = true
		get_tree().paused = true
	elif Input.is_action_just_released("escape") && visible:
		visible = false
		get_tree().paused = false


func _on_CheckBox_toggled(button_pressed):
	if $CheckBox.pressed == true:
		GLOBAL.SOUND_OFF = true
		$ColorRect.visible = true
	else:
		GLOBAL.SOUND_OFF = false
		$ColorRect.visible = false
