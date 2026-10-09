extends Node
var niveles: Array = [
	
	"res://scenes/mundo/levels/nivel_1.tscn",
	"res://scenes/mundo/levels/nivel_2.tscn"  # 0
	#nivel 2
	#others levels
	
]

var nivel_actual_index: int = 0

func siguiente_nivel():
	nivel_actual_index += 1
	
	if nivel_actual_index < niveles.size():
		var ruta_siguiente = niveles[nivel_actual_index]
		get_tree().call_deferred("change_scene_to_file", ruta_siguiente)
	else:
		print("endgame: no hay mas niveles")
		nivel_actual_index = 0
		get_tree().call_deferred("change_scene_to_file", "res://scenes/mundo/menu_principal/menu_principal.tscn")
