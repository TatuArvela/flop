extends Node3D

@onready var emitter: GPUParticles3D = get_node("emitter")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	emitter.one_shot = true
	emitter.emitting = true

	get_tree().create_timer(2.0).timeout.connect(_on_emitter_done)

func _on_emitter_done() -> void:
	queue_free.call_deferred()
