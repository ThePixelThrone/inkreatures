extends Node2D

enum powerup_types {FREEZE, HORNS, SPIKES, GOO, ROCKETS, GHOST, NET, BOMBERMON, MEDUSA, PEPPER}
var type

func on_pickup(object):
	if (object.is_in_group("players")):
		object.acquire_powerup(type)
		if (type == HORNS or type == ROCKETS or type == BOMBERMON or type == MEDUSA or type == PEPPER):
			object.activate_powerup()
		queue_free()

func setup():
	if (type == FREEZE):
		get_node("Particles2D").change_color(Color(0.15,1,1,1)) # TODO : número mágico?
		var tex = load("res://assets/images/freeze.png")
		get_node("Sprite").set_texture(tex)
	elif (type == HORNS):
		pass
	elif (type == SPIKES):
		pass
	elif (type == GOO):
		pass
	elif (type == ROCKETS):
		get_node("Particles2D").change_color(Color(1,1,1,1)) # TODO : número mágico?
		var tex = load("res://assets/images/pepper.png")
		get_node("Sprite").set_texture(tex)
	elif (type == GHOST):
		get_node("Particles2D").change_color(Color(1,1,1,1)) # TODO : número mágico?
		var tex = load("res://assets/images/ghost.png")
		get_node("Sprite").set_texture(tex)
	elif (type == NET):
		pass
	elif (type == BOMBERMON):
		pass
	elif (type == MEDUSA):
		pass
	elif (type == PEPPER):
		get_node("Particles2D").change_color(Color(1,0,0,1)) # TODO : número mágico?
		var tex = load("res://assets/images/pepper.png")
		get_node("Sprite").set_texture(tex)

func _ready():
	type = randi()%powerup_types.size()
	type = ROCKETS
	get_node("Area2D").connect("body_enter", self, "on_pickup")
	setup()