extends StaticBody2D

func interact(player):
	if (player.smashing):
		get_node("AnimationPlayer").play("Press")
		get_node("Spikes1/AnimationPlayer").play("Raise")
		get_node("Spikes2/AnimationPlayer").play("Raise")

func _ready():
	get_node("Spikes1/AnimationPlayer").play("Lower")
	get_node("Spikes2/AnimationPlayer").play("Lower")
	pass