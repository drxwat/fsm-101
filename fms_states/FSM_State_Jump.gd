extends FSM_State
class_name FSM_State_Jump


func _init(_agent).(_agent):
	pass

func input(fsm_input: FSM_Meta.FSM_Input) -> int:
	if fsm_input.is_on_floor:
		if "move_right" in fsm_input.actions or "move_left" in fsm_input.actions:
			return FSM_Meta.FSM_States.Move
		else:
			return FSM_Meta.FSM_States.Idle
	return FSM_Meta.FSM_States.None

func update(fsm_input: FSM_Meta.FSM_Input, delta: float):
	agent.velocity.x = int(fsm_input.actions.has("move_right")) - int(fsm_input.actions.has("move_left"))
	agent.velocity.x *= agent.speed
	agent.flip_h(agent.velocity.x < 0)

func enter():
	agent.velocity.y = agent.max_jump_velocity
	agent.play_animation("jump")
