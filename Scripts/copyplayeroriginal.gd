extends CharacterBody2D

# In your player script
signal tool_switched

const LEVEL_MUSIC = {
	"Level1": preload("res://Assets/Music/3-07 Goron City (Hyrule Symphony).mp3"),
	"Level2": preload("res://Assets/Music/3-09 Gerudo Valley (Hyrule Symphony).mp3"),
	"Level3": preload("res://Assets/Music/3-08 Zora's Domain (Hyrule Symphony).mp3"),
}
const JUMP_SOUND = preload("res://Assets/Sounds/jump.wav")
const COLLECT_SOUND = preload("res://Assets/Sounds/collect.wav")
const HURT_SOUND = preload("res://Assets/Sounds/hurt.wav")

# Constants
const BASE_SPEED: float = 250.0
const JUMP_VELOCITY: float = -400.0
const CLIMB_SPEED: float = 150.0
const WATER_JUMP_FORCE: float = -350
const SWIM_UP_FORCE: float = -150
const FLOAT_FORCE: float = -20.0
const WATER_DRAG: float = 3.0
const POLLUTED_WATER_SPEED_MULTIPLIER: float = 0.4  # More sluggish than clean water
const POLLUTED_WATER_DRAG: float = 4.5  # Higher drag in polluted water
const POLLUTED_WATER_GRAVITY: float = 0.25  # Heavier feeling in polluted water

# Nodes
@export var tool_scenes: Dictionary = {
	"water_purifier": preload("res://Tools/WaterPurifier.tscn"),
	"magic_brush": preload("res://Tools/CleaningBrush.tscn"),
	"vine_extender": preload("res://Tools/VineExtender.tscn")
}
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var climb_detector: Area2D = $ClimbDetector
@onready var timer = $Timer
@onready var tool_holder: Node2D = $ToolHolder
@onready var tool_anchor: Node2D = $ToolAnchor 
@onready var tool_name_label = $UI2/ToolNameLabel
@onready var tool_icon_sprite = $UI2/ToolIcon 
@onready var health_bar
@onready var score_label
@onready var audio_player: AudioStreamPlayer = $BGMPlayer  # New AudioStreamPlayer for background music
@onready var sfx_player: AudioStreamPlayer = $AudioStreamPlayer

# Ecotools
var current_tool: Tool = null
var available_tools: Array[Tool] = []

# Variables
var max_health: int = 100
var health: int = 100
var score = 0
var total_collectibles: int = 0
var collected_count: int = 0

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var water_gravity: float = gravity * 0.15  # Reduced gravity in water
var is_climbing: bool = false
var can_climb: bool = false
var climb_grace_time: float = 0.2
var climb_grace_timer: float = 0.0
var is_invulnerable: bool = false
var invulnerability_duration: float = 2.0

# Water-related variables
var is_in_water: bool = false
var is_in_polluted_water: bool = false  # New variable to track water type
var is_swimming: bool = false
var current_speed: float = BASE_SPEED
var walk_speed: float = BASE_SPEED
var swim_speed: float = BASE_SPEED * 0.6
var polluted_swim_speed: float = BASE_SPEED * POLLUTED_WATER_SPEED_MULTIPLIER
var swim_depth_threshold: float = -20.0
var death_timer: float = 1.0
var water_transition_timer: float = 0.0
const WATER_TRANSITION_TIME: float = 0.15

var debug_floating_enabled: bool = false  # Toggle for debug floating
var debug_float_speed: float = 200.0     # Speed for debug floating

# Functions
func _ready() -> void:
	# Connect to the tree to detect level changes
	get_tree().connect("node_added", Callable(self, "_on_scene_changed"))
	print("Connected to current_scene_changed signal.")

	# Handle the current scene when the game starts
	if get_tree().current_scene:
		handle_scene_change(get_tree().current_scene)

	# Initialize references for the current level
	update_ui_references()
	setup_tools()
	process_recyclables()
	
	print("Available tools: ", available_tools)
	climb_detector.area_entered.connect(_on_climb_detector_area_entered)
	climb_detector.area_exited.connect(_on_climb_detector_area_exited)
	
	if health_bar:
		health_bar.max_value = max_health
		health_bar.value = health
		
	if score_label:
		update_collectibles_label()

	timer.one_shot = true
	timer.wait_time = death_timer

# Debug floating handler
func handle_debug_floating(_delta: float) -> void:
	velocity = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		velocity.x -= debug_float_speed
	if Input.is_action_pressed("move_right"):
		velocity.x += debug_float_speed
	if Input.is_action_pressed("move_up"):
		velocity.y -= debug_float_speed
	if Input.is_action_pressed("move_down"):
		velocity.y += debug_float_speed
	
	move_and_slide()

func play_sfx(sfx: AudioStream) -> void:
	if sfx:
		var sound_instance = AudioStreamPlayer.new()
		sound_instance.stream = sfx
		add_child(sound_instance)
		sound_instance.play()
		
# Toggle debug floating mode
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_toggle_float"):
		debug_floating_enabled = not debug_floating_enabled
		if debug_floating_enabled:
			print("Debug floating mode enabled")
		else:
			print("Debug floating mode disabled")
			
func set_camera_limits(level: int) -> void:
	# Get the Camera2D node (assuming it's a direct child of the player or accessible in the scene tree)
	var camera: Camera2D = $Camera2D
	
	if level == 3:
		camera.limit_left = -300
		camera.limit_right = 1100
		camera.limit_top = -10000000
		camera.limit_bottom = 730
		print("Camera limits set for level 3")
	else:
		# Default or other level-specific limits can be set here
		camera.limit_left = -500
		camera.limit_right = 10000
		camera.limit_top = -1000000000
		camera.limit_bottom = 630
		print("Camera limits set for level ", level)

func handle_scene_change(scene: Node) -> void:
	var level_name = String(scene.name)
	if level_name.begins_with("Level"):
		BackgroundMusic.pause_music()
		if LEVEL_MUSIC.has(level_name):
			_update_background_music(LEVEL_MUSIC[level_name])
			print("Playing music for", level_name)
	else:
		BackgroundMusic.resume_music()
		print("Resuming main menu music.")
	
	var level_map = {
		"Level1": 1,
		"Level2": 2,
		"Level3": 3
	}
	# Update UI references or any other logic needed
	var level_number = level_map.get(level_name, 0)
	print("Scene name:", scene.name, " -> Extracted level number:", level_number)
	update_ui_references()

	# Determine the level number from the scene name
	set_camera_limits(level_number)
	print("Camera limits updated for level:", level_number)

func _update_background_music(music_stream: AudioStream) -> void:
	if audio_player.stream != music_stream:
		audio_player.stream = music_stream
		audio_player.play()
		
func update_ui_references() -> void:
	# Dynamically update health bar and score label based on the current level's structure
	health_bar = get_tree().current_scene.get_node_or_null("UI/Control/HealthBar")
	score_label = get_tree().current_scene.get_node_or_null("UI/Control/ScoreLabel")

	if health_bar:
		health_bar.max_value = max_health
		health_bar.value = health
	else:
		print("Health bar not found!")

	if score_label:
		update_collectibles_label()
	else:
		print("Score label not found!")

func setup_tools() -> void:
	for tool_name in tool_scenes:
		var tool_instance: Tool = tool_scenes[tool_name].instantiate() as Tool
		if tool_instance:
			print("Tool instantiated:", tool_name)
			print("Tool properties - Name:", tool_instance.tool_name, "Icon:", tool_instance.icon_texture)
			available_tools.append(tool_instance)
			add_child(tool_instance)
			tool_instance.hide()
		else:
			print("Failed to instantiate tool:", tool_name)
	
	# Set initial tool if any exist
	if not available_tools.is_empty():
		switch_to_tool(0)  # Switch to first tool

func process_recyclables() -> void:
	# Get all nodes in the "Recyclables" group
	var recyclables = get_tree().get_nodes_in_group("Recyclables")
	total_collectibles = recyclables.size()
	update_collectibles_label()

	# Connect collectible signals
	for recyclable in recyclables:
		if recyclable.has_signal("collected"):
			recyclable.connect("collected", Callable(self, "_on_recyclable_collected"))

func _physics_process(delta: float) -> void:
		# Handle debug floating mode
	if debug_floating_enabled:
		handle_debug_floating(delta)
		return  # Skip regular processing during debugging
	
	# Handle timers
	if not timer.is_stopped():  # If timer is running (player is dead)
		return  # Don't process movement
		
	if climb_grace_timer > 0:
		climb_grace_timer -= delta
		if climb_grace_timer <= 0:
			can_climb = false

	# Apply gravity or water drag
	if not is_climbing:
		apply_gravity(delta)

	# Climbing logic
	if can_climb and (Input.is_action_pressed("move_up") or Input.is_action_pressed("move_down")):
		is_climbing = true
	elif Input.is_action_just_pressed("jump") or not can_climb:
		is_climbing = false

	if is_climbing:
		handle_climbing()
	else:
		handle_movement(delta)

	move_and_slide()

	if health <= 0:
		die()

func apply_gravity(delta: float) -> void:
	if is_in_water:
		var current_gravity = water_gravity
		var current_drag = WATER_DRAG
		
		if is_in_polluted_water:
			current_gravity *= POLLUTED_WATER_GRAVITY
			current_drag = POLLUTED_WATER_DRAG
		
		# Falling
		if velocity.y > 0:
			velocity.y += current_gravity * delta * 0.5
		else:  # Rising
			velocity.y += current_gravity * delta * 0.8
		
		# Add water resistance based on type
		velocity.y = clamp(velocity.y, -200 * (1.0 if not is_in_polluted_water else 0.7), 
						 150 * (1.0 if not is_in_polluted_water else 1.3))
		velocity.x = move_toward(velocity.x, 0, current_drag * delta * 60)
	else:
		velocity.y += gravity * delta

func handle_climbing() -> void:
	velocity.y = 0
	var vertical_direction: float = Input.get_axis("move_up", "move_down")
	velocity.y = vertical_direction * CLIMB_SPEED
	velocity.x = Input.get_axis("move_left", "move_right") * (BASE_SPEED * 0.5)

	if vertical_direction != 0 or velocity.x != 0:
		animated_sprite.play("climb")
	else:
		animated_sprite.play("climb_idle")
		
func handle_movement(_delta: float) -> void:
	var direction = Input.get_axis("move_left", "move_right")
	if direction != 0:
		velocity.x = direction * current_speed
		animated_sprite.flip_h = direction < 0

		# Update tool's facing direction
		if current_tool:
			current_tool.set_facing_direction(animated_sprite.flip_h)
	else:
		velocity.x = 0  # Reset horizontal velocity when no input

	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY
		animated_sprite.play("jump")
		play_sfx(JUMP_SOUND)
	elif not is_on_floor():
		animated_sprite.play("jump")
	elif direction != 0:
		animated_sprite.play("move")
	else:
		animated_sprite.play("idle")

func set_invulnerability(duration: float) -> void:
	is_invulnerable = true
	await get_tree().create_timer(duration).timeout
	is_invulnerable = false

func handle_water_movement(_delta: float) -> void:
	var input_axis = Input.get_axis("move_left", "move_right")
	var movement_lerp_weight = 0.1 if not is_in_polluted_water else 0.05
	
	# Horizontal movement
	if input_axis != 0:
		var target_speed = input_axis * (current_speed * (0.7 if not is_in_polluted_water else 0.5))
		velocity.x = lerp(velocity.x, target_speed, movement_lerp_weight)
	
	# Vertical movement
	if Input.is_action_pressed("jump"):
		if position.y <= swim_depth_threshold:
			# Surface jump force reduced in polluted water
			velocity.y = WATER_JUMP_FORCE * (1.0 if not is_in_polluted_water else 0.7)
		else:
			# Swimming force reduced in polluted water
			var swim_force = SWIM_UP_FORCE * (1.0 if not is_in_polluted_water else 0.6)
			velocity.y = lerp(velocity.y, swim_force, movement_lerp_weight)
	elif Input.is_action_just_released("jump"):
		velocity.y *= 0.5
	else:
		var float_strength = FLOAT_FORCE * (1.0 if not is_in_polluted_water else 1.3)
		velocity.y = lerp(velocity.y, float_strength, movement_lerp_weight)
	
	animated_sprite.play("swim")

func _on_climb_detector_area_entered(area: Area2D) -> void:
	if area.is_in_group("climbable"):
		can_climb = true
		climb_grace_timer = 0

func _on_climb_detector_area_exited(area: Area2D) -> void:
	if area.is_in_group("climbable"):
		climb_grace_timer = climb_grace_time

func apply_damage(damage: float) -> void:
	if is_invulnerable:
		return
	health -= int(damage)
	health = clamp(health, 0, max_health)
	if health_bar:
		health_bar.value = health
	flash_red()
	play_sfx(HURT_SOUND)
	if health <= 0:
		die()

func die() -> void:
	audio_player.stop()
	animated_sprite.play("gameover")
	timer.start()
	set_physics_process(false)

func update_collectibles_label() -> void:
	if score_label:
		score_label.text = "Collected: %d/%d" % [collected_count, total_collectibles]

func _on_clean_water_entered() -> void:
	is_in_water = true
	is_in_polluted_water = false
	is_swimming = true
	current_speed = swim_speed
	
	velocity *= 0.5
	if velocity.y > 0:
		velocity.y *= 0.3
		
	water_transition_timer = WATER_TRANSITION_TIME

func _on_polluted_water_entered() -> void:
	is_in_water = true
	is_in_polluted_water = true
	is_swimming = true
	current_speed = polluted_swim_speed
	
	# Heavier entry into polluted water
	velocity *= 0.4
	if velocity.y > 0:
		velocity.y *= 0.4
		
	water_transition_timer = WATER_TRANSITION_TIME

func _on_clean_water_exited() -> void:
	is_in_water = false
	is_in_polluted_water = false
	is_swimming = false
	current_speed = walk_speed
	
	if velocity.y < 0:
		velocity.y *= 1.2
		
	water_transition_timer = 0.0

func _on_polluted_water_exited() -> void:
	is_in_water = false
	is_in_polluted_water = false
	is_swimming = false
	current_speed = walk_speed
	
	# Less momentum when exiting polluted water
	if velocity.y < 0:
		velocity.y *= 0.9
		
	water_transition_timer = 0.0

func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()

# Health bar update function
func heal(amount: int) -> void:
	health += amount
	health = clamp(health, 0, max_health)
	if health_bar:
		health_bar.value = health

# Color reset function for damage flash
func _reset_color() -> void:
	animated_sprite.modulate = Color(1, 1, 1)  # Reset to normal color

# Modified flash_red to use timer
func flash_red() -> void:
	animated_sprite.modulate = Color(1, 0, 0)  # Turn red
	var reset_color_timer = Timer.new()
	reset_color_timer.one_shot = true
	reset_color_timer.wait_time = 0.1
	reset_color_timer.timeout.connect(_reset_color)
	add_child(reset_color_timer)
	reset_color_timer.start()

# Recyclable collection handler
func _on_recyclable_collected() -> void:
	collected_count += 1
	play_sfx(COLLECT_SOUND)
	update_collectibles_label()

# Tool handling functions
func _process(_delta: float) -> void:

	# Handle action button (use ecotool)
	if Input.is_action_just_pressed("action_tool"):
		use_tool()

	# Handle switch tool button
	if Input.is_action_just_pressed("switch_tool"):
		switch_tool()

func use_tool() -> void:
	if current_tool:
		var direction = Vector2.RIGHT
		if animated_sprite.flip_h:
			direction = Vector2.LEFT
			
		# Show tool only during use
		current_tool.show()
		current_tool.use_tool(direction)
		
		# Hide tool after use
		await get_tree().create_timer(0.5).timeout  # Adjust time as needed
		current_tool.hide()

func switch_to_tool(index: int) -> void:
	if current_tool:
		current_tool.hide()
		tool_holder.remove_child(current_tool)
	
	if index >= 0 and index < available_tools.size():
		current_tool = available_tools[index]
		current_tool.global_position = tool_anchor.global_position
		current_tool.rotation = tool_anchor.global_rotation
		tool_holder.add_child(current_tool)
		current_tool.hide()  # Only show when in use
		
		# Ensure facing direction matches player
		current_tool.set_facing_direction(animated_sprite.flip_h)
		
		# Update UI
		update_tool_ui()
	else:
		current_tool = null
		print("Invalid tool index:", index)

func update_tool_ui() -> void:
	if !tool_name_label or !tool_icon_sprite:
		push_error("UI elements not properly connected!")
		return
		
	if current_tool:
		tool_name_label.text = current_tool.tool_name
		tool_icon_sprite.texture = current_tool.icon_texture
		tool_name_label.visible = true
		tool_icon_sprite.visible = true
	else:
		tool_name_label.text = ""
		tool_icon_sprite.texture = null
		tool_name_label.visible = false
		tool_icon_sprite.visible = false

func switch_tool() -> void:
	if available_tools.size() <= 1:
		return
		
	var current_index = available_tools.find(current_tool)
	var next_index = (current_index + 1) % available_tools.size()
	switch_to_tool(next_index)
	tool_switched.emit()
	print("Switched to tool: ", current_tool.tool_name)
