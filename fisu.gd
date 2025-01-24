extends RigidBody3D


@export var jump_direction_y = 2.5
@export var jump_strength = 2.5
@export var direction_marker_y = 0.0
@export var turn_rate = 10.0

@onready var body: Node3D = get_node("%Body")
@onready var direction_marker: Node3D = get_node("%JumpDirectionMarker")

var direction: Vector2 = Vector2.RIGHT
var target_direction: Vector2 = Vector2.RIGHT

func _physics_process(delta: float) -> void:
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	direction_marker.visible = true if input_dir.length_squared() > 0 else false
	direction_marker.global_position.x = body.global_position.x
	direction_marker.global_position.z = body.global_position.z

	var modified_distance_y = max(0, body.global_position.y) * 0.1
	direction_marker.global_position.y = direction_marker_y + modified_distance_y

	if input_dir.length_squared() > 0:
		target_direction = input_dir.normalized()

	var old_angle = direction.angle_to(Vector2.RIGHT)
	var target_angle = target_direction.angle_to(Vector2.RIGHT)
	var new_angle = lerp_angle(old_angle, target_angle, turn_rate * delta)
	direction = Vector2.from_angle(-new_angle)

	direction_marker.global_rotation = Vector3.ZERO
	direction_marker.global_rotation_degrees.y = rad_to_deg(new_angle)

	if input_dir.length_squared() > 0 && Input.is_action_just_released("ui_accept"):
		var jump_force_direction = Vector3(direction.x, jump_direction_y, direction.y)
		self.apply_impulse(jump_force_direction * jump_strength)
