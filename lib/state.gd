extends Node2D
class_name State

signal change_state(new_state_name)

var actor:Node2D
var is_active_state:bool = false

func _ready() -> void:
	set_physics_process(false)

func _enter_state(_args:Dictionary) -> void:
	print("\tENTERING STATE ", self.name)
	is_active_state = true
	set_physics_process(true)

func _exit_state() -> void:
	print("\tEXITING STATE ", self.name)
	is_active_state = false
	set_physics_process(false)

func transition_to(new_state_name:String) -> void:
	change_state.emit(new_state_name)

func _physics_process(_delta:float) -> void: pass
func _handle_input(_event:InputEvent) -> void: pass
