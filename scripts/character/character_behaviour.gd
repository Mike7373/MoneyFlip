extends Node

class_name character_behaviour

@export var character_stats : Resource
@export var point : Vector2

enum type_of_bag {attack, recover}
var bag_type : type_of_bag

var coin_side
var coins_to_flip : int
var multiplier : int
var wait_time : float

signal on_attack
signal on_recovery
signal on_death

@onready var maxHealth = character_stats.health
@onready var max_attack_small_bag = character_stats.small_bag.attack_bags
@onready var max_attack_large_bag = character_stats.large_bag.attack_bags
@onready var max_recover_small_bag = character_stats.small_bag.recover_bags
@onready var max_recover_large_bag = character_stats.large_bag.recover_bags

func select_type_of_bag(p:type_of_bag):
	bag_type = p

func select_amount_of_coins(type:int):
	match bag_type:
		type_of_bag.attack:
			match type:
				0:
					coins_to_flip = 1
				1:
					coins_to_flip = character_stats.small_bag.coin
					character_stats.small_bag.attack_bags -= 1
				2:
					coins_to_flip = character_stats.large_bag.coin
					character_stats.large_bag.attack_bags -= 1
		type_of_bag.recover:
			match type:
				0:
					coins_to_flip = 1
				1:
					coins_to_flip = character_stats.small_bag.coin
					character_stats.small_bag.recover_bags -= 1
				2:
					coins_to_flip = character_stats.large_bag.coin
					character_stats.large_bag.recover_bags -= 1

func select_coin_side(p:int):
	coin_side = p

func random_head_or_tails() -> int:
	return randi_range(0, 1)

func play_head_or_tails(coins):
	multiplier = 0
	for coin in coins:
		var result = random_head_or_tails()
		coin.play_anim(result)
		if result == coin_side:
			multiplier += 1
		await get_tree().create_timer(0.5).timeout

func do_action(player, enemy):
	match bag_type:
		type_of_bag.attack:
			attack(player, enemy)
		type_of_bag.recover:
			recover(player)

func attack(player, enemy):
	enemy.character_stats.health -= player.character_stats.damage * player.multiplier
	
	player.play_attack_anim()
	wait_time = calculate_time_to_wait(player.character.sprite_frames, "Attack")
	await get_tree().create_timer(wait_time).timeout
	
	if enemy.character_stats.health <= 0:
		wait_time = calculate_time_to_wait(player.character.sprite_frames, "Die")
		enemy.emit_signal("on_death", name, wait_time)
		player.on_attack.emit()
		enemy.play_die_anim()
		await get_tree().create_timer(wait_time).timeout
		return
	
	enemy.play_hurt_anim()
	player.on_attack.emit()

func recover(player):
	character_stats.health += character_stats.recovery * multiplier
	
	if character_stats.health >= maxHealth:
		character_stats.health = maxHealth
	
	player.play_heal_anim()
	wait_time = calculate_time_to_wait(player.character.sprite_frames, "Heal")
	await get_tree().create_timer(wait_time).timeout
	on_recovery.emit()

func calculate_time_to_wait(sprite_frames, anim_name) -> float:
	var frame_speed = sprite_frames.get_animation_speed(anim_name)
	var frame_count = sprite_frames.get_frame_count(anim_name)
	var result = 1 / frame_speed * frame_count
	return result

func get_recovery_treshold() -> int:
	return character_stats.recovery_threshold
