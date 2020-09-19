extends KinematicBody2D


signal airborne

# Camera Constants
const CAMERA_GROUNDED_LOOKAHEAD = 1
const CAMERA_AIR_LOOKAHEAD = 0.3

# Logic Constants
const FALLRAYCASTDIST = 100

# Game Mechanic Constants
const ACCEL = 20
const MINSPEED = 0
const MAXSPEED = 120
const GRAVITY = 5
const BOOST_MAX = 5.0
const OVER_SPEED_FRCTION = 1
const BOOSTACCEL = 7
const DOWNHILLBONUS = 50
const UPHILLBONUS = 10
const DECEL = 15
const GAME_END_DECEL = 200
 
# Movement Variables
var fwdVelocity = MINSPEED
var velocityInput = 0;
var boostInput = false
var boost = BOOST_MAX

# States about being in the air
var grounded = true
var onRamp = false
var airVel = 0

# Board rotation, cosmetic.
var currAngle = 0
var targAngle = 0

var gameEnded = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func getNextBoardState():
	var b = get_node("Back").get_overlapping_bodies().size() > 0
	var m = get_node("Mid").get_overlapping_bodies().size() > 0
	var f = get_node("Front").get_overlapping_bodies().size() > 0
	return [b,m,f]

func getStaminaPct():
	return boost / BOOST_MAX
	
func updateVelocity(delta):
	fwdVelocity += delta * ACCEL * velocityInput

	if(fwdVelocity > MAXSPEED):
		fwdVelocity = lerp(fwdVelocity, MAXSPEED, delta * OVER_SPEED_FRCTION)
		
	if boost > 0 && boostInput:
		fwdVelocity += BOOSTACCEL * ACCEL * delta
		boost -= delta
		
	if velocityInput == 0:
		fwdVelocity -= delta * DECEL
	if gameEnded:
		fwdVelocity -= delta * GAME_END_DECEL
		
	fwdVelocity = max(fwdVelocity, MINSPEED)
		

func velocityShredRatio():
	if grounded:
		return fwdVelocity / (1.5*MAXSPEED)
	else:
		return 0
	
func handleRot(boardState, delta):
	
	var b = boardState[0]
	var m = boardState[1]
	var f = boardState[2]
	
	# Tip the board one way or another.
	if(b && !m && !f):
		targAngle = 45
		fwdVelocity += delta * DOWNHILLBONUS
		
	if(m):
		targAngle = 0
		
	if(!b && !m && f):
		targAngle = -45
		fwdVelocity -= delta * UPHILLBONUS
		onRamp = true
	
	animateToTargetAngle(delta)
	
	
func animateToTargetAngle(delta):
	var v = lerp(currAngle,targAngle,5*delta)
	currAngle = v
	var y_bias = abs(currAngle) * (5.0/45.0)
	
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
			emit_signal("airborne",true)
		else:
			# Find the rotation to use.
			handleRot(bs,delta)
			
		var baseIn = fwdVelocity/MAXSPEED * (1 + 3*clamp((currAngle - targAngle)/45,0,1))
		get_node("Sprite/SnowParticles").setIntensity(baseIn)
		
			
	else:
		
		get_node("Sprite/SnowParticles").setIntensity(0)
		var c = move_and_collide(Vector2(0, delta * airVel))
		if(c):
			grounded = true
			emit_signal("airborne",false)
		move_and_collide(Vector2(delta * fwdVelocity,0))
		airVel += GRAVITY
		targAngle = 0
		animateToTargetAngle(delta)
		


func _input(ev):
	if(gameEnded):
		velocityInput = 0
		return
		
	if Input.is_key_pressed(KEY_RIGHT):
		velocityInput = 1
	elif Input.is_key_pressed(KEY_LEFT):
		velocityInput = -1
	else:
		velocityInput = 0
		
	boostInput = false
	if Input.is_key_pressed(KEY_B):
		boostInput = true

func _on_LiftSends_game_end():
	gameEnded = true
