extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var health = 100
onready var target=get_parent().get_parent().get_node("Player")
var fire_point=Vector2.ZERO
var fire_rotation=Vector2.ZERO
var fire_angle = 30
export (int,1,20) var bullet_count = 3

export var fire_type = 0
export var spin_rate = 0.0
onready var fire_origin = get_parent().get_parent()
var movement = Vector2.ZERO
export (int,-256,256) var move_speed = 128
export (float) var fire_rate = 1.0
export (bool) var auto_spin = false
export (bool) var follow_player = false
export (float) var spin_speed = 1.0
export (bool) var two_emitters = false
var base_fire_rate = 1.0
var emitter = Global.emitter.new()
func _ready():
	base_fire_rate = fire_rate
	add_child(emitter)
	emitter.assemble(
		fire_type,
		bullet_count,
		spin_rate,
		1,
		fire_rate,
		get_parent().get_parent(),
		fire_angle
		)
func _process(delta):
	scale = Vector2(1,1)*lerp(1.0,0.825,pow(1-health/100,2))
	modulate = Color(1,1-min((1-scale.x)*5.714,1),1-min((1-scale.x)*5.714,1),1)
	if follow_player:
		emitter.fire_rotation = position.angle_to_point(target.position)+PI
	spin_rate += delta*PI/2*spin_speed
	if spin_rate >= PI*2:
		spin_rate = 0
	if auto_spin:
		
		emitter.spin_rate = spin_rate
	emitter.fire_point = position
	fire_rate -= delta
	if fire_rate <= 0:
		emitter.trigger()
		fire_rate = base_fire_rate
func hurt(val=1):
	health -= val
	if health <= 0:queue_free()
