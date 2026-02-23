extends Tool

@export var icon_image: Texture  # Assign via the inspector
@export var tool_sfx: AudioStream

@onready var tool_sprite = $tool_sprite
@onready var audio_player = $AudioStreamPlayer

func _ready() -> void:
	tool_name = "Magic Brush"
	icon_texture = icon_image
	audio_player.stream = tool_sfx

func use_tool(position: Vector2) -> void:
	var brush_position = global_position  # Get the Magic Brush's global position
	print("Using Magic Brush at position:", brush_position)

	# Check for garbage nearby
	for garbage in get_tree().get_nodes_in_group("Garbage"):
		print("Garbage position:", garbage.global_position)
		if garbage.global_position.distance_to(brush_position) < 300:
			print("Garbage in range:", garbage)
			_play_tool_sfx()
			garbage.clean_hit()
			return

	print("No garbage detected in range.")


func set_facing_direction(is_facing_left: bool) -> void:
	# Adjust the tool's position based on the facing direction
	position = Vector2(-30, 15) if is_facing_left else Vector2(30, 15)
	tool_sprite.flip_h = is_facing_left

func _play_tool_sfx() -> void:
	if audio_player and tool_sfx:
		audio_player.play()
	else:
		print("No tool SFX assigned or AudioStreamPlayer is missing!")
