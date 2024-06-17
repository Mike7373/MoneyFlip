extends Control

const luke = preload("res://scenas/Luke.tscn")
const daniel = preload("res://scenas/Daniel.tscn")
const maury = preload("res://scenas/Maury.tscn")
const mike = preload("res://scenas/Mike.tscn")
enum character_type {Luke, Daniel, Maury, Mike}
var selected_char : character_type

func instatiateCharacters(character : PackedScene):
	var player = character.instantiate()
	_init_main_character(player)
	selected_char = character_type.get(player.name)
	
	var enemy
	var random = randi() % 4
	#ATTENZIONE! Quella che stai per vedere è una cosa brutta che potrebbe provocarti insonnia :'D
	match random:
		0:
			if selected_char == random:
				enemy = daniel.instantiate()
			else:
				enemy = luke.instantiate()
			enemy.find_child("Character").flip_h = true
			_init_enemy_character(enemy)
		1:
			if selected_char == random:
				enemy = maury.instantiate()
			else:
				enemy = daniel.instantiate()
			enemy.find_child("Character").flip_h = true
			_init_enemy_character(enemy)
		2:
			if selected_char == random:
				enemy = mike.instantiate()
			else:
				enemy = maury.instantiate()
			enemy.find_child("Character").flip_h = true
			_init_enemy_character(enemy)
		3:
			if selected_char == random:
				enemy = luke.instantiate()
			else:
				enemy = mike.instantiate()
			enemy.find_child("Character").flip_h = true
			_init_enemy_character(enemy)
	
	%GameManager.player = player
	%GameManager.enemy = enemy
	
	%GameManager.player.on_recovery.connect(%GameManager.update_player_stats_canvas)
	%GameManager.player.on_attack.connect(%GameManager.update_enemy_stats_canvas)
	%GameManager.player.on_death.connect(%GameManager.show_game_over_canvas)
	
	%GameManager.enemy.on_recovery.connect(%GameManager.update_enemy_stats_canvas)
	%GameManager.enemy.on_attack.connect(%GameManager.update_player_stats_canvas)
	%GameManager.enemy.on_death.connect(%GameManager.show_game_over_canvas)

func _on_luke_button_down():
	#imposta character
	%CharacterCanvas.hide()
	%Background.show()
	%StatsCanvas.show()
	instatiateCharacters(luke)
	%GameManager.PlayRound()

func _on_daniel_button_down():
	#imposta character
	%CharacterCanvas.hide()
	%Background.show()
	%StatsCanvas.show()
	instatiateCharacters(daniel)
	%GameManager.PlayRound()

func _on_mauro_button_down():
	#imposta character
	%CharacterCanvas.hide()
	%Background.show()
	%StatsCanvas.show()
	instatiateCharacters(maury)
	%GameManager.PlayRound()

func _on_mike_button_down():
	#imposta character
	%CharacterCanvas.hide()
	%Background.show()
	%StatsCanvas.show()
	instatiateCharacters(mike)
	%GameManager.PlayRound()

func _init_main_character(player):
	%LeftSpawner.add_child(player)
	%LeftCharacter.find_child("Name").text = player.name
	%LeftCharacter.find_child("Percentage").text = str(player.character_stats.health) + "%"
	%LeftCharacter.find_child("ProgressBar").max_value = player.character_stats.health
	%LeftCharacter.find_child("ProgressBar").value = player.character_stats.health

func _init_enemy_character(enemy):
	%RightSpawner.add_child(enemy)
	%RightCharacter.find_child("Name").text = enemy.name
	%RightCharacter.find_child("Percentage").text = str(enemy.character_stats.health) + "%"
	%RightCharacter.find_child("ProgressBar").max_value = enemy.character_stats.health
	%RightCharacter.find_child("ProgressBar").value = enemy.character_stats.health
