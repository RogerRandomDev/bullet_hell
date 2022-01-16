extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var fire_point=Vector2.ZERO
var fire_rotation=Vector2.ZERO
var fire_angle = 30
export (int,1,30) var bullet_count = 3
export (float) var spin_speed = 1.0
export var fire_type = 0
export var spin_rate = 0.0
onready var fire_origin = get_parent()
var movement = Vector2.ZERO
export (int,-256,256) var move_speed = 128
export (float) var fire_rate = 1.0
export (bool) var auto_spin = false
var base_fire_rate = 1.0
var emitter = Global.emitter.new()
func _ready():
	base_fire_rate = fire_rate
	add_child(emitter)
	emitter.assemble(
		fire_type,
		bullet_count,
		spin_rate,
		0,
		fire_rate,
		get_parent(),
		fire_angle
		)
func _process(delta):
# warning-ignore:return_value_discarded
	move_and_collide(movement*move_speed*delta)
	position.x = clamp(position.x,16,368)
	position.y = clamp(position.y,75,525)
	emitter.fire_rotation = position.angle_to_point(get_parent().get_parent().get_parent().get_global_mouse_position()-Vector2(128,0))+PI
	emitter.fire_point = position
	spin_rate += delta*PI/2*spin_speed
	if spin_rate>=2*PI:spin_rate=0
	emitter.spin_rate = spin_rate
	if auto_spin:
		emitter.fire_rotation += spin_rate
	fire_rate -= delta
	if Input.is_mouse_button_pressed(1) && fire_rate <= 0:
		emitter.trigger()
		fire_rate = base_fire_rate
func _input(event):
	if Input.is_mouse_button_pressed(1) && fire_rate <= 0:
		emitter.trigger()
		fire_rate = base_fire_rate
	if !event is InputEventKey:return
	movement = Vector2(
		int(Input.is_action_pressed("right"))-int(Input.is_action_pressed("left")),
		int(Input.is_action_pressed("down"))-int(Input.is_action_pressed("up"))*0.5
	)
	$Tween.interpolate_method($Sprite,'fly_in_direction',$Sprite.material.get_shader_param('mouse_position'),movement*Vector2(64,16),0.375,Tween.TRANS_LINEAR)
	$Tween.start()
