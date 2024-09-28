extends RefCounted
class_name Shake

var duration_ms: int
var frequency_hz: int
var amplitude_factor: float

var _samples: Array[float] = []
var start_time: int
var is_shaking: bool = false

func _init(d: float, f: int, a: float) -> void:
	duration_ms = floor(d * 1000)
	frequency_hz = f
	amplitude_factor = a

	var sample_count: int = floor(d * frequency_hz)
	for i in range(sample_count):
		_samples.append(randf() * 2 - 1)

	start_time = Time.get_ticks_msec()
	is_shaking = true

func value() -> float:
	var t: int = Time.get_ticks_msec() - start_time
	if t > duration_ms:
		is_shaking = false
		return 0

	var s: float = t / 1000.0 * frequency_hz
	var s0: int = floor(s)
	var s1: int = s0 + 1
	var k: float = _decay(t)

	return (
		(_noise(s0) + (s - s0) *
		(_noise(s1) - _noise(s0))) *
		k *
		amplitude_factor
	)

func _noise(s: int) -> float:
	if s >= _samples.size(): return 0
	return _samples[s]

func _decay(t: int) -> float:
	if t >= duration_ms: return 0
	return (duration_ms - t) / float(duration_ms)
