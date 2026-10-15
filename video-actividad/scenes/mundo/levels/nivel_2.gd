extends Node2D
func _ready():
	var pista_nivel_2 = preload("res://sounds/music/POL-test-your-skills-short.wav")
	MusicaFondo.cambiar_musica(pista_nivel_2)
