extends Camera2D

@export var target: Node2D
@export var smoothing: float = 20.0

func _process(delta: float) -> void:
	if not target: return
	
	var desired_pos: Vector2 = target.global_position
	var smoothed_pos: Vector2 = lerp(global_position, desired_pos, delta * smoothing)
	
	var level_bounds = $"../LevelLoader".bounds;
	var min_x = level_bounds.position.x
	var min_y = level_bounds.position.y
	var max_x = level_bounds.position.x + level_bounds.size.x
	var max_y = level_bounds.position.y + level_bounds.size.y
	
	smoothed_pos.x = clamp(smoothed_pos.x, min_x, max_x)
	smoothed_pos.y = clamp(smoothed_pos.y, min_y, max_y)
	
	print("goal: ", target.global_position, ", pos: ", smoothed_pos);
	global_position = smoothed_pos
