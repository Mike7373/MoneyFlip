extends Control

func _on_play_button_button_down():
	get_tree().change_scene_to_file("res://scenas/GameScene.tscn")
	#pass

func _on_exit_button_button_down():
	get_tree().quit()
	#pass

#Non riesco a mettere il flag su "loop" in inspector, ma così funziona
func _on_background_music_finished():
	%BackgroundMusic.play()
