@tool
extends Node2D

var _positions: Array[Vector2];
@export var positions: Array[Vector2]:
	get:
		if Engine.is_editor_hint():
			return $CharacterBody2D.positions;
		return _positions;
	set(new):
		_positions = new;
		if Engine.is_editor_hint():
			$CharacterBody2D.positions = new;

var _startIndex: int;
@export var startIndex: int:
	get:
		if Engine.is_editor_hint():
			return $CharacterBody2D.currentPosition;
		return _startIndex;
	set(new):
		_startIndex = new;
		if Engine.is_editor_hint():
			$CharacterBody2D.currentPosition = new;

@export var animationDuration: float = 0.5;
@export var animationCurve: Curve;

var _size: Vector2;
@export var size: Vector2:
	get:
		if Engine.is_editor_hint():
			return $CharacterBody2D.size;
		return _size;
	set(new):
		_size = new;
		if Engine.is_editor_hint():
			$CharacterBody2D.size = new;

var _red: bool;
@export var platformRed: bool:
	get:
		if Engine.is_editor_hint():
			return $CharacterBody2D.platformRed;
		return _red;
	set(new):
		_red = new;
		if Engine.is_editor_hint():
			$CharacterBody2D.platformRed = new;

var _yellow: bool;
@export var platformYellow: bool:
	get:
		if Engine.is_editor_hint():
			return $CharacterBody2D.platformYellow;
		return _yellow;
	set(new):
		_yellow = new;
		if Engine.is_editor_hint():
			$CharacterBody2D.platformYellow = new;

var _blue: bool;
@export var platformBlue: bool:
	get:
		if Engine.is_editor_hint():
			return $CharacterBody2D.platformBlue;
		return _blue;
	set(new):
		_blue = new;
		if Engine.is_editor_hint():
			$CharacterBody2D.platformBlue = new;

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	$CharacterBody2D.positions = positions;
	$CharacterBody2D.currentPosition = startIndex;
	$CharacterBody2D.animationDuration = animationDuration;
	$CharacterBody2D.animationCurve = animationCurve
	$CharacterBody2D.size = size;
	$CharacterBody2D.platformRed = platformRed;
	$CharacterBody2D.platformYellow = platformYellow;
	$CharacterBody2D.platformBlue = platformBlue;
	$CharacterBody2D.initialize();
