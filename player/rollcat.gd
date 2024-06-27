class_name rollcat
extends CharacterBody3D

const VERTICAL_ACCELERATION_BASE:float = -1
const HORIZONTAL_ACCELERATION_BASE:float = -1
const INITIAL_SPEED:float = 10
const initial_direction=Vector3(1,0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	var direction = initial_direction
	velocity = INITIAL_SPEED * direction.normalized()
	move_and_slide()
