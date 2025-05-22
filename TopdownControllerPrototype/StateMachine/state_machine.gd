extends Node
class_name StateMachine

@export var initial_state: BaseState

var current_state: BaseState
var states: Dictionary = {}

func _ready() -> void:
	for child: BaseState in get_children():
		if child is BaseState:
			states[child.name.to_lower()] = child
			child.leave_state.connect(on_state_change)
	if initial_state:
		initial_state.enter_state()
		current_state = initial_state

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)


func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func on_state_change(state: BaseState, next_state_name: String) -> void:
	if state != current_state:
		return
	
	var new_state: BaseState = states.get(next_state_name.to_lower())
	if !new_state:
		return
	if current_state:
		current_state.exit_state()
		new_state.enter_state()
		current_state = new_state
		print(current_state)
