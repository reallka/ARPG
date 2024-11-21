class_name EnemyStateDestroy extends Enemy_State

const PICKUP = preload("res://Items/item_pickup/item_pickup.tscn")

@export var anim_name : String = "destroy"
@export var knockback_speed : float = 200.0
@export var decelarate_speed : float = 10.0

@export_category("AI")
@export_category("Item Drops")
@export var drops : Array[ DropData ]


var _damage_position : Vector2
var _direction : Vector2

func init() -> void:
	enemy.enemy_destroyed.connect( _on_enemy_destroyed )

func _Enter() -> void:
	enemy.invulnerable == true

	_direction = enemy.global_position.direction_to( _damage_position )
	
	enemy._SetDirection( _direction )
	enemy.velocity = _direction * -knockback_speed
	
	enemy.update_animation(anim_name)
	enemy.animation_player.animation_finished.connect( _on_animation_finished )
	disable_hurt_box()
	drop_items()
	
func _Exit() -> void:
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.


func Process(_delta: float) -> Enemy_State:
	enemy.velocity -= enemy.velocity * decelarate_speed * _delta
	return null

func Physics(_delta: float) -> Enemy_State:
	return null
	
func _on_enemy_destroyed( hurt_box : HurtBox) -> void:
	_damage_position = hurt_box.global_position
	state_machine.ChangeState(self)


func _on_animation_finished(_a : String) -> void:
	enemy.queue_free()

func disable_hurt_box() -> void:
	var hurt_box : HurtBox = enemy.get_node_or_null("HurtBox")
	if hurt_box:
		hurt_box.monitoring = false


func drop_items() -> void:
	if drops.size() == 0:
		return
	
	for i in drops.size():
		if drops[ i ] == null or drops[ i ].item == null:
			continue
		var drop_count : int = drops[ i ].get_drop_count()
		for j in drop_count:
			var drop : ItemPickup = PICKUP.instantiate() as ItemPickup
			drop.item_data = drops[ i ].item
			enemy.get_parent().call_deferred( "add_child", drop )
			drop.global_position = enemy.global_position
			drop.velocity = enemy.velocity.rotated( randf_range( -1.5, 1.5 ) ) * randf_range( 0.9 , 1.5 )
	pass
