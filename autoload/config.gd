extends Node

var DEBUG: bool = true

static var SCREEN_SIZE: Vector2 = Vector2(
	ProjectSettings.get_setting("display/window/size/viewport_width"),
	ProjectSettings.get_setting("display/window/size/viewport_height")
)
