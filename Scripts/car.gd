extends Node2D

@export var speed: float = 200.0  # Speed of the car
@export var damage: int = 20  # Damage dealt to the player
@export var move_direction: Vector2 = Vector2.LEFT  # Movement direction (default: left)
@export var spawn_position: Vector2 = Vector2(100, 0)  # Spawns 100 pixels to the right of the spawner
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var area: Area2D = $Area2D

func _ready() -> void:
	animated_sprite.play("Drive")  # Start car animation
	area.body_entered.connect(_on_body_entered)  # Connect collision signal

func _physics_process(delta: float) -> void:
	position += move_direction * speed * delta
	print("Car position:", position)

	if position.x < -1000 or position.x > 3000:
		queue_free()

func _on_body_entered(body: Node) -> void:
	# Check if the collided body is the player
	if body.is_in_group("Player"):
		body.apply_damage(damage)  # Call the player's damage function
		queue_free()  # Remove the car after collision
