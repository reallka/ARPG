class_name EnemyStateIdle extends Enemy_State

@export var anim_name : String = "idle"
@export_category("AI")
@export var state_duration_min : float = 0.5
@export var state_duration_max : float = 1.5
@export var after_idle_state : Enemy_State
var _timer : float = 0.0

func init() -> void:
	pass

func _Enter() -> void:
	enemy.velocity = Vector2.ZERO
	_timer = randf_range(state_duration_min, state_duration_max)
	enemy.update_animation(anim_name)
	
func _Exit() -> void:
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func Process(_delta: float) -> Enemy_State:
	_timer -= _delta
	if _timer <= 0:
		return after_idle_state
	return null


func Physics(_delta: float) -> Enemy_State:
	return null
	
