extends Node2D

var spikes_scene
var mon = null

func effect(player):
	mon = player
	player.remove_powerup()
	var spikes = spikes_scene.instance()
	var spikespos = player.position
	spikespos.y += 32
	if (player.facing_left):
		spikespos.x += 25
	else:
		spikespos.x -= 25
	spikes.position = spikespos
	get_parent().get_parent().get_parent().add_child(spikes)

func _ready():
	spikes_scene = load(get_node("/root/global").powerup_effects_dir+"SpikesPowerup.tscn")
