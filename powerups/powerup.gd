extends Node2D

var powerup_types
var type

func on_pickup(object):
	if (object.is_in_group("players")):
		object.acquire_powerup(type)
		if (type == powerup_types.HORNS or type == powerup_types.ROCKETS or type == powerup_types.BOMBERMON 
		or type == powerup_types.MEDUSA or type == powerup_types.PEPPER):
			object.activate_powerup()
		queue_free()

func setup():
	if (type == powerup_types.FREEZE):
		get_node("Particles2D").change_color(Color(0.15,1,1,1)) # TODO : número mágico?
		var tex = load("res://assets/images/freeze.png")
		get_node("Sprite").set_texture(tex)
	elif (type == powerup_types.HORNS):
		pass
	elif (type == powerup_types.SPIKES):
		pass
	elif (type == powerup_types.GOO):
		pass
	elif (type == powerup_types.ROCKETS):
		get_node("Particles2D").change_color(Color(1,0.4,0.4,1)) # TODO : número mágico?
		var tex = load("res://assets/images/icone_jetpack.png")
		get_node("Sprite").set_texture(tex)
	elif (type == powerup_types.GHOST):
		get_node("Particles2D").change_color(Color(1,1,1,1)) # TODO : número mágico?
		var tex = load("res://assets/images/icone_ghost.png")
		get_node("Sprite").set_texture(tex)
	elif (type == powerup_types.NET):
		pass
	elif (type == powerup_types.BOMBERMON):
		pass
	elif (type == powerup_types.MEDUSA):
		get_node("Particles2D").change_color(Color(0,1,0,1)) # TODO : número mágico?
		var tex = load("res://assets/images/icone_medusa.png")
		get_node("Sprite").set_texture(tex)
	elif (type == powerup_types.PEPPER):
		get_node("Particles2D").change_color(Color(1,0,0,1)) # TODO : número mágico?
		var tex = load("res://assets/images/pepper.png")
		get_node("Sprite").set_texture(tex)

func _ready():
	powerup_types = get_node("/root/global").powerup_types
	type = randi()%powerup_types.size()
	type = powerup_types.ROCKETS
	get_node("Area2D").connect("body_enter", self, "on_pickup")
	setup()