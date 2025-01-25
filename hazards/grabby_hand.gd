extends Node3D

@onready var animations: AnimationPlayer = get_node("AnimationPlayer")
@onready var grab_timer: Timer = get_node("Timer")
@onready var hurtbox: Hurtbox = get_node("Hurtbox")


var target: Fisu = null

var parts_inside: Array[FisuBodypart] = []

func _ready() -> void:
	animations.play("enter")
	animations.animation_finished.connect(anim_finished)

	var trigger: Area3D = get_node("GrabTrigger")
	trigger.body_entered.connect(trigger_entered)
	trigger.body_exited.connect(trigger_exited)
	grab_timer.timeout.connect(grab)

func anim_finished(anim: String) -> void:
	if anim == "enter":
		animations.play("idle")

	if anim == "grab":
		animations.play("enter")

func trigger_entered(body: RigidBody3D) -> void:
	if body is not FisuBodypart:
		return

	var target_parent = body.get_parent()
	if target_parent is not Fisu:
		return

	parts_inside.append(body)

	if grab_timer.is_stopped():
		target = target_parent	
		grab_timer.start()

func trigger_exited(body: RigidBody3D) -> void:
	if body is not FisuBodypart:
		return

	var target_parent = body.get_parent()
	if target_parent is not Fisu:
		return
	
	parts_inside.erase(body)

	if parts_inside.size() == 0:
		target = null
		grab_timer.stop()

func grab() -> void:
	animations.play("grab")

func _process(_delta: float) -> void:
	for part in parts_inside:
		if part.is_killed:
			parts_inside.erase(part)

			if parts_inside.size() == 0:
				target = null
				grab_timer.stop()
		elif part.get_parent() is Fisu:
			target = part.get_parent()
		
	if parts_inside.size() > 0 && grab_timer.is_stopped() && animations.current_animation == "idle":
		grab_timer.start()
