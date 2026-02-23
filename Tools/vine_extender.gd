extends Tool
@export var vine_scene: PackedScene
@export var action_radius: float = 100.0

@export var icon_image: Texture  # Assign via the inspector
@export var tool_sfx: AudioStream  # Assign the SFX via the inspector

@onready var tool_sprite = $tool_sprite
@onready var audio_player = $AudioStreamPlayer

var is_near_pot: bool = false
var last_checked_position := Vector2.ZERO
const POSITION_CHECK_THRESHOLD := 5.0

func _ready() -> void:
	tool_name = "Vine Extender"
	icon_texture = icon_image
	add_to_group("Tools")
	last_checked_position = global_position
	audio_player.stream = tool_sfx
	
func _process(_delta: float) -> void:
	if global_position.distance_to(last_checked_position) > POSITION_CHECK_THRESHOLD:
		var pot_nearby = check_for_pot()
		is_near_pot = pot_nearby != null
		last_checked_position = global_position
func check_for_pot() -> Node2D:
	var closest_pot: Node2D = null
	var closest_distance = action_radius
	
	for pot in get_tree().get_nodes_in_group("Pots"):
		var distance = global_position.distance_to(pot.global_position)
		
		if distance <= action_radius and (closest_pot == null or distance < closest_distance):
			closest_pot = pot
			closest_distance = distance
	
	return closest_pot
func use_tool(_position: Vector2) -> void:
	var nearest_pot = check_for_pot()
	if nearest_pot and nearest_pot.has_method("grow_vine"):
		if nearest_pot.grow_vine():
			_play_tool_sfx()
			print("[Vine Extender] Successfully grew a vine!")
		else:
			print("[Vine Extender] Vine already grown.")
	else:
		print("[Vine Extender] No valid pot in range.")

func set_facing_direction(is_facing_left: bool) -> void:
	position = Vector2(-30, 15) if is_facing_left else Vector2(30, 15)
	tool_sprite.flip_h = is_facing_left
	
func _play_tool_sfx() -> void:
	if audio_player and tool_sfx:
		audio_player.play()
	else:
		print("No tool SFX assigned or AudioStreamPlayer is missing!")
