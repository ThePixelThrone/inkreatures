extends Node2D

var mon = null

func effect(player):
	mon = player
	player.remove_powerup()
	set_process(true)
	get_parent().get_node("PowerupAnimations").play("BombermonAcquire")
	get_node("Label").show()
	get_node("DurationTimer").start()

func effect_finish():
	var bodies = get_node("Area2D").get_overlapping_bodies()
	set_process(false)
	get_node("Label").hide()
	for body in bodies:
		if (body.is_in_group("players")):
			body.killed_by_player(mon)
	mon.die()
	get_parent().get_node("PowerupAnimations").play("Bombermon")

func _process(delta):
	var time_left = get_node("DurationTimer").get_time_left()
	get_node("Label").set_text(var2str(int(ceil(time_left))))

func _ready():
	get_node("DurationTimer").connect("timeout", self, "effect_finish")