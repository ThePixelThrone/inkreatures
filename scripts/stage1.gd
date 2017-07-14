extends Node2D

const MAX_PLAYERS = 4
var num_players = 2 # TODO : pegar players,cores,monstros da tela de ready!
var colors = ["vermelho", "verde"]
var monsters = [2, 3]

func _ready():
	# Stage configuration
	# Player setup
	for i in range(num_players):
		var node = "player"+var2str(i+1)
		get_node(node).player = "p"+var2str(i+1)
		var tex = load("res://assets/images/m_0"+var2str(monsters[i])+"_"+colors[i]+".png")
		tex.set_flags(0)
		get_node(node+"/Sprite").set_texture(tex)
	
	# Remove unused players
	for i in range(num_players+1, MAX_PLAYERS+1):
		remove_child(get_node("player"+var2str(i)))