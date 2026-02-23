extends Area2D

signal cleaned  # Emitted when the garbage is cleaned

@export var max_hits: int = 5  # Number of hits needed to clean
var current_hits: int = 0  # Tracks how many times it's been hit

@onready var sprite = $Sprite

func _ready() -> void:
	add_to_group("Garbage")
	print("Garbage initialized at:", global_position)

func clean_hit() -> void:
	current_hits += 1
	print("Garbage hit! Hits:", current_hits, "/", max_hits)

	if current_hits >= max_hits:
		emit_signal("cleaned")
		clean_up()

func clean_up() -> void:
	print("Garbage cleaned!")
	queue_free()  # Remove the garbage
