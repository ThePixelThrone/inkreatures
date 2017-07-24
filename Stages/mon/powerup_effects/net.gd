extends Node2D

var net_scene
var net
var mon = null
var catched_player

func effect(player):
	mon = player
	player.remove_powerup()
	net = net_scene.instance()
	var netpos = player.get_pos()
	netpos.y -= 32
	net.owner = player
	net.set_pos(netpos)
	get_parent().get_parent().get_parent().add_child(net)
	net.connect("catch", self, "on_catch")
	net.start()
	get_node("DurationTimer").start()

func effect_finish():
	if (catched_player != null):
		catched_player.get_node("PowerupEffects/PowerupAnimations").play("NetFinish")

func on_death(player):
	get_node("GroundedTimer").stop()

func on_catch(player):
	if (mon != player):
		catched_player = player
		player.connect("on_death", self, "on_death")
		get_node("GroundedTimer").start()
	net_disappear()

func net_disappear():
	get_node("DurationTimer").stop()
	if (net != null and not net.is_queued_for_deletion()):
		net.queue_free()

func _ready():
	net_scene = load(get_node("/root/global").powerup_effects_dir+"Net.tscn")
	get_node("GroundedTimer").connect("timeout", self, "effect_finish")
	get_node("DurationTimer").connect("timeout", self, "net_disappear")