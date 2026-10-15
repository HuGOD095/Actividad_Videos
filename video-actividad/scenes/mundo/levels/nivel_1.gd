extends Node2D
func _ready():
	var pista_nivel_1 = preload("res://sounds/music/POL-spinning-gears-short.wav")
	MusicaFondo.cambiar_musica(pista_nivel_1)
