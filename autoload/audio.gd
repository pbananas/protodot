extends Node2D

var _existing := {
	&"SFX": [],
	&"Music": []
}

var _fade_tweens := {}

func _ready() -> void:
	pass

func add_sfx(sound_name: StringName, file: AudioStream) -> void:
	_add(sound_name, file, &"SFX")
func add_music(sound_name: StringName, file: AudioStream) -> void:
	_add(sound_name, file, &"Music")

func _add(sound_name: StringName, file: AudioStream, bus: StringName) -> void:
	if sound_name in _existing[bus]: return
	var asp := AudioStreamPlayer.new()
	asp.name = sound_name
	asp.bus = bus
	asp.stream = file
	asp.max_polyphony = 10
	add_child(asp)

func play(sound_name: StringName, fade_in: float = 0.0, pitch: float = 1.0) -> void:
	var asp: AudioStreamPlayer = get_node(sound_name)
	if not asp:
		push_warning(
			"You specified a sound file which doesn't exist: '", sound_name,
			"' (available: ", get_children().map(func(c): return str(c.name)), ")"
		)
		return

	if fade_in > 0.0: asp.volume_db = -80
	asp.pitch_scale = pitch
	asp.play()
	if fade_in > 0.0:
		if _fade_tweens.has(sound_name) and _fade_tweens[sound_name].is_running():
			_fade_tweens[sound_name].kill()
		_fade_tweens[sound_name] = get_tree().create_tween()
		_fade_tweens[sound_name].tween_property(asp, "volume_db", 0, fade_in)

func fade_out(sound_name: StringName) -> void:
	_fade_out_player(get_node(sound_name))

func fade_out_all(bus_name: StringName = &"ALL") -> void:
	for player in get_children():
		if bus_name == &"ALL" or player.bus == bus_name:
			_fade_out_player(player)

func _fade_out_player(player: AudioStreamPlayer) -> void:
	var vol = player.volume_db
	if player.playing:
		var sound_name = StringName(player.name)
		if _fade_tweens.has(sound_name) and _fade_tweens[sound_name].is_running():
			_fade_tweens[sound_name].kill()
		_fade_tweens[sound_name] = get_tree().create_tween()
		_fade_tweens[sound_name].tween_property(player, "volume_db", -80, 0.65)
		_fade_tweens[sound_name].tween_callback(func():
			player.stop()
			player.volume_db = vol
		)
