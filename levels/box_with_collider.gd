@tool
extends StaticBody3D

@onready var mesh: MeshInstance3D = get_node("Mesh")
@onready var collider: CollisionShape3D = get_node("CollisionShape3D")

@export var width: float = 1.0:
	get:
		return width
	set(value):
		width = value
		set_mesh_size()
		set_collider_size()

@export var height: float = 1.0:
	get:
		return height
	set(value):
		height = value
		set_mesh_size()
		set_collider_size()

@export var depth: float = 1.0:
	get:
		return depth
	set(value):
		depth = value
		set_mesh_size()
		set_collider_size()

func set_mesh_size() -> void:
	if not mesh:
		return
	var box = mesh.mesh as BoxMesh
	box.size.x = width
	box.size.y = height
	box.size.z = depth

func set_collider_size() -> void:
	if not collider:
		return
	var shape = collider.shape as BoxShape3D
	shape.size.x = width
	shape.size.y = height
	shape.size.z = depth

func _ready() -> void:
	set_mesh_size()
	set_collider_size()
