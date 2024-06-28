extends Node3D

var player:rollcat

# Called when the node enters the scene tree for the first time.
func _ready():
	var tmp = load("res://player/rollcat.tscn")
	player = tmp.instantiate()
	add_child(player)
	player.position = Vector3(0, 20,0 )


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
