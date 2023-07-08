extends Node2D

var mon = null

func effect(player):
	if (mon == null):
		mon = player
		player.connect("on_death", self, "effect_finish")
		get_parent().get_node("PowerupAnimations").play("UnicornStart")
		get_node("Area2D").connect("body_entered", self, "horn_collision")
		get_node("DurationTimer").start()
		get_node("Sprite").show()
	elif (get_node("FlipCooldown").is_stopped()):
		mon.front_flip()
		get_node("FlipCooldown").start()

func effect_finish():
	mon.remove_powerup()
	get_node("Sprite").hide()
	get_node("DurationTimer").stop()
	get_node("Area2D").disconnect("body_entered", self, "horn_collision")
	mon = null

func horn_collision(body):
	if (body.is_in_group("players") and body != mon):
		body.killed_by_player(mon)
		effect_finish()

func _ready():
	get_node("DurationTimer").connect("timeout", self, "effect_finish")
