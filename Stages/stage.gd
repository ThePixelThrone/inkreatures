extends Node2D

var players
var not_playing = [1, 2, 3, 4] # Initially no one is playing

var players_alive
var round_finished = false

func _on_player_kill(player):
	get_node("/root/global").increase_kill_count(player)

func _on_player_death(player):
	var player_nodes = get_tree().get_nodes_in_group("players")
	var winner = null
	var alive_count = 0
	for n in player_nodes:
		if n.isAlive or n.stocks > 0:
			alive_count += 1
			winner = n
	if alive_count == 1:
		round_finish(winner.player)
	elif alive_count == 0:
		round_finish(player)

func queue_respawn(mon):
	if mon.stocks > 0:
		mon.stocks -= 1
		remove_child(mon)
		yield(get_tree().create_timer(1.5), "timeout")
		mon.isAlive = true
		mon.set_position(mon.spawn_point)
		add_child(mon)
		# For some weird reason, after playing bombermon animation _ready isn't called
		# Call it manually
		mon._ready()
		mon.set_physics_process(true)
		mon.get_node("PowerupEffects/Ghost").effect(mon)
	else:
		mon.queue_free()

func round_finish(winner):
	if round_finished:
		return
	round_finished = true
	get_node("/root/global").increase_player_score(winner)
	Engine.time_scale = 0.6
	yield(get_tree().create_timer(2), "timeout")
	Engine.time_scale = 1
	get_tree().change_scene("res://Stages/scoreboard/Scoreboard.tscn")

func _ready():
	# Stage configuration
	# Player setup
	players = get_node("/root/global").player_list
	for player in players:
		not_playing.erase(player.number)
		var node_name = "player"+var2str(player.number)
		get_node(node_name).player = player.number
		get_node(node_name).controller = player.controller_device
		get_node(node_name).spawn_point = get_node(node_name).get_position()
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
