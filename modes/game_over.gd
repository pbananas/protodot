extends Node2D
class_name GameOver

var main_scene: Main

# todo -- wtf bro

func _unhandled_key_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		main_scene.menu()
