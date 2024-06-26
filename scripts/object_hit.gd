extends RigidBody3D

var checkVelocity = false

@export var stopThresh = 0.001
@export var fallThresh = 0.25

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_check_score()

func _check_score():
	if !checkVelocity: return
	
	# if velocity reached zero check orientation
	if linear_velocity.length() <= stopThresh:
		# Add points here and stop checking
		checkVelocity = false
		var final_rot = rotation.normalized().dot(Vector3.UP)
		#print(name, " STOPPED: ", final_rot)
		# if the final rot is different enough from up then add score
		if abs(final_rot) >= 0.25:
			print(name, " Fell...")
			# Add points to score here

func _on_body_entered(body):
	#var colliding = get_colliding_bodies()
	# start checking velocity
	if body is RigidBody3D:
		print("hit rigidbody")
	else:
		checkVelocity = true
