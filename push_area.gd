extends Area3D

var speed = 300

func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		var push := Vector3.ZERO
		push.x = speed * delta
		body.external_forces.append(push)
