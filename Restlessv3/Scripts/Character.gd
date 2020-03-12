extends Sprite
class_name Character

const CELLSIZE:int=32

var mappos:Vector2 setget set_position
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_position(var value:Vector2)->void:
	mappos=value
	position=value*CELLSIZE



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
