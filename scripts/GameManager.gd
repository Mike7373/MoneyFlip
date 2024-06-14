extends Node

var currentRound:int = 1
var isPlayerTurn:bool
var isLastPlayer:bool = false

func _ready():
	PlayGame()

func PlayRound():
	%RoundSound.play()
	%RoundCanvas.show()
	%RoundText.text = "Round " + String.num(currentRound)
	await get_tree().create_timer(3.0).timeout
	%RoundCanvas.hide()
	
	if isPlayerTurn:
		#apri UI della scelta dei sacchetti
		%GameplayCanvas.show()
		isPlayerTurn = false;
	else:
		#fai giocare l'AI
		isPlayerTurn = true
		EndRound()

func EndRound():
	if isLastPlayer:
		isLastPlayer = false
	else:
		isLastPlayer = true
		currentRound += 1
	PlayRound()
	
func PlayGame():
	isPlayerTurn = (bool)(randi() % 2)
	%CharacterCanvas.show()

func EndGame():
	#schermata di sconfitta
	pass

func _on_audio_stream_player_2d_finished():
	%AudioStreamPlayer2D.play()
