extends CanvasLayer

const DELAY := 1.1

var transitioning:bool = false

@onready var circle: TextureRect = $Circle

func _ready() -> void:
	circle.material.set_shader_parameter("circle_size", 1.05)

func transition(load_cb:Callable, done_cb:Callable=Callable()) -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
	if transitioning: return
	transitioning = true

	var in_tween := get_tree().create_tween()
	in_tween.tween_method(
		func(value): circle.material.set_shader_parameter("circle_size", value),
		1.05,
		0.0,
		0.25
	)
	in_tween.tween_callback(func() -> void:
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
		await get_tree().create_timer(DELAY).timeout
		var loaded = load_cb.call()
		var out_tween:Tween = create_tween()

		out_tween.tween_method(
			func(value): circle.material.set_shader_parameter("circle_size", value),
			0.0,
			1.05,
			0.2
		)

		out_tween.tween_callback(func() -> void:
			if done_cb.is_valid(): done_cb.call(loaded)
			transitioning = false
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		)
		out_tween.play()
	)
	in_tween.play()


#
	#var shader_params:Dictionary = transition_shader_params[image]
	#bg.material.set_shader_parameter("primary_color", shader_params.primary_color)
	#bg.material.set_shader_parameter("secondary_color", shader_params.secondary_color)
#
	#text.texture = transition_textures[image]
	#container.position.x = 160
	#text.scale = Vector2(1.1, 1.1)
	#text.rotation = -0.1
	#var in_tween:Tween = create_tween()
	#in_tween.parallel().tween_property(container, "position:x", 0, SLIDE_SPEED)
	#in_tween.parallel().tween_property(text, "scale", Vector2(0.9, 0.9), DELAY*2)
	#in_tween.parallel().tween_property(text, "rotation", 0, DELAY*2)
	#in_tween.tween_callback(func() -> void:
		#var loaded = load_cb.call()
		#Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
		#await get_tree().create_timer(DELAY).timeout
		#var out_tween:Tween = create_tween()
		#out_tween.tween_property(container, "position:x", -160, SLIDE_SPEED)
		#out_tween.tween_callback(func() -> void:
			#if done_cb.is_valid(): done_cb.call(loaded)
			#transitioning = false
		#)
		#out_tween.play()
	#)
	#in_tween.play()
#
	#await get_tree().create_timer(0.6).timeout
	#audio_stream_player.stream = transition_sounds[image]
	#audio_stream_player.play()
