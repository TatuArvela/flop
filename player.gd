class_name PlayerController
extends Node3D

@export var body_prefab: PackedScene

@export var body: Fisu

@export var death_delay: float = 3.5

var input_dir: Vector2 = Vector2.ZERO

var was_dead = false

signal just_died
signal respawned

func _process(delta: float) -> void:
	if body != null && !body.is_queued_for_deletion():
		body.controller = self

	if Input.is_action_just_pressed("debug_reset"):
		reset_player()

	if Input.is_action_just_pressed("debug_hurt"):
		body.health -= 1

	if !was_dead && body.is_dead:
		was_dead = true
		just_died.emit()
		get_tree().create_timer(death_delay).timeout.connect(reset_player)

	if !body.is_dead:
		was_dead = false

	var post_processing: PostProcessing = get_tree().get_first_node_in_group("PostProcessing")
	if post_processing != null:
		var target_darken = 0.9 if body.is_dead else 0.0
		var rate = 0.5 if body.is_dead else 1.0
		post_processing.darken = move_toward(post_processing.darken, target_darken, rate * delta)

func reset_player() -> void:
	if body != null && !body.is_queued_for_deletion():
		body.controller = null
		body = null
	
	body = body_prefab.instantiate()
	body.controller = self
	add_child(body)

	respawned.emit()

func _physics_process(_delta: float) -> void:
	input_dir = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
