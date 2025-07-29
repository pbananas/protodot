extends Camera2D
class_name Camera

const CAMERA_SMOOTH_SPEED: float = 0.4
var current_velocity: Vector2 = Vector2.ZERO

var _base_offset: Vector2i = Vector2i.ZERO
var _shake_x: Shake
var _shake_y: Shake

var _snapped: bool = false
var follow_target: Node2D
var force_position: Vector2 = Vector2.INF
var _disable_damping: bool = false

func _ready() -> void:
	_base_offset = get_viewport().get_visible_rect().size / 2
	offset = _base_offset
	Events.Camera.shake.connect(shake)
	Events.Camera.pause_damping.connect(func(): _disable_damping = true)
	Events.Camera.resume_damping.connect(func(): _disable_damping = false)
	Events.Camera.zoom.connect(_zoom)
	Events.Camera.reset_zoom.connect(_reset_zoom)

func _zoom(amount: float, location: Vector2, disable_damping: bool) -> void:
	var old_disable_damping = _disable_damping
	_disable_damping = disable_damping
	force_position = location
	var t: Tween = create_tween()
	t.tween_property(self, "zoom", Vector2(amount, amount), 0.25)
	await t.finished
	_disable_damping = old_disable_damping

func _reset_zoom() -> void:
	force_position = Vector2.INF
	var t: Tween = create_tween()
	t.tween_property(self, "zoom", Vector2.ONE, 0.2)

func shake(d: float, f: int, a: float, x_yn: bool = true, y_yn: bool = true) -> void:
	if x_yn: _shake_x = Shake.new(d,f,a)
	if y_yn: _shake_y = Shake.new(d,f,a)

func _handle_shake() -> void:
	if _shake_x: offset.x = _base_offset.x + _shake_x.value()
	if _shake_y: offset.y = _base_offset.y + _shake_y.value()

func _process(delta: float) -> void:
	var new_position: Vector2
	if is_instance_valid(follow_target):
		new_position = follow_target.get_global_position() - Config.SCREEN_SIZE/2
	else:
		new_position = Vector2.ZERO

	if not _snapped:
		_snapped = true
		global_position = new_position
		return

	if _disable_damping:
		global_position = new_position
	else:
		global_position = _smooth_damp(
			global_position,
			new_position,
			current_velocity,
			CAMERA_SMOOTH_SPEED,
			delta
		)

	_handle_shake()

	$CurrentPos.global_position = global_position
	$TargetPos.global_position = follow_target.global_position if follow_target else Vector2.ZERO

func _smooth_damp(current: Vector2, target_pos: Vector2, velocity: Vector2, smooth_time: float, delta: float) -> Vector2:
	var omega: float = 2.0 / smooth_time
	var x: float = omega * delta
	var expo: float = 1.0 / (1.0 + x + 0.48 * x * x + 0.235 * x * x * x)

	var change: Vector2 = current - target_pos
	var temp: Vector2 = (velocity + omega * change) * delta

	current_velocity = (velocity - omega * temp) * expo

	return target_pos + (change + temp) * expo
