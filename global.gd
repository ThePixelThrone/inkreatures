extends Node

const MAX_PLAYERS = 4
const TOTAL_MONSTERS = 5 # Number  of monster types
const powerup_effects_dir = "res://Stages/mon/powerup_effects/"

# Color strings used by assets
const colors = ["azul", "vermelho", "verde", "amarelo"]

enum game_modes {SURVIVAL, PIXEL_THRONE, VIRUS, CO_OP}

enum powerup_types {FREEZE, UNICORN, SPIKES, ROCKETS, GHOST, NET, BOMBERMON, MEDUSA, PEPPER}

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

func _ready():
	pass

# Called when a player joins the game in the character selection screen
func add_player(num, color, mon, device):
	var player = Player.new()
	player.number = num
	player.color = color
	player.monster = mon
	player.controller_device = device
	player_list.append(player)

func game_start():
	get_tree().change_scene("res://Stages/Stage"+var2str(selected_stage)+".tscn")
