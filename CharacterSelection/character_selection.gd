extends Node2D

const MAX_PLAYERS = 4

class ConnectedPlayerInfo:
	func _init(connected_device, joined_tube):
		device = connected_device
		tube = joined_tube
	var ready = false
	var device = null
	var tube = null

var connected_players = [null, null, null, null]

func find_player_by_device(device):
	for pinfo in connected_players:
		if (pinfo and pinfo.device == device):
			return pinfo
	return null

func game_start():
	for index in range(connected_players.size()):
		var pinfo = connected_players[index]
		if (pinfo and pinfo.ready):
			get_node("/root/global").add_player(index, pinfo.tube.get_selected_color(), pinfo.tube.selected_monster, pinfo.device)
	get_node("/root/global").game_start()

func all_players_ready():
	for pinfo in connected_players:
		if (pinfo and not pinfo.ready):
			return false
	return true

func update_players_ready():
	if (all_players_ready()):
		get_node("StartText").show()
	else:
		get_node("StartText").hide()

func set_join(join, device, selected_mon, selected_color):
	if (join):
		for i in range(connected_players.size()):
			if (not connected_players[i]):
				var tube = get_node("Tubes/Tube"+var2str(i+1))
				connected_players[i] = ConnectedPlayerInfo.new(device, tube)
				tube.join(join, selected_mon, selected_color)
				break
	else:
		for i in range(connected_players.size()):
			var pinfo = connected_players[i]
			if (pinfo and pinfo.device == device):
				get_node("Tubes/Tube"+var2str(i+1)).join(join, null, null)
				connected_players[i] = null
	update_players_ready()

func set_ready(ready, pinfo):
	pinfo.ready = ready
	pinfo.tube.set_ready(ready)
	update_players_ready()

func _input(event):
	var devices = get_node("/root/global").devices
	for pinfo in connected_players:
		if (pinfo and event.is_action_pressed(pinfo.device+"_start") and all_players_ready()):
			game_start()

	for pinfo in connected_players:
		if (not pinfo):
			continue
		var device = pinfo.device
		if (not pinfo.ready):
			if (event.is_action_pressed(device+"_up")):
				pinfo.tube.next_mon()
			elif (event.is_action_pressed(device+"_down")):
				pinfo.tube.prev_mon()
			elif (event.is_action_pressed(device+"_left")):
				pinfo.tube.prev_color()
			elif (event.is_action_pressed(device+"_right")):
				pinfo.tube.next_color()
	
	for device in devices:
		if (event.is_action_pressed(device+"_jump") || event.is_action_pressed(device+"_start")):
			var pinfo = find_player_by_device(device)
			if (not pinfo):
				set_join(true, device, null, null)
			elif (not pinfo.ready):
				set_ready(true, pinfo)
		elif (event.is_action_pressed(device+"_cancel")):
			var pinfo = find_player_by_device(device)
			if (pinfo):
				if (pinfo.ready):
					set_ready(false, pinfo)
				else:
					set_join(false, device, null, null)

func _ready():
	var tubes = get_node("Tubes").get_children()
	var p_num = 1
	for tube in tubes:
		var tex = load("res://assets/gfx/p"+var2str(p_num)+".png")
		tube.get_node("PlayerLabel").texture = tex
		p_num += 1
	var players = get_node("/root/global").player_list
	var colors = get_node("/root/global").colors
	for p in players:
		set_join(true, p.controller_device, p.monster, colors.find(p.color))
	set_process_input(true)
