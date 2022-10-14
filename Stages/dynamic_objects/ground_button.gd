extends StaticBody2D

var activated = false
var timer

func interact(player): # Every member of "dynamic_objects" need to implement interact(player)
	if (player.smashing and not activated):
		get_node("AnimationPlayer").play("Press")
		get_node("Spikes1/AnimationPlayer").play("Raise")
		get_node("Spikes2/AnimationPlayer").play("Raise")
		get_node("CollisionShape2D").translate(Vector2(0, 4)) # Metade da altura, TODO : tirar numero magico
		timer.start()
		activated = true

func timer_timeout():
	get_node("AnimationPlayer").play("Release")
	get_node("Spikes1/AnimationPlayer").play("Lower")
	get_node("Spikes2/AnimationPlayer").play("Lower")
	get_node("CollisionShape2D").translate(Vector2(0, -4)) # Metade da altura, TODO : tirar numero magico
	activated = false

func _ready():
	timer = get_node("Timer")
	timer.connect("timeout", self, "timer_timeout")
	get_node("Spikes1/AnimationPlayer").play("Lower")
	get_node("Spikes2/AnimationPlayer").play("Lower")
	pass
