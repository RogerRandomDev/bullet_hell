extends Node


class emitter extends Node2D:
	var fire_angle = 0.0
	var spin_rate = 1.0
	var bullet_count = 1.0
	var type = 0
	var owned = 0
	var fire_rate = 1.0
	var fire_origin
	func assemble(type_of=0,bullets=1,rot_speed_new=1.0,owned_by=0,n_fire_rate=1.0,origin=null,fire_angle_n=0.0):
		fire_origin = origin
		owned = owned_by
		type = type_of
		fire_angle = fire_angle_n
		spin_rate = rot_speed_new
		bullet_count = bullets
		fire_rate = n_fire_rate
	
	
	
	
	var fire_rotation = 0.0
	var fire_point = Vector2.ZERO
	
	func trigger():
		call(Global.fire_forms.keys()[type])
	func Line():
		fire_origin.fire_bullet(fire_rotation,fire_point,owned)
	func Triple():
		for x in bullet_count:
			fire_origin.fire_bullet(
				fire_rotation+deg2rad(fire_angle/2-(fire_angle/bullet_count)*x),
				fire_point,
				owned
			)
	func Cross():
		for x in bullet_count:
			fire_origin.fire_bullet(
				(PI/bullet_count)*2*x+spin_rate,
				fire_point,
				owned
			)
	func CrossDouble():
		var range_for_use = (60/(bullet_count/2))
		for x in bullet_count:
			fire_origin.fire_bullet(
				(PI/bullet_count)*2*x+spin_rate+deg2rad(int(x%2==0)*range_for_use),
				fire_point,
				owned
			)
