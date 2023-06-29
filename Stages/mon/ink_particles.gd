extends Particles2D

func setup(color):
	get_process_material().set_color(color)

func _ready():
	# Not sure if this is the best approach, make a copy to avoid changing everyone
	var mat = get_process_material().duplicate(true)
	set_process_material(mat)
