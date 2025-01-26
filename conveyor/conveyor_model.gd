@tool
class_name ConveyorModel
extends Node3D

@export var modelNode: MeshInstance3D
@export var conveyorLength: int = 1
@export var conveyorSpeed: float = 1.0

func _process(delta) -> void:
	if modelNode:
		var surfaceMaterial = modelNode.get_surface_override_material(0)
		if surfaceMaterial is ShaderMaterial:	
			surfaceMaterial.set("shader_parameter/ConveyorSpeed", conveyorSpeed)
			surfaceMaterial.set("shader_parameter/ConveyorLength", conveyorLength)
