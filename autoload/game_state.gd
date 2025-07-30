extends Node

var has_started: bool = false

func start_game() -> void:
	has_started = true
	Events.game.start.emit()

func end_game() -> void:
	has_started = false
	Events.game.over.emit()
