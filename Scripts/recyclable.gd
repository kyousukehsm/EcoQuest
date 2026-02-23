extends Area2D

signal collected

func _ready() -> void:
	add_to_group("Recyclables")

func _on_body_entered(body):
	if body.name == "Player":
		emit_signal("collected") 
		queue_free()
