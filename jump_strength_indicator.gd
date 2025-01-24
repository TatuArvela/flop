@tool
class_name JumpStrengthIndicator
extends Node3D

@onready var arrows: Array[Node3D] = [
	get_node("Arrow"),
	get_node("Arrow2"),
	get_node("Arrow3"),
	get_node("Arrow4"),
]

@export var arrow_size_increase = 0.1
@export var arrow_spacing = 0.01

@export var strength: float = 0.0:
	get:
		return strength
	set(value):
		strength = value
		refresh()

func refresh() -> void:
	var strength_per_arrow = 1.0 / max(1, arrows.size())
	var arrow_size = 0.05

	var total_size = 0.0
	for i in arrows.size():
		var required_strength = i * strength_per_arrow
		var is_strength_high_enough = strength >= required_strength

		var arrow_scale_i = 1.0 + i * arrow_size_increase
		arrows[i].scale = Vector3(arrow_scale_i, 1.0, arrow_scale_i)

		arrows[i].visible = is_strength_high_enough
		arrows[i].position.x = total_size
		total_size += (arrow_size * arrow_scale_i) + arrow_spacing

func _ready() -> void:
	strength = 0
