extends Camera2D

# Camera settings
@export var target_path: NodePath  # Path to the player node
@export var zoom_level: float = 2.0
@export var follow_speed: float = 5.0  # Lower = smoother camera
@export var screen_margin: Vector2 = Vector2(100, 100)  # Border margin in pixels

# Target node reference
@onready var target: Node2D = get_node(target_path)

func _ready() -> void:
	# Set initial zoom
	zoom = Vector2(zoom_level, zoom_level)
	
	# Enable pixel-perfect rendering for that retro feel
	position_smoothing_enabled = true
	position_smoothing_speed = follow_speed
	
	# Ensure limit drawing is enabled
	limit_smoothed = true
	
	if target:
		# Start at player position
		global_position = target.global_position
	else:
		push_warning("Camera target not set!")

func _physics_process(delta: float) -> void:
	if not target:
		return
		
	# Get target position
	var target_pos = target.global_position
	
	# Calculate desired camera position with screen bounds
	var desired_pos = calculate_desired_position(target_pos)
	
	# Smoothly move camera
	global_position = global_position.lerp(desired_pos, follow_speed * delta)

func calculate_desired_position(target_pos: Vector2) -> Vector2:
	var new_pos = target_pos
	
	# If we have screen limits set
	if limit_right > limit_left or limit_bottom > limit_top:
		# Calculate camera bounds considering zoom
		var half_screen = get_viewport_rect().size / (2 * zoom.x)
		
		# Apply screen margins
		var margin = screen_margin / zoom.x
		
		# Clamp X position
		if limit_right > limit_left:
			new_pos.x = clamp(
				new_pos.x,
				limit_left + half_screen.x + margin.x,
				limit_right - half_screen.x - margin.x
			)
			
		# Clamp Y position
		if limit_bottom > limit_top:
			new_pos.y = clamp(
				new_pos.y,
				limit_top + half_screen.y + margin.y,
				limit_bottom - half_screen.y - margin.y
			)
	
	return new_pos

# Call this to set camera bounds (e.g., from your level scene)
func set_camera_limits(left: int, right: int, top: int, bottom: int) -> void:
	limit_left = left
	limit_right = right
	limit_top = top
	limit_bottom = bottom

# Optional: Add dynamic zoom based on player speed or state
func set_zoom_level(new_zoom: float) -> void:
	zoom_level = new_zoom
	zoom = Vector2(zoom_level, zoom_level)
