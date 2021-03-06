extends KinematicBody2D


signal airborne
signal landed

# Camera Constants
const CAMERA_GROUNDED_LOOKAHEAD = 1
const CAMERA_AIR_LOOKAHEAD = 0.3

# Logic Constants
const FALLRAYCASTDIST = 50

# Game Mechanic Constants
const ACCEL = 30
const MINSPEED = 0
const MAXSPEED = 120
const GRAVITY = 8
const BOOST_MAX = 2.0
const OVER_SPEED_FRCTION = 1
const BOOSTACCEL = 8
const DOWNHILLBONUS = 40
const UPHILLBONUS = 10
const DECEL = 40
const GAME_END_DECEL = 500
const BOARD_UPGRADE_SPEED_BONUS = 40
const JETPACK_STRENGTH = 300
const BOOST_RECHARGE = 0.0003

 
# Movement Variables
var fwdVelocity = MINSPEED
var velocityInput = 0;
var boostInput = false
var boost = BOOST_MAX
var teleportFlag = -1
var currStage = 0

# Items
var canUseJetpack = false
var canUseEnergyDrink = false

# States about being in the air
var grounded = true
var onRamp = false
var airVel = 0

# Board rotation, cosmetic.
var currAngle = 0
var targAngle = 0

var fireballCoolDown = 1

var gameEnded = false

# Increments speed
var boardLevel = 0

# More boost
var hasEnergyDrink = false

# Provides one Impulse
var hasJetpack = false

# Faster Acceleration
var hasScarf = false

# Provides one fireball.
var hasFireball = false

var firedJetpack = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func maxSpeed():
	return MAXSPEED + (boardLevel * BOARD_UPGRADE_SPEED_BONUS)

func getNextBoardState():
	var b = get_node("Back").get_overlapping_bodies().size() > 0
	var m = get_node("Mid").get_overlapping_bodies().size() > 0
	var f = get_node("Front").get_overlapping_bodies().size() > 0
	return [b,m,f]

func getStaminaPct():
	return boost / BOOST_MAX
	
func updateVelocity(delta):
	
	if(hasScarf):
		fwdVelocity += delta * ACCEL * 2 * velocityInput
	else:
		fwdVelocity += delta * ACCEL * velocityInput

	if(fwdVelocity >  maxSpeed()):
		fwdVelocity = lerp(fwdVelocity, maxSpeed(), delta * OVER_SPEED_FRCTION)
		
	if boost > 0 && boostInput:
		fwdVelocity += BOOSTACCEL * ACCEL * delta
		boost -= delta
		if(boost <= 0 && canUseEnergyDrink):
			canUseEnergyDrink = false
			boost += (BOOST_MAX / 2)
			get_node("EDrinkSound").play()
			
		
	if velocityInput <= 0:
		fwdVelocity -= delta * DECEL
	
	if gameEnded:
		fwdVelocity -= delta * GAME_END_DECEL
		
	fwdVelocity = max(fwdVelocity, MINSPEED)
	
	boost += fwdVelocity * delta * BOOST_RECHARGE
	boost = min(BOOST_MAX,boost)
		

func makeFireBall():
	fireballCoolDown = 1
	var fresource = preload("res://Fireball.tscn")
	get_node("FireBallSound").play()
	
	var f = fresource.instance()
	get_node("../").add_child(f)
	f.global_position = global_position
	f.position += Vector2(0,-10)
	
	var vel = 5 + fwdVelocity * 1.5
	
	f.speed = Vector2(vel,0)
	
	f = fresource.instance()
	get_node("../").add_child(f)
	f.global_position = global_position
	f.position += Vector2(0,-10)
	
	f.speed = Vector2(vel,vel/4)
	
	f = fresource.instance()
	get_node("../").add_child(f)
	f.global_position = global_position
	f.position += Vector2(0,-10)
	
	f.speed = Vector2(vel,-vel/4)

func velocityShredRatio():
	if grounded:
		return fwdVelocity / (1.5* maxSpeed())
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

func wipeout():
	#nasty but w/e
	get_node("../UI").wipeout()
	grounded = true
	onRamp = false
	emit_signal("airborne",false,"")
	emit_signal("landed")
	fwdVelocity = 0

func getYVel():
	if(grounded):
		return CAMERA_GROUNDED_LOOKAHEAD * targAngle
	else:
		return CAMERA_AIR_LOOKAHEAD * airVel

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):

	fireballCoolDown -= delta
	
	if(teleportFlag != -1):
		position = get_node("../LiftReturns/" + str(teleportFlag)).position
		teleportFlag = -1
		
	if(firedJetpack):
		if grounded:
			emit_signal("airborne",true,"Jetpack Boost")
			grounded = false
		onRamp = false
		airVel -= JETPACK_STRENGTH
		firedJetpack = false
		get_node("FireParticle").set_emitting(true)
		get_node("FireSound").play()
		
	if grounded:
		updateVelocity(delta)
		# Send the board up into the air.
		move_and_collide(delta * Vector2(0,-2*fwdVelocity))
		
		# Move with the velocity.
		move_and_collide(delta * Vector2(fwdVelocity,0))
		
		# Drop the board.
		# If we were on the ramp, and we read a flat board here, then we need to ignore this and set state to airborne.
		var last_pos = position + Vector2(0,2)
		
		move_and_collide(Vector2(0,FALLRAYCASTDIST))
		
		var bs = getNextBoardState()
		
		if(onRamp && !bs[2]):
			grounded = false
			onRamp = false
			airVel = -fwdVelocity
			position = last_pos
			var v = get_node("../NamedRamps").findChild(currStage,position)
			emit_signal("airborne",true,v)
		else:
			# Find the rotation to use.
			handleRot(bs,delta)
			
		var baseIn = fwdVelocity/ maxSpeed() * (1 + 3*clamp((currAngle - targAngle)/45,0,1))
		get_node("Sprite/SnowParticles").setIntensity(baseIn)
		
			
	else:
		
		get_node("Sprite/SnowParticles").setIntensity(0)
		var c = move_and_collide(Vector2(0, delta * airVel))
		
		if gameEnded:
			fwdVelocity -= delta * GAME_END_DECEL
		
		if(c):
			grounded = true
			emit_signal("airborne",false,"")
			emit_signal("landed")
			airVel = 0
		move_and_collide(Vector2(delta * fwdVelocity,0))
		airVel += GRAVITY
		targAngle = 0
		animateToTargetAngle(delta)
		
		
func _input(ev):
	if(gameEnded):
		velocityInput = 0
		boostInput = false
		return
		
	if Input.is_key_pressed(KEY_RIGHT):
		velocityInput = 1
	elif Input.is_key_pressed(KEY_LEFT):
		velocityInput = -1
	else:
		velocityInput = 0
	
	if Input.is_key_pressed(KEY_M) && canUseJetpack:
		canUseJetpack = false
		firedJetpack = true
		
	if Input.is_key_pressed(KEY_N) && fireballCoolDown < 0 && hasFireball:
		makeFireBall()
		
		
		
	boostInput = false
	if Input.is_key_pressed(KEY_B):
		boostInput = true

func _on_LiftSends_game_end():
	gameEnded = true

func refresh(i):
	currStage = i
	gameEnded = false
	boost = BOOST_MAX
	if(hasJetpack):
		canUseJetpack = true
	if(hasEnergyDrink):
		canUseEnergyDrink = true
	get_node("../UI/right/right/Record").text = ""
	
func _on_Map_load_level(i):
	teleportFlag = i
	refresh(i)
		
func getSpriteSet():
	var base = boardLevel * 8
	if(hasScarf):
		base += 4
	if(hasJetpack):
		base += 2
	return base
