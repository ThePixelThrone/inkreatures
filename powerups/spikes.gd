extends Node2D

var spikes_scene
var mon = null

func effect(player):
	mon = player
	player.remove_powerup()
	var spikes = spikes_scene.instance()
	var spikespos = player.get_pos()
	spikespos.y += 32
	spikes.set_pos(spikespos)
	get_parent().get_parent().get_parent().add_child(spikes)

func _ready():
	spikes_scene = load("res://powerups/SpikesPowerup.tscn")