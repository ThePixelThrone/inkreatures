extends Particles2D

func change_color(color):
	get_color_ramp().set_color(0, color)
	get_color_ramp().set_color(1, Color(color.r, color.g, color.b, 0))

func _ready():
	pass
