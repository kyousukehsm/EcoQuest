extends Tool

@export var icon_image: Texture  # Assign via the inspector
@export var tool_sfx: AudioStream

@onready var tool_sprite = $tool_sprite
@onready var audio_player = $AudioStreamPlayer

func _ready() -> void:
	tool_name = "Water Purifier"	
	icon_texture = icon_image
	audio_player.stream = tool_sfx

func use_tool(_position: Vector2) -> void:
	var purifier_position = global_position
	print("Using Water Purifier at position:", purifier_position)

	# Check for polluted water nearby
	for polluted_water in get_tree().get_nodes_in_group("PollutedWater"):
		print("Purifying water:", polluted_water)
		if polluted_water.global_position.distance_to(purifier_position) < 300:
			polluted_water.clean_hit()
			_play_tool_sfx()
			return

	print("No polluted water detected in range.")

func set_facing_direction(is_facing_left: bool) -> void:
	# Adjust the tool's position based on the facing direction
	position = Vector2(-30, 15) if is_facing_left else Vector2(30, 15)
	tool_sprite.flip_h = is_facing_left

func _play_tool_sfx() -> void:
	if audio_player and tool_sfx:
		audio_player.play()
	else:
		print("No tool SFX assigned or AudioStreamPlayer is missing!")
