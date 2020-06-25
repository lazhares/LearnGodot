
class_name Enemy
extends Character 


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const ACTIVE=1
const INACTIVE=0

var current_state:int=ACTIVE
var counter:int=0



# Called when the node enters the scene tree for the first time.
func _ready():
	current_hp=4
	max_hp=4
	assert($HpContainer is HpContainer)
	HpManager=get_node("HpContainer")
	HpManager._init(16,4)
	$AnimationPlayer.play("MOVEMENT_UP")

func take_turn(mapgraph:AStar2D, mapstatus)->bool:
	if check_for_attack(mapstatus)==true:
		pass
	return true


func check_for_attack(mapstatus)->bool:
	for dir in G.Directions:
		if mapstatus[G.INHABITANT] is Player:
			return true
	return false


func move(graph)->void:
	
	pass
	
func center_position()->void:
	var real_offset:Vector2=offset - (G.CELLSIZE/2)*Vector2(1,1)
	position+=real_offset
	offset=(G.CELLSIZE/2)*Vector2(1,1)
	return



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
