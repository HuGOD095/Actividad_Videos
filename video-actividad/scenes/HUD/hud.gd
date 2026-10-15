extends CanvasLayer
@onready var coin: Label = $Label
@onready var cora1: Sprite2D =$Corazon1
@onready var cora2: Sprite2D =$Corazon2
@onready var cora3: Sprite2D =$Corazon3

var totalCoins = 0
var maxCoins = 0

func _ready():
	var nodoContenedorMonedas = get_parent().get_node("Coins")
	maxCoins = nodoContenedorMonedas.get_child_count()
	
	for moneda in nodoContenedorMonedas.get_children():
		moneda.get_node("Area2D").coinCollected.connect(_on_moneda_recogida)
		
		var jugador = get_parent().get_node("Player/Jugador")
		if jugador:
			if not jugador.vidas_actualizadas.is_connected(_actualizar_corazones):
				jugador.vidas_actualizadas.connect(_actualizar_corazones)
			_actualizar_corazones(jugador.vidas)

func _actualizar_corazones(vidas_restantes):
	if vidas_restantes >=1:
		cora1.frame=1
	else:
		cora1.frame = 3
	if vidas_restantes >= 2:
		cora2.frame = 1
	else:
		cora2.frame = 3
	if vidas_restantes >= 3:
		cora3.frame = 1
	else:
		cora3.frame = 3
	
func _on_moneda_recogida():
	totalCoins += 1
	coin.text = ": " + str(totalCoins)
	
	if totalCoins >=maxCoins:
		var jugador = get_parent().get_node("Player/Jugador")
		if jugador:
			jugador.set_physics_process(false)
			jugador.animation.play("idle")
		await get_tree().create_timer(0.8).timeout
		LevelManager.siguiente_nivel()
