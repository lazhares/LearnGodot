extends TextureRect

var HpSprite={0:preload("res://Sprites/PlaceHolder/ui_heart_empty.png"),
1:preload("res://Sprites/PlaceHolder/ui_heart_quarter.png"),
2:preload("res://Sprites/PlaceHolder/ui_heart_half.png"),
3:preload("res://Sprites/PlaceHolder/ui_heart_three_quarters.png"),
4:preload("res://Sprites/PlaceHolder/ui_heart_full.png")}

var HpValue:int setget set_hp
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.


func set_hp(value:int)->void:
	assert(value<5)
	HpValue=value
	texture=HpSprite[value]

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
