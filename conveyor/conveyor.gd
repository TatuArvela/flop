@tool
class_name Conveyor
extends Node3D

@onready var conveyorSurface: Node3D = get_node('ConveyorSurface')
@onready var conveyorLong: StaticBody3D = conveyorSurface.get_node('ConveyorLong')
@onready var conveyorMedium: StaticBody3D = conveyorSurface.get_node('ConveyorMedium')
@onready var conveyorShort: StaticBody3D = conveyorSurface.get_node('ConveyorShort')

enum ConveyorSize {LONG = 4, MEDIUM = 2, SHORT = 1}
@export var conveyorSize: ConveyorSize

@export var conveyorAngle: int = 0

func _process(_delta):
	var newRotation := Vector3.ZERO
	newRotation.z = conveyorAngle
	conveyorSurface.rotation = newRotation
	
	if (conveyorSize == ConveyorSize.LONG):
		conveyorLong.show()
	else:
		conveyorLong.hide()

	if (conveyorSize == ConveyorSize.MEDIUM):
		conveyorMedium.show()
	else:
		conveyorMedium.hide()

	if (conveyorSize == ConveyorSize.SHORT):
		conveyorShort.show()
	else:
		conveyorShort.hide()
