extends Node

enum fire_forms{Line,Triple,Cross,CrossDouble}
var bullet_shape = RectangleShape2D.new()
const bullet_scene = preload("res://scenes/bullet.tscn")
const emitter = preload("res://scripts/emitter.gd").emitter
func _ready():
	bullet_shape.extents = Vector2(3,4)
