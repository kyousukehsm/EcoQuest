# Tool.gd (base class)
extends Node2D
class_name Tool

@export var tool_name: String = "Default Tool"
@export var icon_texture: Texture2D

func get_tool_name() -> String:
	return tool_name

func get_icon_texture() -> Texture2D:
	return icon_texture
