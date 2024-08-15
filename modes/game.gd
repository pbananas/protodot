extends Node2D
class_name Game

var main_scene:Main

func _ready() -> void:
	GameState.start_game()
