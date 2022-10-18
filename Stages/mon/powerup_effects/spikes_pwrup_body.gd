extends KinematicBody2D

const GRAVITY = 1280.0 # Pixels/second
var velocity = Vector2()

func _physics_process(delta):
	var force = Vector2(0, GRAVITY)
	velocity += force*delta
	var motion = velocity*delta
	var collision = move_and_collide(motion, false)
	var floor_velocity = Vector2()
	if (collision):
		# Ran against something, is it the floor? Get normal and angle
		var n = collision.normal
		var angle = rad2deg(acos(n.dot(Vector2(0, -1))))
		# Check if collision is vertical/floor
		if (angle < 0.4):
			floor_velocity = collision.collider_velocity
			velocity.x = 0
			velocity.y = 0
	if (floor_velocity != Vector2()):
		# If floor moves, move with floor
		move_and_slide(floor_velocity*delta)

# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(true)

