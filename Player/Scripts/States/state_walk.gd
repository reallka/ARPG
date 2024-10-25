class_name State_Walk extends State

@export var move_speed : float =  100.0

@onready var attack: State_Attack = $"../Attack"

@onready var idle: State_Idle = $"../Idle"


func _Enter() -> void:
	player._UpdateAnimation("walk")
	
func _Exit() -> void:
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func Process(_delta: float) -> State:
	if player.direction == Vector2.ZERO:
		return idle

	player.velocity = player.direction * move_speed
	
	if player._SetDirection():
		player._UpdateAnimation("walk")
	return null
	

func Physics(_delta: float) -> State:
	return null
	
func HandleInput(_event : InputEvent) -> State:
	if _event.is_action_pressed("attack"):
		return attack
	return null
