#Class for hp UI
class_name HpContainer 

extends HBoxContainer


var _Heart:PackedScene=preload("res://Heart.tscn") #HeartResource
export var heart_size:int
var max_hp:int setget set_max_hp
var current_hp:int setget set_hp


func _init(heart_size_value:int, max_hp_value:int):
	heart_size=heart_size_value
	self.max_hp=max_hp_value
	self.current_hp=max_hp_value
	


func set_max_hp(value:int)->void:
	max_hp=value
# warning-ignore:integer_division
	var HeartNumber:int=int((value-1)/4) + 1
	#print(get_child_count(),",",HeartNumber)
	if get_child_count()<HeartNumber:
		margin_right=32*HeartNumber+margin_left
# warning-ignore:unused_variable
		for i in range (HeartNumber-get_child_count()):
			var NewHeart:Heart=_Heart.instance()
			NewHeart._init(heart_size)
			add_child(NewHeart)
			
			
func set_hp(value:int)->void:
	current_hp=value
	for heart in get_children():
		if value>4:
			heart.HpValue=4
			value=value-4
		else:
			heart.HpValue=value
			value=0

	

	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
