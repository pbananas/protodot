extends Node2D

var _existing := {
	&"SFX": [],
	&"Music": []
}

#@onready var _sfx := {}
#@onready var _music := {}

#func _ready() -> void:
	#for key in _sfx: _add(key, _sfx[key], &"SFX")
	#for key in _music: _add(key, _music[key], &"Music")

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
	add_child(asp)

func play(sound_name: String) -> void:
	get_node(sound_name).play()

func fade_out(sound_name: String) -> void:
	_fade_out_player(get_node(sound_name))

func fade_out_all() -> void:
	for player in get_children():
		_fade_out_player(player)

func _fade_out_player(player: AudioStreamPlayer) -> void:
	var vol = player.volume_db
	if player.playing:
		var t: Tween = get_tree().create_tween()
		t.tween_property(player, "volume_db", -80, 0.65)
		t.tween_callback(func():
			player.stop()
			player.volume_db = vol
		)
