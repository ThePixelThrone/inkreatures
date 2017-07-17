extends Node2D

var mon = null

func effect(player):
	mon = player
	get_parent().get_parent().get_node("Sprite").set_self_opacity(0.5)
	get_parent().get_parent().set_collision_mask(2)
	get_parent().get_parent().set_layer_mask(2)
	get_node("DurationTimer").start()

func effect_finish():
	get_parent().get_parent().get_node("Sprite").set_self_opacity(1)
	get_parent().get_parent().set_collision_mask(1)
	get_parent().get_parent().set_layer_mask(1)
	get_parent().get_parent().get_node("CollisionShape2D").set_trigger(false)

func _ready():
	get_node("DurationTimer").connect("timeout", self, "effect_finish")