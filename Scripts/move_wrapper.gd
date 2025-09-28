@tool
extends Node2D

var _positions: Array[Vector2];
@export var positions: Array[Vector2]:
	get:
		if Engine.is_editor_hint():
			return $StaticBody2D.positions;
		return _positions;
	set(new):
		_positions = new;
		if Engine.is_editor_hint():
			$StaticBody2D.positions = new;

var _currentPosition: int;
@export var currentPosition: int:
	get:
		if Engine.is_editor_hint():
			return $StaticBody2D.currentPosition;
		return _currentPosition;
	set(new):
		currentPosition = new;
		if Engine.is_editor_hint():
			$StaticBody2D.currentPosition = new;

var _size: Vector2;
@export var size: Vector2:
	get:
		if Engine.is_editor_hint():
			return $StaticBody2D.size;
		return _size;
	set(new):
		_size = new;
		if Engine.is_editor_hint():
			$StaticBody2D.size = new;

var _red: bool;
@export var platformRed: bool:
	get:
		if Engine.is_editor_hint():
			return $StaticBody2D.platformRed;
		return _red;
	set(new):
		_red = new;
		if Engine.is_editor_hint():
			$StaticBody2D.platformRed = new;

var _yellow: bool;
@export var platformYellow: bool:
	get:
		if Engine.is_editor_hint():
			return $StaticBody2D.platformYellow;
		return _yellow;
	set(new):
		_yellow = new;
		if Engine.is_editor_hint():
			$StaticBody2D.platformYellow = new;

var _blue: bool;
@export var platformBlue: bool:
	get:
		if Engine.is_editor_hint():
			return $StaticBody2D.platformBlue;
		return _blue;
	set(new):
		_blue = new;
		if Engine.is_editor_hint():
			$StaticBody2D.platformBlue = new;

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	$StaticBody2D.positions = positions;
	$StaticBody2D.currentPosition = currentPosition;
	$StaticBody2D.size = size;
	$StaticBody2D.platformRed = platformRed;
	$StaticBody2D.platformYellow = platformYellow;
	$StaticBody2D.platformBlue = platformBlue;
