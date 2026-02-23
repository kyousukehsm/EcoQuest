extends Area2D

signal purified  # Emitted when the water is purified
signal player_entered  # Emitted when the player enters the polluted water
signal player_exited  # Emitted when the player exits the polluted water

@export var damage: float = 10.0  # Damage dealt to the player
@export var knockback_force: float = 300.0  # Force applied to knock the player back
@export var max_hits: int = 1  # Number of hits needed to purify
var current_hits: int = 0  # Tracks how many times it's been hit

@onready var sprite = $Sprite

func _ready() -> void:
	add_to_group("PollutedWater")
	print("[PollutedWater] Initialized at position:", global_position)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("[PollutedWater] Player detected!")
		emit_signal("player_entered")
		body.apply_damage(damage)
		
		# Apply knockback to the player
		var knockback_direction = (body.global_position - global_position).normalized()
		body.velocity = knockback_direction * knockback_force
		body.velocity.y = max(body.velocity.y - 200, -knockback_force)
		
		if body.has_method("set_invulnerability") and not body.is_invulnerable:
			body.set_invulnerability(1.0)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("[PollutedWater] Player exited!")
		emit_signal("player_exited")

func clean_hit() -> void:
	current_hits += 1
	print("[PollutedWater] Hit received! Hits:", current_hits, "/", max_hits)

	if current_hits >= max_hits:
		emit_signal("purified")
		purify()

func purify() -> void:
	print("[PollutedWater] Purifying!")
	var clean_water = preload("res://Scenes/CleanWater.tscn").instantiate()
	clean_water.global_position = global_position
	get_parent().add_child(clean_water)
	queue_free()  # Remove the polluted water node
