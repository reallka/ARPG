class_name Player extends CharacterBody2D

signal direction_changed( new_direction: Vector2)
signal player_damaged( hurt_box: HurtBox)

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var invulnerable : bool = false
var hp: int = 6
var max_hp: int = 6

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var effect_animation_player: AnimationPlayer = $EffectAnimationPlayer

@onready var state_machine: PlayerStateMachine = $StateMachine
@onready var hit_box: HitBox = $HitBox

signal DirectionChanged(new_direction : Vector2)

func _ready() -> void:
	PlayerManager.player = self
	state_machine.Initialize(self)
	hit_box.Damaged.connect( _take_damage )
	update_hp(99)
	pass
	
	
func _process( _delta ):
	direction = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	).normalized()
	pass
	
func _physics_process(_delta: float) -> void:
	move_and_slide()

func _SetDirection() -> bool:
	var new_dir : Vector2 = cardinal_direction
	if direction == Vector2.ZERO:
		return false
	
	
	if direction.y == 0:
		new_dir = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT
	elif direction.x == 0:
		new_dir = Vector2.UP if direction.y < 0 else Vector2.DOWN
	
	if new_dir == cardinal_direction:
		return false
	
	cardinal_direction = new_dir
	DirectionChanged.emit(new_dir)
	sprite_2d.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	return true

func _UpdateAnimation(state : String) -> void:
	animation_player.play(state + "_" + _AnimDirection() )
	
func _AnimDirection() -> String:
	
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"

func _take_damage( hurt_box: HurtBox ):
	if invulnerable == true:
		return
	update_hp( -hurt_box.damage )
	if hp > 0:
		player_damaged.emit(hurt_box)
	else:
		player_damaged.emit(hurt_box)
		update_hp( 99 )
	
	pass
	

func update_hp( delta : int ):
	hp = clampi( hp + delta, 0, max_hp)
	PlayerHud.update_hp(hp , max_hp)
	pass
	
func make_invulnerable( _duration : float = 1.0 ) -> void:
	invulnerable = true
	hit_box.monitoring = false
	
	await get_tree().create_timer( _duration ).timeout
	
	invulnerable = false
	hit_box.monitoring = true
	pass
