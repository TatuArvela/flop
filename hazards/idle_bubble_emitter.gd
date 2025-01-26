extends Node3D

func _physics_process(_delta: float) -> void:
	global_position = get_parent().global_position
