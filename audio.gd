extends Node2D
func _ready() -> void:
	
	position.x = 700
	position.y = 1100
	print("a")
	add_child(preload("res://Level.tscn").instantiate())
