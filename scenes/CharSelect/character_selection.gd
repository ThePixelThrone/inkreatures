extends Node2D

const MAX_PLAYERS = 4

var player_joined = [false, false, false, false]
var player_ready = [false, false, false, false]

var ready_count = 0
var joined_count = 0

var everyone_ready = false
var gameRootNode

func game_start():
	for player in range(MAX_PLAYERS):
		if (player_ready[player]):
			var p = get_node("Tubes/Tube"+var2str(player+1))
			get_node("/root/global").add_player(player+1, p.colors[p.selected_color], p.selected_monster)
	get_node("/root/global").game_start()

func players_ready(all_ready):
	if (all_ready):
		get_node("StartText").show()
		everyone_ready = true
	else:
		get_node("StartText").hide()
		everyone_ready = false

func set_join(join, player):
	get_node("Tubes/Tube"+var2str(player+1)).join(join)
	if (join):
		joined_count += 1
		player_joined[player] = true
	else:
		joined_count -= 1
		player_joined[player] = false
	players_ready(ready_count == joined_count and ready_count > 0)

func set_ready(ready, player):
	get_node("Tubes/Tube"+var2str(player+1)).set_ready(ready)
	if (ready):
		ready_count += 1
		player_ready[player] = true
	else:
		ready_count -= 1
		player_ready[player] = false
	players_ready(ready_count == joined_count and ready_count > 0)

func _input(event):
	if (everyone_ready): # Check if anyone pressed start
		for p in range(MAX_PLAYERS):
			if (event.is_action_pressed("p"+var2str(p+1)+"_start")):
				game_start()
	
	for p in range(MAX_PLAYERS):
		var p_num = var2str(p+1) # Player number string
		var player_tube = get_node("Tubes/Tube"+p_num)
		if (player_joined[p] and not player_ready[p]):
			if (event.is_action_pressed("p"+p_num+"_up")):
				player_tube.next_mon()
			elif (event.is_action_pressed("p"+p_num+"_down")):
				player_tube.prev_mon()
			elif (event.is_action_pressed("p"+p_num+"_left")):
				player_tube.prev_color()
			elif (event.is_action_pressed("p"+p_num+"_right")):
				player_tube.next_color()
		
		if (event.is_action_pressed("p"+p_num+"_jump") || event.is_action_pressed("p"+p_num+"_start")):
			if (not player_ready[p]):
				if (not player_joined[p]):
					set_join(true, p)
				else:
					set_ready(true, p)
		elif (event.is_action_pressed("p"+p_num+"_cancel")):
			if (player_ready[p]):
				set_ready(false, p)
			elif (player_joined[p]):
				set_join(false, p)
	

func _ready():
	gameRootNode = get_node("/root/GameRootNode")
	var tubes = get_node("Tubes").get_children()
	var p_num = 1
	for tube in tubes:
		var tex = load("res://assets/gfx/p"+var2str(p_num)+".png")
		tube.get_node("PlayerLabel").set_texture(tex)
		p_num += 1
	set_process_input(true)