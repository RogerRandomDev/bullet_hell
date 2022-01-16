extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var health = 100
onready var target=get_parent().get_parent().get_node("Player")
var fire_point=Vector2.ZERO
var fire_rotation=Vector2.ZERO
var fire_angle = 30
var start_point = Vector2.ZERO
export (int,1,20) var bullet_count = 3
export var fire_type = 0
export var spin_rate = 0.0
var motion_rate = 0.0
onready var fire_origin = get_parent().get_parent()
var movement = Vector2.ZERO
export (int,-256,256) var move_speed = 128
export (float) var fire_rate = 1.0
export (bool) var auto_spin = false
export (bool) var follow_player = false
export (float) var spin_speed = 1.0
export (int) var bullet_speed = 512.0
var base_fire_rate = 1.0
var emitter = Global.emitter.new()
export (bool) var move = false
export (String,"Circle","test1") var move_mode = "test"
export (float) var motion_speed = 1.0
export (Vector2) var motion_scale
export (int) var move_min = 16
export (int) var move_max = 368
const time_to_get_hurt = 1.0
var cur_time_self = 0.0
func _ready():
	start_point = position
	base_fire_rate = fire_rate
	add_child(emitter)
	emitter.assemble(
		fire_type,
		bullet_count,
		spin_rate,
		1,
		fire_rate,
		get_parent().get_parent(),
		fire_angle,
		bullet_speed
		)
func _process(delta):
	scale = Vector2(1,1)*lerp(1.0,0.825,max(1-pow(health/95,2),0))
	modulate = Color(1,1-min((1-scale.x)*5.714,1),1-min((1-scale.x)*5.714,1),1)
	if move:
		position = call(move_mode)
	if follow_player:
		emitter.fire_rotation = position.angle_to_point(target.position)+PI
	spin_rate += delta*PI/2*spin_speed
	motion_rate += delta*PI*motion_speed
	if spin_rate >= PI*2:
		spin_rate = 0
	if motion_rate >= PI*2:
		motion_rate -= PI*2
	cur_time_self += delta
	if cur_time_self >= time_to_get_hurt:
		cur_time_self = 0
		hurt(1)
	if auto_spin:
		
		emitter.spin_rate = spin_rate
	emitter.fire_point = position
	fire_rate -= delta
	if fire_rate <= 0:
		emitter.trigger()
		fire_rate = base_fire_rate
func hurt(val=1):
	if !is_processing():return
	health -= val
	get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().update_score(val)
	if health <= 0:
		get_parent().get_parent().remove_enemy()
		get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().update_score(100)
		queue_free()
func fly_into(position_to_go):
	set_process(false)
	var tween = Tween.new()
	tween.interpolate_property(self,"position",Vector2(192,-150),position_to_go,1.5,Tween.TRANS_ELASTIC)
	tween.connect("tween_all_completed",self,"finish_flight",[tween])
	add_child(tween)
	tween.start()
func finish_flight(tween):
	tween.disconnect("tween_all_completed",self,"finish_flight")
	tween.queue_free()
	set_process(true)
func Circle():
	return Vector2(cos(motion_rate),sin(motion_rate))*motion_scale+start_point
