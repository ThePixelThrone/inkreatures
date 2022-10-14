extends Node2D

var mon = null

func effect(player):
	mon = player
	player.remove_powerup()
	player.connect("on_death", self, "effect_finish")
	get_parent().get_node("PowerupAnimations").play("Horns")
	get_node("Area2D").connect("body_entered", self, "horn_collision")
	get_node("DurationTimer").start()

func effect_finish():
	get_node("Sprite").hide()
	get_node("DurationTimer").stop()
	get_node("Area2D").disconnect("body_entered", self, "horn_collision")

func horn_collision(body):
	if (body.is_in_group("players") and body != mon):
		body.killed_by_player(mon)
		effect_finish()

func _ready():
	get_node("DurationTimer").connect("timeout", self, "effect_finish")
