extends Node2D
class_name FSM

signal state_changed
signal change_state(new_state:String, enter_args:Dictionary)

@export var actor:Node2D
@export var initial_state:State

var current_state:State
var _states:Dictionary = {}

func _ready():
	set_physics_process(false) # children will do it

	change_state.connect(_change_state)
	for available_state in get_children():
		if available_state is State:
			_states[available_state.name] = available_state
			available_state.actor = actor
			available_state.change_state.connect(_change_state)

func init() -> void:
	if initial_state:
		_change_state(initial_state.name)

func set_state_property(state_name:StringName, property_name:String, value:Variant) -> void:
	_states[state_name].set(property_name, value)

func _change_state(new_state_name:String, enter_args:Dictionary={}):
	#print("CHANGING STATE: ", new_state_name, " (current: ", current_state, ")")

	if current_state is State:
		await current_state._exit_state()
	#print("\t\tEXIT COMPLETE")

	var new_state:State = _states[new_state_name]
	new_state._enter_state(enter_args)
	#print("\t\tENTER COMPLETE")
	current_state = new_state

	call_deferred("emit_signal", "state_changed")

func _handle_input(event:InputEvent) -> void:
	if current_state:
		current_state._handle_input(event)
