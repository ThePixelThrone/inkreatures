extends Node2D

var mon = null
var tag_cooldown = false
export var timer_duration = 5

func on_collision(player1, player2):
	var tagged = player1
	if (tagged == mon):
		tagged = player2
	mon.disconnect("player_collision", self, "on_collision")
	var powerup_animations = get_parent().get_node("PowerupAnimations")
	if (powerup_animations.get_current_animation() == "BombermonAcquire"):
		powerup_animations.stop()
	get_node("Label").hide()
	var bombermon = tagged.get_node("PowerupEffects").get_node("Bombermon")
	bombermon.tag_player(tagged, get_node("DurationTimer").get_time_left())
	get_node("DurationTimer").stop()

func tag_player(player, time_left):
	mon = player
	mon.connect("player_collision", self, "on_collision")
	mon.get_node("PowerupEffects").get_node("PowerupAnimations").play("BombermonAcquire")
	get_node("Label").show()
	get_node("DurationTimer").start(time_left)

func effect(player):
	player.remove_powerup()
	tag_player(player, timer_duration)

func effect_finish():
	var bodies = get_node("Area2D").get_overlapping_bodies()
	set_process(false)
	get_node("Label").hide()
	for body in bodies:
		if (body.is_in_group("players") and body != mon):
			body.killed_by_player(mon)
	mon.die()
	get_parent().get_node("PowerupAnimations").play("Bombermon")

func _process(delta):
	var time_left = get_node("DurationTimer").get_time_left()
	get_node("Label").set_text(var2str(int(ceil(time_left))))

func _ready():
	get_node("DurationTimer").connect("timeout", self, "effect_finish")
