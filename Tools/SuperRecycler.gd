extends Tool

func _ready() -> void:
	tool_name = "super_recycler"

func use_tool(position: Vector2) -> void:
	print("Super recycling initiated at:", position)
	# Perform all tool actions
	emit_signal("clean_area", position)

func set_facing_direction(is_facing_left: bool) -> void:
	# Adjust the tool's position based on the facing direction
	position = Vector2(-30, 15) if is_facing_left else Vector2(30, 15)
	$tool_sprite.flip_h = is_facing_left
