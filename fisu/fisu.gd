class_name Fisu
extends Node3D

@export_category("Configuration")
@export_group("Jump")
@export var jump_direction_y = 2.5
@export var jump_force = 2.5
@export var direction_marker_y = 0.0
@export var turn_rate = 7.5

@export_range(-180, 180, 0.5, "radians_as_degrees") var direction_indicator_visual_offset_angle = deg_to_rad(-45)
@export_range(-180, 180, 0.5, "radians_as_degrees") var direction_indicator_physics_offset_angle = deg_to_rad(45)

@export var turn_only_on_input: bool = false

var _min_jump_strength: float = 0.5
var _max_jump_strength: float = 1.0

@export_range(0.5, 1.0, 0.05) var min_jump_strength: float = 0.5:
	get:
		return min(_min_jump_strength, _max_jump_strength)
	set(value):
		if _max_jump_strength < value:
			_max_jump_strength = value
		_min_jump_strength = value

@export_range(0.5, 1.0, 0.05) var max_jump_strength: float = 1.0:
	get:
		return max(_min_jump_strength, _max_jump_strength)
	set(value):
		if _min_jump_strength > value:
			_min_jump_strength = value
		_max_jump_strength = value

@export_group("Camera shake")
@export var jump_camera_shake = 0.025
@export var hit_camera_shake_scale = 0.01

@export_group("Prewire")
@export var blood_prefab: PackedScene
@export var bubbles_prefab: PackedScene

@onready var body: RigidBody3D = get_node("body_1")
@onready var direction_marker: JumpDirectionMarker = get_node("JumpDirectionMarker")
@onready var idle_bubble_emitter: IdleBubbleEmitter = get_node("head/BubbleEmitterMarker/BubblesEmitter")
@onready var jump_cooldown: Timer = get_node("JumpCooldown")
@onready var control_linger: Timer = get_node("ControlLinger")

@onready var hinges: Array[Joint3D] = [
	get_node("Hinge1"),
	get_node("Hinge2"),
	get_node("Hinge3"),
	get_node("Hinge4"),
	get_node("Hinge5"),
	get_node("Hinge6"),
	get_node("Hinge7"),
	get_node("Hinge8"),
]

@onready var parts: Array[FisuBodypart] = [
	get_node("body_1"),
	get_node("body_2"),
	get_node("body_3"),
	get_node("body_4"),
	get_node("body_5"),
	get_node("body_6"),
	get_node("body_7"),
	get_node("body_8"),
]

var body_global_position: Vector3:
	get:
		return body.global_position

var controller: PlayerController

var direction: Vector2 = Vector2.RIGHT
var target_direction: Vector2 = Vector2.RIGHT

var is_grounded: bool = false

var is_charging: bool:
	get:
		return direction_marker.is_charging

const GROUNDED_CHECK_DISTANCE: float = 0.025

var max_health: int:
	get:
		return hinges.size()

var health: int:
	get:
		return health
	set(value):
		var clamped_value = clamp(value, 0, max_health)
		health = clamped_value

		if health == 0:
			direction_marker.visible = false

		var did_hurt: bool = false

		for i in hinges.size():
			if i >= health && hinges[i] != null:
				emit_blood()

				hinges[i].queue_free()
				hinges[i] = null
				parts[i].is_killed = true

				did_hurt = true

		if did_hurt:
			damaged.emit()


var is_dead: bool:
	get:
		return health <= 0

signal jumped
signal landed
signal damaged

func _ready() -> void:
	target_direction = Vector2.UP
	direction = Vector2.UP
	health = max_health
	idle_bubble_emitter.start_emitting()

func _physics_process(delta: float) -> void:
	if is_dead || controller == null:
		# NOTE: we might end up here on first frame or sth
		if idle_bubble_emitter != null && !idle_bubble_emitter.is_queued_for_deletion():
			idle_bubble_emitter.stop_emitting()
		return

	# HACK: might do wacky things near walls lmao
	if body.test_move(body.global_transform, Vector3.DOWN * GROUNDED_CHECK_DISTANCE):
		if not is_grounded:
			var hit_strength = clamp(sqrt(abs(body.linear_velocity.y)) * hit_camera_shake_scale, 0.01, 0.25)
			var camera_shake: Shaker = get_tree().get_first_node_in_group("CameraShaker")
			camera_shake.shake(hit_strength)
			idle_bubble_emitter.start_emitting()
			landed.emit()
		is_grounded = true

	var input_dir = controller.input_dir
	var is_direction_input_active = input_dir.length_squared() > 0

	var direction_marker_should_be_visible = is_grounded && (is_direction_input_active || direction_marker.is_charging)
	if not direction_marker.visible and direction_marker_should_be_visible:
		direction_marker.fade_in()
	elif direction_marker.visible and not direction_marker_should_be_visible:
		direction_marker.fade_out()

	direction_marker.global_position = body.global_position

	if is_direction_input_active:
		target_direction = input_dir.normalized()

	if !turn_only_on_input || (turn_only_on_input && (is_direction_input_active || !control_linger.is_stopped())):
		var old_angle = direction.angle_to(Vector2.RIGHT)
		var target_angle = target_direction.angle_to(Vector2.RIGHT)
		var new_angle = lerp_angle(old_angle, target_angle, turn_rate * delta)
		direction = Vector2.from_angle(-new_angle)

		direction_marker.global_rotation = Vector3.ZERO
		direction_marker.global_rotation_degrees.y = rad_to_deg(new_angle + direction_indicator_visual_offset_angle)

		if is_direction_input_active:
			control_linger.start()

	if is_grounded && !is_charging && can_jump && Input.is_action_pressed("jump"):
		direction_marker.start_charge()

	if is_charging && Input.is_action_just_released("jump"):
		if can_jump:
			jump()
			jump_cooldown.start()
		
var can_jump: float:
	get:
		return jump_cooldown.is_stopped()

func jump() -> void:
	var strength_percentage = direction_marker.stop_charge()
	var strength = lerp(min_jump_strength, max_jump_strength, strength_percentage)
	var jump_direction = direction.rotated(direction_indicator_physics_offset_angle)
	is_grounded = false

	var jump_force_direction = Vector3(jump_direction.x, jump_direction_y, jump_direction.y)
	body.apply_impulse(jump_force_direction * jump_force * strength)

	idle_bubble_emitter.stop_emitting()
	emit_bubbles()

	direction_marker.shake(0.1)
	var camera_shake: Shaker = get_tree().get_first_node_in_group("CameraShaker")
	camera_shake.shake(jump_camera_shake * strength)

	jumped.emit()

func emit_blood() -> void:
	emit_particles(blood_prefab)

func emit_bubbles() -> void:
	emit_particles(bubbles_prefab)

func emit_particles(prefab: PackedScene) -> void:
	var emitter = prefab.instantiate()
	get_tree().current_scene.add_child(emitter)
	emitter.global_position = body.global_position
	emitter.global_rotation.y = body.global_rotation.y
