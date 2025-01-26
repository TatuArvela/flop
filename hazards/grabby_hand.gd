extends TrapTrigger

@onready var animations: AnimationPlayer = get_node("AnimationPlayer")
@onready var wtf: AudioStreamPlayer3D = get_node("wtf")

func _on_setup() -> void:
	is_idle = false
	animations.play("enter")
	animations.animation_finished.connect(anim_finished)

	activated.connect(grab)
	player_entered.connect(_on_player_entered)
	player_left.connect(_on_player_left)

func _on_player_left() -> void:
	is_idle = true

func _on_player_entered() -> void:
	is_idle = false
	if !wtf.playing:
		wtf.play()

func anim_finished(anim: String) -> void:
	if anim == "enter":
		is_idle = true
		animations.play("idle")

	if anim == "grab":
		is_idle = false
		animations.play("enter")

func grab() -> void:
	animations.play("grab")
