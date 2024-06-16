extends Node2D

@onready var animated_sprite_2d = $AnimatedSprite2D

func play_anim(coin_side):
	if coin_side == 0:
		play_head_anim()
	elif coin_side == 1:
		play_tail_anim()

func play_head_anim():
	animated_sprite_2d.play("head")

func play_tail_anim():
	animated_sprite_2d.play("tail")
