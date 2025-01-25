@tool
class_name Shaker
extends Node3D

@export var shake_strength = 0.0
@export var shake_decay = 1.0

var rng = RandomNumberGenerator.new()

func _process(delta: float) -> void:
	if shake_strength <= 0:
		position = Vector3.ZERO
		return

	position.x = rng.randf_range(-shake_strength, shake_strength)
	position.y = rng.randf_range(-shake_strength, shake_strength)
	position.z = rng.randf_range(-shake_strength, shake_strength)

	shake_strength = move_toward(shake_strength, 0.0, shake_decay * delta)
