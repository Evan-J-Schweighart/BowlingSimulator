extends CanvasLayer

# As a reminder for myself I'm saying a round is two turns

var curTurn = 0
var curRound = 0

var turnPoints = 0
var totPoints = 0

var turnScoreList = []
var roundScoreList = []

var inRoundEnd = false

var rounds

@onready var scoreLabel = $Score
@onready var anim = $AnimationPlayer
@onready var scoreCard = $PanelMid/ScoreCard/PanelContainer/HBoxContainer
@onready var endRoundUI = $EndRoundUI

# Called when the node enters the scene tree for the first time.
func _ready():
	rounds = scoreCard.get_children()
	check_reloaded()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	tempPauseControl()
	
	if Input.is_action_just_pressed("TestTurnEnd"):
		turn_end()

func tempPauseControl():
	if Input.is_action_just_pressed("pause"):
		pauseToggle()

func score_points(points):
	var curScore = int(scoreLabel.text)
	# update point for turn and total
	turnPoints = curScore + points
	
	scoreLabel.text = str(turnPoints)
	
func pauseToggle():
	# Cant pause when the round is over aleardy
	if inRoundEnd: return
	
	# Pause game and move in/out the menu
	if not get_tree().paused: anim.play("PauseTransition")
	else: anim.play_backwards("PauseTransition")
	get_tree().paused = !get_tree().paused
	
func round_end():
	# If at the max rounds end game?
	if curRound == 10:
		print("GameOver")
	
	# Duplicate the score card and show it
	roundScoreList.append(totPoints)
	var scoreCopy = scoreCard.duplicate()
	endRoundUI.add_child(scoreCopy)
	
	# Play animation
	anim.play("EndRound")
	inRoundEnd = true
	get_tree().paused = true
	
func fill_scores():
	for i in range(len(roundScoreList)):
		# Fill the score for each turn
		for j in range(2):
			var curTurnScore = rounds[i].get_child(0).get_child(j).get_child(0)
			if i+j < len(turnScoreList):
				curTurnScore.text = str(turnScoreList[i+j])
		# Fill the score for each round
		var roundScoreLabel = rounds[i].get_child(1)
		roundScoreLabel.text = str(roundScoreList[i])
	
func turn_end():
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
		round_end()
		
	totPoints += turnPoints
	turnScoreList.append(turnPoints)
	turnPoints = 0
	scoreLabel.text = str(turnPoints)

func _on_resume_pressed():
	pauseToggle()

func _on_quit_pressed():
	get_tree().quit()

### CONTINUE AFTER ROUND ###
func _on_button_pressed():
	anim.play_backwards("EndRound")
	inRoundEnd = false
	await get_tree().create_timer(0.1).timeout
	
	# loading ui data
	Reloading.uiData["turnScores"] = turnScoreList
	Reloading.uiData["roundScores"] = roundScoreList
	# reload the scene
	get_tree().reload_current_scene()
	
func check_reloaded():
	# get the scores for the score card
	if "turnScores" in Reloading.uiData.keys():
		turnScoreList = Reloading.uiData["turnScores"]
		roundScoreList = Reloading.uiData["roundScores"]
		
		# Get back our current running total
		totPoints = roundScoreList[-1]
		curRound = len(roundScoreList)
		
		# Fill in the scores that got cleared
		fill_scores()
		get_tree().paused = false
