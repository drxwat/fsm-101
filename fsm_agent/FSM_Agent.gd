extends KinematicBody2D

signal animation_finished

const UNIT_HEIGHT = 16.0

var input_actions := ["jump", "move_left", "move_right"]
var state: FSM_State = FSM_State_Idle.new(self)

var speed := 40.0 
var max_jump_height = 1.2 * UNIT_HEIGHT
var min_jump_height = 0.5 * UNIT_HEIGHT
var jump_duration = 0.4
var velocity := Vector2.ZERO
var gravity: float
var max_jump_velocity: float
var min_jump_velocity: float

var animated_sprite: AnimatedSprite

func _ready():
	gravity = 2 * max_jump_height / pow(jump_duration, 2)
	max_jump_velocity = -sqrt(2 * gravity * max_jump_height)
	min_jump_velocity = -sqrt(2 * gravity * min_jump_height)
	animated_sprite = $AnimatedSprite
	animated_sprite.connect("animation_finished", self, "on_animation_finished")

func _physics_process(delta: float):
	velocity.y += gravity * delta
	handle_state(delta)
	velocity = move_and_slide(velocity, Vector2.UP)

func handle_state(delta: float):
	var actions := []
	for action in input_actions:
		if Input.is_action_pressed(action):
			actions.append(action)
	var fsm_input = FSM_Meta.FSM_Input.new(actions, is_on_floor())
	var new_state_id = state.input(fsm_input)
	if new_state_id != FSM_Meta.FSM_States.None:
		var new_state = get_new_state(new_state_id)
		state.exit()	
		state = new_state
		state.enter()
	state.update(fsm_input, delta)

func get_new_state(state_id: int):
	match state_id:
		FSM_Meta.FSM_States.Idle:
			return FSM_State_Idle.new(self)
		FSM_Meta.FSM_States.Move:
			return FSM_State_Move.new(self)
		FSM_Meta.FSM_States.Jump:
			return FSM_State_Jump.new(self)
	push_error("Invalid state ID: %d" % state_id)
	
func play_animation(animation: String):
	animated_sprite.play(animation)
	
func flip_h(condition: bool):
	animated_sprite.scale.x = -1 if condition else 1

func on_animation_finished():
	emit_signal("animation_finished")

