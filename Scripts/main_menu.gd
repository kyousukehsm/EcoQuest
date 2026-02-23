extends Control

# Ensure BackgroundMusic is resumed when entering the main menu
func _ready():
	if $StartGameButton:
		$StartGameButton.pressed.connect(_on_start_game_button_pressed)
	if $ExitButton:
		$ExitButton.pressed.connect(_on_exit_button_pressed)
	if $SettingsButton:
		$SettingsButton.pressed.connect(_on_settings_button_pressed)
	
	# Ensure the music is resumed when the scene is ready
	BackgroundMusic.resume_music()
	print("Resuming music in the main menu.")

func _on_start_game_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/LevelSelect.tscn")

func _on_exit_button_pressed():
	get_tree().quit()

func _on_settings_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Settings.tscn")
