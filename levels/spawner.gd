extends Marker3D

@export var prefabs: Array[PackedScene] = []

var rng = RandomNumberGenerator.new()

func spawn() -> void:
	var x = prefabs[rng.randi_range(0, prefabs.size() - 1)].instantiate()
	get_tree().current_scene.add_child(x)

	x.global_position = global_position
	x.global_position.x += rng.randf_range(-0.3, 0.3)
	x.reset_physics_interpolation()
