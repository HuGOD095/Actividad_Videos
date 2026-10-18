extends Control


func _ready():
	VirtualControls.ocultar()
	var pista_menu = preload("res://sounds/music/POL-star-way-short.wav")
	MusicaFondo.cambiar_musica(pista_menu)
func _on_start_pressed():	
	get_tree().change_scene_to_file("res://scenes/mundo/levels/nivel_1.tscn")


func _on_exit_pressed():
	get_tree().quit()
	
