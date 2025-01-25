extends Node3D

@export var player: PlayerController

var fisu: Fisu:
	get:
		return player.body

@export var camera_smoothing_speed_xz = 1.0
@export var camera_smoothing_speed_y = 0.01

func _physics_process(delta: float) -> void:
	if fisu == null || fisu.is_queued_for_deletion():
		return

	global_position.x = lerp(global_position.x, fisu.body_global_position.x, camera_smoothing_speed_xz * delta)
	global_position.z = lerp(global_position.z, fisu.body_global_position.z, camera_smoothing_speed_xz * delta)

	global_position.y = lerp(global_position.y, fisu.body_global_position.y, camera_smoothing_speed_y * delta)
