extends CanvasLayer

@onready var resume_button: Button = $Control/ResumeButton
@onready var restart_button: Button = $Control/RestartButton
@onready var quit_button: Button = $Control/QuitButton

signal resume_game
signal restart_game
signal quit_game

func _ready() -> void:
	if resume_button:
		resume_button.pressed.connect(_on_resume_button_pressed)
	if restart_button:
		restart_button.pressed.connect(_on_restart_button_pressed)
	if quit_button:
		quit_button.pressed.connect(_on_quit_button_pressed)
		
func _on_resume_button_pressed() -> void:
	emit_signal("resume_game")

func _on_restart_button_pressed() -> void:
	emit_signal("restart_game")

func _on_quit_button_pressed() -> void:
	emit_signal("quit_game")
