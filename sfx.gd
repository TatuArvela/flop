extends AudioStreamPlayer

@export var pitch_min: float = 1.0
@export var pitch_max: float = 1.0

@export var sfx: Array[AudioStream] = []

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	finished.connect(_on_finished)

func _on_finished() -> void:
	pitch_scale = rng.randf_range(pitch_min, pitch_max)

	if sfx.size() > 0:
		stream = sfx[rng.randi_range(0, sfx.size() - 1)]


func start_play() -> void:
	play()

func stop_play() -> void:
	stop()
