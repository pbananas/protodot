extends Node

var has_started: bool = false

func start_game() -> void:
	has_started = true
	Events.game_start.emit()

func end_game() -> void:
	has_started = false
	Events.game_over.emit()
