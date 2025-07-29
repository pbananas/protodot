extends CanvasLayer
class_name SceneTransition

enum TransitionType {
	IRIS,
	FADE,
	SLIDE_HORIZONTAL,
	SLIDE_VERTICAL,
	SLIDE_DIAGONAL
}

const DELAY := 0.6
const TRANSITION_TIME := 0.35

var transitioning: bool = false
var current_type: TransitionType = TransitionType.FADE

@onready var circle: TextureRect = $Circle
@onready var fade_rect: ColorRect = $FadeRect

func _ready() -> void:
	get_viewport().size_changed.connect(_on_viewport_resized)
	_setup_transitions()

func _on_viewport_resized() -> void:
	_setup_transitions()

func _setup_transitions() -> void:
	var viewport_size = get_viewport().get_visible_rect().size

	# Setup iris transition
	circle.size = viewport_size
	if circle.texture:
		circle.texture.width = circle.size.x
	if circle.material:
		circle.material.set_shader_parameter("screen_width", circle.size.x)
		circle.material.set_shader_parameter("screen_height", circle.size.y)
		circle.material.set_shader_parameter("circle_size", 1.05)

	# Setup fade transition
	fade_rect.size = viewport_size
	fade_rect.color.a = 0.0

func transition(load_cb: Callable, done_cb: Callable=Callable(), type: TransitionType = current_type) -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
	if transitioning: return
	transitioning = true

	match type:
		TransitionType.IRIS:
			_transition_iris(load_cb, done_cb)
		TransitionType.FADE:
			_transition_fade(load_cb, done_cb)
		TransitionType.SLIDE_HORIZONTAL:
			_transition_slide_horizontal(load_cb, done_cb)
		TransitionType.SLIDE_VERTICAL:
			_transition_slide_vertical(load_cb, done_cb)
		TransitionType.SLIDE_DIAGONAL:
			_transition_slide_diagonal(load_cb, done_cb)

func _transition_iris(load_cb: Callable, done_cb: Callable) -> void:
	circle.visible = true
	fade_rect.visible = false

	var in_tween := get_tree().create_tween()
	in_tween.tween_method(_set_shader_circle_size, 1.05, 0.0, TRANSITION_TIME)
	in_tween.tween_callback(func() -> void:
		await get_tree().create_timer(DELAY).timeout
		var loaded = load_cb.call()

		var out_tween:Tween = create_tween()
		out_tween.tween_method(_set_shader_circle_size, 0.0, 1.05, TRANSITION_TIME)
		out_tween.tween_callback(func() -> void:
			if done_cb.is_valid(): done_cb.call(loaded)
			_finish_transition()
		)
	)

func _transition_fade(load_cb: Callable, done_cb: Callable) -> void:
	circle.visible = false
	fade_rect.visible = true
	fade_rect.color.a = 0.0

	var in_tween := get_tree().create_tween()
	in_tween.tween_property(fade_rect, "color:a", 1.0, TRANSITION_TIME)
	in_tween.tween_callback(func() -> void:
		await get_tree().create_timer(DELAY).timeout
		var loaded = load_cb.call()

		var out_tween:Tween = create_tween()
		out_tween.tween_property(fade_rect, "color:a", 0.0, TRANSITION_TIME)
		out_tween.tween_callback(func() -> void:
			if done_cb.is_valid(): done_cb.call(loaded)
			_finish_transition()
		)
	)

func _transition_slide_horizontal(load_cb: Callable, done_cb: Callable) -> void:
	circle.visible = false
	fade_rect.visible = true
	var viewport_size = get_viewport().get_visible_rect().size
	fade_rect.position.x = viewport_size.x
	fade_rect.color.a = 1.0

	var in_tween := get_tree().create_tween()
	in_tween.tween_property(fade_rect, "position:x", 0.0, TRANSITION_TIME)
	in_tween.tween_callback(func() -> void:
		await get_tree().create_timer(DELAY).timeout
		var loaded = load_cb.call()

		var out_tween:Tween = create_tween()
		out_tween.tween_property(fade_rect, "position:x", -viewport_size.x, TRANSITION_TIME)
		out_tween.tween_callback(func() -> void:
			if done_cb.is_valid(): done_cb.call(loaded)
			_finish_transition()
		)
	)

func _transition_slide_vertical(load_cb: Callable, done_cb: Callable) -> void:
	circle.visible = false
	fade_rect.visible = true
	var viewport_size = get_viewport().get_visible_rect().size
	fade_rect.position.y = -viewport_size.y
	fade_rect.color.a = 1.0

	var in_tween := get_tree().create_tween()
	in_tween.tween_property(fade_rect, "position:y", 0.0, TRANSITION_TIME)
	in_tween.tween_callback(func() -> void:
		await get_tree().create_timer(DELAY).timeout
		var loaded = load_cb.call()

		var out_tween:Tween = create_tween()
		out_tween.tween_property(fade_rect, "position:y", viewport_size.y, TRANSITION_TIME)
		out_tween.tween_callback(func() -> void:
			if done_cb.is_valid(): done_cb.call(loaded)
			_finish_transition()
		)
	)

func _transition_slide_diagonal(load_cb: Callable, done_cb: Callable) -> void:
	circle.visible = false
	fade_rect.visible = true
	var viewport_size = get_viewport().get_visible_rect().size
	fade_rect.position = Vector2(viewport_size.x, -viewport_size.y)
	fade_rect.color.a = 1.0

	var in_tween := get_tree().create_tween()
	in_tween.tween_property(fade_rect, "position", Vector2.ZERO, TRANSITION_TIME)
	in_tween.tween_callback(func() -> void:
		await get_tree().create_timer(DELAY).timeout
		var loaded = load_cb.call()

		var out_tween:Tween = create_tween()
		out_tween.tween_property(fade_rect, "position", Vector2(-viewport_size.x, viewport_size.y), TRANSITION_TIME)
		out_tween.tween_callback(func() -> void:
			if done_cb.is_valid(): done_cb.call(loaded)
			_finish_transition()
		)
	)

func _finish_transition() -> void:
	transitioning = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	circle.visible = false
	fade_rect.visible = false

func _set_shader_circle_size(value: float) -> void:
	circle.material.set_shader_parameter("circle_size", value)
