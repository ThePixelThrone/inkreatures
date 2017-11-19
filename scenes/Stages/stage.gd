extends Node2D

var players
var not_playing = [1, 2, 3, 4] # Initially no one is playing

var score = [0, 0, 0, 0]
var players_alive
var rounds = 3 # Not being used at the moment
var gameRootNode

func _on_player_kill(player):
	score[player-1] += 1
	print(score[player-1])

func _on_player_death(player):
	players_alive -= 1
	if (players_alive == 1):
		OS.set_time_scale(0.6)
		round_finish()

func round_finish(): # Not implemented yet
	pass

func _ready():
	gameRootNode = get_node("/root/GameRootNode")
	# Stage configuration
	# Player setup
	players = get_node("/root/global").player_list
	for player in players:
		not_playing.erase(player.number)
		var node_name = "player"+var2str(player.number)
		get_node(node_name).player = player.number
		var tex = load("res://assets/images/m_0"+var2str(player.monster)+"_"+player.color+".png")
		tex.set_flags(0)
		get_node(node_name+"/Sprite").set_texture(tex)
		get_node(node_name).set_color(player.color)
		get_node(node_name).connect("on_kill", self, "_on_player_kill")
		get_node(node_name).connect("on_death", self, "_on_player_death")
	
	players_alive = players.size()
	
	# Remove unused players
	for p in not_playing:
		get_node("player"+var2str(p)).queue_free()