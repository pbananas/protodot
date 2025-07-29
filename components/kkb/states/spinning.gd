extends State
class_name KkbSpinningState
static var state_name := "spinning"

var spinning_tween: Tween

func _enter_state(_args: Dictionary, _from_last: Dictionary) -> void:
	spinning_tween = get_tree().create_tween()
	spinning_tween.set_loops()
	spinning_tween.bind_node(self)
	spinning_tween.tween_property(fsm.target, "rotation_degrees", fsm.target.rotation_degrees + 360, 2)
	spinning_tween.tween_callback(func(): fsm.target.rotation_degrees -= 360)

func _exit_state() -> Dictionary:
	spinning_tween.kill()
	spinning_tween = null
	return {}
