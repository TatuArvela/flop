extends Control

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://levels/alku.tscn")


func _on_dont_button_pressed() -> void:
	get_tree().quit()
