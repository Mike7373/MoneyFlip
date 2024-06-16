extends Node

var currentRound:int = 1
var isPlayerTurn:bool
var isLastPlayer:bool = false

var player : character_behaviour
var enemy : character_behaviour

func _ready():
	PlayGame()

func update_player_stats_canvas():
	%LeftCharacter.find_child("Percentage").text = str(player.character_stats.health) + "%"
	%LeftCharacter.find_child("ProgressBar").value = player.character_stats.health

func update_enemy_stats_canvas():
	%RightCharacter.find_child("Percentage").text = str(enemy.character_stats.health) + "%"
	%RightCharacter.find_child("ProgressBar").value = enemy.character_stats.health

func PlayRound():
	print("PLayerTurn: " + str(isPlayerTurn))
	#qui ci vanno i sfx
	%RoundCanvas.show()
	%RoundText.text = "Round " + String.num(currentRound)
	await get_tree().create_timer(3.0).timeout
	%RoundCanvas.hide()
	
	if isPlayerTurn:
		#apri UI della scelta dei sacchetti
		%GameplayCanvas.show()
		$"../UI/GameplayCanvas/PurseTypeSelection".show()
		print("I can show you the world")
	else:
		#fai giocare l'AI
		_IA_turn()

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

func _on_attack_button_down():
	player.select_type_of_bag(player.type_of_bag.attack)
	_after_action_selection()

func _on_heal_button_down():
	player.select_type_of_bag(player.type_of_bag.recover)
	_after_action_selection()

func _after_action_selection():
	$"../UI/GameplayCanvas/PurseTypeSelection".hide()
	$"../UI/GameplayCanvas/PurseTypeSelection2".show()

func _on_head_button_down():
	player.select_coin_side(0)
	_after_head_or_tail_selection()

func _on_cross_button_down():
	player.select_coin_side(1)
	_after_head_or_tail_selection()

func _after_head_or_tail_selection():
	$"../UI/GameplayCanvas/PurseTypeSelection2".hide()
	$"../UI/GameplayCanvas/CoinFlipSelection".show()

func _on_single_coin_button_down():
	player.select_amount_of_coins(0)
	_after_amount_of_coin_selection()

func _on_small_bag_button_down():
	player.select_amount_of_coins(1)
	_after_amount_of_coin_selection()

func _on_big_bag_button_down():
	player.select_amount_of_coins(2)
	_after_amount_of_coin_selection()

func _after_amount_of_coin_selection():
	$"../UI/GameplayCanvas/CoinFlipSelection".hide()
	player.play_head_or_tails()
	player.do_action(enemy)
	isPlayerTurn = false
	EndRound()

func _IA_turn():
	enemy.select_type_of_bag(randi_range(0,1))
	print("Action: " + str(enemy.bag_type))
	enemy.select_coin_side(randi_range(0,1))
	print("Coin Side: " + str(enemy.coin_side))
	enemy.select_amount_of_coins(randi_range(0,2))
	print("Coin Amount: " + str(enemy.coins_to_flip))
	enemy.play_head_or_tails()
	enemy.do_action(player)
	print("Action done!")
	isPlayerTurn = true
	EndRound()
