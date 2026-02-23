extends CanvasLayer

signal dialogue_ended  # Declare the signal

@onready var panel = $Panel
@onready var dialogue_label: Label = $Panel/Label
@onready var next_indicator: Control = $Panel/NextIndicator

var is_active = false
var dialogue_lines = []  # Store the dialogue lines here
var current_line = 0  # Tracks the current line of dialogue

func _ready() -> void:
	var font = dialogue_label.get_theme_font("font")
	dialogue_label.add_theme_font_size_override("font_size", 50)  # Adjust size as needed
	print("DialogueBox is ready. Panel:", panel)
	panel.visible = false  # Hide the dialogue box initially
	next_indicator.visible = false
	print("Panel node:", panel)
	print("DialogueLabel node:", dialogue_label)
	print("NextIndicator node:", next_indicator)
	
	if not panel or not dialogue_label or not next_indicator:
		print("Error: DialogueBox or Panel is not properly initialized.")
		return

func _unhandled_input(event: InputEvent) -> void:
	if is_active and event.is_action_pressed("interact"):
		show_next_line()
		get_viewport().set_input_as_handled()  # Prevent other nodes from receiving input

func start_dialogue(dialogue: Array):
	print("Starting dialogue with lines:", dialogue)
	print("Panel visibility before start:", panel.visible)
	print("DialogueLabel text before start:", dialogue_label.text)
	if not panel or not dialogue_label or not next_indicator:
		print("Error: DialogueBox nodes are not accessible.")
		return

	dialogue_lines = dialogue
	current_line = 0

	if dialogue_lines.size() > 0:
		is_active = true
		panel.visible = true
		show_next_line()
	else:
		end_dialogue()

func show_next_line() -> void:
	if current_line < dialogue_lines.size():
		dialogue_label.text = dialogue_lines[current_line]
		current_line += 1
		next_indicator.visible = (current_line < dialogue_lines.size())
		print("Next indicator visible: ", next_indicator.visible)  # Debug
	else:
		end_dialogue()

func end_dialogue() -> void:
	is_active = false
	panel.visible = false
	emit_signal("dialogue_ended")  # Emit the signal when the dialogue ends
