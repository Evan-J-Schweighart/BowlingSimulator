class_name rollcat
extends CharacterBody3D

const VERTICAL_ACCELERATION_BASE:float =  -100
const NUMBOUNCES:int = 2

const FRICTION_ACCEL_BASE:float = 2
const INITIAL_SPEED:float = 30

const DIRECTION_ACCEL_BASE: float= 2

var curr_acceleration_horiz:Vector3
var last_collider:Object
var collision_capsule:CollisionShape3D

var cSpeed:float
var cDir:float
var isInAir:bool
var bounceCounter:int = 0

var spherePivot:Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	floor_stop_on_slope=false
	velocity = Vector3(INITIAL_SPEED, 0, 0)
	cSpeed = INITIAL_SPEED
	cDir = 0
	isInAir = true
	spherePivot = get_node("Pivot/sphere2")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var cameraRot:Node3D = get_node("Node3D")
	cameraRot.look_at(to_global(Vector3(velocity.normalized().x, 0, velocity.normalized().z).rotated(transform.basis.y,deg_to_rad(90))))
	spherePivot.rotate(velocity.normalized().rotated(Vector3.DOWN,deg_to_rad(90)),-.6*cSpeed*delta)
	
	if Input.is_action_pressed("right"):
		cDir += DIRECTION_ACCEL_BASE * delta
		#get_node("Pivot").rotate_x(cSpeed*delta)

	elif Input.is_action_pressed("left"):
		cDir -= DIRECTION_ACCEL_BASE * delta
		#get_node("Pivot").rotate_x(-1*cSpeed*delta)
	cDir = clamp(cDir, -1, 1)
func _physics_process(delta):
	cSpeed = cSpeed - (FRICTION_ACCEL_BASE*delta)
	#print(velocity)
	#print(cSpeed)
	var normHoriz = Vector2(1, cDir).normalized()
	var cnode:Node3D = get_node("Node3D")
	
	
	#var rotTo = look_at()
	#rotate_object_local(Vector3(0,1,0), rot_x)
	
	#cnode.rotate_object_local(Vector3(1,0,0), rotTo)

	#cnode.rotation = Vector3(normHoriz.x, 0, normHoriz.y).rotated(self.transform.basis.get_euler(),180)
	if cSpeed < 10 and !isInAir:
		velocity = Vector3(0,0,0)
	else:
		var tmp:float
		if isInAir:
			tmp = velocity.y + (VERTICAL_ACCELERATION_BASE*delta)
		else:
			tmp = 0# VERTICAL_ACCELERATION_BASE*delta
			

		print(velocity)
		velocity = Vector3(normHoriz.x * cSpeed, tmp, normHoriz.y *cSpeed)
		

		
		#print(norm)
		var curr_collision = move_and_collide(velocity*delta)
		if curr_collision:
			var curr_collider:CollisionObject3D = curr_collision.get_collider()
			var metaData = curr_collider.get_meta("bouncesUs")
			if isInAir and bounceCounter < NUMBOUNCES:
				var newvel = velocity.bounce(curr_collision.get_normal())
				newvel.y = newvel.y * .6
				velocity = newvel
				bounceCounter = bounceCounter + 1
				print(bounceCounter)
			elif bounceCounter == NUMBOUNCES:
				isInAir = false
				velocity.y=0
				bounceCounter = 0
				
		#velocity = transform.basis * velocity
				
