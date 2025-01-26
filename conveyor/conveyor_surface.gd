@tool
class_name ConveyorSurface
extends StaticBody3D

@export var speed: float = 0.5
@export var length: int = 1

@onready var start: Marker3D = get_node("Start")
@onready var end: Marker3D = get_node("End")

@export var modelNode: ConveyorModel

func _ready():
	var velocity = start.global_position.direction_to(end.global_position)
	set_constant_linear_velocity(velocity * speed)
	
func _process(delta):
	if (modelNode):
		modelNode.conveyorSpeed = speed
		modelNode.conveyorLength = length
