extends Particles2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var amarelo = Color(1, 0.78, 0, 1)
var azul = Color(0, 0.45, 1, 1)
var verde = Color(0, 0.87, 0.15, 1)
var vermelho = Color(1, 0, 0.19, 1)

func setup(color):
	if (color == "amarelo"):
		set_color(amarelo)
	elif (color == "azul"):
		set_color(azul)
	elif (color == "verde"):
		set_color(verde)
	elif (color == "vermelho"):
		set_color(vermelho)

func _ready():
	pass
