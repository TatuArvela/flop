@tool
extends Node3D

@onready var blade: Node3D = get_node("SawOrigin/FishFileeMaker/Bottom_001/Blade_001")

@export_range(-0.1, 0.2, 0.01) var height_offset: float = 0.03:
	get:
		return height_offset
	set(value):
		height_offset = value
		if blade == null:
			return

		blade.position.y = value

@export var z_pos: float = 0.242:
	get:
		if blade != null:
			return blade.position.z

		return 0.0
	set(value):
		if blade == null:
			return

		blade.position.z = value
