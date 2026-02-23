extends Tool

func _ready() -> void:
	tool_name = "vine_extender"

func use_tool(position: Vector2) -> void:
	print("Creating vine at:", position)
	# Spawn a temporary vine path
	var vine = preload("res://tools/vine_path.tscn").instantiate()
	vine.global_position = position
	vine.queue_free_after(5.0)
	add_child(vine)

func set_facing_direction(is_facing_left: bool) -> void:
	# Adjust the tool's position based on the facing direction
	position = Vector2(-30, 15) if is_facing_left else Vector2(30, 15)
	$tool_sprite.flip_h = is_facing_left
