extends Node

var UI := preload("res://UI.tscn")
var HUD = UI.instantiate()

func _ready() -> void:
	get_tree().current_scene.add_child(HUD)
