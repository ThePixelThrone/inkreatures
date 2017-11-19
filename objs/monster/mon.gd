extends KinematicBody2D

const GRAVITY = 1280.0 # Pixels/second

# Angle in degrees towards either side that the player can consider "floor"
const FLOOR_ANGLE_TOLERANCE = 40
# Angle that will kill a player upon contact
const KILL_ANGLE_THRESHOLD = 47

const WALK_FORCE = 800
const WALK_MIN_SPEED = 10
const WALK_MAX_SPEED = 220
const STOP_FORCE = 1200
const JUMP_SPEED = 575
const BOUNCE_SPEED = 320

const SMASH_BONUS_WALK_FORCE = 1500
const SMASH_WALK_SPEED = 330
const SMASH_SPEED = 900
const SMASH_GROUNDED_TIME = 0.2 # Keeps player stuck on ground for 0.2 seconds

const WALL_JUMP_THRESHOLD = 0.17

const DEATH_ANIMATION_TIME = 1

const SLIDE_STOP_VELOCITY = 1.0 # One pixel per second
const SLIDE_STOP_MIN_TRAVEL = 1.0 # One pixel

var velocity = Vector2()
var on_air_time = 100

# Timer in seconds that keeps the player on ground when grounded is true
var grounded_timer = 0
# Timer to control wall jumps time window
var wall_jump_timer = 0
# Timer used to count death animation time
var death_timer = 0

# These control the state of the player
var smashing = false
var grounded = false
var frozen = false

# The player can only jump when num_jumps > 0. Used for wall jumps and powerups
var num_jumps = 1

var prev_jump_pressed = false
var prev_smash_pressed = false

var anim_state = 0 # Controls the animation states

var prev_facing_left = false # Both are used to control direction player is facing
var facing_left = false

var wall_jump = false # Used to control if player did a wall jump

var player = 1
var color = "azul"
var isAlive = true

var time_flow = 1 # Gambiarra pra pepper TODO : fazer direito
var upwards_accel = 0 # Used for power-ups

var powerup = null # Powerup being held
var splash_scene = null # Used to draw ink spatters

signal on_kill # Signal emitted when killing another player
signal on_death
signal on_smash
signal on_jump
signal turn_left
signal turn_right
signal player_collision # Emitted on any player collision
signal surface_collision # Emitted everytime landing on any surface

func _fixed_process(delta):
	delta *= time_flow
	
	# Create forces
	var force = Vector2(0, GRAVITY-upwards_accel)
	
	# Reading inputs
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
	
	if (not grounded and not frozen): # Only moves if not grounded or frozen
		if (walk_left and isAlive):
			if ((velocity.x <= WALK_MIN_SPEED and velocity.x > -WALK_MAX_SPEED)
			or (smashing and velocity.x <= WALK_MIN_SPEED and velocity.x > -SMASH_WALK_SPEED)):
				force.x -= WALK_FORCE
				if (smashing):
					force.x -= SMASH_BONUS_WALK_FORCE
				stop = false
				facing_left = true
		elif (walk_right and isAlive):
			if ((velocity.x >= -WALK_MIN_SPEED and velocity.x < WALK_MAX_SPEED)
			or (smashing and velocity.x >= -WALK_MIN_SPEED and velocity.x < SMASH_WALK_SPEED)):
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
	if (not frozen):
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
				emit_signal("player_collision", self, get_collider())
				if (angle > 180-KILL_ANGLE_THRESHOLD):
					killed_by_player(get_collider())
				elif (angle < KILL_ANGLE_THRESHOLD):
					get_collider().killed_by_player(self)
		elif (get_collider().is_in_group("dynamic")):
			if (isAlive):
				get_collider().interact(self)
		elif (get_collider().is_in_group("death_colliders")):
			if (isAlive):
				die()
		
		if (angle < FLOOR_ANGLE_TOLERANCE):
			# If angle to the "up" vectors is < angle tolerance
			# char is on floor
			on_air_time = 0
			floor_velocity = get_collider_velocity()
		elif (angle < 180-KILL_ANGLE_THRESHOLD and not wall_jump):
			# If angle is in between floor and kill threshold
			# character has hit a wall
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
			if (not frozen):
				move(motion)
	
	if (floor_velocity != Vector2()):
		# If floor moves, move with floor
		move(floor_velocity*delta)
	
	if (isAlive):
		if (on_air_time == 0): # This means a surface(ground) collision
			if (smashing):
				# Ends smashing because player has hit a surface
				grounded = true # Sticks player on floor
				grounded_timer = SMASH_GROUNDED_TIME
				velocity.x = 0
				get_node("Trail").set_emitting(false)
				smashing = false
			if (not grounded): # Only bounces when not grounded
				velocity.y = -BOUNCE_SPEED
				num_jumps = 1
				wall_jump = false
			emit_signal("surface_collision")
		
		
		if (jump and not prev_jump_pressed and num_jumps > 0 and not smashing and not frozen and not grounded):
			# Jump must also be allowed to happen if the character left the floor a little bit ago.
			# Makes controls more snappy.
			velocity.y = -JUMP_SPEED
			num_jumps -= 1
			emit_signal("on_jump")
		
		
		if (smash and on_air_time > 0.15 and not prev_smash_pressed and not smashing and not frozen and not grounded):
			velocity.y = SMASH_SPEED
			smashing = true
			emit_signal("on_smash")
		
		if (activate_powerup):
			activate_powerup()
		
		prev_jump_pressed = jump
		prev_smash_pressed = smash
		
		if (facing_left):
			if (not prev_facing_left):
				emit_signal("turn_left")
				self.set_scale(Vector2(-1, 1))
				prev_facing_left = true
		elif (prev_facing_left):
				emit_signal("turn_right")
				self.set_scale(Vector2(1, 1))
				prev_facing_left = false
		
		# Animation controls
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
		
		if (frozen):
			velocity.x = 0
			velocity.y = 0
			if (get_node("AnimationPlayer").is_playing()):
				get_node("AnimationPlayer").stop()


func killed_by_player(killer):
	if (isAlive):
		killer.emit_signal("on_kill", killer.player)
		die()

func die():
	if (isAlive):
		get_node("AnimationPlayer").play("Die")
		isAlive = false
		ink_splash()
		emit_signal("on_death", self.player)

func ink_splash(): # Generates an ink splash where player stands
	var splash = splash_scene.instance()
	splash.set_pos(get_pos())
	splash.setup(color)
	get_parent().add_child(splash)

func acquire_powerup(p):
	powerup = p

func activate_powerup():
	if (powerup != null):
		get_node("PowerupEffects").effect(self, powerup)

func remove_powerup():
	powerup = null

func freeze():
	frozen = true
	get_node("AnimationPlayer").stop(false)
	get_node("PowerupEffects/PowerupAnimations").play("Freeze")

func unfreeze():
	frozen = false
	get_node("PowerupEffects/PowerupAnimations").play("Unfreeze")

func net(): # Catched by a Net thrown by another player
	grounded = true
	grounded_timer = get_node("PowerupEffects/Net/GroundedTimer").get_wait_time()
	get_node("PowerupEffects/PowerupAnimations").play("Net")

func _ready():
	splash_scene = load("res://objs/splash/Splash.tscn")
	set_fixed_process(true)

func set_color(color):
	self.color = color
	get_node("Trail").set_color(color)
	get_node("Ink").setup(color)