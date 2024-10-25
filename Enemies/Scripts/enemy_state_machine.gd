class_name EnemyStateMachine  extends Node

var states: Array[ Enemy_State ]
var prev_state : Enemy_State
var current_state : Enemy_State


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	
func _process(delta: float) -> void:
	ChangeState(current_state.Process(delta))
	pass

func _physics_process(delta: float) -> void:
	ChangeState(current_state.Physics(delta))
	pass
	
func Initialize(_enemy : Enemy ) -> void:
	states = []
	
	for i in get_children():
		if i is Enemy_State:
			states.append(i)

	for s in states:
		s.enemy = _enemy
		s.state_machine = self
		s.init()
	
	if states.size() > 0:
		ChangeState(states[0])
		process_mode = Node.PROCESS_MODE_INHERIT

func ChangeState(new_state : Enemy_State) -> void:
	if new_state == null || new_state == current_state:
		return
		
	if current_state:
		current_state._Exit()
		
	prev_state = current_state
	current_state = new_state
	current_state._Enter()
