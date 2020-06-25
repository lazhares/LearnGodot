extends Node

const Directions:PoolVector2Array=PoolVector2Array([Vector2(0,-1),
Vector2(0,1),Vector2(1,0),Vector2(-1,0)])
const WALL:int=1
const EMPTY:int=0
const CELLSIZE:int=32
const ID:int=0
const PASSABLE:int=1
const INHABITANT:int=2
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
