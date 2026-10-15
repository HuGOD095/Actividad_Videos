extends CharacterBody2D
@onready var daño_sonido: AudioStreamPlayer = $"../Damage"
@onready var muerte_sonido: AudioStreamPlayer = $"../Dead"
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

var vidas: int = 3
var retroceso: bool = false
signal vidas_actualizadas(vidas_actuales)


func _ready():
	# Aquí hago que mi nodo detecte areas y cuerpos (area = sierra, cuerpo = picos)
	area_2d.body_entered.connect(_on_peligro_detectado)
	area_2d.area_entered.connect(_on_peligro_detectado)
func _physics_process(delta):
	if retroceso:
		velocity.y += grav * delta
		move_and_slide()
		return
	
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

func _on_peligro_detectado(nodo_colision):
	if retroceso: return
	if nodo_colision.is_in_group("enemigo"):
		_recibir_daño(nodo_colision)
	else:
		_morir()

func _recibir_daño(enemigo):
	daño_sonido.play()
	vidas -= 1
	vidas_actualizadas.emit(vidas)
	print("vidas restantes: ", vidas)
	if vidas <= 0:
		_morir()
	else:
		retroceso = true
		
		var direction_empuje = sign(global_position.x - enemigo.global_position.x)
		if direction_empuje == 0: direction_empuje = -1
		velocity.y = -200
		velocity.x = direction_empuje * 120
		
		animation.modulate = Color(1, 0.3, 0.3)
		
		await get_tree().create_timer(0.2).timeout
		
		animation.modulate = Color(1,1,1)
		retroceso = false

func _morir():
	muerte_sonido.play()
	set_physics_process(false)
	await _efecto_muerte()
	LevelManager.reiniciar_nivel_actual()
func _efecto_muerte():
	var color_hexa = Color.html("#8c200c")
	var color = create_tween()
	color.tween_property(animation, "modulate", color_hexa, 0.5 )
	await color.finished


func _vida():
	print("perdio una vida")
