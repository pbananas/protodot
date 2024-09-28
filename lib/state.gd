extends Node2D
class_name State

signal change_state(new_state_name)

var target: Node2D
var fsm: FSM
var is_active_state: bool = false

# override these
func _enter_state(_args: Dictionary, _from_last: Dictionary) -> void: pass
func _exit_state() -> Dictionary: return {}
func _physics_process(_delta: float) -> void: pass
func _handle_input(_event: InputEvent) -> void: pass
func _setup() -> void: pass

func _ready() -> void:
	set_physics_process(false)
	_setup()

func _enter_state_base() -> void:
	# print("\tENTERING STATE ", self.name)
	is_active_state = true
	set_physics_process.call_deferred(true)

func _exit_state_base() -> void:
	#print("\tEXITING STATE ", self.name)
	is_active_state = false
	set_physics_process(false)

func transition_to(new_state_name: String) -> void:
	change_state.emit(new_state_name)

func is_current_state() -> bool:
	return fsm.current_state == name
