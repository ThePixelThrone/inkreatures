extends Node2D

var powerup_types
var type

func on_pickup(object):
	if (object.is_in_group("players")):
		object.acquire_powerup(type)
		if (type == powerup_types.HORNS or type == powerup_types.ROCKETS
		or type == powerup_types.BOMBERMON or type == powerup_types.MEDUSA
		or type == powerup_types.PEPPER):
			object.activate_powerup()
		queue_free()

func setup(): # Update the sprite and sets up particle colors
	match type:
		powerup_types.FREEZE:
			get_node("Particles2D").change_color(Color(0.15,1,1,1)) # TODO : número mágico?
			var tex = load("res://assets/images/freeze.png")
			get_node("Sprite").set_texture(tex)
		powerup_types.HORNS:
			get_node("Particles2D").change_color(Color(0.55,0.3,0.1,1)) # TODO : número mágico?
			var tex = load("res://assets/images/horns_temp_icon.png")
			get_node("Sprite").set_texture(tex)
		powerup_types.SPIKES:
			get_node("Particles2D").change_color(Color(1,1,1,1)) # TODO : número mágico?
			var tex = load("res://assets/images/espinhos.png")
			get_node("Sprite").set_texture(tex)
		powerup_types.GOO: # NOT IMPLEMENTED
			get_node("Particles2D").change_color(Color(1,1,1,1)) # TODO : número mágico?
			var tex = load("res://assets/images/no_sprite.png")
			get_node("Sprite").set_texture(tex)
		powerup_types.ROCKETS:
			get_node("Particles2D").change_color(Color(1,0.4,0.4,1)) # TODO : número mágico?
			var tex = load("res://assets/images/icone_jetpack.png")
			get_node("Sprite").set_texture(tex)
		powerup_types.GHOST:
			get_node("Particles2D").change_color(Color(1,1,1,1)) # TODO : número mágico?
			var tex = load("res://assets/images/icone_ghost.png")
			get_node("Sprite").set_texture(tex)
		powerup_types.NET:
			get_node("Particles2D").change_color(Color(1,1,1,1)) # TODO : número mágico?
			var tex = load("res://assets/images/net_temp_icon.png")
			get_node("Sprite").set_texture(tex)
		powerup_types.BOMBERMON:
			get_node("Particles2D").change_color(Color(1,0.4,0.4,1)) # TODO : número mágico?
			var tex = load("res://assets/images/bombermon_temp.png")
			get_node("Sprite").set_texture(tex)
		powerup_types.MEDUSA:
			get_node("Particles2D").change_color(Color(0,1,0,1)) # TODO : número mágico?
			var tex = load("res://assets/images/icone_medusa.png")
			get_node("Sprite").set_texture(tex)
		powerup_types.PEPPER:
			get_node("Particles2D").change_color(Color(1,0,0,1)) # TODO : número mágico?
			var tex = load("res://assets/images/pepper.png")
			get_node("Sprite").set_texture(tex)

func _ready():
	powerup_types = get_node("/root/global").powerup_types
	randomize()
	type = randi() % powerup_types.size()
	get_node("Area2D").connect("body_entered", self, "on_pickup")
	setup()
