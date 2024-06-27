extends CanvasLayer


@onready var scoreLabel = $Score
@onready var anim = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	tempPauseControl()

func tempPauseControl():
	if Input.is_action_just_pressed("pause"):
		print("Toggle pause")
		pauseToggle()

func score_points(points):
	var curScore = int(scoreLabel.text)
	scoreLabel.text = str(curScore + points)
	
func pauseToggle():
	if not get_tree().paused: anim.play("PauseTransition")
	else: anim.play_backwards("PauseTransition")
	get_tree().paused = !get_tree().paused


func _on_resume_pressed():
	pauseToggle()

func _on_quit_pressed():
	get_tree().quit()
