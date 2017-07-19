extends Node2D

const MAX_JUMPING_ACCEL = 1200
const BASE_ACCEL = 1500
const VELOCITY_FACTOR = 1.3

var mon = null
enum states {OFF, ON, FLYING}
var state = OFF

func effect(player):
	if (state == OFF):
		state = ON
		mon = player
		player.connect("surface_collision", self, "landed")
		player.connect("on_jump", self, "on_jump")
		get_parent().get_node("PowerupAnimations").play("RocketsAcquire")
		get_node("DurationTimer").start()
	elif (state == ON and not player.smashing):
		get_parent().get_node("PowerupAnimations").play("Rockets")
		state = FLYING
		player.upwards_accel = BASE_ACCEL + player.velocity.y*VELOCITY_FACTOR
		get_node("FlyingTimer").start()

func on_jump():
	if (mon.upwards_accel > MAX_JUMPING_ACCEL):
		mon.upwards_accel = BASE_ACCEL + mon.velocity.y*VELOCITY_FACTOR

func landed():
	if (state == FLYING):
		get_node("LeftParticles").set_emitting(false)
		get_node("RightParticles").set_emitting(false)
		mon.upwards_accel = 0
		state = ON

func reset_accel():
	mon.upwards_accel = 0

func effect_finish():
	mon.disconnect("surface_collision", self, "landed")
	mon.disconnect("on_jump", self, "on_jump")
	if (mon.powerup == get_node("/root/global").powerup_types.ROCKETS):
		mon.remove_powerup()
	get_node("LeftParticles").set_emitting(false)
	get_node("RightParticles").set_emitting(false)
	state = OFF
	mon.upwards_accel = 0

func _ready():
	get_node("DurationTimer").connect("timeout", self, "effect_finish")
	get_node("FlyingTimer").connect("timeout", self, "reset_accel")