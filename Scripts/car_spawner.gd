extends Node2D

@export var car_scene: PackedScene  # Drag and drop `Car.tscn` here
@export var spawn_interval: float = 20.0  # Time between spawns
@export var spawn_position: Vector2 = Vector2(0, 0)  # Spawn offset
@export var move_direction: Vector2 = Vector2.LEFT  # Car direction

@onready var spawn_timer: Timer = $Timer

func _ready() -> void:
	spawn_timer.wait_time = spawn_interval
	spawn_timer.one_shot = false
	spawn_timer.timeout.connect(_spawn_car)
	spawn_timer.start()  # Start spawning cars

	# Spawn the first car immediately
	_spawn_car()

func _spawn_car() -> void:
	var car = car_scene.instantiate() as Node2D
	car.global_position = global_position + spawn_position
	car.move_direction = move_direction
	get_parent().add_child(car)
