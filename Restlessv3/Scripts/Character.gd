class_name Character
extends Sprite


const CELLSIZE:int=32

var HpManager:HpContainer
var current_hp:int setget set_hp
var max_hp:int setget set_max_hp
var current_map_pos:Vector2 setget set_position
var next_map_pos:Vector2
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_position(value:Vector2)->void:
	current_map_pos=value


func set_hp(value:int)->void:
	HpManager.set_hp=value
	
func set_max_hp(value:int)->void:
	HpManager.set_max_hp=value


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
