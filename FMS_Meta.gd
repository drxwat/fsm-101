extends Node
class_name FSM_Meta

enum FSM_States { None = -1, Idle, Move, Attack, Jump }

class FSM_Input:
	var actions: Array
	var is_on_floor: bool
	
	func _init(_actions: Array, _is_on_floor: bool):
		actions = _actions
		is_on_floor = _is_on_floor
