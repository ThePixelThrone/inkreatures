extends Node2D

var mon = null

func effect(player):
	mon = player
	get_parent().get_node("PowerupAnimations").play("Medusa")
	player.remove_powerup()
	player.add_to_group("death_colliders")
	get_node("DurationTimer").start()

func effect_finish():
	get_node("Sprite").hide()
	mon.remove_from_group("death_colliders")
	get_parent().get_node("PowerupAnimations").stop(true)

func _ready():
	get_node("DurationTimer").connect("timeout", self, "effect_finish")
