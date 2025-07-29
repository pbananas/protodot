extends Node

var has_started: bool = false

func start_game() -> void:
	has_started = true
	Events.Game.start.emit()

func end_game() -> void:
	has_started = false
	Events.Game.over.emit()
