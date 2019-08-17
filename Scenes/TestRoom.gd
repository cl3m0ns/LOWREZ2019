extends Node2D

func _ready():
	if !GLOBAL.SOUND_OFF:
		$AudioStreamPlayer2D.play()

func _process(delta):
	if GLOBAL.SOUND_OFF:
		$AudioStreamPlayer2D.stop()
	elif !$AudioStreamPlayer2D.playing:
		$AudioStreamPlayer2D.play()