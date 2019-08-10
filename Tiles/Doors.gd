extends StaticBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var showDoors = false
var hideDoors = true

# Called when the node enters the scene tree for the first time.
func _ready():
	hide_doors()

func hide_doors():
	GLOBAL.DOORS_HIDDEN = true
	$CollisionShape2D.disabled = true
	$Sprite.visible = false

func show_doors():
	GLOBAL.DOORS_HIDDEN = false
	$CollisionShape2D.disabled = false
	$Sprite.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if hideDoors && $Sprite.visible == true:
		hide_doors()
		hideDoors = false
	
	if showDoors:
		show_doors()
		showDoors = false
