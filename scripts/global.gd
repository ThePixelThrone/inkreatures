extends Node

const MAX_PLAYERS = 4

enum game_modes {SURVIVAL, PIXEL_THRONE, VIRUS, CO_OP}

enum powerup_types {FREEZE, HORNS, SPIKES, GOO, ROCKETS, GHOST, NET, BOMBERMON, MEDUSA, PEPPER}

var colors = ["azul", "vermelho", "verde", "amarelo"]

var player_list = []
var selected_stage = 2
var game_mode = SURVIVAL

class Player:
	var number
	var color
	var monster

func _ready():
	pass

func add_player(num, color, mon):
	var player = Player.new()
	player.number = num
	player.color = color
	player.monster = mon
	player_list.append(player)

func game_start():
	get_tree().change_scene("res://scenes/Stage"+var2str(selected_stage)+".tscn")