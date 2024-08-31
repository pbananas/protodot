extends Node2D
class_name Main

@onready var menu_scene = preload("res://modes/menu.tscn")
@onready var game_scene = preload("res://modes/game.tscn")
@onready var game_over_scene = preload("res://modes/game_over.tscn")

var current_scene

func _ready() -> void:
	_set_mouse_cursor()
	$Camera2D.offset = get_viewport().get_visible_rect().size / 2
	_swap_scenes(game_scene) # TODO
	Events.game_over.connect(game_over)

func game() -> void: _change_scene(game_scene)
func game_over() -> void: _change_scene(game_over_scene)
func menu() -> void: _change_scene(menu_scene)

func _change_scene(new_scene) -> void:
	$SceneTransition.transition(
		_swap_scenes.bind(new_scene),
		func(_loaded_scene) -> void:
			Audio.fade_out_all()
	)

func _swap_scenes(to: PackedScene) -> void:
	if current_scene:
		remove_child(current_scene)
		current_scene.queue_free()

	current_scene = to.instantiate()
	current_scene.main_scene = self
	add_child(current_scene)

func _unhandled_key_input(event: InputEvent) -> void:
	if event.keycode == KEY_ESCAPE:
		get_tree().quit()

	if event.is_action("fullscreen"):
		var fullscreen = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
		var new_mode = DisplayServer.WINDOW_MODE_WINDOWED \
			if fullscreen \
			else DisplayServer.WINDOW_MODE_FULLSCREEN
		DisplayServer.window_set_mode(new_mode)

func _set_mouse_cursor() -> void:
	pass
