extends Control

const luke = preload("res://scenas/Luke.tscn")
const daniel = preload("res://scenas/Daniel.tscn")
const maury = preload("res://scenas/Maury.tscn")
const mike = preload("res://scenas/Mike.tscn")

func instatiateCharacters(character : PackedScene):
	var player = character.instantiate()
	var enemy
	%LeftSpawner.add_child(player)
	%LeftCharacter.find_child("Name").text = player.name
	var random = randi() % 4
	#ATTENZIONE! Quella che stai per vedere è una cosa brutta che potrebbe provocarti insonnia :'D
	match random:
		0:
			if player.name == "Luke":
				enemy = daniel.instantiate()
			else:
				enemy = luke.instantiate()
			enemy.find_child("Character").flip_h = true
			%RightSpawner.add_child(enemy)
			%RightCharacter.find_child("Name").text = enemy.name
		1:
			if player.name == "Daniel":
				enemy = maury.instantiate()
			else:
				enemy = daniel.instantiate()
			enemy.find_child("Character").flip_h = true
			%RightSpawner.add_child(enemy)
			%RightCharacter.find_child("Name").text = enemy.name
		2:
			if player.name == "Maury":
				enemy = mike.instantiate()
			else:
				enemy = maury.instantiate()
			enemy.find_child("Character").flip_h = true
			%RightSpawner.add_child(enemy)
			%RightCharacter.find_child("Name").text = enemy.name
		3:
			if player.name == "Mike":
				enemy = luke.instantiate()
			else:
				enemy = mike.instantiate()
			enemy = mike.instantiate()
			enemy.find_child("Character").flip_h = true
			%RightSpawner.add_child(enemy)
			%RightCharacter.find_child("Name").text = enemy.name
		

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
