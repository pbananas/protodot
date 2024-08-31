# meta-name: State Template for FSM
# meta-default: true

extends State
class_name _CLASS_State
static var state_name := "_CLASS_".to_snake_case()

func _setup() -> void: pass
func _enter_state(_args: Dictionary, _from_last: Dictionary) -> void: pass
func _exit_state() -> Dictionary: return {}
func _physics_process(_delta: float) -> void: pass
func _handle_input(_event: InputEvent) -> void: pass
