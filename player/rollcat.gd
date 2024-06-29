class_name rollcat
extends CharacterBody3D

const VERTICAL_ACCELERATION_BASE:float =  -150

const JUMPVELOCITY:float = 100

const FRICTION_ACCEL_BASE:float = 0
const INITIAL_SPEED:float = 50

const FLOOR_BOUNCE_MAX:int = 2
const BOUNCESCALES = Vector2(0.5, 0.1)

const BOUNCE_TIMEOUT_SECONDS:float = 0.5

const SPHERE_MESH_ROTATION_CONST = 0.15

var curr_acceleration_horiz:Vector3
var last_collider:Object
var collision_capsule:CollisionShape3D

var cSpeed:float
var velocity2D:Vector2

var isInAir:bool
var bounceCounter:int = 0

var collisionCapsule:CollisionShape3D
var spherePivot:Node3D
var cameraRot:Node3D
var cameraHelper:Node3D
var raycastDown:RayCast3D

var bounceTimer:Timer
var canBounce:bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	floor_stop_on_slope=true
	wall_min_slide_angle = 0

	#floor
	velocity = Vector3(0, 0, -1*INITIAL_SPEED)
	cSpeed = INITIAL_SPEED
	bounceTimer = get_node("bounceTimer")
	bounceTimer.wait_time = .1
	isInAir = true
	spherePivot = get_node("Pivot/sphere2")
	cameraRot = get_node("cameraPivot")
	cameraHelper = get_node("cameraHelper")
	collisionCapsule = get_node("CollisionCapsule")
	raycastDown = get_node("RayCast3D")	
	cameraHelper.set_transform(cameraRot.transform)

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta):
	cameraRot.set_transform(cameraRot.transform.interpolate_with(cameraHelper.transform, 1.5*delta))
	spherePivot.rotate(velocity.normalized().rotated(Vector3.DOWN,deg_to_rad(90)),-2.5*SPHERE_MESH_ROTATION_CONST*cSpeed*delta)
	
	

func _physics_process(delta):
	#print(velocity)

	var curr_collision = move_and_collide(velocity*delta)
	


	isInAir = !raycastDown.is_colliding()
	
	
	if curr_collision:
		if last_collider != null:
			if last_collider ==curr_collision.get_collider() and abs(rad_to_deg(curr_collision.get_normal().angle_to(Vector3.UP))) > 10:
				#print("same collider, isInAir: ", isInAir)
				#print(abs(rad_to_deg(curr_collision.get_normal().angle_to(Vector3.UP))))
				velocity.y = JUMPVELOCITY
				bounceCounter = 0
			#isInAir = true
				

		
		
		var curr_collider:CollisionObject3D = curr_collision.get_collider()
		var metaData = curr_collider.get_meta("bouncesUs")
		
		var hitFloor:bool = abs(rad_to_deg(curr_collision.get_normal().angle_to(Vector3.UP))) < 10
		
		if metaData:
			print(curr_collision.get_angle(0, Vector3.UP))
		if metaData and canBounce:
			velocity = velocity.bounce(curr_collision.get_normal())
			if !isInAir and bounceCounter >= FLOOR_BOUNCE_MAX and hitFloor:
				bounceCounter=0
				velocity.y = 0
			#	print("here")
				canBounce = false
				bounceTimer.start()
				print("a, velocity = ", velocity, ", isInAir = ", isInAir, ", collision normal: ", abs(rad_to_deg(curr_collision.get_normal().angle_to(Vector3.UP))))
			else: 
				if abs(rad_to_deg(curr_collision.get_normal().angle_to(Vector3.UP))) < 10: #bounce on floor
					bounceCounter = bounceCounter + 1
					velocity.y = velocity.y*.5
					canBounce = false
					bounceTimer.start()
					print("b, velocity = ", velocity, ", isInAir = ", isInAir, ", collision normal: ", abs(rad_to_deg(curr_collision.get_normal().angle_to(Vector3.UP))))
				elif last_collider != curr_collision.get_collider(): #bounce on wall
					canBounce = false
					bounceTimer.start()
					print("c, velocity = ", velocity, ", isInAir = ", isInAir, ", collision normal: ", abs(rad_to_deg(curr_collision.get_normal().angle_to(Vector3.UP))))
			last_collider = curr_collision.get_collider()
	else:
		var cRight = Vector3(velocity.z, 0, -1 * velocity.x)
		if Input.is_action_pressed("right"):
			var tmp = (velocity - cRight * 1.5 * delta).normalized() * cSpeed
			velocity = Vector3(tmp.x, velocity.y, tmp.z)
		#	cameraHelper.look_at(global_position + Vector3(velocity.x, 0, velocity.z))
		elif Input.is_action_pressed("left"):
			var tmp = (velocity + cRight * 1.5 * delta).normalized()  * cSpeed
			velocity = Vector3(tmp.x, velocity.y, tmp.z)
			#cameraHelper.look_at(global_position + Vector3(velocity.x, 0, velocity.z))
		if Input.is_action_pressed("jump") and !isInAir:
			velocity.y = JUMPVELOCITY
			bounceCounter = 0
			#isInAir = true
	

	cSpeed = clamp(cSpeed - (FRICTION_ACCEL_BASE*delta), 0, INITIAL_SPEED)
	
	var tmp:float
	if isInAir:
		tmp = velocity.y + (VERTICAL_ACCELERATION_BASE*delta)
	else:
		tmp = velocity.y

	velocity2D = Vector2(velocity.x,velocity.z).normalized()*cSpeed
	velocity = Vector3(velocity2D.x, tmp, velocity2D.y)
	cameraHelper.look_at(global_position + Vector3(velocity.x, 0*velocity.y, velocity.z))

func _on_bounce_timer_timeout():
	#print('yo')
	canBounce = true # Replace with function body.
