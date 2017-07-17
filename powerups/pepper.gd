extends Node

var mon = null

func fire_aura_on():
	get_parent().get_node("PowerupAnimations").play("Pepper")
	
func fire_aura_off():
	get_node("Sprite").hide()
	get_parent().get_node("PowerupAnimations").stop(true)

func effect(player):
	mon = player
	player.connect("smashing", self, "fire_aura_on")
	player.connect("surface_collision", self, "fire_aura_off")
	player.time_flow = 1.15
	get_node("DurationTimer").start()

func effect_finish():
	get_node("Sprite").hide()
	get_parent().get_node("PowerupAnimations").stop(true)
	mon.time_flow = 1
	mon.disconnect("smashing", self, "fire_aura_on")
	mon.disconnect("surface_collision", self, "fire_aura_off")

func _ready():
	get_node("DurationTimer").connect("timeout", self, "effect_finish")