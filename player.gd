class_name PlayerController
extends Node3D

@export var body_prefab: PackedScene

@export var body: Fisu

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("debug_reset"):
		if body != null && !body.is_queued_for_deletion():
			body.queue_free()
			body = null
		
		body = body_prefab.instantiate()
		add_child(body)
