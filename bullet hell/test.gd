extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


onready var Player = $Player
export (int,1000,10000) var bullet_count = 1000
var cur_bullet = 0
func _ready():
	for bullet in bullet_count:
		var bul = Global.bullet_scene.instance()
		$bullet_set.add_child(bul)
		bul.hide()
		bul.set_physics_process(false)
func fire_bullet(rot,point,shooter=0):
	$bullet_set.get_child(cur_bullet).load_in(shooter,rot,point)
	cur_bullet+=1
	if cur_bullet >= bullet_count:cur_bullet = 0
