extends Area2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
var start_pos: Vector2
var collected := false

func _ready():
	start_pos = position
	sprite.play("default")


func _on_body_entered(body: Node2D) -> void:
	if collected:
		return

	if GameManager.game_state != GameManager.GameState.PLAY:
		return

	if not body.is_in_group("player"):
		return

	collected = true
	$AudioStreamPlayer2D.play()
	hide()
	GameManager.inc_score()

	remove_from_group("untouched_coin")

	if get_tree().get_nodes_in_group("untouched_coin").is_empty():
		GameManager.finish_game()


func reset():
	position = start_pos
	add_to_group("untouched_coin")
	show()
	collected = false
