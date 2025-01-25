class_name Fisu
extends Node3D

@onready var body: Node3D = get_node("%Body")

var body_global_position: Vector3:
	get:
		return body.global_position
