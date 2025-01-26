class_name PostProcessing
extends ColorRect

@export_range(0.0, 1.0, 0.01) var darken: float = 0.0:
	get:
		return darken
	set(value):
		darken = value
		if material is ShaderMaterial:	
			material.set("shader_parameter/darken", darken)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if material is ShaderMaterial:	
		material.set("shader_parameter/darken", darken)
