extends Node2D
class_name FSM

signal state_changed
signal change_state(new_state: String, enter_args: Dictionary)

var current_state: String :
	get: return _current_state.name
var _current_state: State
var _states: Dictionary = {}

static func setup(fsm_target: Node2D, states: Array[GDScript]) -> FSM:
	if Config.DEBUG:
		print("*** New FSM for ", fsm_target)
	var instance: FSM = new()
	instance.name = "FSM for %s" % fsm_target.name

	if states.size() == 0: return instance

	instance.target = fsm_target
	for state_class in states:
		var state = state_class.new()
		state.name = state_class.state_name
		state.fsm = instance
		print("\tAdded state: ", state.name)
		instance.add_child(state)

	# go to initial state
	instance.ready.connect(func(): instance._change_state(instance.get_child(0).name))
	fsm_target.add_child(instance)

	return instance


func _ready():
	set_physics_process(false) # children will do it

	change_state.connect(_change_state)
	for available_state in get_children():
		if available_state is State:
			_states[available_state.name] = available_state
			available_state.setup()
			available_state.change_state.connect(_change_state)

func set_state_property(state_name: StringName, property_name: String, value: Variant) -> void:
	_states[state_name].set(property_name, value)

func _change_state(new_state_name: String, enter_args: Dictionary={}):
	#if Config.DEBUG:
		#print("CHANGING STATE: ", new_state_name, " (current: ", _current_state, ")")

	var from_last_state: Dictionary
	if _current_state is State:
		_current_state._exit_state_base()
		from_last_state = await _current_state._exit_state()
	#if Config.DEBUG: print("\tEXIT COMPLETE - from last: ", from_last_state)

	var new_state: State = _states[new_state_name]
	new_state._enter_state_base()
	await new_state._enter_state(enter_args, from_last_state)
	#if Config.DEBUG: print("\tENTER COMPLETE")
	_current_state = new_state

	state_changed.emit.call_deferred()

func _unhandled_input(event: InputEvent) -> void:
	if _current_state:
		_current_state._handle_input(event)
