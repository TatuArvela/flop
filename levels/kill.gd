extends Area3D

@export var player: PlayerController

func kill(body :Node3D) -> void:
	if body is not FisuBodypart:
		return

	if (body as FisuBodypart).is_killed:
		return

	do_kill.call_deferred()

func do_kill() -> void:
	player.body.health -= 999
	#get_tree().change_scene_to_file("res://main_menu.tscn")
