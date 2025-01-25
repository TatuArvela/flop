class_name PlayerController
extends Node3D

@export var body_prefab: PackedScene

@export var body: Fisu

var input_dir: Vector2 = Vector2.ZERO

func _process(_delta: float) -> void:
	if body != null && !body.is_queued_for_deletion():
		body.controller = self

	if Input.is_action_just_pressed("debug_reset"):
		if body != null && !body.is_queued_for_deletion():
			body.controller = null
			body = null
		
		body = body_prefab.instantiate()
		body.controller = self
		add_child(body)

	if Input.is_action_just_pressed("debug_hurt"):
		body.health -= 1

func _physics_process(_delta: float) -> void:
	input_dir = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
