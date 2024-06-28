class_name rollcat
extends CharacterBody3D

const VERTICAL_ACCELERATION_BASE:float =  -150
const NUMBOUNCES:int = 2
const BOUNCESCALES = Vector2(0.5, 0.2)
const JUMPVELOCITY:float = 100

const FRICTION_ACCEL_BASE:float = 2
const INITIAL_SPEED:float = 50


const SPHERE_MESH_ROTATION_CONST = 0.15

var curr_acceleration_horiz:Vector3
var last_collider:Object
var collision_capsule:CollisionShape3D

var cSpeed:float
var velocity2D:Vector2

var isInAir:bool
var bounceCounter:int = 0
var spherePivot:Node3D
var cameraRot:Node3D
var cameraHelper:Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	floor_stop_on_slope=false
	velocity = Vector3(0, 0, -1*INITIAL_SPEED)
	cSpeed = INITIAL_SPEED
	
	isInAir = true
	spherePivot = get_node("Pivot/sphere2")
	cameraRot = get_node("cameraPivot")
	cameraHelper = get_node("cameraHelper")
	
	cameraHelper.set_transform(cameraRot.transform)
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta):
	var c = Vector3(velocity.x, 0, velocity.z).normalized()
	
	cameraRot.set_transform(cameraRot.transform.interpolate_with(cameraHelper.transform, 2.5*delta))
	spherePivot.rotate(velocity.normalized().rotated(Vector3.DOWN,deg_to_rad(90)),-1*SPHERE_MESH_ROTATION_CONST*cSpeed*delta)
	
	

func _physics_process(delta):
	var cRight = Vector3(velocity.z, 0, -1 * velocity.x)
	if Input.is_action_pressed("right"):
		var tmp = (velocity - cRight * 1.5 * delta).normalized() * cSpeed
		velocity = Vector3(tmp.x, velocity.y, tmp.z)
		cameraHelper.look_at(global_position + Vector3(velocity.x, 0, velocity.z))
	elif Input.is_action_pressed("left"):
		var tmp = (velocity + cRight * 1.5 * delta).normalized()  * cSpeed
		velocity = Vector3(tmp.x, velocity.y, tmp.z)
		cameraHelper.look_at(global_position + Vector3(velocity.x, 0, velocity.z))
	
	if Input.is_action_pressed("jump") and !isInAir:
		velocity.y = JUMPVELOCITY
		bounceCounter = 0
		isInAir=true

	
	cSpeed = clamp(cSpeed - (FRICTION_ACCEL_BASE*delta), 0, INITIAL_SPEED)
	
	var tmp:float
	if isInAir:
		tmp = velocity.y + (VERTICAL_ACCELERATION_BASE*delta)
	else:
		tmp = 0 #VERTICAL_ACCELERATION_BASE
	velocity2D = Vector2(velocity.x,velocity.z).normalized()*cSpeed
	velocity = Vector3(velocity2D.x, tmp, velocity2D.y)

	var curr_collision = move_and_collide(velocity*delta)
	
	if curr_collision:
		var curr_collider:CollisionObject3D = curr_collision.get_collider()
		var metaData = curr_collider.get_meta("bouncesUs")
		if isInAir and bounceCounter < NUMBOUNCES:
			tmp = JUMPVELOCITY * BOUNCESCALES[bounceCounter]
			bounceCounter = bounceCounter + 1
			#print(bounceCounter)
		elif bounceCounter == NUMBOUNCES:
			isInAir = false
			tmp=0
			bounceCounter = 0
		velocity.y = tmp
	#velocity = Vector3(velocity2D.x, tmp, velocity2D.y)	
	#print(velocity)
	
				
