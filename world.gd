extends Node2D


func reset():
	for coin in $coins.get_children():
		coin.reset()
