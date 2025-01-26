class_name IdleBubbleEmitter
extends Node3D

@onready var emitter: GPUParticles3D = get_node("emitter")

func _physics_process(_delta: float) -> void:
	global_position = get_parent().global_position


func start_emitting() -> void:
	emitter.emitting = true


func stop_emitting() -> void:
	emitter.emitting = false
