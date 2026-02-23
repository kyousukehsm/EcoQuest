extends Area2D

@export var health_value: int = 20 

func _on_body_entered(body):
	if body.is_in_group("Player") and body.has_method("heal"):
		body.heal(health_value) 
		queue_free() 
