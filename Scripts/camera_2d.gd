extends Camera2D

func _process(delta: float):
	var player = $"../Player"
	position = position.lerp(player.position, 0.1)
	
