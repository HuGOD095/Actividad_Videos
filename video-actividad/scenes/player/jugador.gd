extends CharacterBody2D
@onready var area_2d: Area2D = $DetectorPicos
@onready var animation: AnimatedSprite2D = $Player
@onready var hitbox: CollisionShape2D = $HitboxNormal
@onready var hitbox_default: Vector2 = hitbox.shape.size
const speed: float = 50
const speedMax: float = 150
const jump: float = -200
const grav: float = 500
const frenoJump: float = 0.5
const coyoteDuration: float = 0.08
var coyoteTimer: float = 0.0
var isCrouch: bool = false



func _ready():
	area_2d.body_entered.connect(_on_detector_picos_area_entered)
func _physics_process(delta):
	_crouched()
	_salto(delta)
	if not isCrouch:
		_movimiento()
	else:
		velocity.x = lerp(velocity.x, 0.0, 0.5)
	move_and_slide()
	_actualizar_animacion()


func _movimiento():
	if Input.is_action_pressed("left"):
		animation.flip_h = false	
		velocity.x = max(velocity.x - speed, -speedMax)
	elif Input.is_action_pressed("right"):
		animation.flip_h = true
		velocity.x = min(velocity.x + speed, speedMax)
	else:
		velocity.x = lerp(velocity.x, 0.0, 0.5)
	
func _salto(delta):
	if is_on_floor():
		coyoteTimer = coyoteDuration
	else:
		coyoteTimer -= delta
		velocity.y += grav * delta
		
	if Input.is_action_pressed("jump") and coyoteTimer > 0.0 and not isCrouch:
		velocity.y = jump
		coyoteTimer = 0.0
		
func _crouched():
	if Input.is_action_pressed("crouched") and is_on_floor():
		isCrouch = true
		hitbox.shape.size.y = hitbox_default.y / 2.0
		hitbox.position.y = hitbox_default.y / 4.0
	else:
		isCrouch = false
		hitbox.shape.size.y = hitbox_default.y
		hitbox.position.y = 0.0
func _actualizar_animacion():
	if not is_on_floor():
		if velocity.y < 0:
			animation.play("jump")
		else:
			animation.play("drop")
	else:
		if Input.is_action_pressed("crouched"):
			animation.play("crouched")
		elif Input.is_action_pressed("left") or Input.is_action_pressed("right"):
			animation.play("run")
		else:
			animation.play("idle")

func _on_detector_picos_area_entered(_area):
	set_physics_process(false)
	await _efecto_muerte()
	get_tree().call_deferred("reload_current_scene")
	
	
func _efecto_muerte():
	var color_hexa = Color.html("#8c200c")
	var color = create_tween()
	color.tween_property(animation, "modulate", color_hexa, 0.5 )
	await color.finished
