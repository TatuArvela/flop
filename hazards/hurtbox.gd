class_name Hurtbox
extends Area3D

var target: Fisu = null
var parts_inside: Array[FisuBodypart] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(trigger_entered)
	body_exited.connect(trigger_exited)

func trigger_entered(body: RigidBody3D) -> void:
	if body is not FisuBodypart:
		return

	var target_parent = body.get_parent()
	if target_parent is not Fisu:
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
	
	target.health -= 1
	var camera_shake: Shaker = get_tree().get_first_node_in_group("CameraShaker")
	camera_shake.shake(0.25)

func _process(_delta: float) -> void:
	for part in parts_inside:
		if part.is_killed:
			parts_inside.erase(part)

			if parts_inside.size() == 0:
				target = null

