extends Node2D

@onready var score_label := $Labels/ScoreLabel
@onready var game_over_label = $Labels/GameOverLabel
@onready var hint_label = $Labels/HintLabel


func _ready() -> void:
	game_over_label.position = get_viewport_rect().size / 2.0 - game_over_label.size / 2.0
	game_over_label.position.y -= 300
	
	hint_label.position = get_viewport_rect().size / 2.0 - hint_label.size / 2.0
	hint_label.position.y = game_over_label.position.y + 50
	
	GameManager.score_changed.connect(_on_score_changed)
	GameManager.game_over.connect(_on_game_over)
	
	score_label.text = "Score: " + str(GameManager.score)


func _process(_delta: float) -> void:
	if GameManager.game_state == GameManager.GameState.OVER:
		if Input.is_action_just_pressed("ui_accept"):
			reset()


func _on_score_changed(score: int):
	score_label.text = "Score: " + str(GameManager.score)


func _on_game_over():
	game_over_label.show()
	hint_label.show()

	score_label.position = get_viewport_rect().size / 2.0 - score_label.size / 2.0
	score_label.position.y = game_over_label.position.y + 100


func reset():
	score_label.position = Vector2(0, 0)
	game_over_label.hide()
	hint_label.hide()

	$player.reset()

	$world.reset()

	GameManager.replay()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == $player:
		$player.die()
		GameManager.finish_game()
