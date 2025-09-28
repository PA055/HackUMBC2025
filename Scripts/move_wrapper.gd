@tool
extends Node2D

# --- Cache CharacterBody2D child ---
@onready var body: CharacterBody2D = $CharacterBody2D

# --- Positions ---
var _positions: Array[Vector2] = []
@export var positions: Array[Vector2]:
	get:
		if Engine.is_editor_hint() and body:
			return body.positions
		return _positions
	set(value):
		_positions = value
		if body:
			body.positions = value

# --- Current Index ---
var _startIndex: int = 0
@export var startIndex: int:
	get:
		if Engine.is_editor_hint() and body:
			return body.currentPosition
		return _startIndex
	set(value):
		_startIndex = value
		if body:
			body.currentPosition = value

# --- Animation ---
@export var animationDuration: float = 0.25
@export var animationCurve: Curve

# --- Size ---
var _size: Vector2 = Vector2(200, 40)
@export var size: Vector2:
	get:
		if body:
			return body.size
		return _size
	set(value):
		_size = value
		if body:
			body.size = value

# --- Colors ---
var _red: bool = false
@export var platformRed: bool:
	get: return body and body.platformRed if Engine.is_editor_hint() else _red
	set(value):
		_red = value
		if body:
			body.platformRed = value

var _yellow: bool = false
@export var platformYellow: bool:
	get: return body and body.platformYellow if Engine.is_editor_hint() else _yellow
	set(value):
		_yellow = value
		if body:
			body.platformYellow = value

var _blue: bool = false
@export var platformBlue: bool:
	get: return body and body.platformBlue if Engine.is_editor_hint() else _blue
	set(value):
		_blue = value
		if body:
			body.platformBlue = value

func _ready() -> void:
	if body:
		body.positions = positions
		body.currentPosition = startIndex
		body.animationDuration = animationDuration
		body.animationCurve = animationCurve
		body.size = size
		body.platformRed = platformRed
		body.platformYellow = platformYellow
		body.platformBlue = platformBlue
		body.initialize()
