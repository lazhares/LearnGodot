
class_name Heart
extends TextureRect


var HpValue:int setget set_hp

const HpSprite={
	0:preload("res://Sprites/PlaceHolder/ui_heart_empty.png"),
	1:preload("res://Sprites/PlaceHolder/ui_heart_quarter.png"),
	2:preload("res://Sprites/PlaceHolder/ui_heart_half.png"),
	3:preload("res://Sprites/PlaceHolder/ui_heart_three_quarters.png"),
	4:preload("res://Sprites/PlaceHolder/ui_heart_full.png"),
}


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.

func _init(value:int):
	margin_right=value
	margin_bottom=value


func set_hp(value:int)->void:
	assert(value<5)
	assert(value>-1)
	HpValue=value
	texture=HpSprite[value]

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
