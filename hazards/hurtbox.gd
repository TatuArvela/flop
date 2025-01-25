class_name Hurtbox
extends Area3D

var target: Fisu = null
var parts_inside: Array[FisuBodypart] = []

@export var instant_damage: bool = false
@export var instant_damage_cooldown: float = 0.5

var damage_on_cooldown = false

func _reset_damage_cooldown() -> void:
	damage_on_cooldown = false

func _ready() -> void:
	body_entered.connect(trigger_entered)
	body_exited.connect(trigger_exited)

func trigger_entered(body: RigidBody3D) -> void:
	if body is not FisuBodypart:
		return

	var target_parent = body.get_parent()
	if target_parent is not Fisu:
		return

	if instant_damage and not body.is_killed:
		if damage_on_cooldown:
			return
		damage_on_cooldown = true

		hurt_target(target_parent)
		get_tree().create_timer(instant_damage_cooldown).timeout.connect(_reset_damage_cooldown)
		return

	parts_inside.append(body)
	target = target_parent

func trigger_exited(body: RigidBody3D) -> void:
	if body is not FisuBodypart:
		return

	var target_parent = body.get_parent()
	if target_parent is not Fisu:
		return
	
	parts_inside.erase(body)

	if parts_inside.size() == 0:
		target = null

func hurt() -> void:
	if target == null:
		return

	hurt_target(target)

func hurt_target(fisu: Fisu) -> void:
	if fisu == null:
		return

	fisu.health -= 1
	var camera_shake: Shaker = get_tree().get_first_node_in_group("CameraShaker")
	camera_shake.shake(0.25)

func _process(_delta: float) -> void:
	for part in parts_inside:
		if part.is_killed:
			parts_inside.erase(part)

			if parts_inside.size() == 0:
				target = null

