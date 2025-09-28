@tool
extends StaticBody2D

# --- Cache NinePatchRect child ---
@onready var sprite: NinePatchRect = $NinePatchRect

# --- Enabled state ---
var _enabled: bool = true
@export var enabled: bool:
	get: return _enabled
	set(value):
		_enabled = value
		_update_visuals()
		set_collision_layer(4 if _enabled else 0)

# --- Size ---
var _size: Vector2 = Vector2(200, 40)
@export var size: Vector2:
	get: return _size
	set(value):
		_size = value
		_update_visuals()

# --- Colors ---
enum ColorMask {RED = 1, YELLOW = 2, BLUE = 4}
var platformColor: int = 0

@export var platformRed: bool:
	get: return platformColor & ColorMask.RED
	set(value): _on_edit_color(ColorMask.RED, value)
@export var platformYellow: bool:
	get: return platformColor & ColorMask.YELLOW
	set(value): _on_edit_color(ColorMask.YELLOW, value)
@export var platformBlue: bool:
	get: return platformColor & ColorMask.BLUE
	set(value): _on_edit_color(ColorMask.BLUE, value)

func _on_edit_color(color: ColorMask, value: bool):
	platformColor = (platformColor & ~color) | (color if value else 0)
	_update_visuals()

func _update_visuals():
	if sprite:
		sprite.size = _size / sprite.scale
		sprite.position = -_size * 0.5
		sprite.texture = load(
			"res://Assets/ToggleBlocks/Block" +
			("Enabled" if _enabled else "Disabled") +
			str(platformColor) +
			".png"
		)

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
		set_collision_layer(4 if _enabled else 0)
		_update_visuals()

func _ready() -> void:
	_update_visuals()
	if not Engine.is_editor_hint():
		$CollisionShape2D.shape = $CollisionShape2D.shape.duplicate()
		$CollisionShape2D.shape.size = _size
		set_collision_layer(4 if _enabled else 0)
