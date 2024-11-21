class_name State_Attack extends State

var attacking: bool  = false
@onready var walk: State_Walk = $"../Walk"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var idle: State_Idle = $"../Idle"
@onready var attack_anim: AnimationPlayer = $"../../Sprite2D/AttackEffectSprite/AnimationPlayer"
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D"
@export_range(1,20,0.5) var decelerate_speed : float = 5.0
@onready var hurt_box: HurtBox = $"../../Interactions/HurtBox"




func _Enter() -> void:
	player._UpdateAnimation("attack")
	attack_anim.play("attack_" + player._AnimDirection())
	audio_stream_player_2d.pitch_scale = randf_range(0.9, 1.1)
	audio_stream_player_2d.play()
	animation_player.animation_finished.connect(EndAttack)
	attacking = true
	await get_tree().create_timer(0.075).timeout
	if attacking:
		hurt_box.monitoring = true
	pass
func _Exit() -> void:
	animation_player.animation_finished.disconnect(EndAttack)
	hurt_box.monitoring = false
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func Process(_delta: float) -> State:
	player.velocity -= player.velocity * decelerate_speed * _delta
	
	if attacking == false:
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return walk
	return null

func Physics(_delta: float) -> State:
	return null
	
func HandleInput(_event : InputEvent) -> State:
	return null

func EndAttack(_newAnimName : String) -> void:
	attacking = false
	
