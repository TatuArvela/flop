extends TrapTrigger

@onready var animations: AnimationPlayer = get_node("AnimationPlayer")

func _on_setup() -> void:
	is_idle = true

	animations.animation_finished.connect(anim_finished)
	activated.connect(drop)

func anim_finished(anim: String) -> void:
	if anim == "recover":
		is_idle = true

	if anim == "drop":
		get_tree().create_timer(0.5).timeout.connect(start_recover)

func start_recover() -> void:
	animations.play("recover")

func drop() -> void:
	is_idle = false
	animations.play("drop")
