extends Particles2D

func set_color(color):
	var tex = load("res://assets/images/rastro_"+color+".png")
	tex.set_flags(0)
	set_texture(tex)

func _ready():
	pass