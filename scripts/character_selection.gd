extends Node2D

const MAX_PLAYERS = 4

var player_joined = [false, false, false, false]
var player_ready = [false, false, false, false]
var player_list = []

var ready_count = 0
var joined_count = 0

var everyone_ready = false

func game_start(): # TODO
	print("start")
	for player in player_list:
		var p = get_node("tube"+var2str(player))
		print("-----")
		print("Player: "+var2str(player))
		print("Monster: "+var2str(p.selected_monster))
		print("Color: "+p.colors[p.selected_color])

func all_players_ready(all_ready):
	if (all_ready):
		get_node("StartText").show()
		everyone_ready = true
	else:
		get_node("StartText").hide()
		everyone_ready = false

func set_join(join, player):
	get_node("tube"+var2str(player)).join(join)
	if (join):
		joined_count += 1
		player_joined[player] = true
	else:
		joined_count -= 1
		player_joined[player] = false
	all_players_ready(ready_count == joined_count)

func set_ready(ready, player):
	get_node("tube"+var2str(player)).set_ready(ready)
	if (ready):
		player_list.append(player)
		ready_count += 1
		player_ready[player] = true
	else:
		player_list.erase(player)
		ready_count -= 1
		player_ready[player] = false
	all_players_ready(ready_count == joined_count)

func _input(event):
	if (everyone_ready): # Check if anyone pressed start
		for p in player_list:
			if (event.is_action_pressed("p"+var2str(p+1)+"_start")):
				game_start()
	
	for p in range(MAX_PLAYERS):
		if (player_joined[p] and not player_ready[p]):
			if (event.is_action_pressed("p"+var2str(p+1)+"_up")):
				get_node("tube"+var2str(p)).next_mon()
			elif (event.is_action_pressed("p"+var2str(p+1)+"_down")):
				get_node("tube"+var2str(p)).prev_mon()
			elif (event.is_action_pressed("p"+var2str(p+1)+"_left")):
				get_node("tube"+var2str(p)).prev_color()
			elif (event.is_action_pressed("p"+var2str(p+1)+"_right")):
				get_node("tube"+var2str(p)).next_color()
		
		if (event.is_action_pressed("p"+var2str(p+1)+"_jump") || event.is_action_pressed("p"+var2str(p+1)+"_start")):
			if (not player_ready[p]):
				if (not player_joined[p]):
					set_join(true, p)
				else:
					set_ready(true, p)
		elif (event.is_action_pressed("p"+var2str(p+1)+"_cancel")):
			if (player_ready[p]):
				set_ready(false, p)
			elif (player_joined[p]):
				set_join(false, p)
	

func _ready():
	for i in range(MAX_PLAYERS):
		var tex = load("res://assets/gfx/p"+var2str(i+1)+".png")
		get_node("tube"+var2str(i)+"/PlayerLabel").set_texture(tex)
	set_process_input(true)