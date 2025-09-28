@tool
extends StaticBody2D

@export var positions: Array[Vector2] = [Vector2()];

var _prevPos: int = 0;
var _currentPos: int = 0;
@export var currentPosition: int: 
	get: return _currentPos;
	set(new): 
		_prevPos = _currentPos;
		_currentPos = new % positions.size();
		if _currentPos < 0: _currentPos += positions.size();
		var nextPos = (new + 1) % positions.size();
		if Engine.is_editor_hint():
			position = positions[_currentPos];
			if positions[nextPos] == positions[_currentPos]:
				$Arrow.texture = load("res://Assets/Testing/dot.png");
			else:
				$Arrow.texture = load("res://Assets/Testing/arrow.png");
				$Arrow.look_at(positions[nextPos] + get_parent().position);

@export var animationDuration: float = 0.5;
@export var animationCurve: Curve;
var progress: float;

var _size: Vector2 = Vector2(200, 40);
@export var size: Vector2:
	get:
		return _size;
	set(new):
		_size = new;
		if Engine.is_editor_hint() and $NinePatchRect:
			$NinePatchRect.size = new / $NinePatchRect.scale;
			$NinePatchRect.position = -new * 0.5;

enum ColorMask {RED = 1, YELLOW = 2, BLUE = 4};
@export var platformColor: int;

@export var platformRed: bool:
	get: return platformColor & ColorMask.RED;
	set(new): _on_edit_color(ColorMask.RED, new);
@export var platformYellow: bool:
	get: return platformColor & ColorMask.YELLOW;
	set(new): _on_edit_color(ColorMask.YELLOW, new);
@export var platformBlue: bool:
	get: return platformColor & ColorMask.BLUE;
	set(new): _on_edit_color(ColorMask.BLUE, new);

func _on_edit_color(color: ColorMask, new: bool):
	platformColor = (platformColor & ~color) | (color if new else 0);
	if Engine.is_editor_hint() and $NinePatchRect:
		$NinePatchRect.texture = load( \
			   "res://Assets/MoveBlocks/Block" \
			+ str(platformColor) \
			+ ".png" \
		);

func initialize() -> void:
	if Engine.is_editor_hint():
		return;
	
	$CollisionShape2D.shape = $CollisionShape2D.shape.duplicate();
	$CollisionShape2D.shape.size = _size;
	$NinePatchRect.size = _size / $NinePatchRect.scale;
	$NinePatchRect.position = -_size * 0.5;
	$NinePatchRect.texture = load(
		   "res://Assets/MoveBlocks/Block"
		+ str(platformColor)
		+ ".png"
	);

func _input(event: InputEvent) -> void:
	var toggle = false;
	if event.is_action_pressed("MoveRed") and platformColor & ColorMask.RED:
		toggle = true;
	if event.is_action_pressed("MoveYellow") and platformColor & ColorMask.YELLOW:
		toggle = true;
	if event.is_action_pressed("MoveBlue") and platformColor & ColorMask.BLUE:
		toggle = true;
	
	if toggle:
		progress = 0.0;
		currentPosition = currentPosition + 1;

func easeInOutExpo(x: float) -> float: 
	return 0.0 if x == 0 else ( \
		   1.0 if x == 1 else ( \
		   pow(2, 20 * x - 10) / 2  \
				if x < 0.5 else \
		   (2 - pow(2, -20 * x + 10)) / 2 \
		));

func next_position(start: Vector2, end: Vector2, dt: float) -> Vector2:
	progress = clamp(progress + dt / animationDuration, 0.0, 1.0)
	var eased = animationCurve.sample(progress)
	return lerp(start, end, eased);
	
func next_velocity(start: Vector2, end: Vector2, dt: float, eps: float = 0.001) -> Vector2:
	var t1 = clamp(progress - eps, 0.0, 1.0)
	var t2 = clamp(progress + eps, 0.0, 1.0)
	var eased = (animationCurve.sample(t2) - animationCurve.sample(t1)) / (t2 - t1)
	return (end - start) * (eased / animationDuration);

func _process(delta: float) -> void:
	if Engine.is_editor_hint() and $CollisionShape2D:
		$CollisionShape2D.shape = $CollisionShape2D.shape.duplicate();
	else:
		var prevPos = positions[_prevPos];
		var targetPos = positions[_currentPos];
		var nextPos = positions[(_currentPos + 1) % positions.size()];
		
		var next = next_position(prevPos, targetPos, delta);
		position = next;
		
		if nextPos == positions[_currentPos]:
			$Arrow.texture = load("res://Assets/Testing/dot.png");
		else:
			$Arrow.texture = load("res://Assets/Testing/arrow.png");
			$Arrow.look_at(nextPos + get_parent().position);
