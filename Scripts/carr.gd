extends RigidBody2D  # Use RigidBody2D for physics and gravity

@export var speed: float = 200.0  # Speed of the car
@export var damage: int = 20  # Damage to the player
@export var move_direction: Vector2 = Vector2.RIGHT  # Default movement direction (right)
@export var bounce_rotation: float = 15.0  # Rotation angle when the car bumps into an obstacle

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var area: Area2D = $Area2D

func _ready() -> void:
	# Play the car's driving animation
	animated_sprite.play("Drive")
	
	# Set the initial velocity (move in a straight line)
	linear_velocity = move_direction * speed
	
	# Connect the collision signal for the car's area
	area.body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	# Continuously apply the velocity (keep the car moving)
	linear_velocity = move_direction * speed
	# The RigidBody2D will automatically handle the physics and collision detection
	# No need for move_and_slide()

# Method to handle when the car collides with something
func _on_body_entered(body: Node) -> void:
	# If the player collides with the car
	if body.is_in_group("Player"):
		body.apply_damage(damage)  # Apply damage to the player
		queue_free()  # Remove the car after colliding with the player

	# If the car collides with something other than the player, rotate and flip direction
	elif not body.is_in_group("Player"):
		rotate_car_on_bump()

# Method to make the car rotate and flip direction when it bumps into an obstacle
func rotate_car_on_bump() -> void:
	# Apply a small horizontal rotation when the car hits something (other than the player)
	rotation_degrees += bounce_rotation  # Rotate car clockwise

	# Flip the direction (reverse the movement direction)
	move_direction = -move_direction  # Reverse the horizontal direction
