extends Node2D

var map = [
	[0,0],[1,0],[2,0],[3,0],
	[0,1],[1,1],[2,1],[3,1],
	[0,2],[1,2],[2,2],[3,2],
	[0,3],[1,3],[2,3],[3,3],
]
var testXWidth = 64
var testYWidth = 64
#Test Rooms are 480 x 336
var room = preload("res://Scenes/TestRoom.tscn")
var player = preload("res://Player/Player.tscn")
        #add_child(bullet)

var mapFirstRow = 	[[0,0],[1,0],[2,0],[3,0]]

func add_player(startPlayerPos):
	var plyr = player.instance()
	plyr.set_position(startPlayerPos)
	add_child(plyr)

func _ready():
	#pick a starting point in the first row
	var startingPoint = choose(mapFirstRow)
	#spawn start room at starting point
	var x = startingPoint[0] * testXWidth
	var y = startingPoint[1] * testYWidth
	var startPlayerPos = Vector2(x+32, y+32)
	print("player x: ", x, "player y: ", y)
	print("x: ", x, " y: ", y)
	var startRoom = room.instance()
	startRoom.set_position(Vector2(x, y))
	add_child(startRoom)
	
	
	#randomly add y, or subract or add x
	var xory = choose(["x", "y"])
	print("xory: ", xory)
	match xory:
		"x":
			x = startingPoint[0] + choose([1, -1]) * testXWidth
			print("x: ", x, " y: ", y)
			var nextRoom = room.instance()
			nextRoom.set_position(Vector2(x, y))
			add_child(nextRoom)
		"y":
			y = startingPoint[1] + 1 * testYWidth
			print("x: ", x, " y: ", y)
			var nextRoom = room.instance()
			nextRoom.set_position(Vector2(x, y))
			add_child(nextRoom)
	
	
	#if x == 0 || x=== 3 then move down a row
	
	#if y === 3 stop.
	
	#when done add player to startRoom
	add_player(startPlayerPos)
	
	pass # Replace with function body.


func choose(array):
	array.shuffle()
	return array.front()