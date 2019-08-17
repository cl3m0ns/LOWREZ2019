extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	if !GLOBAL.SOUND_OFF:
		$AudioStreamPlayer2D.play()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GLOBAL.SOUND_OFF:
		$AudioStreamPlayer2D.stop()
	elif !$AudioStreamPlayer2D.playing:
		$AudioStreamPlayer2D.play()
#	pass
