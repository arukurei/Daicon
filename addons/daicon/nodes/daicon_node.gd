@tool
@icon("res://addons/daicon/icons/daicon.svg")
class_name Daicon extends Node2D

@export var shader_trigger_nodes : Array[Node]
@export var shader_target_nodes : Array[Node]

func _ready() -> void:
	self.set_y_sort_enabled(true)
