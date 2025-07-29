extends Node2D
class_name Game

var main_scene: Main

func _ready() -> void:
	# main_scene.camera.target = player
	# GameState.player = player
	GameState.start_game()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):  # SPACE key
		# Emit camera shake: duration=0.5s, frequency=30Hz, amplitude=5.0
		Events.Camera.shake.emit(0.5, 30, 5.0, true, true)

func transition_complete() -> void: pass
