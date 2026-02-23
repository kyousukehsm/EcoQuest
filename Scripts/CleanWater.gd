extends Area2D

signal player_entered
signal player_exited

func _ready() -> void:
	add_to_group("CleanWater")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		emit_signal("player_entered")
		body._on_clean_water_entered()

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		emit_signal("player_exited")
		body._on_clean_water_exited()
