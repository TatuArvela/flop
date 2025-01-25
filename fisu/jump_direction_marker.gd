class_name JumpDirectionMarker
extends Node3D

@onready var jump_strength_indicator: JumpStrengthIndicator = get_node("%Arrows")
@onready var animations: AnimationPlayer = get_node("%Animations")
@onready var shaker: Shaker = get_node("%Shaker")

var is_charging: bool:
	get:
		return jump_strength_indicator.is_charging

func shake(amount: float) -> void:
	shaker.shake_strength = amount

func fade_in() -> void:
	animations.play("fade_in")

func fade_out() -> void:
	animations.play("fade_out")

func start_charge() -> void:
	animations.speed_scale = 2.0
	jump_strength_indicator.start_charge()

func stop_charge() -> float:
	animations.speed_scale = 1.0
	return jump_strength_indicator.stop_charge()

func _ready() -> void:
	animations.animation_finished.connect(anim_finished)
	visible = false
	shaker.scale = Vector3.ZERO

func anim_finished(anim_name: String) -> void:
	if anim_name == "fade_in":
		animations.play("idle")
