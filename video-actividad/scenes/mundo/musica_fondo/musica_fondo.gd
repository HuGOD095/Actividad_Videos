extends AudioStreamPlayer
func cambiar_musica(nueva_cancion: AudioStream):
	if stream == nueva_cancion:
		return
	
	stream = nueva_cancion
	play()
