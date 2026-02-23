extends Area2D

@onready var notification_label: Label = $NotificationLabel

@export var notification_text: String = "Default sign text"  
@export var display_time: float = 10.0 

var notification_timer: Timer = Timer.new()

func _ready() -> void:
	add_child(notification_timer)
	notification_timer.one_shot = true
	notification_timer.timeout.connect(hide_notification)

	# Clear label at the start
	notification_label.text = ""  
	notification_label.visible = false  # Hide the label initially

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		show_notification()

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("Player"):  
		hide_notification()

func show_notification() -> void:
	notification_label.text = notification_text  
	notification_label.visible = true
	notification_timer.start(display_time)

func hide_notification() -> void:
	notification_label.visible = false
	notification_label.text = ""
