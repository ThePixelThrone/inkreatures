extends Node2D

var powerup_types
var type
export var base_respawn_time = 8
export var respawn_variance = 4

func disable():
	get_node("Area2D").disconnect("body_entered", self, "on_pickup")
	var respawn_time = base_respawn_time + (rand_range(-1, 1) * respawn_variance)
	get_node("RespawnTimer").start(respawn_time)
	self.hide()

func on_pickup(object):
	if (object.is_in_group("players") and object.acquire_powerup(type)):
		if (type == powerup_types.UNICORN or type == powerup_types.ROCKETS
		or type == powerup_types.BOMBERMON or type == powerup_types.DASH
		or type == powerup_types.PEPPER):
			object.activate_powerup()
		disable()

func setup(): # Update the sprite and sets up particle colors
	match type:
		powerup_types.FREEZE:
			get_node("Particles2D").change_color(Color(0.15,1,1,1)) # TODO : número mágico?
			var tex = load("res://assets/images/freeze.png")
			get_node("Sprite").set_texture(tex)
		powerup_types.UNICORN:
			get_node("Particles2D").set_random_colors()
			var tex = load("res://assets/images/unicorn_powerup.png")
			get_node("Sprite").set_texture(tex)
		powerup_types.SPIKES:
			get_node("Particles2D").change_color(Color(1,1,1,1)) # TODO : número mágico?
			var tex = load("res://assets/images/espinhos.png")
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
		powerup_types.DASH:
			get_node("Particles2D").change_color(Color(0,1,0,1)) # TODO : número mágico?
			var tex = load("res://assets/images/icone_medusa.png")
			get_node("Sprite").set_texture(tex)
		powerup_types.PEPPER:
			get_node("Particles2D").change_color(Color(1,0,0,1)) # TODO : número mágico?
			var tex = load("res://assets/images/pepper.png")
			get_node("Sprite").set_texture(tex)

func spawn():
	randomize()
	type = randi() % powerup_types.size()
	get_node("Area2D").connect("body_entered", self, "on_pickup")
	setup()
	self.show()

func _ready():
	powerup_types = get_node("/root/global").powerup_types
	get_node("RespawnTimer").connect("timeout", self, "spawn")
	spawn()
