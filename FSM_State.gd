extends Reference
class_name FSM_State

var agent: KinematicBody2D

func _init(_agent: KinematicBody2D):
	agent = _agent

func input(fsm_input: FSM_Meta.FSM_Input) -> int:
	return FSM_Meta.FSM_States.None

func update(fsm_input: FSM_Meta.FSM_Input, delta: float) -> void:
	pass

func enter() -> void:
	pass

func exit() -> void:
	pass
