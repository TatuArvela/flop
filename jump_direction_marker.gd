class_name JumpDirectionMarker
extends Node3D

@onready var jump_strength_indicator: JumpStrengthIndicator = get_node("%Arrows")
@onready var animations: AnimationPlayer = get_node("%Animations")

var is_charging: bool:
	get:
		return jump_strength_indicator.is_charging

func start_charge() -> void:
	animations.speed_scale = 2.0
	jump_strength_indicator.start_charge()

func stop_charge() -> float:
	animations.speed_scale = 1.0
	return jump_strength_indicator.stop_charge()
