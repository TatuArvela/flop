@tool
class_name Strut
extends Node3D

@onready var strutBase: StaticBody3D = get_node('StrutBase')
@onready var strutGirder: Node3D = get_node('StrutGirder')
@onready var strutGirderColliders: StaticBody3D = get_node('StrutGirderColliders')

@export var height: float = 0

func _process(_delta):
	if height > 0.68:
		strutBase.show()
	else:
		strutBase.hide()
	
	var girderScale := Vector3.ZERO
	var girderYScale = height / 0.8
	girderScale.x = 1
	girderScale.y = clamp(girderYScale, 0.01, girderYScale)
	girderScale.z = 1
	strutGirder.scale = girderScale
	
	strutBase.position.y = -height - 0.1
	strutGirder.position.y = -height
	strutGirderColliders.position.y = -height
