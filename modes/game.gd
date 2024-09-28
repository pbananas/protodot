extends Node2D
class_name Game

var main_scene: Main

func _ready() -> void:
	# main_scene.camera.target = player
	# GameState.player = player
	GameState.start_game()

func transition_complete() -> void: pass
