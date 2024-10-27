class_name State_Stun extends State

@export var knockback_speed : float = 200.0
@export var decelarate_speed : float = 10.0
@export var invulnerable_duration : float = 1.0

var hurt_box : HurtBox
var direction : Vector2

var next_state : State = null

@onready var idle: State_Idle = $"../Idle"

func init() -> void:
	player.player_damaged.connect( _player_damaged )

func _Enter() -> void:
	
	player.animation_player.animation_finished.connect( _animation_finished )
	
	direction = player.global_position.direction_to( hurt_box.global_position )
	player.velocity = direction * -knockback_speed
	player._SetDirection()
	
	player._UpdateAnimation("stun")
	player.make_invulnerable( invulnerable_duration )
	player.effect_animation_player.play("damaged")
	pass

func _Exit() -> void:
	next_state = null
	player.animation_player.animation_finished.disconnect( _animation_finished )
# Called every frame. 'delta' is the elapsed time since the previous frame.
func Process(_delta: float) -> State:
	player.velocity -= player.velocity * decelarate_speed * _delta
	return next_state

func Physics(_delta: float) -> State:
	return null
	
func _player_damaged( _hurt_box : HurtBox ):
	hurt_box = _hurt_box
	state_machine.ChangeState( self )
	pass
	
func _animation_finished( _a : String ) -> void:
	next_state = idle
