class_name TrapTrigger
extends Node3D

@export var activation_timer: Timer
@export var hurtbox: Hurtbox

var target: Fisu = null

var parts_inside: Array[FisuBodypart] = []

signal player_left
signal player_entered

signal activated
signal setup


@onready var trigger: Area3D = get_node("GrabTrigger")

func _ready() -> void:
	trigger.body_entered.connect(trigger_entered)
	trigger.body_exited.connect(trigger_exited)
	activation_timer.timeout.connect(activate)

	setup.emit()

func trigger_entered(body: RigidBody3D) -> void:
	if body is not FisuBodypart:
		return

	var target_parent = body.get_parent()
	if target_parent is not Fisu:
		return

	parts_inside.append(body)

	if activation_timer.is_stopped() && is_idle:
		target = target_parent
		start_activation()

func trigger_exited(body: RigidBody3D) -> void:
	if body is not FisuBodypart:
		return

	var target_parent = body.get_parent()
	if target_parent is not Fisu:
		return
	
	parts_inside.erase(body)

	if parts_inside.size() == 0:
		target = null
		stop_activation()

func activate() -> void:
	activation_timer.stop()
	activated.emit()

var is_idle: bool = false

func stop_activation() -> void:
	activation_timer.stop()
	player_left.emit()

func start_activation() -> void:
	activation_timer.start()
	player_entered.emit()

func _process(_delta: float) -> void:
	for part in parts_inside:
		if part.is_killed:
			parts_inside.erase(part)

			if parts_inside.size() == 0:
				target = null
				stop_activation()
		elif part.get_parent() is Fisu:
			target = part.get_parent()
		
	if parts_inside.size() > 0 && activation_timer.is_stopped() && is_idle:
		start_activation()
