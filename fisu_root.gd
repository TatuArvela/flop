class_name Fisu
extends Node3D

@onready var body: Node3D = get_node("body_1")

var body_global_position: Vector3:
	get:
		if body == null || body.is_queued_for_deletion():
			return Vector3.ZERO

		return body.global_position
