extends Node2D

var mon = null

func dash():
	get_node("DashCooldown").start()
	mon.velocity.x += 500 * sign(mon.velocity.x)

func effect(player):
	if (mon == null):
		mon = player
		get_parent().get_node("PowerupAnimations").play("Dash")
		get_node("DurationTimer").start()
	elif (get_node("DashCooldown").is_stopped()):
		dash()

func effect_finish():
	mon.remove_powerup()
	mon = null
	get_node("Sprite").hide()
	get_parent().get_node("PowerupAnimations").stop(true)

func _ready():
	get_node("DurationTimer").connect("timeout", self, "effect_finish")
