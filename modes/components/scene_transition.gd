extends CanvasLayer

const DELAY := 1.1

var transitioning:bool = false

@onready var circle: TextureRect = $Circle

func _ready() -> void:
	circle.size = get_viewport().get_visible_rect().size
	circle.material.set_shader_parameter("screen_width", circle.size.x)
	circle.material.set_shader_parameter("screen_height", circle.size.y)
	circle.material.set_shader_parameter("circle_size", 1.05)

func transition(load_cb:Callable, done_cb:Callable=Callable()) -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
	if transitioning: return
	transitioning = true

	var in_tween := get_tree().create_tween()
	in_tween.tween_method(_set_shader_circle_size, 1.05, 0.0, 0.25)
	in_tween.tween_callback(func() -> void:
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
		await get_tree().create_timer(DELAY).timeout
		var loaded = load_cb.call()

		var out_tween:Tween = create_tween()
		out_tween.tween_method(_set_shader_circle_size, 0.0, 1.05, 0.2)
		out_tween.tween_callback(func() -> void:
			if done_cb.is_valid(): done_cb.call(loaded)
			transitioning = false
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		)
		#out_tween.play()
	)
	#in_tween.play()

func _set_shader_circle_size(value: float) -> void:
	circle.material.set_shader_parameter("circle_size", value)
