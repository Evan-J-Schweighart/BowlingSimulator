class_name rollcat
extends CharacterBody3D

const VERTICAL_ACCELERATION_BASE:float =  -10
const FRICTION_ACCEL_BASE:float = 100
const TERMINAL_FALLVEL:float = -500

const INITIAL_SPEED:float = 1000
const INITIAL_DIRECTION =Vector3(0,0,1)

const STICKTOFLOOR_Y_SPEED:float = 50

var curr_acceleration_horiz:Vector3
var last_collider:Object
var collision_capsule:CollisionShape3D

var cSpeed:float

# Called when the node enters the scene tree for the first time.
func _ready():
	floor_stop_on_slope=false
	var direction = INITIAL_DIRECTION
	velocity = INITIAL_SPEED * direction.normalized()
	collision_capsule = get_node("CollisionCapsule")
	cSpeed = INITIAL_SPEED
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):

	print(velocity)
	cSpeed = cSpeed - (FRICTION_ACCEL_BASE*delta)
	if cSpeed < 0:
		velocity = Vector3(0,0,0)
	else:
		var tmp:float
		if !is_on_floor():
			tmp = velocity.y + VERTICAL_ACCELERATION_BASE
			if tmp < TERMINAL_FALLVEL:
				tmp = TERMINAL_FALLVEL
		else:
			tmp = VERTICAL_ACCELERATION_BASE
	
		var norm = Vector2(velocity.x, velocity.z).normalized() * cSpeed
		velocity = Vector3(norm.x, tmp, norm.y)

		var curr_collision = move_and_collide(velocity*delta)

		if !is_on_floor():
			if curr_collision:
				#var curr_collider = curr_collision.get_collider()
				print("Bounce on floor")
				#last_collider = curr_collider		
				velocity = velocity.bounce(curr_collision.get_normal())
				velocity.y = velocity.y*.75
				if abs(velocity.y) < STICKTOFLOOR_Y_SPEED:
					apply_floor_snap()
					print("snap")
	
