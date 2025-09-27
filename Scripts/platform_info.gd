@tool
extends StaticBody2D

var _size: Vector2 = Vector2(200, 40);
@export var size: Vector2:
	get:
		return _size
	set(new):
		_size = new;
		if Engine.is_editor_hint() and $CollisionShape2D and $NinePatchRect:
			$CollisionShape2D.shape.size = new;
			$NinePatchRect.size = new / $NinePatchRect.scale;
			$NinePatchRect.position = -new * 0.5;

enum ColorMask {RED = 1, GREEN = 2, BLUE = 4};
var platformColor: int = 0;

@export var platformRed: bool:
	get: return platformColor & ColorMask.RED;
	set(new): _on_edit_color(ColorMask.RED, new);
@export var platformGreen: bool:
	get: return platformColor & ColorMask.GREEN;
	set(new): _on_edit_color(ColorMask.GREEN, new);
@export var platformBlue: bool:
	get: return platformColor & ColorMask.BLUE;
	set(new): _on_edit_color(ColorMask.BLUE, new);

func _on_edit_color(color: ColorMask, new: bool):
	platformColor = (platformColor & ~color) | (color if new else 0);
	if Engine.is_editor_hint() and $NinePatchRect:
		$NinePatchRect.texture = load("res://Assets/Blocks/BlockEnabled" + str(platformColor) + ".png");

func _ready() -> void:
	if not Engine.is_editor_hint():
		$CollisionShape2D.shape = $CollisionShape2D.shape.duplicate();
		$CollisionShape2D.shape.size = _size;
		$NinePatchRect.size = _size / $NinePatchRect.scale;
		$NinePatchRect.position = -_size * 0.5;
		$NinePatchRect.texture = load("res://Assets/Blocks/BlockEnabled" + str(platformColor) + ".png");

func _process(_delta: float) -> void:
	if Engine.is_editor_hint() and $CollisionShape2D:
		$CollisionShape2D.shape = $CollisionShape2D.shape.duplicate();
