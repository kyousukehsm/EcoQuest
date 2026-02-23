extends Tool

func _ready() -> void:
	tool_name = "air_purifier"

func use_tool(position: Vector2) -> void:
	print("Clearing toxic clouds...")
	# Emit a clearing wave
	var wave = preload("res://tools/air_wave.tscn").instantiate()
	wave.global_position = position
	add_child(wave)

func set_facing_direction(is_facing_left: bool) -> void:
	# Adjust the tool's position based on the facing direction
	position = Vector2(-30, 15) if is_facing_left else Vector2(30, 15)
	$tool_sprite.flip_h = is_facing_left
