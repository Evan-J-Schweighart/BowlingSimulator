class_name rollcat
extends CharacterBody3D

const VERTICAL_ACCELERATION_BASE:float =  -10
const TERMINAL_FALLVEL:float = -1000
const NUMBOUNCES:int = 2

const FRICTION_ACCEL_BASE:float = 20
const INITIAL_SPEED:float = 500
const INITIAL_DIRECTION =Vector3(0,0,1)

const STICKTOFLOOR_Y_SPEED:float = 200

var curr_acceleration_horiz:Vector3
var last_collider:Object
var collision_capsule:CollisionShape3D

var cSpeed:float
var isInAir:bool
var bounceCounter:int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	floor_stop_on_slope=false
	var direction = INITIAL_DIRECTION
	velocity = INITIAL_SPEED * direction.normalized()
	collision_capsule = get_node("CollisionCapsule")
	cSpeed = INITIAL_SPEED
	isInAir = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	cSpeed = cSpeed - (FRICTION_ACCEL_BASE*delta)
	print(cSpeed)
	#print(cSpeed)
	if cSpeed < 0 and !isInAir:
		velocity = Vector3(0,0,0)
	else:
		var tmp:float
		if isInAir:
			tmp = velocity.y + VERTICAL_ACCELERATION_BASE
			if tmp < TERMINAL_FALLVEL:
				tmp = TERMINAL_FALLVEL
		else:
			tmp = VERTICAL_ACCELERATION_BASE
		
		var norm = Vector2(velocity.x, velocity.z).normalized() * cSpeed

		velocity = Vector3(norm.x, tmp, norm.y)
		#print(norm)

		var curr_collision = move_and_collide(velocity*delta)
		if curr_collision:
			var curr_collider:CollisionObject3D = curr_collision.get_collider()
			var metaData = curr_collider.get_meta("bouncesUs")
			if isInAir and bounceCounter < NUMBOUNCES:
				#print(velocity.bounce(curr_collision.get_normal()))
				velocity = velocity.bounce(curr_collision.get_normal())
				velocity.y = velocity.y * .9
				bounceCounter = bounceCounter + 1
				print(bounceCounter)
				#print(velocity)
			elif bounceCounter == NUMBOUNCES:
				isInAir = false
				bounceCounter = 0
				
		
		
