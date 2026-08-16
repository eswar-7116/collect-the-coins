extends CharacterBody2D

const SPEED: float = 150.0
const JUMP_VELOCITY: float = -360.0
var start_position: Vector2
var dead := false


func _ready() -> void:
	start_position = position
	$AnimatedSprite2D.play("idle")


func _physics_process(delta: float) -> void:
	if dead:
		velocity = Vector2.ZERO
		return

	if not is_on_floor():
		velocity += get_gravity() * delta

	if GameManager.game_state == GameManager.GameState.OVER:
		velocity.x = 0
		$AnimatedSprite2D.animation = "idle"
		move_and_slide()
		return

	if Input.is_action_pressed("ui_up") and is_on_floor():
		$jump.play()
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		$AnimatedSprite2D.animation = "run"
		velocity.x = direction * SPEED
		if velocity.x < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if velocity.x == 0 and velocity.y == 0:
		$AnimatedSprite2D.animation = "idle"

	move_and_slide()


func die():
	if dead:
		return

	dead = true
	$death.play()
	velocity = Vector2.ZERO
	hide()
	$AnimatedSprite2D.stop()

	set_physics_process(false)


func reset():
	position = start_position
	dead = false
	velocity = Vector2.ZERO
	show()
	$AnimatedSprite2D.play("idle")

	set_physics_process(true)
