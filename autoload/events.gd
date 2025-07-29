extends Node

class _Game:
	signal start
	signal over

class _Camera:
	signal shake(d: float, f: int, a: float, x_yn: bool, y_yn: bool)
	signal zoom(amount: float, location: Vector2, disable_damping: bool)
	signal reset_zoom
	signal pause_damping
	signal resume_damping

var Game = _Game.new()
var Camera = _Camera.new()
