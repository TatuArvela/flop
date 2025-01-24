class_name JumpDirectionMarker
extends Node3D

@onready var jump_strength_indicator: JumpStrengthIndicator = get_node("%Arrows")
@onready var animations: AnimationPlayer = get_node("%Animations")

func start_charge() -> void:
	animations.play("charge")

func stop_charge() -> float:
	var progress = animations.current_animation_position / animations.current_animation_length
	animations.play("idle")
	jump_strength_indicator.strength = 0.0
	return progress
