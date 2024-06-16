extends character_behaviour

@onready var character = $Character

func play_attack_anim():
	character.play("Attack")
	_to_idle("Attack")

func play_heal_anim():
	character.play("Heal")
	_to_idle("Heal")

func play_hurt_anim():
	character.play("Hurt")
	_to_idle("Hurt")

func play_idle_anim():
	character.play("Idle")

func play_die_anim():
	character.play("Die")

func _to_idle(anim_name):
	var anim_wait_time = calculate_time_to_wait(character.sprite_frames, anim_name)
	await get_tree().create_timer(anim_wait_time).timeout
	play_idle_anim()
