extends Node

var currentRound:int = 1
var isPlayerTurn:bool
var isLastPlayer:bool = false

func _ready():
	isPlayerTurn = (bool)(randi() % 2)

func PlayRound():
	#qui ci va il collegamento al testo per mostrare quale round inizia + timer + sfx
	if isPlayerTurn:
		#apri UI della scelta dei sacchetti
		pass
	else:
		#fai giocare l'AI
		pass

func EndRound():
	if isLastPlayer:
		isLastPlayer = false
	else:
		isLastPlayer = true
		currentRound += 1
	PlayRound()
	
func PlayGame():
	#select character
	PlayRound()

func EndGame():
	#schermata di sconfitta
	pass
