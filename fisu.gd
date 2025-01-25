extends RigidBody3D

@export var jump_direction_y = 2.5
@export var jump_force = 2.5
@export var direction_marker_y = 0.0
@export var turn_rate = 10.0
@export var jump_camera_shake = 0.05

@onready var body: RigidBody3D = get_node("%body_1")
@onready var direction_marker: JumpDirectionMarker = get_node("%JumpDirectionMarker")

var direction: Vector2 = Vector2.RIGHT
var target_direction: Vector2 = Vector2.RIGHT

var is_grounded: bool = false

var is_charging: bool:
	get:
		return direction_marker.is_charging

const GROUNDED_CHECK_DISTANCE: float = 0.025

func _physics_process(delta: float) -> void:
	# HACK: might do wacky things near walls lmao
	if self.test_move(global_transform, Vector3.DOWN * GROUNDED_CHECK_DISTANCE):
		if not is_grounded:
			var hit_strength = clamp(abs(body.linear_velocity.y) / 20.0, 0.01, 0.25)
			var camera_shake: Shaker = get_tree().get_first_node_in_group("CameraShaker")
			camera_shake.shake(hit_strength)
		is_grounded = true

	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var is_direction_input_active = input_dir.length_squared() > 0

	var direction_marker_should_be_visible = is_grounded && (is_direction_input_active || direction_marker.is_charging)
	if not direction_marker.visible and direction_marker_should_be_visible:
		direction_marker.fade_in()
	elif direction_marker.visible and not direction_marker_should_be_visible:
		direction_marker.fade_out()

	direction_marker.global_position = body.global_position

	if is_direction_input_active:
		target_direction = input_dir.normalized()

	var old_angle = direction.angle_to(Vector2.RIGHT)
	var target_angle = target_direction.angle_to(Vector2.RIGHT)
	var new_angle = lerp_angle(old_angle, target_angle, turn_rate * delta)
	direction = Vector2.from_angle(-new_angle)

	direction_marker.global_rotation = Vector3.ZERO
	direction_marker.global_rotation_degrees.y = rad_to_deg(new_angle)

	if is_grounded && !is_charging && Input.is_action_pressed("ui_accept"):
		direction_marker.start_charge()

	if is_charging && Input.is_action_just_released("ui_accept"):
		var strength_percentage = direction_marker.stop_charge()
		var min_strength = 0.5
		var max_strength = 1.0
		var strength = lerp(min_strength, max_strength, strength_percentage)

		direction_marker.shake(0.1)
		var camera_shake: Shaker = get_tree().get_first_node_in_group("CameraShaker")
		camera_shake.shake(jump_camera_shake * strength)

		var jump_force_direction = Vector3(direction.x, jump_direction_y, direction.y)
		self.apply_impulse(jump_force_direction * jump_force * strength)
		is_grounded = false
