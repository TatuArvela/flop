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


enum ConveyorSize {LONG = 4, MEDIUM = 2, SHORT = 1}
@export var conveyorSize: ConveyorSize = ConveyorSize.SHORT

@export var startHeight: int = 0
@export var endHeight: int = 0

func _process(_delta):
	conveyorLong.hide()
	longEnd.hide()
	conveyorMedium.hide()
	mediumEnd.hide()
	conveyorShort.hide()
	shortEnd.hide()
	
	var shownSurface
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
	
	if (end && start):
		var newRotation := Vector3.ZERO
		var direction = start.position.direction_to(end.position)
		conveyorSurface.rotation = newRotation
