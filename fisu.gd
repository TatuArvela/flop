extends RigidBody3D


@export var jump_velocity_y = 2.5
@export var jump_strength = 2.5
@export var direction_marker_y = 0.0

@onready var body: Node3D = get_node("%Body")
@onready var direction_marker: Node3D = get_node("%JumpDirectionMarker")

func _physics_process(delta: float) -> void:
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = Vector3(input_dir.x, 0, input_dir.y).normalized()
	if direction && Input.is_action_just_released("ui_accept"):
		direction.y = jump_velocity_y
		self.apply_impulse(direction * jump_strength)

	direction_marker.visible = true if direction else false

	if direction:
		direction_marker.global_position.x = body.global_position.x
		direction_marker.global_position.z = body.global_position.z

		var modified_distance_y = max(0, body.global_position.y) * 0.1
		direction_marker.global_position.y = direction_marker_y + modified_distance_y

		var jump_angle = direction.signed_angle_to(Vector3.FORWARD, Vector3.DOWN)
		direction_marker.global_rotation = Vector3.ZERO
		direction_marker.global_rotation_degrees.y = rad_to_deg(jump_angle)
