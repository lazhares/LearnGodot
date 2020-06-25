class_name Player
extends Character 


var HpGui:HpContainer
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	HpGui=get_node("/root/Main/UI/HpContainer")
	pass # Replace with function body.

func set_hp(value:int)->void:
	current_hp=value
	HpGui.set_hp(value)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
