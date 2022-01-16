extends Node


class spawner extends Node:
	var enemy_bullets = 10
	var enemy_shoots = 2
	var enemy_count = 1
	var spawn_delay = 10.0
	var current_enemy_count = 1
	var time_left = 5.0
	var wait_time = 0.0
	var added_enemy = false
	func _ready():
		randomize()
	func assemble(bullet_count=10,shoot_types=2,enemy_count_new=1,n_spawn_delay=10.0) -> void:
		enemy_bullets = bullet_count
		enemy_shoots = shoot_types
		enemy_count = enemy_count_new
		spawn_delay = n_spawn_delay
		wait_time = spawn_delay
		time_left = 1.0
	func _physics_process(delta):
		time_left -= delta
		if time_left <= 0:
			time_left = wait_time
			if added_enemy:
				added_enemy = false
			else:
				added_enemy = true
				on_timeout()
				
	func on_timeout():
		if current_enemy_count < enemy_count:
			current_enemy_count += 1
			var enemy = new_enemy()
			get_parent().get_node("enemies").add_child(enemy)
			enemy.fly_into(random_position_for_enemy())
	func new_enemy():
		var e = load("res://scenes/enemy.tscn").instance()
		e.fire_rate = 0.125
		e.fire_type = 3
		e.bullet_count = 8
		e.spin_speed = 1.25
		e.auto_spin = true
		return e
	func remove_enemy():
		current_enemy_count -= 1
		time_left -= min(max(time_left-spawn_delay*((current_enemy_count/enemy_count)),0),0.5)
	func random_position_for_enemy():
		return Vector2(
			round(rand_range(48,336)),
			round(rand_range(25,250))
			
		)
