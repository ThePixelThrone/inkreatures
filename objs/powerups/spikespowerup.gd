extends Node2D

var spikes_scene
var mon = null

func effect(player):
	mon = player
	player.remove_powerup()
	var spikes = spikes_scene.instance()
	var spikespos = player.get_pos()
	spikespos.y += 32
	if (player.facing_left):
		spikespos.x += 20
	else:
		spikespos.x -= 20
	spikes.set_pos(spikespos)
	get_parent().get_parent().get_parent().add_child(spikes)

func _ready():
	spikes_scene = load(get_node("/root/global").powerup_effects_dir+"SpikesPowerup.tscn")