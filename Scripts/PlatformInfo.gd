@tool
extends StaticBody2D

@export var size: Vector2:
	get:
		return $CollisionShape2D.shape.extents;
	set(new):
		$CollisionShape2D.shape.extents = new;

@export var platformRed: bool;
@export var platformGreen: bool;
@export var platformBlue: bool;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
