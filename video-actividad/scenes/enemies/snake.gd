extends CharacterBody2D
@onready var anim: AnimatedSprite2D = $AnimationSnake
@onready var hitbox_head: CollisionShape2D = $HitboxHead
@onready var hitbox_body: CollisionShape2D = $HitboxSnake
@onready var salio_plataforma: RayCast2D = $RayCast2D
var pos_original_cabeza: float
var pos_original_cuerpo: float
var scl_original_cuerpo: float

var speed: float = 50
const speedMax: float = 150
const grav: float = 500
var mov_izquierda: bool = true


func _ready():
	# con esto añado al snake en un grupo de enemigos, para que sea más limpio
	add_to_group("enemigo")
	pos_original_cabeza = hitbox_head.position.y
	pos_original_cuerpo = hitbox_body.position.y
	scl_original_cuerpo = hitbox_body.scale.x
	anim.frame_changed.connect(_on_frame_changed)
	anim.play("run")

func _physics_process(delta):
	mover_enemigo(delta)
	verificar_borde()
	move_and_slide()
	
	
func mover_enemigo(delta):
	velocity.x = speed
	velocity.y += grav * delta

func verificar_borde():
	if not salio_plataforma.is_colliding():
		cambiar_direccion()

func cambiar_direccion():
	mov_izquierda = !mov_izquierda
	
	if mov_izquierda:
		speed = -50
	else:
		speed = 50
	scale.x = -scale.x
func _on_frame_changed():
	if anim.animation == "run":
		if anim.frame >= 3 and anim.frame <= 5:
			hitbox_head.position.y = pos_original_cabeza + 3
			hitbox_body.scale.x = scl_original_cuerpo / 1.5
			hitbox_body.position.y = pos_original_cuerpo + 1
			
		else:
			hitbox_head.position.y = pos_original_cabeza
			hitbox_body.position.y = pos_original_cuerpo
			hitbox_body.scale.x = scl_original_cuerpo
