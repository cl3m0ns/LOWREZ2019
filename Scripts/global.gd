extends Node

var map_seed = 0

var DOORS_HIDDEN = true
var BOSS_ROOM = false

func _ready():
	randomize()
	if !map_seed:
		map_seed = randi()
		seed(map_seed)
		print("Seed: ", map_seed)