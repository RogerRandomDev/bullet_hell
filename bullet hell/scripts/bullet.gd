extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var query = Physics2DShapeQueryParameters.new()
var distance_travelled = 0.0
const max_dist = 1024.0
var speed:float = 512.0
var travel_angle = Vector2.ONE
var who_fired = 0
const bullet_damage = 1.0
func _ready():
	query.set_shape(Global.bullet_shape)
	query.collide_with_bodies=true
	travel_angle = Vector2(1,0).rotated(rotation)
func load_in(firer=0,rot=0,point=Vector2.ZERO,spd=512):
#	who_fired = firer
	speed=spd
	query.collision_layer = firer+1
	position = point;rotation = rot
	travel_angle = Vector2(1,0).rotated(rotation)
	distance_travelled = 0.0
	show()
	modulate = Color(1,int(firer==0),int(firer==0),1)
	scale = Vector2(int(firer!=0)+1,int(firer!=0)+1)
		
	show_on_top=true
	set_physics_process(true)
func _physics_process(delta:float) -> void:
	var movement := speed*delta
	distance_travelled+=movement
	position+=movement*travel_angle
	query.transform = global_transform
	var result :=get_world_2d().direct_space_state.intersect_shape(query,1)
	if distance_travelled > max_dist||result:
		if result.size()>0:
			var hit = result[0]["collider"]
			if hit.has_method("hurt"):hit.hurt(bullet_damage)
		hide()
		set_physics_process(false)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
