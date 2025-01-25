extends StaticBody3D

@export var speed = 1

func _ready():
	var velocity = $Start.global_position.direction_to($End.global_position)
	set_constant_linear_velocity(velocity * speed)
