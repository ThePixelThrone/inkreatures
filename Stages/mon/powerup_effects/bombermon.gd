extends Node2D

var mon = null
var tag_cooldown = false
export var timer_duration = 5

var spark_positions = [Vector2(8,-6), Vector2(6,-5), Vector2(4,-8), Vector2(2,-7), Vector2(0,-6)]

func flip_h():
	get_node("OverheadIcon").set_flip_h(true)
	get_node("OverheadIcon/FuseSparks").position.x *= -1

func reset_flip_h():
	get_node("OverheadIcon").set_flip_h(false)
	get_node("OverheadIcon/FuseSparks").position.x *= -1

func display_overhead_icon(enabled):
	get_node("OverheadIcon").set_visible(enabled)
	get_node("OverheadIcon/FuseSparks").set_visible(enabled)

func on_collision(player1, player2):
	var tagged = player1
	if (tagged == mon):
		tagged = player2
	mon.disconnect("player_collision", self, "on_collision")
	var powerup_animations = get_parent().get_node("PowerupAnimations")
	if (powerup_animations.get_current_animation() == "BombermonAcquire"):
		powerup_animations.stop()
	display_overhead_icon(false)
	var bombermon = tagged.get_node("PowerupEffects").get_node("Bombermon")
	bombermon.tag_player(tagged, get_node("DurationTimer").get_time_left())
	get_node("DurationTimer").stop()

func tag_player(player, time_left):
	mon = player
	mon.connect("player_collision", self, "on_collision")
	mon.get_node("PowerupEffects").get_node("PowerupAnimations").play("BombermonAcquire")
	display_overhead_icon(true)
	get_node("DurationTimer").start(time_left)

func effect(player):
	player.remove_powerup()
	tag_player(player, timer_duration)

func effect_finish():
	var bodies = get_node("Area2D").get_overlapping_bodies()
	set_process(false)
	display_overhead_icon(false)
	for body in bodies:
		if (body.is_in_group("players") and body != mon):
			body.killed_by_player(mon)
	mon.die()
	get_parent().get_node("PowerupAnimations").play("Bombermon")

func _process(delta):
	if (!get_node("DurationTimer").is_stopped()):
		var time_left = int(ceil(get_node("DurationTimer").get_time_left()))
		get_node("OverheadIcon").set_frame(5 - time_left)
		get_node("OverheadIcon/FuseSparks").set_position(spark_positions[5-time_left])
		if (get_node("OverheadIcon").is_flipped_h()):
			get_node("OverheadIcon/FuseSparks").position.x *= -1

func _ready():
	get_parent().get_parent().connect("turn_left", self, "flip_h")
	get_parent().get_parent().connect("turn_right", self, "reset_flip_h")
	get_node("DurationTimer").connect("timeout", self, "effect_finish")
