extends Particles2D

var amarelo = Color(1, 0.78, 0, 1)
var azul = Color(0, 0.45, 1, 1)
var verde = Color(0, 0.87, 0.15, 1)
var vermelho = Color(1, 0, 0.19, 1)

func setup(color):
	# TODO: How to set material color in 3.5?
	# self.material.color = amarelo
	if (color == "amarelo"):
		get_process_material().set_color(amarelo)
	elif (color == "azul"):
		get_process_material().set_color(azul)
	elif (color == "verde"):
		get_process_material().set_color(verde)
	elif (color == "vermelho"):
		get_process_material().set_color(vermelho)

func _ready():
	pass
