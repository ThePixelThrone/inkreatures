extends Node2D

var mon = null

func effect(player):
	mon = player
	player.remove_powerup()
	get_node("DurationTimer").start()

func effect_finish():
	get_parent().get_parent().get_node("Sprite").set_self_opacity(1)

func _ready():
	get_node("DurationTimer").connect("timeout", self, "effect_finish")