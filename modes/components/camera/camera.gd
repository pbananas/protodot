extends Camera2D
class_name Camera

const CAMERA_SMOOTH_SPEED: float = 0.2

var current_velocity: Vector2 = Vector2.ZERO
var _snapped: bool = false
var follow_target: Node2D

#var _shake_x: Shake
#var _shake_y: Shake

func _ready() -> void:
	pass#Events.shake.connect(shake)

func shake(d: float, f: int, a: float, x_yn: bool = true, y_yn: bool = true) -> void:
	pass
	#if x_yn: _shake_x = Shake.new(d,f,a)
	#if y_yn: _shake_y = Shake.new(d,f,a)

#func _handle_shake() -> void:
	#if _shake_x: offset.x = _shake_x.value()
	#if _shake_y: offset.y = _shake_y.value()

func _process(delta: float) -> void:
	var target: Vector2
	if is_instance_valid(follow_target):
		target = follow_target.get_global_position() - Config.SCREEN_SIZE/2 #GameState.scene.get_camera_follow_target()
	else:
		target = Vector2.ZERO

	if not _snapped:
		_snapped = true
		global_position = target
		return

	global_position = _smooth_damp(
		global_position,
		target,
		current_velocity,
		CAMERA_SMOOTH_SPEED,
		delta
	)

	#_handle_shake()

	#$CurrentPos.global_position = global_position
	#$TargetPos.global_position = target

func _smooth_damp(current: Vector2, target: Vector2, velocity: Vector2, smooth_time: float, delta: float) -> Vector2:
	var omega: float = 2.0 / smooth_time
	var x: float = omega * delta
	var expo: float = 1.0 / (1.0 + x + 0.48 * x * x + 0.235 * x * x * x)

	var change: Vector2 = current - target
	var temp: Vector2 = (velocity + omega * change) * delta

	current_velocity = (velocity - omega * temp) * expo

	return target + (change + temp) * expo
