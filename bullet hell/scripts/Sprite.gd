extends Sprite


func _ready():
	material.set_shader_param("width", get_texture().get_width())
	material.set_shader_param("height", get_texture().get_height())
func fly_in_direction(dir):
	material.set_shader_param("mouse_position",dir)
