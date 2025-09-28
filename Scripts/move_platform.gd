@tool
extends StaticBody2D

@export var positions: Array[Vector2] = [Vector2()];

var _currentPos: int = 0;
@export var currentPosition: int: 
	get: return _currentPos;
	set(new): 
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
@export var platformColor: int = 0;

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
		$NinePatchRect.texture = load(
			   "res://Assets/MoveBlocks/Block"
			+ str(platformColor)
			+ ".png"
		);

func _ready() -> void:
	if not Engine.is_editor_hint():
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
		currentPosition = currentPosition + 1;

func _process(delta: float) -> void:
	if Engine.is_editor_hint() and $CollisionShape2D:
		$CollisionShape2D.shape = $CollisionShape2D.shape.duplicate();
	else:
		position = positions[_currentPos];
		var nextPos = positions[(_currentPos + 1) % positions.size()];
		if nextPos == positions[_currentPos]:
			$Arrow.texture = load("res://Assets/Testing/dot.png");
		else:
			$Arrow.texture = load("res://Assets/Testing/arrow.png");
			$Arrow.look_at(nextPos + get_parent().position);
