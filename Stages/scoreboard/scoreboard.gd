extends Node

var players
var not_playing = [1, 2, 3, 4]

onready var pos_y = [get_node("B1/Floor").get_global_position().y, get_node("B2/Floor").get_global_position().y, get_node("B3/Floor").get_global_position().y]
const floor_height = 240

func _ready():
	players = get_node("/root/global").player_list
	for player in players:
		not_playing.erase(player.number)
		var node_name = "player"+var2str(player.number)
		get_node(node_name).player = player.number
		get_node(node_name).controller = "null"
		var tex = load("res://assets/images/m_0"+var2str(player.monster)+"_"+player.color+".png")
		tex.set_flags(0)
		get_node(node_name+"/Sprite").set_texture(tex)
		get_node(node_name).set_color(player.color)
		get_node(node_name).connect("on_kill", self, "_on_player_kill")
		get_node(node_name).connect("on_death", self, "_on_player_death")
		get_node(node_name).position.y -= player.score * floor_height
		if player.score == 2:
			get_node(node_name).set_modulate(get_node("B3").get_modulate())
			get_node("B3/Spotlight"+var2str(player.number)).set_visible(true)
		elif player.score == 3:
			get_tree().change_scene("res://Stages/scoreboard/Winner.tscn")
			return
	# Remove unused players
	for p in not_playing:
		get_node("player"+var2str(p)).queue_free()
	yield(get_tree().create_timer(4), "timeout")
	get_node("/root/global").game_start()
