extends CanvasLayer

@onready var dpad = $DPAD
@onready var action = $Action
@onready var button_up = $"DPAD/GridContainer/Button Up"
@onready var button_left = $"DPAD/GridContainer/Button Left"
@onready var button_right = $"DPAD/GridContainer/Button Right"
@onready var button_down = $"DPAD/GridContainer/Button Down"
@onready var button_interact = $"Action/HBoxContainer/Button Interact"
@onready var button_jump = $"Action/HBoxContainer/Button Jump"
@onready var button_switch = $"Action/HBoxContainer/Button Switch"
@onready var button_action = $"Action/HBoxContainer/Button Action"
@onready var debug = $"DPAD/GridContainer/debug"

var debug_toggled = false  # Track the debug toggle state

func _ready() -> void:
	if not DisplayServer.is_touchscreen_available():
		hide()
	else:
		show()

# D-pad button signals
func _on_button_up_pressed() -> void:
	Input.action_press("move_up")

func _on_button_up_released() -> void:
	Input.action_release("move_up")

func _on_button_down_pressed() -> void:
	Input.action_press("move_down")

func _on_button_down_released() -> void:
	Input.action_release("move_down")

func _on_button_left_pressed() -> void:
	Input.action_press("move_left")

func _on_button_left_released() -> void:
	Input.action_release("move_left")

func _on_button_right_pressed() -> void:
	Input.action_press("move_right")

func _on_button_right_released() -> void:
	Input.action_release("move_right")

# Action button signals
func _on_button_jump_pressed() -> void:
	Input.action_press("jump")

func _on_button_jump_released() -> void:
	Input.action_release("jump")

func _on_button_interact_pressed() -> void:
	Input.action_press("interact")

func _on_button_interact_released() -> void:
	Input.action_release("interact")

func _on_button_switch_pressed():
	Input.action_press("switch_tool")

func _on_button_switch_released():
	Input.action_release("switch_tool")

func _on_button_action_pressed():
	Input.action_press("action_tool")

func _on_button_action_released():
	Input.action_release("action_tool")

# Toggle the debug action on button press
func _on_debug_pressed():
	debug_toggled = !debug_toggled  # Toggle the state
	if debug_toggled:
		Input.action_press("debug_toggle_float")  # Activate the action
	else:
		Input.action_release("debug_toggle_float")  # Deactivate the action
