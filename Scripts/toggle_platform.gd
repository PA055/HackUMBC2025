extends StaticBody2D

func _process(delta):
	if Input.is_action_pressed("ToggleRed"):
		push_error("toggle red");
