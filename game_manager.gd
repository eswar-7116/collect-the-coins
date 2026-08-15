extends Node

signal score_changed(score: int)
signal game_over

enum GameState { PLAY, OVER }

var score: int = 0
var game_state: GameState = GameState.PLAY


func set_score(new_score: int):
	score = new_score
	score_changed.emit(score)


func inc_score():
	set_score(score+1)


func finish_game():
	game_over.emit()
	game_state = GameState.OVER


func replay():
	set_score(0)
	game_state = GameState.PLAY
