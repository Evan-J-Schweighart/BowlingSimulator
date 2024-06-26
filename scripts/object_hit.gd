extends RigidBody3D

var checkVelocity = false
var hasFallen = false

@export var stopThresh = 0.001
@export var fallThresh = 0.25
@export var breakVelocity = 10
@export var pointVal = 1

@onready var UI = %UI

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
		if abs(final_rot) >= 0.25 and not hasFallen:
			print(name, " Fell...")
			hasFallen = true
			if UI:
				UI.score_points(pointVal)
			# Add points to score here

func _on_body_entered(body):
	#var colliding = get_colliding_bodies()
	# start checking velocity
	var colSpeed = linear_velocity.length()
	if colSpeed >= breakVelocity:
		UI.score_points(pointVal)
		queue_free()
	else:
		checkVelocity = true
