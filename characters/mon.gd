extends KinematicBody2D

# This is a simple collision demo showing how
# the kinematic controller works.
# move() will allow to move the node, and will
# always move it to a non-colliding spot,
# as long as it starts from a non-colliding spot too.

# Member variables
const GRAVITY = 1280.0 # Pixels/second

# Angle in degrees towards either side that the player can consider "floor"
const FLOOR_ANGLE_TOLERANCE = 40
# Angle that will kill a player upon contact
const KILL_ANGLE_THRESHOLD = 47
const WALK_FORCE = 800
const WALK_MIN_SPEED = 10
const WALK_MAX_SPEED = 200
const SMASH_BONUS_WALK_FORCE = 1500
const SMASH_WALK_SPEED = 300
const STOP_FORCE = 1200
const JUMP_SPEED = 590
const BOUNCE_SPEED = 290
const SMASH_SPEED = 900
const WALL_JUMP_THRESHOLD = 0.17
const DEATH_ANIMATION_TIME = 1

const SLIDE_STOP_VELOCITY = 1.0 # One pixel per second
const SLIDE_STOP_MIN_TRAVEL = 1.0 # One pixel

var velocity = Vector2()
var on_air_time = 100
var grounded_timer = 0
var wall_jump_timer = 0
var death_timer = 0
var num_jumps = 1
var smashing = false
var grounded = false

var prev_jump_pressed = false
var prev_smash_pressed = false
var anim_state = 0

var facing_left = false
var wall_jump = true

var player = 1
var color = "azul"
var isAlive = true

var time_flow = 1 # Gambiarra pra pepper TODO : fazer direito
var upwards_accel = 0 # Used for power-ups

var powerup = null # Powerup being held
var splash_scene = null # Used to draw ink spatters

signal on_kill # Signal emitted when killing another player
signal on_smash
signal on_jump
signal surface_collision # Emitted everytime landing on any surface

func _fixed_process(delta):
	delta *= time_flow
	
	# Create forces
	var force = Vector2(0, GRAVITY-upwards_accel)
	var walk_left = Input.is_action_pressed("p"+var2str(player)+"_left")
	var walk_right = Input.is_action_pressed("p"+var2str(player)+"_right")
	var jump = Input.is_action_pressed("p"+var2str(player)+"_jump")
	var smash = Input.is_action_pressed("p"+var2str(player)+"_smash")
	var activate_powerup = Input.is_action_pressed("p"+var2str(player)+"_powerup")
	
	var stop = true
	
	if (not isAlive and not get_node("AnimationPlayer").is_playing()):
		queue_free()
	
	if (grounded):
		grounded_timer -= delta
		if (grounded_timer <= 0):
			grounded = false
			grounded_timer = 0
	
	if (wall_jump_timer < WALL_JUMP_THRESHOLD):
		wall_jump_timer += delta
		if (wall_jump and wall_jump_timer > WALL_JUMP_THRESHOLD):
			num_jumps -= 1
	
	if (walk_left and not grounded and isAlive):
		var smash_condition = (smashing and velocity.x <= WALK_MIN_SPEED and velocity.x > -SMASH_WALK_SPEED)
		if ((velocity.x <= WALK_MIN_SPEED and velocity.x > -WALK_MAX_SPEED) or smash_condition):
			force.x -= WALK_FORCE
			if (smashing):
				force.x -= SMASH_BONUS_WALK_FORCE
			stop = false
			facing_left = true
	elif (walk_right and not grounded and isAlive):
		var smash_condition = (smashing and velocity.x >= -WALK_MIN_SPEED and velocity.x < SMASH_WALK_SPEED)
		if ((velocity.x >= -WALK_MIN_SPEED and velocity.x < WALK_MAX_SPEED) or smash_condition):
			force.x += WALK_FORCE
			if (smashing):
				force.x += SMASH_BONUS_WALK_FORCE
			stop = false
			facing_left = false
	
	if (stop):
		var vsign = sign(velocity.x)
		var vlen = abs(velocity.x)
		
		vlen -= STOP_FORCE*delta
		if (vlen < 0):
			vlen = 0
		
		velocity.x = vlen*vsign
	
	# Integrate forces to velocity
	velocity += force*delta
	
	# Integrate velocity into motion and move
	var motion = velocity*delta
	
	# Move and consume motion
	motion = move(motion)
	
	var floor_velocity = Vector2()
	
	if (is_colliding()):
		# You can check which tile was collision against with this
		# print(get_collider_metadata())
		
		# Ran against something, is it the floor? Get normal and angle
		var n = get_collision_normal()
		var angle = rad2deg(acos(n.dot(Vector2(0, -1))))
		
		if (get_collider().is_in_group("players")): # Player collision
			if (isAlive and get_collider().isAlive):
				if (angle > 180-KILL_ANGLE_THRESHOLD):
					die()
					emit_signal("on_kill", get_collider().player)
				elif (angle < KILL_ANGLE_THRESHOLD):
					get_collider().die()
					emit_signal("on_kill", player)
		elif (get_collider().is_in_group("dynamic")):
			if (isAlive):
				get_collider().interact(self)
		
		if (angle < FLOOR_ANGLE_TOLERANCE):
			# If angle to the "up" vectors is < angle tolerance
			# char is on floor
			on_air_time = 0
			floor_velocity = get_collider_velocity()
		elif (angle < 180-KILL_ANGLE_THRESHOLD and not wall_jump):
			wall_jump = true
			wall_jump_timer = 0
			num_jumps += 1
		
		if (on_air_time == 0 and force.x == 0 and get_travel().length() < SLIDE_STOP_MIN_TRAVEL and abs(velocity.x) < SLIDE_STOP_VELOCITY and get_collider_velocity() == Vector2()):
			# Since this formula will always slide the character around, 
			# a special case must be considered to to stop it from moving 
			# if standing on an inclined floor. Conditions are:
			# 1) Standing on floor (on_air_time == 0)
			# 2) Did not move more than one pixel (get_travel().length() < SLIDE_STOP_MIN_TRAVEL)
			# 3) Not moving horizontally (abs(velocity.x) < SLIDE_STOP_VELOCITY)
			# 4) Collider is not moving
			
			revert_motion()
			velocity.y = 0.0
		else:
			# For every other case of motion, our motion was interrupted.
			# Try to complete the motion by "sliding" by the normal
			motion = n.slide(motion)
			velocity = n.slide(velocity)
			# Then move again
			move(motion)
	
	if (floor_velocity != Vector2()):
		# If floor moves, move with floor
		move(floor_velocity*delta)
	
	if (isAlive):
		# Colidiu com o chão
		if (on_air_time == 0):
			if (smashing):
				grounded = true # Prende no chão por 0.2 seg
				grounded_timer = 0.2
				velocity.x = 0
				get_node("Trail").set_emitting(false)
				smashing = false
			if (not grounded):
				velocity.y = -BOUNCE_SPEED
				num_jumps = 1
				wall_jump = false
			emit_signal("surface_collision")
		
		
		if (jump and not prev_jump_pressed and num_jumps > 0 and not smashing):
			# Jump must also be allowed to happen if the character left the floor a little bit ago.
			# Makes controls more snappy.
			velocity.y = -JUMP_SPEED
			num_jumps -= 1
			emit_signal("on_jump")
		
		
		if (smash and on_air_time > 0.15 and not prev_smash_pressed and not smashing):
			velocity.y = SMASH_SPEED
			smashing = true
			emit_signal("on_smash")
		
		if (activate_powerup):
			activate_powerup()
		
		prev_jump_pressed = jump
		prev_smash_pressed = smash
		
		if (facing_left):
			self.set_scale(Vector2(-1, 1))
		else:
			self.set_scale(Vector2(1, 1))
		
		if (smashing and anim_state != 4):
			anim_state = 4
			get_node("AnimationPlayer").play("Smash")
		elif (on_air_time == 0 and anim_state < 3):
			anim_state = 3
			get_node("AnimationPlayer").play("Ground")
		elif (velocity.y < 0 and anim_state != 2):
			anim_state = 2
			get_node("AnimationPlayer").queue("Up")
		elif (!smashing and velocity.y > 0 and anim_state != 1):
			anim_state = 1
			get_node("AnimationPlayer").queue("Down")
		
		on_air_time += delta

func die():
	get_node("AnimationPlayer").play("Die")
	isAlive = false
	var splash = splash_scene.instance()
	splash.set_pos(get_pos())
	splash.setup(color)
	get_parent().add_child(splash)

func acquire_powerup(p):
	powerup = p

func activate_powerup():
	if (powerup != null):
		get_node("PowerupEffects/Ghost").effect(self)

func remove_powerup():
	powerup = null

func _ready():
	self.add_to_group("players", true)
	splash_scene = load("res://scenes/Splash.tscn")
	set_fixed_process(true)
