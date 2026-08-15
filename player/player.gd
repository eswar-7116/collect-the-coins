extends CharacterBody2D

const SPEED: float = 150.0
const JUMP_VELOCITY: float = -360.0
var start_position: Vector2


func _ready() -> void:
	start_position = position


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if GameManager.game_state == GameManager.GameState.PLAY:
		if Input.is_action_pressed("ui_up") and is_on_floor():
			$AudioStreamPlayer2D.play()
			velocity.y = JUMP_VELOCITY

		var direction := Input.get_axis("ui_left", "ui_right")
		if direction:
			$AnimatedSprite2D.play("run")
			velocity.x = direction * SPEED
			if velocity.x < 0:
				$AnimatedSprite2D.flip_h = true
			else:
				$AnimatedSprite2D.flip_h = false
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		velocity.x = 0
	
	if velocity.x == 0 and velocity.y == 0:
		$AnimatedSprite2D.play("idle")

	move_and_slide()


func reset():
	position = start_position
