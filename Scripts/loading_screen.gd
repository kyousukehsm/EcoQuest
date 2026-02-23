extends CanvasLayer

@export var delay_time: float = 2.0  # Delay in seconds before moving to the Main Menu

func _ready():
	await get_tree().create_timer(delay_time).timeout
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
