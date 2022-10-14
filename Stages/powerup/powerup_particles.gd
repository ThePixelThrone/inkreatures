extends Particles2D

func change_color(color):
	var gradient = get_process_material().get_color_ramp().get_gradient()
	gradient.set_color(0, color)
	gradient.set_color(1, Color(color.r, color.g, color.b, 0))
	
func _ready():
	pass
