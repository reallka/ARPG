class_name HitBox extends Area2D

signal Damaged( damage : int)

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	pass
	
	
	
func TakeDamage( hurt_box : HurtBox ) -> void:
	print("TakeDamage: ", hurt_box)
	Damaged.emit( hurt_box )
