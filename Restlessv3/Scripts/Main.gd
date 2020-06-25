extends Control
var CameraNode:Camera2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready()->void:
	get_node("UI/HpContainer").max_hp=8
	get_node("UI/HpContainer").current_hp=5
	get_node("WorldMap").HpContainer=get_node("UI/HpContainer")
	pass
	#CameraNode=get_node("Camera2D")

func _input(event:InputEvent)->void:
#	if event is InputEventMouseButton:
#		if event.button_index == BUTTON_WHEEL_UP and event.pressed:
#				CameraNode.zoom=CameraNode.zoom+Vector2(0.25,0.25)
#		if event.button_index == BUTTON_WHEEL_DOWN and event.pressed:
#			CameraNode.zoom=CameraNode.zoom-Vector2(0.25,0.25)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	pass
