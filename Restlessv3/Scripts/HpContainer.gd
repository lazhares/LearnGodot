extends HBoxContainer
var MaxHp:int setget set_max_hp
var CurrentHp:int setget set_hp
var Heart:Resource=preload("res://Heart.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#self.MaxHp=9
	#self.CurrentHp=5
	pass # Replace with function body.

func set_max_hp(value:int)->void:
	MaxHp=value
# warning-ignore:integer_division
	var HeartNumber:int=int((value-1)/4) + 1
	#print(get_child_count(),",",HeartNumber)
	if get_child_count()<HeartNumber:
		margin_right=32*HeartNumber+margin_left
# warning-ignore:unused_variable
		for i in range (HeartNumber-get_child_count()):
			add_child(Heart.instance())
			
			
func set_hp(value:int)->void:
	CurrentHp=value
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
