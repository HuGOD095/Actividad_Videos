extends CanvasLayer

func ocultar():
	hide()
	process_mode = Node.PROCESS_MODE_DISABLED
	
func mostrar():
	show()
	process_mode =Node.PROCESS_MODE_INHERIT
