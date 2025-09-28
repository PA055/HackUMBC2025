extends Camera2D

func _process(delta: float):
	var player = $"../Player"
	position = position.lerp(player.global_position, 0.9)
	
