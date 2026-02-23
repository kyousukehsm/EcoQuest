extends Control

# Volume slider and mute checkbox
@onready var volume_slider: HSlider = $TextureRect/VolumeSlider
@onready var mute_checkbox: CheckBox = $TextureRect/MuteCheckbox
@onready var menu: Button = $TextureRect/Menu

func _ready():
	# Set slider to full volume initially
	volume_slider.value = volume_slider.max_value  # Default max value is 1.0 (0 dB)
	
	# Connect the signals
	mute_checkbox.toggled.connect(_on_mute_checkbox_toggled)
	volume_slider.value_changed.connect(_on_volume_slider_changed)
	
	# Set the initial volume
	_update_music_volume()

# Called when the volume slider value changes
func _on_volume_slider_changed(value: float) -> void:
	# Update the music volume dynamically
	_update_music_volume()

# Called when the mute checkbox is toggled
func _on_mute_checkbox_toggled(pressed: bool) -> void:
	if pressed:
		# Mute the music by setting volume to -80 dB
		BackgroundMusic.set_volume(-80)
	else:
		# Restore volume based on slider value
		_update_music_volume()

# Updates the background music volume
func _update_music_volume() -> void:
	# Check if music is not muted
	if not mute_checkbox.pressed:
		# Convert slider value (0.0 to 1.0) to decibels (linear to log scale)
		var volume = max(volume_slider.value, 0.01)  # Prevent log(0)
		var volume_db = 20 * (log(volume) / log(10))  # Convert to dB
		BackgroundMusic.set_volume(volume_db)
		print("Slider Value:", volume_slider.value)
		print("Mute Checkbox Pressed:", mute_checkbox.pressed)
		print("Volume (dB):", 20 * (log(max(volume_slider.value, 0.01)) / log(10)))

func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
