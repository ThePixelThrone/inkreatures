extends KinematicBody2D

# Member variables
const GRAVITY = 1000.0 # Pixels/second
const STARTING_VELOCITY = 300
# Angle in degrees towards either side that the player can consider "floor"
const FLOOR_ANGLE_TOLERANCE = 40

const SLIDE_STOP_VELOCITY = 1.0 # One pixel per second
const SLIDE_STOP_MIN_TRAVEL = 1.0 # One pixel

var velocity = Vector2()
var on_air_time = 100

var owner_mon

signal catch

func _physics_process(delta):
	# Create forces
	var force = Vector2(0, GRAVITY)
	
	# Integrate forces to velocity
	velocity += force*delta
	
	# Integrate velocity into motion and move
	var motion = velocity*delta
	
	# Move and consume motion
	var collision = move_and_collide(motion)
	
	var floor_velocity = Vector2()
	
	if (collision):
		# You can check which tile was collision against with this
		# print(get_collider_metadata())
		
		# Ran against something, is it the floor? Get normal and angle
		var n = collision.normal
		var angle = rad2deg(acos(n.dot(Vector2(0, -1))))
		
		if (collision.collider.is_in_group("players")):
			emit_signal("catch", collision.collider)
			if (collision.collider != owner_mon):
				collision.collider.net()
		
		if (angle < FLOOR_ANGLE_TOLERANCE):
			# If angle to the "up" vectors is < angle tolerance
			# char is on floor
			on_air_time = 0
			floor_velocity = collision.collider_velocity
	
	if (floor_velocity != Vector2()):
		# If floor moves, move with floor
		move_and_slide(floor_velocity*delta)
	
	on_air_time += delta

func start():
	velocity.y = -STARTING_VELOCITY
	velocity.x = 0
	set_physics_process(true)

func _ready():
	pass
