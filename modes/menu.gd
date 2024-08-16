extends Node2D
class_name Menu

var main_scene: Main

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_focus_next"):
		if $KKB.fsm.current_state == "spinning":
			$KKB.fsm.change_state.emit("idle")
		else:
			$KKB.fsm.change_state.emit("spinning")

	if Input.is_action_just_pressed("ui_accept"):
		print("switching to game")
		main_scene.game()
