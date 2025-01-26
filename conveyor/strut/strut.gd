@tool
class_name Strut
extends Node3D

@onready var strutBase: StaticBody3D = get_node('StrutBase')
@onready var strutGirder: StaticBody3D = get_node('StrutGirder')

@export var height: float = 0

func _process(_delta):
	if height > 0.68:
		strutBase.show()
	else:
		strutBase.hide()
	
	var girderScale := Vector3.ZERO
	var girderYScale = height / 0.8
	girderScale.x = 1
	girderScale.y = girderYScale
	girderScale.z = 1
	strutGirder.scale = clamp(girderScale, 0.01, girderScale)
	
	strutBase.position.y = -height
	strutGirder.position.y = -height
