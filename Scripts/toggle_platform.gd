@tool
extends StaticBody2D

var _enabled: bool = true
@export var enabled: bool:
	get: return _enabled
	set(new):
		_enabled = new;
		if Engine.is_editor_hint() and $NinePatchRect:
			$NinePatchRect.texture = load(
				   "res://Assets/Blocks/Block"
				+ ("Enabled" if enabled else "Disabled")
				+ str(platformColor)
				+ ".png"
			);

var _size: Vector2 = Vector2(200, 40);
@export var size: Vector2:
	get:
		return _size
	set(new):
		_size = new;
		if Engine.is_editor_hint() and $NinePatchRect:
			$NinePatchRect.size = new / $NinePatchRect.scale;
			$NinePatchRect.position = -new * 0.5;

enum ColorMask {RED = 1, YELLOW = 2, BLUE = 4};
var platformColor: int = 0;

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
			   "res://Assets/Blocks/Block"
			+ ("Enabled" if enabled else "Disabled")
			+ str(platformColor)
			+ ".png"
		);

func _ready() -> void:
	if not Engine.is_editor_hint():
		$CollisionShape2D.shape = $CollisionShape2D.shape.duplicate();
		$CollisionShape2D.shape.size = _size;
		$NinePatchRect.size = _size / $NinePatchRect.scale;
		$NinePatchRect.position = -_size * 0.5;
		set_collision_layer(1 if enabled else 2);
		$NinePatchRect.texture = load(
			   "res://Assets/Blocks/Block"
			+ ("Enabled" if enabled else "Disabled")
			+ str(platformColor)
			+ ".png"
		);

func _input(event: InputEvent) -> void:
	var toggle = false;
	if event.is_action_pressed("ToggleRed") and platformColor & ColorMask.RED:
		toggle = true;
	if event.is_action_pressed("ToggleYellow") and platformColor & ColorMask.YELLOW:
		toggle = true;
	if event.is_action_pressed("ToggleBlue") and platformColor & ColorMask.BLUE:
		toggle = true;
	
	if toggle:
		enabled = not enabled;
		set_collision_layer(1 if enabled else 2);
		$NinePatchRect.texture = load(
			   "res://Assets/Blocks/Block"
			+ ("Enabled" if enabled else "Disabled")
			+ str(platformColor)
			+ ".png"
		);

func _process(_delta: float) -> void:
	if Engine.is_editor_hint() and $CollisionShape2D:
		$CollisionShape2D.shape = $CollisionShape2D.shape.duplicate();
