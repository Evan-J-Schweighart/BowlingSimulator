extends CanvasLayer

# As a reminder for myself I'm saying a round is two turns

var curTurn = 0
var curRound = 0

var turnPoints = 0
var totPoints = 0

var rounds

@onready var scoreLabel = $Score
@onready var anim = $AnimationPlayer
@onready var scoreCard = $PanelMid/ScoreCard/PanelContainer/HBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	rounds = scoreCard.get_children()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	tempPauseControl()
	
	if Input.is_action_just_pressed("TestTurnEnd"):
		turnEnd()

func tempPauseControl():
	if Input.is_action_just_pressed("pause"):
		pauseToggle()

func score_points(points):
	var curScore = int(scoreLabel.text)
	# update point for turn and total
	turnPoints = curScore + points
	
	scoreLabel.text = str(turnPoints)
	
func pauseToggle():
	if not get_tree().paused: anim.play("PauseTransition")
	else: anim.play_backwards("PauseTransition")
	get_tree().paused = !get_tree().paused
	
func roundEnd():
	# get turn 1 or 2
	pass
	
func turnEnd():
	# If out of turns end game?
	if curRound > 9:
		return
	
	# Get the current round box and turn box
	var scoreTotalBox = rounds[curRound].get_child(1)
	var curTurnScore = rounds[curRound].get_child(0).get_child(curTurn).get_child(0)
	
	# Put points in the right turn box
	curTurnScore.text = str(turnPoints)
	
	# If you finish turn 1 then change rounds and reset turns
	if curTurn == 0:
		curTurn += 1
	else:
		curTurn = 0
		curRound += 1
		scoreTotalBox.text = str(totPoints)
		
	totPoints += turnPoints
	turnPoints = 0
		
	print("new Turn: ", curTurn)
	print("new Round: ", curRound)


func _on_resume_pressed():
	pauseToggle()

func _on_quit_pressed():
	get_tree().quit()
