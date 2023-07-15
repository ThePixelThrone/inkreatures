extends Node2D

var mon = null
var affected = []

func effect(player):
	mon = player
	player.remove_powerup()
	var bodies = get_node("Area2D").get_overlapping_bodies()
	get_parent().get_node("PowerupAnimations").play("FreezeNova")
	for body in bodies:
		if (body.is_in_group("players") and body != player):
			body.connect("on_death", self, "on_death")
			affected.append(body)
			body.freeze()
	get_node("DurationTimer").start()

func effect_finish():
	for player in affected:
		if (player != null and player.isAlive):
			player.disconnect("on_death", self, "on_death") 
			player.unfreeze()
	affected.clear()

func on_death(player):
	for p in affected:
		if (p.player == player):
			p.disconnect("on_death", self, "on_death")
			p.unfreeze()
			affected.erase(p)

func _ready():
	get_node("DurationTimer").connect("timeout", self, "effect_finish")
