@tool
class_name Conveyor
extends Node3D

@onready var conveyorSurface: Node3D = get_node('ConveyorSurface')
@onready var conveyorLong: StaticBody3D = conveyorSurface.get_node('ConveyorLong')
@onready var conveyorMedium: StaticBody3D = conveyorSurface.get_node('ConveyorMedium')
@onready var conveyorShort: StaticBody3D = conveyorSurface.get_node('ConveyorShort')

@onready var start: Marker3D = get_node('Start')
@onready var longEnd: Marker3D = get_node('LongEnd')
@onready var mediumEnd: Marker3D = get_node('MediumEnd')
@onready var shortEnd: Marker3D = get_node('ShortEnd')

@onready var strutStart: Node3D = get_node('StrutStart')
@onready var strutEnd: Node3D = get_node('StrutEnd')

enum ConveyorSize {LONG = 4, MEDIUM = 2, SHORT = 1}
@export var conveyorSize: ConveyorSize = ConveyorSize.SHORT

@export var conveyorSpeed: float = 0.5

func _process(_delta):
	conveyorLong.hide()
	longEnd.hide()
	conveyorMedium.hide()
	mediumEnd.hide()
	conveyorShort.hide()
	shortEnd.hide()
	
	var shownSurface: ConveyorSurface
	var end
	if (conveyorSize == ConveyorSize.LONG):
		shownSurface = conveyorLong
		end = longEnd
	if (conveyorSize == ConveyorSize.MEDIUM):
		shownSurface = conveyorMedium
		end = mediumEnd
	if (conveyorSize == ConveyorSize.SHORT):
		shownSurface = conveyorShort
		end = shortEnd
	shownSurface.show()
	end.show()
	
	if (strutStart && strutEnd):
		strutStart.height = start.global_position.y
		strutStart.position.y = 0
		strutStart.rotation.z = -start.global_rotation.z
		strutEnd.height = end.global_position.y
		strutEnd.position.x = end.position.x - 0.1
		strutEnd.position.y = 0
		strutEnd.rotation.z = -end.global_rotation.z
	
	if (end && start):
		var newRotation := Vector3.ZERO
		var direction = start.position.direction_to(end.position)
		conveyorSurface.rotation = newRotation
	
	shownSurface.speed = conveyorSpeed
