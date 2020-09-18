extends KinematicBody2D

# Constants
const ACCEL = 100
const MINSPEED = 100
const MAXSPEED = 300
const CAMERA_GROUNDED_LOOKAHEAD = 5
const CAMERA_AIR_LOOKAHEAD = 0.1
const FALLRAYCASTDIST = 100
const GRAVITY = 5

# Keep track of velocity.
var fwdVelocity = MINSPEED
var velocityInput = 0;

# States about being in the air
var grounded = true
var onRamp = false
var airVel = 0

# Board rotation, cosmetic.
var currAngle = 0
var targAngle = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func getNextBoardState():
	var b = get_node("Back").get_overlapping_bodies().size() > 0
	var m = get_node("Mid").get_overlapping_bodies().size() > 0
	var f = get_node("Front").get_overlapping_bodies().size() > 0
	return [b,m,f]

func updateVelocity(delta):
	fwdVelocity += delta * ACCEL * velocityInput
	fwdVelocity = clamp(fwdVelocity, MINSPEED, MAXSPEED)
	
func handleRot(boardState, delta):
	
	var b = boardState[0]
	var m = boardState[1]
	var f = boardState[2]
	
	# Tip the board one way or another.
	if(b && !m && !f):
		targAngle = 45
		
	if(m):
		targAngle = 0
		
	if(!b && !m && f):
		targAngle = -45
		onRamp = true
	
	animateToTargetAngle(delta)
	
func animateToTargetAngle(delta):
	var v = lerp(currAngle,targAngle,5*delta)
	currAngle = v
	var y_bias = abs(currAngle) * (20.0/45.0)
	
	get_node("Sprite").rotation_degrees = currAngle
	get_node("Sprite").offset.y = y_bias	
	get_node("Sprite/SnowParticles").setOffset(y_bias)


func getYVel():
	if(grounded):
		return CAMERA_GROUNDED_LOOKAHEAD * targAngle
	else:
		return CAMERA_AIR_LOOKAHEAD * airVel

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if grounded:
		updateVelocity(delta)
		# Send the board up into the air.
		move_and_collide(delta * Vector2(0,-2*fwdVelocity))
		
		# Move with the velocity.
		move_and_collide(delta * Vector2(fwdVelocity,0))
		
		# Drop the board.
		# If we were on the ramp, and we read a flat board here, then we need to ignore this and set state to airborne.
		var last_pos = position
		
		move_and_collide(Vector2(0,FALLRAYCASTDIST))
		
		var bs = getNextBoardState()
		
		if(onRamp && !bs[2]):
			grounded = false
			onRamp = false
			airVel = -fwdVelocity
			position = last_pos
		else:
			# Find the rotation to use.
			handleRot(bs,delta)
			
	else:
		var c = move_and_collide(Vector2(0, delta * airVel))
		if(c):
			grounded = true
		move_and_collide(Vector2(delta * fwdVelocity,0))
		airVel += GRAVITY
		targAngle = 0
		animateToTargetAngle(delta)
		
	


func _input(ev):
	if Input.is_key_pressed(KEY_RIGHT):
		velocityInput = 1
	elif Input.is_key_pressed(KEY_LEFT):
		velocityInput = -1
	else:
		velocityInput = 0
