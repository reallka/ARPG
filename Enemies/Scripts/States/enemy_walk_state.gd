class_name EnemyStateWander extends Enemy_State

@export var anim_name : String = "walk"
@export var wander_speed : float = 30.0

@export_category("AI")
@export var state_animation_duration : float = 0.5
@export var state_cycles_min : int = 1
@export var state_cycles_max : int = 3
@export var next_state : Enemy_State
var _timer : float = 0.0
var _direction : Vector2

func init() -> void:
	pass

func _Enter() -> void:
	_timer = randi_range(state_cycles_min, state_cycles_max) * state_animation_duration
	var rand = randi_range(0, 3)
	_direction = enemy.DIR_4[ rand ]
	enemy.velocity = _direction * wander_speed
	enemy._SetDirection( _direction )
	enemy.update_animation(anim_name)


func _Exit() -> void:
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.


func Process(_delta: float) -> Enemy_State:
	_timer -= _delta
	if _timer < 0:
		return next_state
	return null


func Physics(_delta: float) -> Enemy_State:
	return null
	
