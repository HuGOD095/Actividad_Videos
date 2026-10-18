extends CanvasLayer
@onready var boton_pausa: Button = $Control/Pause
@onready var boton_exit: Button = $Control/exit

func _ready():

	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	
	boton_pausa.pressed.connect(_on_boton_pausa_pressed)
	boton_exit.pressed.connect(_on_boton_exit_pressed)
	

func _input(event):
	if event.is_action_pressed("pause"):
		alternar_pausa()
		
func alternar_pausa():
	get_tree().paused = !get_tree().paused
	
	if get_tree().paused:
		visible = true
		VirtualControls.ocultar()

	else:
		visible = false
		VirtualControls.mostrar()
		
func _on_boton_pausa_pressed():
	VirtualControls.mostrar()
	get_tree().paused = false
	visible = false
func _on_boton_exit_pressed():
	get_tree().paused = false
	visible = false
	get_tree().call_deferred("change_scene_to_file", "res://scenes/mundo/menu_principal/menu_principal.tscn")
