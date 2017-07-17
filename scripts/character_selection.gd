extends Node2D

const MAX_PLAYERS = 4

var player_joined = [false, false, false, false]
var player_ready = [false, false, false, false]

func _ready():
	for i in range(MAX_PLAYERS):
		var tex = load("res://assets/gfx/p"+var2str(i+1)+".png")
		get_node("tube"+var2str(i)+"/PlayerLabel").set_texture(tex)
	set_process_input(true)

func set_join(join, player):
	get_node("tube"+var2str(player)).join(join)
	if (join):
		player_joined[player] = true
	else:
		player_joined[player] = false

func set_ready(ready, player):
	get_node("tube"+var2str(player)).set_ready(ready)
	if (ready):
		player_ready[player] = true
	else:
		player_ready[player] = false

func _input(event):
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
		elif (event.is_action_pressed("p"+var2str(p+1)+"_powerup")):
			if (player_ready[p]):
				set_ready(false, p)
			elif (player_joined[p]):
				set_join(false, p)
	
