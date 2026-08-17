extends CharacterBody2D

const SPEED: float = 150.0
const JUMP_VELOCITY: float = -360.0
const FLY_SPEED: float = 600.0

var start_position: Vector2
var dead := false
var  fly_mode := false

func _ready() -> void:
	start_position = position
	$AnimatedSprite2D.play("idle")


func _physics_process(delta: float) -> void:
	if dead:
		velocity = Vector2.ZERO
		return
	
	# DEBUG FLY CHEAT
	if OS.is_debug_build():
		if Input.is_action_just_pressed("fly_mode"):
			fly_mode = !fly_mode

		if fly_mode:
			var fly_direction := Input.get_vector(
				"ui_left",
				"ui_right",
				"ui_up",
				"ui_down"
			)

			velocity = fly_direction * FLY_SPEED
			move_and_slide()
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
	
	if absf(direction) >= 0.1:
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			var body = collision.get_collider()

			if body is RigidBody2D:
				var push_direction = Vector2(direction, -0.9).normalized()
				body.apply_central_impulse(push_direction * 100 * body.mass)

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
