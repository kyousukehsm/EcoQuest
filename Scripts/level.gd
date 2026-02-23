extends Node2D

@onready var world_tilemap: TileMap = $TileMap  # Your ground tiles
@onready var climb_tilemap: TileMap = $TileMap2  # Your ladder/rope tiles
@onready var pause_button: Button = $UI/Control/PauseButton
@onready var aliya: Node2D = $Aliya  # Reference to the Aliya node in the scene

@export var aliya_dialogue: Array = [
	"Nagagalak akong makita ka, Jemboy!",
	"Ako si Aliya, isang diwata na naninirahan sa gubat.",
	"Kailangan ko ang iyong tulong sa paglilinis ng kalikasan."
]

var recyclable_count: int = 0
var active_water_areas: int = 0  # Track how many water areas player is in
var pause_menu: CanvasLayer = null  # Reference to the pause menu

func _ready() -> void:
	# Connect pause button
	if pause_button:
		pause_button.pressed.connect(_on_pause_button_pressed)
	
	setup_climbable_areas()
	
	if aliya:  # Check if aliya exists in the scene
		# Set the custom dialogue for this Aliya instance
		aliya.set_dialogue(aliya_dialogue)  # Call set_dialogue() from the Aliya script
	else:
		print("Aliya instance not found!")

func _on_pause_button_pressed() -> void:
	if pause_menu == null:
		# Instantiate the Pause Menu only if it hasn't been created yet
		pause_menu = load("res://Scenes/PauseMenu.tscn").instantiate()
		get_tree().current_scene.add_child(pause_menu)
		
		pause_menu.resume_game.connect(close_pause_menu)
		pause_menu.restart_game.connect(restart_level)
		pause_menu.quit_game.connect(quit_game)
		
	pause_menu.visible = true  # Show the pause menu
	get_tree().paused = true   # Pause the game

func close_pause_menu() -> void:
	if pause_menu:
		pause_menu.visible = false  
	get_tree().paused = false  # Resume the game
	
func restart_level() -> void:
	close_pause_menu()
	get_tree().reload_current_scene()
	
func quit_game() -> void:
	close_pause_menu()
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")

func setup_climbable_areas() -> void:
	var used_cells = climb_tilemap.get_used_cells(0)  # 0 is the layer number
	for cell in used_cells:
		var source_id = climb_tilemap.get_cell_source_id(0, cell)
		if source_id != -1:  # -1 means empty cell
			var climb_area = preload("res://Scenes/climbable_area.tscn").instantiate()
			climb_area.position = climb_tilemap.map_to_local(cell)
			add_child(climb_area)
