@tool
extends CharacterBody2D

# --- Cache child nodes safely ---
@onready var rect: NinePatchRect = $NinePatchRect
@onready var arrow: Sprite2D = $Arrow
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var tracks: Node2D = $"../Tracks"

# --- Positions & movement ---
@export var positions: Array[Vector2] = [Vector2()]

var _prevPos: int = 0
var _currentPos: int = 0
@export var currentPosition: int:
	get: return _currentPos
	set(new):
		_prevPos = _currentPos
		_currentPos = new % positions.size()
		if _currentPos < 0: _currentPos += positions.size()
		var nextPos = (_currentPos + 1) % positions.size()
		if Engine.is_editor_hint() and positions.size() > 0:
			position = positions[_currentPos]
			if positions[nextPos] == positions[_currentPos]:
				arrow.texture = load("res://Assets/Testing/dot.png")
			else:
				arrow.texture = load("res://Assets/Testing/arrow.png")
				arrow.look_at(positions[nextPos] + get_parent().position)

@export var animationDuration: float = 0.25
@export var animationCurve: Curve
var progress: float = 0.0

# --- Size & display ---
var _size: Vector2 = Vector2(200, 40)
@export var size: Vector2:
	get: return _size
	set(value):
		_size = value
		if rect:
			rect.size = value / rect.scale
			rect.position = -value * 0.5
		if collision:
			collision.shape = collision.shape.duplicate()
			collision.shape.size = value

# --- Platform colors ---
enum ColorMask { RED = 1, YELLOW = 2, BLUE = 4 }
@export var platformColor: int = 0

@export var platformRed: bool:
	get: return platformColor & ColorMask.RED
	set(value): _on_edit_color(ColorMask.RED, value)

@export var platformYellow: bool:
	get: return platformColor & ColorMask.YELLOW
	set(value): _on_edit_color(ColorMask.YELLOW, value)

@export var platformBlue: bool:
	get: return platformColor & ColorMask.BLUE
	set(value): _on_edit_color(ColorMask.BLUE, value)

func _on_edit_color(color: ColorMask, new: bool) -> void:
	platformColor = (platformColor & ~color) | (color if new else 0)
	if rect:
		rect.texture = load("res://Assets/MoveBlocks/Block" + str(platformColor) + ".png")

# --- Tracks rendering ---
func _refresh_tracks(points: Array[Vector2]) -> void:
	if not tracks:
		return
	for child in tracks.get_children():
		child.queue_free()

	for i in range(points.size()):
		var start = points[i]
		var end = points[(i + 1) % points.size()]
		var line = Line2D.new()
		line.points = [start, end]
		line.texture = load("res://Assets/MoveBlocks/middle_track.png")
		line.texture_mode = Line2D.LINE_TEXTURE_TILE
		line.width = 14
		line.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
		tracks.add_child(line)

	for point in points:
		var sprite = Sprite2D.new()
		sprite.texture = load("res://Assets/MoveBlocks/track_circle.png")
		sprite.position = point
		sprite.scale = Vector2(0.65, 0.65)
		tracks.add_child(sprite)

	tracks.z_index = -5

# --- Initialization ---
func initialize() -> void:
	if Engine.is_editor_hint():
		return
	if collision:
		collision.shape = collision.shape.duplicate()
		collision.shape.size = _size
	if rect:
		rect.size = _size / rect.scale
		rect.position = -_size * 0.5
		rect.texture = load("res://Assets/MoveBlocks/Block" + str(platformColor) + ".png")
	_refresh_tracks(positions)

# --- Input handling ---
func _input(event: InputEvent) -> void:
	var toggle = false
	if event.is_action_pressed("MoveRed") and platformColor & ColorMask.RED:
		toggle = true
	if event.is_action_pressed("MoveYellow") and platformColor & ColorMask.YELLOW:
		toggle = true
	if event.is_action_pressed("MoveBlue") and platformColor & ColorMask.BLUE:
		toggle = true

	if toggle:
		progress = 0.0
		currentPosition += 1

# --- Movement helpers ---
func easeInOutExpo(x: float) -> float: 
	if x == 0: return 0
	if x == 1: return 1
	if x < 0.5:
		return pow(2, 20 * x - 10) / 2
	return (2 - pow(2, -20 * x + 10)) / 2

func next_position(start: Vector2, end: Vector2, dt: float) -> Vector2:
	progress = clamp(progress + dt / animationDuration, 0.0, 1.0)
	var eased = animationCurve.sample(progress) if animationCurve else progress
	return lerp(start, end, eased)

func next_velocity(eps: float = 0.001) -> Vector2:
	var start = positions[_prevPos]
	var end = positions[_currentPos]
	var t1 = clamp(progress - eps, 0.0, 1.0)
	var t2 = clamp(progress + eps, 0.0, 1.0)
	var eased = (animationCurve.sample(t2) - animationCurve.sample(t1)) / (t2 - t1) if animationCurve else 1.0
	return (end - start) * (eased / animationDuration)

# --- Process loop ---
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		if collision and tracks:
			_refresh_tracks(positions)
			collision.shape = collision.shape.duplicate()
	else:
		if positions.size() == 0:
			return
		var prevPos = positions[_prevPos]
		var targetPos = positions[_currentPos]
		var nextPos = positions[(_currentPos + 1) % positions.size()]

		var next = next_position(prevPos, targetPos, delta)
		position = next

		if arrow:
			if nextPos == positions[_currentPos]:
				arrow.texture = load("res://Assets/Testing/dot.png")
			else:
				arrow.texture = load("res://Assets/Testing/arrow.png")
				arrow.look_at(nextPos + get_parent().position)
