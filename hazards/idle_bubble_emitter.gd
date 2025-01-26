class_name IdleBubbleEmitter
extends Node3D

@export var sfx: Array[AudioStream] = []
@export var min_delay: float = 0.5
@export var max_delay: float = 1.5


@onready var emitter: GPUParticles3D = get_node("emitter")
@onready var sfx_timer: Timer = get_node("SfxTimer")
@onready var sfx_player: AudioStreamPlayer = get_node("AudioStreamPlayer")

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	sfx_timer.timeout.connect(pop)

func pop() -> void:
	sfx_player.stream = sfx[rng.randi_range(0, sfx.size() - 1)]
	sfx_player.play()
	sfx_timer.start(rng.randf_range(min_delay, max_delay))

func _physics_process(_delta: float) -> void:
	global_position = get_parent().global_position

func start_emitting() -> void:
	emitter.emitting = true
	sfx_timer.start()

func stop_emitting() -> void:
	emitter.emitting = false
	sfx_timer.stop()
