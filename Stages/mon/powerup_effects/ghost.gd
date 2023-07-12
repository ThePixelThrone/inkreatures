extends Node2D

var mon = null

func effect(player):
	mon = player
	mon.connect("on_death", self, "effect_finish")
	player.remove_powerup()
	# Set opacity to 50% with this (wtf godot):
	get_parent().get_parent().get_node("Sprite").self_modulate.a = 0.5
	get_parent().get_parent().set_collision_mask_bit(1, false)
	get_parent().get_parent().set_collision_layer_bit(1, false)
	# Not sure what do do with this:
	#get_parent().get_parent().set_layer_mask(2)
	get_node("DurationTimer").start()

func effect_finish():
	# Reset opacity to 100%
	get_parent().get_parent().get_node("Sprite").self_modulate.a = 1
	get_parent().get_parent().set_collision_mask_bit(1, true)
	get_parent().get_parent().set_collision_layer_bit(1, true)
	get_node("DurationTimer").stop()
	#get_parent().get_parent().set_layer_mask(1)
	# No more triggers in 3.0, need to use Area2D ?
	#get_parent().get_parent().get_node("CollisionShape2D").set_trigger(false)

func _ready():
	get_node("DurationTimer").connect("timeout", self, "effect_finish")
