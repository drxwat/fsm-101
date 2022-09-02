extends FSM_State
class_name FSM_State_Idle

const DEFAULT_ANIMATION := "idle1"
const ALTERNATIVE_ANUIMATIONS := ["idle2", "idle3"]
const ANIMATION_INTERVAL := 5.0

var rng := RandomNumberGenerator.new()
var time_to_alternative_animation := ANIMATION_INTERVAL

func _init(_agent).(_agent):
	rng.randomize()
	
func input(fsm_input: FSM_Meta.FSM_Input) -> int:
	if "jump" in fsm_input.actions:
		return FSM_Meta.FSM_States.Jump
	elif "move_right" in fsm_input.actions or "move_left" in fsm_input.actions:
		return FSM_Meta.FSM_States.Move
	return FSM_Meta.FSM_States.None

func update(fsm_input: FSM_Meta.FSM_Input, delta: float):
	time_to_alternative_animation -= delta
	if time_to_alternative_animation <= 0 and not agent.is_connected("animation_finished", self, "on_animation_finished"):
		var animation = ALTERNATIVE_ANUIMATIONS[rng.randi_range(0, ALTERNATIVE_ANUIMATIONS.size() - 1)]
		agent.play_animation(animation)
		agent.connect("animation_finished", self, "on_animation_finished", [], CONNECT_ONESHOT)
	
	agent.velocity.x = 0.0

func enter():
	agent.play_animation(DEFAULT_ANIMATION)

func exit():
	if agent.is_connected("animation_finished", self, "on_animation_finished"):
		agent.disconnect("animation_finished", self, "on_animation_finished")

func on_animation_finished():
	time_to_alternative_animation = ANIMATION_INTERVAL
	agent.play_animation(DEFAULT_ANIMATION)
