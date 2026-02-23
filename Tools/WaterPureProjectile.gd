extends RigidBody2D

@export var velocity: Vector2 = Vector2.ZERO
@export var lifetime: float = 1.0

func _ready() -> void:
	print("[WaterPureProjectile] Collision layers:", collision_layer)
	print("[WaterPureProjectile] Collision masks:", collision_mask)
	print("[PollutedWater] Collision layers:", collision_layer)
	print("[PollutedWater] Collision masks:", collision_mask)

	print("[WaterPureProjectile] Initialized with velocity:", velocity)
	linear_velocity = velocity

	var timer := Timer.new()
	timer.wait_time = lifetime
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "_on_lifetime_timeout"))
	add_child(timer)
	timer.start()
	print("[WaterPureProjectile] Lifetime timer started for:", lifetime, "seconds")

func _on_lifetime_timeout() -> void:
	print("[WaterPureProjectile] Lifetime expired, removing projectile")
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("PollutedWater"):
		print("[WaterPureProjectile] Hit detected! Cleaning water.")
		body.clean_water()
		queue_free()  # Immediately remove the projectile
