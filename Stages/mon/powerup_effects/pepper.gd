extends Node2D

var mon = null

func effect(player):
	mon = player
	player.remove_powerup()
	player.time_flow = 1.25
	get_parent().get_node("PowerupAnimations").play("Pepper")
	get_node("DurationTimer").start()

func effect_finish():
	get_node("Sprite").hide()
	get_parent().get_node("PowerupAnimations").stop(true)
	mon.time_flow = 1

func _ready():
	get_node("DurationTimer").connect("timeout", self, "effect_finish")
