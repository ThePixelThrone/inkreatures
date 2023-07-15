extends Node

const MAX_PLAYERS = 4
const TOTAL_MONSTERS = 5 # Number  of monster types
const powerup_effects_dir = "res://Stages/mon/powerup_effects/"

# Color strings used by assets
const colors = ["azul", "vermelho", "verde", "amarelo"]

enum game_modes {SURVIVAL, PIXEL_THRONE, VIRUS, CO_OP}

enum powerup_types {FREEZE, UNICORN, SPIKES, ROCKETS, GHOST, NET, BOMBERMON, DASH, PEPPER, VIALS}

# Hardcoded for now, will be mapped later
var devices = ["keyboard", "dev0", "dev1", "dev2", "dev3"]

var player_list = []
var selected_stage = 2
var game_mode = game_modes.SURVIVAL

class Player:
	var number
	var color
	var monster
	var controller_device
	var kills = 0
	var score = 0
	var win_count = 0

func _ready():
	pass

# Called when a player joins the game in the character selection screen
func add_player(index, color, mon, device):
	var player
	if index > player_list.size()-1:
		player = Player.new()
		player_list.append(player)
	else:
		player = player_list[index]
	player.number = index+1
	player.color = color
	player.monster = mon
	player.controller_device = device

func game_start():
	get_tree().change_scene("res://Stages/Stage"+var2str(selected_stage)+".tscn")
	selected_stage = 1 + randi() % 2

func increase_kill_count(pnum):
	for p in player_list:
		if p.number == pnum:
			p.kills = p.kills + 1

func increase_player_score(pnum):
	for p in player_list:
		if p.number == pnum:
			p.score = p.score + 1

func reset_player_scores():
	for p in player_list:
		p.score = 0
