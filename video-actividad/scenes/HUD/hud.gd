extends CanvasLayer
@onready var coin: Label = $Label

var totalCoins = 0
var maxCoins = 0

func _ready():
	var nodoContenedorMonedas = get_parent().get_node("Coins")
	maxCoins = nodoContenedorMonedas.get_child_count()
	
	for moneda in nodoContenedorMonedas.get_children():
		moneda.get_node("Area2D").coinCollected.connect(_on_moneda_recogida)
		

func _on_moneda_recogida():
	totalCoins += 1
	coin.text = ": " + str(totalCoins)
	
	if totalCoins >=maxCoins:
		LevelManager.siguiente_nivel()
