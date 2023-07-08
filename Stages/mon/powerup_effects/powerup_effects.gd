extends Node2D

var powerup_types

func effect(player, type):
	if (type == powerup_types.FREEZE):
		get_node("Freeze").effect(player)
	elif (type == powerup_types.UNICORN):
		get_node("Unicorn").effect(player)
	elif (type == powerup_types.SPIKES):
		get_node("Spikes").effect(player)
	elif (type == powerup_types.ROCKETS):
		get_node("Rockets").effect(player)
	elif (type == powerup_types.GHOST):
		get_node("Ghost").effect(player)
	elif (type == powerup_types.NET):
		get_node("Net").effect(player)
	elif (type == powerup_types.BOMBERMON):
		get_node("Bombermon").effect(player)
	elif (type == powerup_types.DASH):
		get_node("Dash").effect(player)
	elif (type == powerup_types.PEPPER):
		get_node("Pepper").effect(player)
	elif (type == powerup_types.VIALS):
		get_node("Vials").effect(player)
	pass

func _ready():
	powerup_types = get_node("/root/global").powerup_types
	pass
