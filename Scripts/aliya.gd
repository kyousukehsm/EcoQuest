extends Node2D
class_name Aliya

var dialogue: Array = []
var has_vanished = false
@onready var notification = $Notification
@onready var animation_player = $AnimationPlayer
@onready var interact_area = $Area2D
@onready var dialogue_box = get_node("/root/Level1/DialogueBox")

func _ready():
	notification.visible = false
	# Verify animation exists
	if animation_player and !animation_player.has_animation("vanish"):
		push_warning("Missing 'vanish' animation!")

func _on_area_2d_body_entered(body):
	if body.name == "Player" and not has_vanished:
		notification.visible = true

func _on_area_2d_body_exited(_body):
	notification.visible = false

func _process(_delta):
	if Input.is_action_just_pressed("interact") and notification.visible and not has_vanished:
		start_dialogue()

func set_dialogue(new_dialogue: Array) -> void:
	dialogue = new_dialogue

func start_dialogue():
	if !is_instance_valid(dialogue_box):
		push_error("DialogueBox invalid")
		return
	
	notification.visible = false
	
	# Disconnect first to prevent duplicate connections
	if dialogue_box.dialogue_ended.is_connected(_on_dialogue_ended):
		dialogue_box.dialogue_ended.disconnect(_on_dialogue_ended)
	
	# Reconnect with one-shot
	dialogue_box.start_dialogue(dialogue)
	dialogue_box.dialogue_ended.connect(_on_dialogue_ended, CONNECT_ONE_SHOT)

func _on_dialogue_ended():
	if !has_vanished:  # Only vanish once
		vanish()

func vanish():
	if animation_player:
		if animation_player.has_animation("vanish"):
			animation_player.play("vanish")
		else:
			push_error("Missing 'vanish' animation!")
	
	has_vanished = true
	notification.visible = false
	
	if interact_area:
		interact_area.set_monitorable(false)
		interact_area.set_deferred("monitoring", false)
