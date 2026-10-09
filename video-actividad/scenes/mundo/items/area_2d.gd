extends Area2D
@onready var animation: AnimatedSprite2D = $Coin
@onready var hitbox: CollisionShape2D = $CollisionShape2D

signal coinCollected

func _on_body_entered(_body):
	hitbox.queue_free()
	emit_signal("coinCollected")
	animation.play("coin_select")
	await animation.animation_finished
	queue_free()
	
