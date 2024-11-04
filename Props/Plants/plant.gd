class_name Plant extends Node2D


func _ready() -> void:
	$HitBox.Damaged.connect( TakeDamage )
	
func TakeDamage ( _damage : HurtBox ) -> void:
	queue_free()
