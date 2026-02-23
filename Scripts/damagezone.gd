extends Area2D  # The node detects collisions

signal player_damaged  # Signal to notify damage

func _on_body_entered(body):
	if body.name == "Player":  # Check if it's the player
		body.apply_damage()  # Call the player's damage function
		emit_signal("player_damaged", body)
		print("ouch")
