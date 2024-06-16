extends Node

class_name character_behaviour

@export var character_stats : Resource
@export var point : Vector2

enum type_of_bag {attack, recover}
var bag_type : type_of_bag

var coin_side
var coins_to_flip : int
var multiplier : int

signal on_attack
signal on_recovery

func select_character(scene:String):
	var character = load(scene)
	var instance = character.instantiate()
	instance.global_position = point
	$"../..".add_child(instance)

func select_type_of_bag(p:type_of_bag):
	bag_type = p

func select_amount_of_coins(type:int):
	if bag_type == type_of_bag.attack:
		if type == 0:
			coins_to_flip = 1
		elif type == 1:
			coins_to_flip = character_stats.small_bag.coin
			character_stats.small_bag.attack_bags -= 1
		elif type == 2:
			coins_to_flip = character_stats.large_bag.coin
			character_stats.large_bag.attack_bags -= 1
	if bag_type == type_of_bag.recover:
		if type == 0:
			coins_to_flip = 1
		elif type == 1:
			coins_to_flip = character_stats.small_bag.coin
			character_stats.small_bag.recover_bags -= 1
		elif type == 2:
			coins_to_flip = character_stats.large_bag.coin
			character_stats.large_bag.recover_bags -= 1

func select_coin_side(p:int):
	coin_side = p

func random_head_or_tails() -> int:
	return randi_range(0, 1)

func play_head_or_tails():
	for coin : int in coins_to_flip:
		var result = random_head_or_tails()
		if result == coin_side:
			multiplier += 1

func do_action(target):
	match bag_type:
		type_of_bag.attack:
			attack(target)
		type_of_bag.recover:
			recover()

func attack(target):
	print("Before Attack: " + str(target.character_stats.health))
	target.character_stats.health -= character_stats.damage * multiplier
	print("After Attack: " + str(target.character_stats.health))
	print("Tot Damage: " + str(character_stats.damage * multiplier))
	on_attack.emit()

func recover():
	character_stats.health += character_stats.recovery * multiplier
	on_recovery.emit()
