extends Node

var currentRound:int = 1
var isPlayerTurn:bool
var isLastPlayer:bool = false

var player
var enemy
var is_someone_dead : bool = false
var game_over_timer
var coins_anim_timer

func _ready():
	PlayGame()

func show_game_over_canvas(p_name, p_wait_time):
	is_someone_dead = true
	game_over_timer = p_wait_time
	$"../UI/GameOver/Background/GameOverText".text = p_name + " wins!"

func PlayRound():
	if isLastPlayer:
		isLastPlayer = false
	else:
		%RoundSound.play()
		%RoundCanvas.show()
		%RoundText.text = "Round " + String.num(currentRound)
		await get_tree().create_timer(3.0).timeout
		%RoundCanvas.hide()
		isLastPlayer = true
		currentRound += 1
	if isPlayerTurn:
		%GameplayCanvas.show()
		$"../UI/GameplayCanvas/PurseTypeSelection".show()
	else:
		_IA_turn()

func EndRound():
	if is_someone_dead:
		EndGame()
		return
	PlayRound()

func PlayGame():
	isPlayerTurn = (bool)(randi() % 2)
	%CharacterCanvas.show()

func EndGame():
	await get_tree().create_timer(game_over_timer).timeout
	%GameOver.show()

func _on_audio_stream_player_2d_finished():
	%AudioStreamPlayer2D.play()

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
	update_bag_usages()

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
	head_or_tail(player)
	await get_tree().create_timer(coins_anim_timer).timeout
	player.do_action(player, enemy)
	await get_tree().create_timer(player.wait_time).timeout
	isPlayerTurn = false
	EndRound()

func update_player_stats_canvas():
	%LeftCharacter.find_child("Percentage").text = str(player.character_stats.health) + "%"
	%LeftCharacter.find_child("ProgressBar").value = player.character_stats.health

func update_enemy_stats_canvas():
	%RightCharacter.find_child("Percentage").text = str(enemy.character_stats.health) + "%"
	%RightCharacter.find_child("ProgressBar").value = enemy.character_stats.health

func update_bag_usages():
	var small_bag_text = $"../UI/GameplayCanvas/CoinFlipSelection/SmallBag/Use".text
	var large_bag_text = $"../UI/GameplayCanvas/CoinFlipSelection/BigBag/Use".text
	var attack_small_bags = player.character_stats.small_bag.attack_bags
	var attack_large_bags = player.character_stats.large_bag.attack_bags
	var recover_small_bags = player.character_stats.small_bag.recover_bags
	var recover_large_bags = player.character_stats.large_bag.recover_bags
	
	match player.bag_type:
		player.type_of_bag.attack:
			if attack_small_bags <= 0:
				$"../UI/GameplayCanvas/CoinFlipSelection/SmallBag".disabled = true
			else:
				$"../UI/GameplayCanvas/CoinFlipSelection/SmallBag".disabled = false
			if attack_large_bags <= 0:
				$"../UI/GameplayCanvas/CoinFlipSelection/BigBag".disabled = true
			else:
				$"../UI/GameplayCanvas/CoinFlipSelection/BigBag".disabled = false
			
			small_bag_text = str(attack_small_bags) + " / " + str(player.max_attack_small_bag)
			large_bag_text = str(attack_large_bags) + " / " + str(player.max_attack_large_bag)
			
		player.type_of_bag.recover:
			if recover_small_bags <= 0:
				$"../UI/GameplayCanvas/CoinFlipSelection/SmallBag".disabled = true
			else:
				$"../UI/GameplayCanvas/CoinFlipSelection/SmallBag".disabled = false
			if recover_large_bags <= 0:
				$"../UI/GameplayCanvas/CoinFlipSelection/BigBag".disabled = true
			else:
				$"../UI/GameplayCanvas/CoinFlipSelection/BigBag".disabled = false
			
			small_bag_text = str(recover_small_bags) + " / " + str(player.max_recover_small_bag)
			large_bag_text = str(recover_large_bags) + " / " + str(player.max_recover_large_bag)
	
	$"../UI/GameplayCanvas/CoinFlipSelection/SmallBag/Use".text = small_bag_text
	$"../UI/GameplayCanvas/CoinFlipSelection/BigBag/Use".text = large_bag_text

func head_or_tail(entity):
	$"../UI/GameplayCanvas/HeadOrTailGame".show()
	
	match entity.coin_side:
		0:
			$"../UI/GameplayCanvas/HeadOrTailGame/CoinSide/Head".show()
			$"../UI/GameplayCanvas/HeadOrTailGame/CoinSide/Tail".hide()
		1:
			$"../UI/GameplayCanvas/HeadOrTailGame/CoinSide/Head".hide()
			$"../UI/GameplayCanvas/HeadOrTailGame/CoinSide/Tail".show()
	
	var coins = $"../UI/GameplayCanvas/HeadOrTailGame/Coins".get_children()
	for coin in coins:
		coin.show()
		
	match entity.coins_to_flip:
		1:
			$"../UI/GameplayCanvas/HeadOrTailGame/Coins/Coin2".hide()
			$"../UI/GameplayCanvas/HeadOrTailGame/Coins/Coin3".hide()
			$"../UI/GameplayCanvas/HeadOrTailGame/Coins/Coin4".hide()
			$"../UI/GameplayCanvas/HeadOrTailGame/Coins/Coin5".hide()
		entity.character_stats.small_bag.coin:
			$"../UI/GameplayCanvas/HeadOrTailGame/Coins/Coin3".hide()
			$"../UI/GameplayCanvas/HeadOrTailGame/Coins/Coin5".hide()
	
	var coins_to_play = []
	for coin in coins:
		if !coin.visible:
			continue
		coins_to_play.push_front(coin)
	
	entity.play_head_or_tails(coins_to_play)
	coins_anim_timer = coins_to_play.size() * 0.5 + 1.5
	await get_tree().create_timer(coins_anim_timer).timeout
	$"../UI/GameplayCanvas/HeadOrTailGame".hide()

func _IA_turn():
	if enemy.character_stats.health < enemy.get_recovery_treshold():
		enemy.select_type_of_bag(randi_range(0,1))
	else:
		enemy.select_type_of_bag(0)
	enemy.select_coin_side(randi_range(0,1))
	enemy.select_amount_of_coins(randi_range(0,2))
	head_or_tail(enemy)
	await get_tree().create_timer(coins_anim_timer).timeout
	enemy.do_action(enemy, player)
	await get_tree().create_timer(enemy.wait_time).timeout
	isPlayerTurn = true
	EndRound()
