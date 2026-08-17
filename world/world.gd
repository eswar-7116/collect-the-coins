extends Node2D


func reset():
	for coin in get_tree().get_nodes_in_group("coin"):
		coin.reset()

	$ball.reset()
