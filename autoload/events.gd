extends Node

signal game_start
signal game_over

signal camera_shake(d: float, f: float, a: float, disable_damping: bool)
signal zoom(amount: float, location: Vector2, disable_damping: bool)
signal reset_zoom
signal pause_damping
signal resume_damping
