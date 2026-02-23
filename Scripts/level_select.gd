extends Control

func _ready():
	# Iterate through buttons in the GridContainer
	for button in $GridContainer.get_children():
		if button is Button:
			button.pressed.connect(func(): _on_level_button_pressed(button.name))

	# Connect Back Button
	if $BackButton:
		$BackButton.pressed.connect(_on_back_pressed)

func _on_level_button_pressed(level_name: String):
	# Change to the corresponding level
	var level_scene = "res://Scenes/Levels/" + level_name + ".tscn"
	if ResourceLoader.exists(level_scene):
		get_tree().change_scene_to_file(level_scene)
	else:
		print("Level scene not found: ", level_scene)

func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
