extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (String)var scene_name="test"
# Called when the node enters the scene tree for the first time.
func _ready():
	var n_scene = load("res://test.tscn").instance()
	$HBoxContainer/g/Viewport.add_child(n_scene)
