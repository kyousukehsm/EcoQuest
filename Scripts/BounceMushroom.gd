extends Node2D

@export var bounce_force: float = -1000.0  # The bounce force applied to the player
@export var bounce_sfx: AudioStream  # Assign the bounce SFX via the inspector

@onready var collision_area: Area2D = $Area2D
@onready var animated_sprite: AnimatedSprite2D = $Sprite2D/AnimatedSprite2D
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer  # Ensure this node exists in the scene

func _ready() -> void:
	collision_area.body_entered.connect(_on_body_entered)
	animated_sprite.play("Idle")

# When the player lands on the mushroom
func _on_body_entered(body: Node) -> void:
	if body is CharacterBody2D:  # Ensure the body is the player
		# Apply bounce force to the player
		body.velocity.y = bounce_force

		# Play bounce animation
		animated_sprite.play("Bounce")
		
		# Play the bounce SFX
		_play_bounce_sfx()
		
		await animated_sprite.animation_finished
		animated_sprite.play("Idle")

func _play_bounce_sfx() -> void:
	if audio_player and bounce_sfx:
		audio_player.stream = bounce_sfx
		audio_player.play()
	else:
		print("No bounce SFX assigned or AudioStreamPlayer is missing!")
