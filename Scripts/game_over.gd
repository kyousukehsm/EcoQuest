extends CanvasLayer

@onready var restart_button: Button = $Control/RestartButton
@onready var quit_button: Button = $Control/QuitButton

signal restart_game
signal quit_game

func _ready() -> void:
	if restart_button:
		restart_button.pressed.connect(_on_restart_button_pressed)
	if quit_button:
		quit_button.pressed.connect(_on_quit_button_pressed)

func _on_restart_button_pressed() -> void:
	emit_signal("restart_game")

func _on_quit_button_pressed() -> void:
	emit_signal("quit_game")
