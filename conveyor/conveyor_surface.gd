extends StaticBody3D

@export var speed = 1

@onready var start: Marker3D = get_node("Start")
@onready var end: Marker3D = get_node("End")

func _ready():
	var velocity = start.global_position.direction_to(end.global_position)
	set_constant_linear_velocity(velocity * speed)
