extends Node2D
class_name Menu

var main_scene: Main

func _ready() -> void:
	var t = get_tree().create_tween()
	t.set_loops()
	t.bind_node($KKB)
	t.tween_property($KKB, "rotation", 2*PI, 10)
	t.tween_callback(func(): $KKB.rotation = 0)

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		main_scene.game()
