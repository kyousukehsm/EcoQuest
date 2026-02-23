extends Area2D

# Signal to inform the player they are near a climbable area
signal player_nearby(is_near)

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):  # Ensure the player is in the "Player" group
		emit_signal("player_nearby", true)

func _on_Area2D_body_exited(body):
	if body.is_in_group("Player"):
		emit_signal("player_nearby", false)


func _on_player_nearby(is_near):
	pass # Replace with function body.
