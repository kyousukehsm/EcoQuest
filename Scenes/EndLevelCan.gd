extends Area2D

# Path to the second level scene
@export var next_level_scene: String
var message_label: Label  # Assuming you have a Label node for messages

# Reference to the player or other necessary nodes (if needed)
@onready var player = get_tree().current_scene.get_node("Player")
@onready var collectibles_group = get_tree().get_nodes_in_group("Recyclables")  # Assuming you have added collectibles to this group

func _ready():
	# Debugging: Check if all recyclables are in the correct group
	for collectible in collectibles_group:
		if not collectible.is_in_group("Recyclables"):
			print("This collectible is not in the 'Recyclables' group: ", collectible)
	
	# Debugging: Check the number of collectibles in the group
	var collectible_count = collectibles_group.size()
	print("Collectibles in this level: ", collectible_count)
	
	# Debugging: Check for duplicates in the group
	var seen_positions = []
	for collectible in collectibles_group:
		if collectible is Node2D:
			if seen_positions.has(collectible.position):
				print("Duplicate collectible detected at position: ", collectible.position)
			seen_positions.append(collectible.position)
			
			# Optionally print the collectible position to ensure they are at the right place
			print("Collectible position: ", collectible.position)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Collided with end level")
		
		# Check if the player has collected all collectibles
		if player.collected_count == player.total_collectibles:
			if next_level_scene != "":
				print("All collectibles collected! Transitioning to next level.")
				get_tree().change_scene_to_file(next_level_scene)
				reset_input_actions()
			else:
				print("Error: next_level_scene is not set.")
		else:
			print("You need to collect all items to proceed!")

func reset_input_actions() -> void:
	# Release all active input actions to reset the control states
	Input.action_release("move_up")
	Input.action_release("move_down")
	Input.action_release("move_left")
	Input.action_release("move_right")
	Input.action_release("jump")
	Input.action_release("interact")
	Input.action_release("switch_tool")
	Input.action_release("action_tool")
	Input.action_release("debug_toggle_float")
