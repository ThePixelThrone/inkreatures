extends Node2D

const MAX_PLAYERS = 4
var num_players = 4 # TODO : pegar players,cores,monstros da tela de ready!
var colors = ["vermelho", "verde", "azul", "amarelo"]
var monsters = [2, 3, 5, 4]

func _ready():
	# Stage configuration
	# Player setup
	for i in range(num_players):
		var node_name = "player"+var2str(i+1)
		get_node(node_name).player = "p"+var2str(i+1)
		var tex = load("res://assets/images/m_0"+var2str(monsters[i])+"_"+colors[i]+".png")
		tex.set_flags(0)
		get_node(node_name+"/Sprite").set_texture(tex)
		get_node(node_name+"/Trail").set_color(colors[i])
		get_node(node_name+"/Ink").setup(colors[i])
		get_node(node_name).color = colors[i]
	
	# Remove unused players
	for i in range(num_players+1, MAX_PLAYERS+1):
		remove_child(get_node("player"+var2str(i)))