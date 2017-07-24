extends Node2D

var powerup_types

func effect(player, type):
	if (type == powerup_types.FREEZE):
		get_node("Freeze").effect(player)
	elif (type == powerup_types.HORNS):
		get_node("Horns").effect(player)
	elif (type == powerup_types.SPIKES):
		get_node("Spikes").effect(player)
	elif (type == powerup_types.GOO):
		get_node("Goo").effect(player)
	elif (type == powerup_types.ROCKETS):
		get_node("Rockets").effect(player)
	elif (type == powerup_types.GHOST):
		get_node("Ghost").effect(player)
	elif (type == powerup_types.NET):
		get_node("Net").effect(player)
	elif (type == powerup_types.BOMBERMON):
		get_node("Bombermon").effect(player)
	elif (type == powerup_types.MEDUSA):
		get_node("Medusa").effect(player)
	elif (type == powerup_types.PEPPER):
		get_node("Pepper").effect(player)
	pass

func _ready():
	powerup_types = get_node("/root/global").powerup_types
	pass
