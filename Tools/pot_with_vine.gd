extends Area2D

@export var interaction_range: float = 200.0
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var vine_sprite: Sprite2D = $VineVisual
@onready var climb_shape: CollisionShape2D = $ClimbingCollision

var vine_grown: bool = false

func _ready() -> void:
	vine_sprite.visible = false  # Start vine as invisible
	climb_shape.disabled = true  # Start vine as non-climbable
	
	# Use a callable for the connection
	animation_player.animation_finished.connect(_on_animation_finished)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Tools") and not vine_grown:
		print("[PotWithVine] Tool entered range.")
		body.set_meta("near_pot", self)

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("Tools"):
		print("[PotWithVine] Tool left range.")
		body.set_meta("near_pot", null)
	if body.is_in_group("Climbable"):
		print("[Player] Detected climbable surface:", body.name)

func grow_vine() -> bool:
	if vine_grown:
		print("[PotWithVine] Vine already grown.")
		return false

	print("[PotWithVine] Growing vine...")
	vine_grown = true

	# Play growth animation
	animation_player.play("grow")
	return true

func _on_animation_finished(animation_name: String) -> void:
	if animation_name == "grow":
		climb_shape.disabled = false  # Enable climbing
		add_to_group("climbable")    # Add to Climbable group
		print("[PotWithVine] Vine is now climbable.")
