extends Node2D

var sprite
var mon = null

func effect(player):
	mon = player
	get_parent().get_node("PowerupAnimations").play("Medusa")
	player.remove_powerup()
	player.connect("player_collision", self, "on_collision")
	get_node("DurationTimer").start()

func on_collision(player1, player2):
	if (mon == player1):
		player2.die(player1)
	else:
		player1.die(player2)

func effect_finish():
	sprite.hide()
	mon.disconnect("player_collision", self, "on_collision")
	get_parent().get_node("PowerupAnimations").stop(true)

func _ready():
	sprite = get_node("Sprite")
	get_node("DurationTimer").connect("timeout", self, "effect_finish")