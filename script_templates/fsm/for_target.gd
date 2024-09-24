# meta-name: FSM Template
# meta-default: true

extends FSM
class_name _CLASS_FSM

@export var target: _CLASS_

static func setup(fsm_target: _CLASS_, states: Array[GDScript]) -> FSM:
  target = fsm_target as _CLASS_
