extends Area2D

@onready var player: Node2D = $"../Player/Jugador"


func _process(_delta):
	if player:
		global_position.x = player.global_position.x
		
func _on_body_entered(body):
	
	if body.get_name() == "Jugador":
		get_tree().call_deferred("reload_current_scene")
