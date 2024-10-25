class_name EnemyStateStun extends Enemy_State

@export var anim_name : String = "stun"
@export var knockback_speed : float = 200.0
@export var decelarate_speed : float = 10.0

@export_category("AI")

@export var next_state : Enemy_State

var _damage_position : Vector2
var _direction : Vector2
var _animation_finished : bool = false

func init() -> void:
	enemy.enemy_damaged.connect( _on_enemy_damaged )

func _Enter() -> void:
	enemy.invulnerable == true
	
	_animation_finished = false
	_direction = enemy.global_position.direction_to( _damage_position )
	
	enemy._SetDirection( _direction )
	enemy.velocity = _direction * -knockback_speed
	
	enemy.update_animation(anim_name)
	enemy.animation_player.animation_finished.connect( _on_animation_finished )

func _Exit() -> void:
	enemy.invulnerable == false
	enemy.animation_player.animation_finished.disconnect( _on_animation_finished )
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.


func Process(_delta: float) -> Enemy_State:
	if _animation_finished == true:
		return next_state
	enemy.velocity -= enemy.velocity * decelarate_speed * _delta
	return null

func Physics(_delta: float) -> Enemy_State:
	return null
	
func _on_enemy_damaged(hurt_box: HurtBox) -> void:
	_damage_position = hurt_box.global_position
	state_machine.ChangeState(self)


func _on_animation_finished(_a : String) -> void:
	_animation_finished = true
