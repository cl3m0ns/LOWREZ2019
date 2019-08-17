extends Node2D

var deathName = ""
var pickup = preload("res://Player/Heart_Pickup.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$DieAudio.play()
	set_z_index(1)
	$Fly.visible = false
	$KnifeGuy.visible = false
	$Meatball.visible = false
	$Throwing1.visible = false
	$Throwing2.visible = false
	$Throwing3.visible = false
	var drop = choose([false, false, true, false])
	
	match deathName:
		"Fly":
			$Fly.visible = true
			$Fly/FlyAnim.play("die")
			yield($Fly/FlyAnim, "animation_finished")
			addHp(drop)
			set_physics_process(false)
		"KnifeGuy":
			$KnifeGuy.visible = true
			$KnifeGuy/KnifeGuyAnim.play("die")
			yield($KnifeGuy/KnifeGuyAnim, "animation_finished")
			addHp(drop)
			set_physics_process(false)
		"Meatball":
			$Meatball.visible = true
			$Meatball/MeatballAnim.play("die")
			yield($Meatball/MeatballAnim, "animation_finished")
			addHp(drop)
			set_physics_process(false)
		"Throwing1":
			$Throwing1.visible = true
			$Throwing1/Throwing1Anim.play("die")
			yield($Throwing1/Throwing1Anim, "animation_finished")
			addHp(drop)
			set_physics_process(false)
		"Throwing2":
			$Throwing2.visible = true
			$Throwing2/Throwing2Anim.play("die")
			yield($Throwing2/Throwing2Anim, "animation_finished")
			addHp(drop)
			set_physics_process(false)
		"Throwing3":
			$Throwing3.visible = true
			$Throwing3/Throwing3Anim.play("die")
			yield($Throwing3/Throwing3Anim, "animation_finished")
			addHp(drop)
			set_physics_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func addHp(drop):
	if drop:
		var hp = pickup.instance()
		hp.set_position(position)
		get_node("/root/TestRoom").add_child(hp)

func choose(array):
	array.shuffle()
	return array.front()
