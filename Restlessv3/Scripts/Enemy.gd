extends Character 
class_name Enemy

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var current_state:int

const ACTIVE=1
const INACTIVE=0

var counter:int

# Called when the node enters the scene tree for the first time.
func _ready():
	counter=0
	current_state=ACTIVE

func take_turn(var mapgraph:AStar2D, var mapstatus)->void:
	pass



func move(var graph)->void:
	
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
