extends Node3D

@onready var fisu: Fisu = get_parent().get_parent()

@export var camera_smoothing_speed_xz = 1.0
@export var camera_smoothing_speed_y = 0.01

func _physics_process(delta: float) -> void:
	global_position.x = lerp(global_position.x, fisu.body_global_position.x, camera_smoothing_speed_xz * delta)
	global_position.z = lerp(global_position.z, fisu.body_global_position.z, camera_smoothing_speed_xz * delta)

	global_position.y = lerp(global_position.y, fisu.body_global_position.y, camera_smoothing_speed_y * delta)
