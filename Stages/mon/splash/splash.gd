extends CanvasLayer

var amarelo = Color(1, 0.78, 0, 1)
var azul = Color(0, 0.45, 1, 1)
var verde = Color(0, 0.87, 0.15, 1)
var vermelho = Color(1, 0, 0.19, 1)

func setup(color):
	if (color == "amarelo"):
		get_node("Node2D/Splash").set_color(amarelo)
	elif (color == "azul"):
		get_node("Node2D/Splash").set_color(azul)
	elif (color == "verde"):
		get_node("Node2D/Splash").set_color(verde)
	elif (color == "vermelho"):
		get_node("Node2D/Splash").set_color(vermelho)

func set_position(pos):
	get_node("Node2D").position = pos

func _ready():
	# Render on top of other ink splatters
	layer = get_parent().get_child_count() * -1
	# Randomize texture
	var i = randi()%3+1
	var tex = load("res://assets/images/splash"+var2str(i)+".png")
	tex.set_flags(0)
	get_node("Node2D/Splash").set_texture(tex)
	get_node("Node2D/AnimationPlayer").play("Spread")
